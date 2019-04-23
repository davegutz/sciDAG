// Copyright (C) 2019 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// Mar 23, 2019 DA Gutz Created
//
function [INI] = solve_IFC(INI, GEOF, FP)
    // Initialize IFC
    // Inputs: p1, wfmd=wf36, pd, wf1vg=wf1cvg+wf1fvg, wf1v=wfstart, pc, awfb, precx
    // Outputs: wf1c, wfb
    // States:  xhs, xtv, xmv, p2, p3, px1, ln_p3s.wf

    // Name changes
    icf.p1 = INI.p1;
    icf.wf1vg = INI.wf1cvg + INI.wf1fvg;
    icf.wf1f = INI.wf1v;
    icf.pc = INI.pc;
    icf.pd = INI.pd;
    icf.precx = INI.precx;
    icf.wfmd = INI.eng.wf36;
    icf.wf1v = INI.wf1v;
    icf.mvtv.pd = INI.pd;

    // Thermal bypass valve
    icf.wfb = or_aptow(INI.awfb, icf.p1, icf.precx, 1., FP.sg);

    // Loop to solve p1c, xtv, px, and xhs
    if INI.verbose-INI.linearizing > 3
        mprintf('\n');
    end
    try temp = icf.wf1w; 
    catch
        icf.wf1w = 0;
        INI.p1c = icf.p1;
        INI.px = INI.p1c-200;
        INI.xtv = 0;
        INI.xhs = 0;
        icf.wf1leak = 0;
    end
    INI.xtvm = 0;
    INI.xhsm = 0;
    INI.pxm = -1000;
    INI.p1cm = -1000;
    icf.wftvb = 0;
    INI.wftvbm = -1000;
    icf.count = 0;
    while ( ( abs(INI.p1c - INI.p1cm)>1e-16 |..
        abs(INI.xtv - INI.xtvm)>1e-20 |..
        abs(INI.px - INI.pxm )>1e-20 |..
        abs(icf.wftvb - INI.wftvbm )>1e-20 |..
        abs(INI.xhs - INI.xhsm)>1e-20) ..
        & icf.count<25 )
        icf.count = icf.count + 1;
        INI.p1cm = INI.p1c;
        INI.xtvm = INI.xtv;
        INI.xhsm = INI.xhs;
        INI.pxm = INI.px;
        INI.wftvbm = icf.wftvb;

        icf.wf1cx = icf.wfmd + icf.wf1vg - icf.wf1v + icf.wf1w + icf.wf1leak - icf.wftvb;

        // Check Valve
        INI.p1c = or_awpstopd(GEOF.check.ao, icf.wf1cx, icf.p1, GEOF.check.cd, FP.sg);
        icf.p2 = INI.p1c;

        // PRT regulator
        icf.prt = max(INI.p1c-(GEOF.prtv.fs+0.01*GEOF.prtv.ks)/GEOF.prtv.ax1, icf.pc);
//        icf.prt = INI.p1c - 315;

        // PR regulator
        icf.pr = min(icf.pc+250, INI.p1c);

        // Head sensor
        icf.lqx = max(min(GEOF.hs.f_ln/max(INI.xhs, 1e-12), f_lqx(1,$)), f_lqx(1,1));
        icf.hs.cf = interp1(f_lqx(1,:), f_lqx(2,:), icf.lqx, 'linear', 'extrap');
        icf.p3 = icf.p2 + ((INI.px-icf.p2)*GEOF.hs.f_an*(1+(icf.hs.cf*INI.xhs*4/GEOF.hs.f_dn)^2) ..
        - GEOF.hs.fs - GEOF.hs.fb - INI.xhs*(GEOF.hs.ks + GEOF.hs.kb)) / GEOF.hs.ae;
        icf.p3mpd = icf.p3 - icf.pd;
        icf.p2mp3 = icf.p2 - icf.p3;

        icf.wf1c = icf.wf1cx + icf.wfb;
        icf.mv.wfd = icf.wfmd;
        icf.mvtv.wfd = icf.wfmd;

        // Throttle valve
        icf.mvtv.ad = or_wptoa(icf.wfmd, icf.p3, icf.pd, GEOF.mvtv.cd, FP.sg);
        INI.xtv = max(min(rev_lookup(icf.mvtv.ad, GEOF.mvtv.ad), GEOF.mvtv.xmax), GEOF.mvtv.xmin);
        INI.px = (icf.p3*(GEOF.mvtv.ax1-GEOF.mvtv.ax4) - icf.prt*(GEOF.mvtv.ax1-GEOF.mvtv.ax2) - GEOF.mvtv.ks*INI.xtv - GEOF.mvtv.fs) / GEOF.mvtv.ax2;
        icf.wftvb = or_aptow(GEOF.a_tvb.ao, icf.prt, INI.px, GEOF.a_tvb.cd, FP.sg);

        icf.wf1mv = icf.wfmd;

        // Metering valve
        icf.mv.a = or_wptoa(icf.wf1mv, icf.p2, icf.p3, GEOF.mv.cd, FP.sg);
        icf.mv.x = rev_lookup(icf.mv.a, GEOF.mv.at);

        // MV Servovalve leakage f(p1c)
        icf.wf1leak = or_aptow(GEOF.a1leak, icf.pr, icf.pc, 0.61, FP.sg) + ..
                        la_kptow(GEOF.k1leak, icf.pr, icf.pc, FP.kvis);
        icf.wfr = 0*(INI.p1c-icf.pc); // mvsv leakage estimate
        icf.wf1w = icf.wfr;

        // Head sensor recalc for feedback
        icf.wfhs = -icf.wftvb;
        INI.xhs = GEOF.hs.f_an*GEOF.hs.f_cn/(icf.hs.cf*GEOF.hs.f_dn*%pi)/..
            sqrt( FP.sg*abs(INI.px-icf.p2)*(GEOF.hs.f_an*GEOF.hs.f_cn*19020/icf.wfhs)^2 - 1);
        INI.xhs = max(min(INI.xhs, GEOF.hs.xmax), GEOF.hs.xmin);
        if INI.verbose-INI.linearizing > 5
            INI.wfcheck = 19020*sqrt(FP.sg*abs(INI.px-icf.p2)/(1/(GEOF.hs.f_an*GEOF.hs.f_cn)^2 + 1/(icf.hs.cf*GEOF.hs.f_dn*%pi*INI.xhs)^2));
            mprintf('x=%16.12f, p2=%f, px=%f, wf=%f, wfcheck=%f\n', INI.xhs, icf.p2, INI.px, icf.wfhs, INI.wfcheck);
        end

        if INI.verbose-INI.linearizing > 4
            mprintf('IFC(%ld): p1c=%f/%f, xtv=%14.12f/%14.12f, xhs=%14.12f/%14.12f, px=%f/%f\n', icf.count, INI.p1c, INI.p1cm, INI.xtv, INI.xtvm, INI.xhs, INI.xhsm, INI.px, INI.pxm);
        end
    end
    if icf.count >=25 & INI.verbose-INI.linearizing>3
        mprintf('\n*****WARNING(%s): loop counter maximum. p1=%f, p1m=%f, xtv=%14.12f, xtvm=%14.12f, xhs=%14.12f, xhsm=%14.12f\n', mfilename, INI.p1c, INI.p1cm, INI.xtv, INI.xtvm, INI.xhs, INI.xhsm);
    end
    // end loop

    // Assign
    icf.hs.x = INI.xhs;
    icf.mvtv.x = INI.xtv;
    icf.p1so = INI.p1c;  // TODO: add check valve
    icf.wf2s = 0;  // TODO:  shouldn't this be wf1s?
    icf.wf3s = 0;
    icf.wfrt = icf.wftvb;
    icf.wfx = icf.wftvb;
    icf.wf1s = -icf.wftvb;
    icf.wfc = -icf.wfrt + icf.wf1w + icf.wf1leak;
    icf.p1c = INI.p1c;
    icf.px = INI.px;
    icf.xtv = icf.mvtv.x;
    icf.mvsv.x = 0;
    icf.vo_px1.wf = 0;
    icf.vo_px1.p = (icf.pr+icf.pc)/2;
    icf.vo_px2.wf = 0;
    icf.vo_px2.p = (icf.pr+icf.pc)/2;
    icf.check.x = 0.31;
    icf.ln_p3s.wf = 0;
    icf.ln_p3s.p = icf.p3;
    icf.vo_p3s.wf = 0;
    icf.vo_p3s.p = icf.p3;
    icf.vo_p2.wf = icf.wfmd;
    icf.vo_p2.p = icf.p2;
    icf.vo_p3.wf = icf.wfmd;
    icf.vo_p3.p = icf.p3;
    icf.vo_pd.wf = icf.wfmd;
    icf.vo_pd.p = INI.pd;
    icf.vo_px.wf = icf.wf1s;
    icf.vo_px.p = icf.px;
    icf.mo_p3s.wf = 0;
    icf.mo_p3s.p = icf.vo_p3.p;

    // Re-assign
    INI.ifc = icf;
    INI.wfc = icf.wfc;
endfunction
