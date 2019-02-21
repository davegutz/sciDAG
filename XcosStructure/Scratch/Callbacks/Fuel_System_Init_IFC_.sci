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
// Feb 21, 2019    DA Gutz        Created
// 
function ic = F414_Fuel_System_Init_IFC_(ic, GEO, Z, FP, MOD)
    //function [ic, GEOE] = F414_Fuel_System_Init_IFC_(ic, GEO, Z, FP, MOD)
    // 29-Apr-2012   DA Gutz     Created


    // Initialize IFC
    // Inputs:   p1, wfmd=wf36, pd, wf1vg=wf1cvg+wf1fvg, wf1v=wfstart, pc, awfb
    // Outputs:  wf1c, wfb

    // Name changes
    icf         = ic.ifc;
    GEOF        = GEO.ifc;
    icf.p1      = ic.p1;
    icf.wf1vg   = ic.wf1cvg + ic.wf1fvg;
    icf.wf1f    = ic.wf1v;
    icf.pc      = ic.pc;
    icf.pd      = ic.pd;
    icf.precx   = ic.precx;
    icf.wfmd    = ic.eng.wf36;
    icf.wf1v    = ic.wf1v;
    icf.mvtv.pd = ic.pd;

    //  Thermal bypass valve
    icf.wfb     = or_aptow(Z.awfb, icf.p1, icf.precx, 1., FP.sg);

    // Loop to solve p1c, xtv, px, and xhs
    if MOD.verbose-MOD.linearizing > 3
        fprintf('\n');
    end
    try temp = icf.wf1w; %#ok<NASGU>
    catch ERR %#ok<NASGU>
        icf.wf1w    = 0;
        ic.p1c      = icf.p1;
        ic.px       = ic.p1c-200;
        ic.xtv      = 0;
        ic.xhs      = 0;
        icf.wf1leak = 0;
    end
    ic.xtvm     = 0;
    ic.xhsm     = 0;
    ic.pxm      = -1000;
    ic.p1cm     = -1000;
    icf.wftvb   = 0;
    ic.wftvbm   = -1000;
    icf.count   = 0;
    while ( (   abs(ic.p1c  - ic.p1cm)>1e-16 |..
        abs(ic.xtv  - ic.xtvm)>1e-20 |..
        abs(ic.px   - ic.pxm )>1e-20 |..
        abs(icf.wftvb - ic.wftvbm )>1e-20 |..
        abs(ic.xhs  - ic.xhsm)>1e-20) ..
        & icf.count<25 )
        icf.count   = icf.count + 1;
        ic.p1cm = ic.p1c;
        ic.xtvm = ic.xtv;
        ic.xhsm = ic.xhs;
        ic.pxm      = ic.px;
        ic.wftvbm   = icf.wftvb;

        icf.wf1cx   = icf.wfmd + icf.wf1vg - icf.wf1v + icf.wf1w + icf.wf1leak - icf.wftvb;

        // Check Valve
        ic.p1c      = icf.p1 - or_awtop(GEOF.check.ao, icf.wf1cx, 0., GEOF.check.cd, FP.sg);
        icf.p2      = ic.p1c;

        // PRT regulator
        icf.prt     = max(ic.p1c-(GEOF.prtv.fspr+0.01*GEOF.prtv.ks)/GEOF.prtv.ax1, icf.pc);

        // PR regulator
        icf.pr      = min(icf.pc+250, ic.p1c);

        //  Head sensor
    icf.lqx     = max(min(GEOF.hs.flap.ln/ic.xhs, GEOF.hs.flap.cf(end,1)), GEOF.hs.flap.cf(1,1));
    icf.hs.cf   = interp1(GEOF.hs.flap.cf(:,1), GEOF.hs.flap.cf(:,2), icf.lqx, 'linear', 'extrap');
    icf.p3      = icf.p2 + ((ic.px-icf.p2)*GEOF.hs.flap.an*(1+(icf.hs.cf*ic.xhs*4/GEOF.hs.flap.dn)^2)   ..
    - GEOF.hs.fspr - GEOF.hs.fb - ic.xhs*(GEOF.hs.ks + GEOF.hs.kb)) / GEOF.hs.ae;
    icf.p3mpd   = icf.p3 - icf.pd;
    icf.p2mp3   = icf.p2 - icf.p3;

    icf.wf1c        = icf.wf1cx + icf.wfb;
    icf.mv.wfd      = icf.wfmd;
    icf.mvtv.wfd    = icf.wfmd;

    //  Throttle valve
    icf.mvtv.ad = or_wptoa(icf.wfmd, icf.p3, icf.pd, GEOF.mvtv.cd, FP.sg);
    ic.xtv      = max(min(interp1(GEOF.mvtv.ad(:,2), GEOF.mvtv.ad(:,1), icf.mvtv.ad, 'linear', 'extrap'), GEOF.mvtv.xmax), GEOF.mvtv.xmin);
    ic.px      = (icf.p3*(GEOF.mvtv.ax1-GEOF.mvtv.ax4) - icf.prt*(GEOF.mvtv.ax1-GEOF.mvtv.ax2) - GEOF.mvtv.ks*ic.xtv - GEOF.mvtv.fspr) / GEOF.mvtv.ax2;
    icf.wftvb   = or_aptow(GEOF.a_tvb, icf.prt, ic.px, GEOF.cd_tvb, FP.sg);

    icf.wf1mv   = icf.wfmd;

    //  Metering valve
    icf.mv.a    = or_wptoa(icf.wf1mv, icf.p2, icf.p3, GEOF.mv.cd, FP.sg);
    icf.mv.x    = interp1(GEOF.mv.awin(:,2), GEOF.mv.awin(:,1), icf.mv.a);

    // MV Servovalve leakage f(p1c)
    icf.wf1leak   = or_aptow(GEOF.a1leak, icf.pr, icf.pc, 0.61, FP.sg) + ..
    la_kptow(GEOF.k1leak, icf.pr, icf.pc, FP.kvis);
    icf.wfr     = 0*(ic.p1c-icf.pc);       //  mvsv leakage estimate
    icf.wf1w    = icf.wfr;

    // Head sensor recalc for feedback
    icf.wfhs    = -icf.wftvb;
    ic.xhs      = GEOF.hs.flap.an*GEOF.hs.flap.cn/(icf.hs.cf*GEOF.hs.flap.dn*pi)/..
    sqrt( FP.sg*abs(ic.px-icf.p2)*(GEOF.hs.flap.an*GEOF.hs.flap.cn*19020/icf.wfhs)^2 - 1);
    ic.xhs      = max(min(ic.xhs, GEOF.hs.xmax), GEOF.hs.xmin);
    if MOD.verbose-MOD.linearizing > 4
        ic.wfcheck     = 19020*sqrt(FP.sg*abs(ic.px-icf.p2)/(1/(GEOF.hs.flap.an*GEOF.hs.flap.cn)^2 + 1/(icf.hs.cf*GEOF.hs.flap.dn*pi*ic.xhs)^2));
        fprintf('x=%16.12f, p2=%f, px=%f, wf=%f, wfcheck=%f\n', ic.xhs, icf.p2, ic.px, icf.wfhs, ic.wfcheck);
    end

    if MOD.verbose-MOD.linearizing > 4
        fprintf('IFC(%ld):  p1c=%f/%f, xtv=%14.12f/%14.12f, xhs=%14.12f/%14.12f, px=%f/%f\n', icf.count, ic.p1c, ic.p1cm, ic.xtv, ic.xtvm, ic.xhs, ic.xhsm, ic.px, ic.pxm);
    end
end
if icf.count >=25 && MOD.verbose-MOD.linearizing>3
    fprintf('\n*****WARNING(%s):  loop counter maximum.    p1=%f, p1m=%f, xtv=%14.12f, xtvm=%14.12f, xhs=%14.12f, xhsm=%14.12f\n', mfilename, ic.p1c, ic.p1cm, ic.xtv, ic.xtvm, ic.xhs, ic.xhsm);
end
// end loop

// Assign
icf.hs.x    = ic.xhs;
icf.mvtv.x  = ic.xtv;
icf.wf2s    = 0;
icf.wf3s    = 0;
icf.wfrt    = icf.wftvb;
icf.wfx     = icf.wftvb;
icf.wf1s    = -icf.wftvb;
icf.wfc     = -icf.wfrt + icf.wf1w + icf.wf1leak;
icf.p1c     = ic.p1c;
icf.px      = ic.px;
icf.xtv     = icf.mvtv.x;
icf.mvsv.x      = 0;
icf.vo_px1.wf   = 0;
icf.vo_px1.p    = (icf.pr+icf.pc)/2;
icf.vo_px2.wf   = 0;
icf.vo_px2.p    = (icf.pr+icf.pc)/2;
icf.check.x     = 0.31;
icf.ln_p3s.wf   = 0;
icf.ln_p3s.p    = icf.p3;
icf.vo_p3s.wf   = 0;
icf.vo_p3s.p    = icf.p3;
icf.vo_p2.wf    = icf.wfmd;
icf.vo_p2.p     = icf.p2;
icf.vo_p3.wf    = icf.wfmd;
icf.vo_p3.p     = icf.p3;
icf.vo_pd.wf    = icf.wfmd;
icf.vo_pd.p     = ic.pd;
icf.vo_px.wf    = icf.wf1s;
icf.vo_px.p     = icf.px;
icf.mo_p3s.wf   = 0;
icf.mo_p3s.p    = icf.vo_p3.p;



// Re-assign
ic.ifc = icf;
endfunction
