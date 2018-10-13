// lti_trivalve_a.  Building block for a trivalve.  Transient and jet forces
// neglected.  Friction is neglected (damping input).  Transient
// leakages neglected.
// Author:    D. A. Gutz
// Written:    17-Aug-92.
// Revisions:    19-Aug-92    Simplify output arguments.
//        26-Aug-92    Reconfigure.
//        11-Sep-92    Added stops.
//        14-Sep-92    Change pressure cause to 0.
// 
// Input:
// ahs        Spool supply end head area, sqin.
// ahd        Spool drain end head area, sqin.
// alr        Load land rod end head area, sqin.
// ald        Load land drain end head area, sqin.
// ale        Load land bitter end area, sqin.
// bdamp        Damping, lbf/(in/sec).
// cause        Causality, 0=pressure, 1=flow.
// cd        Coefficient of discharge.
// ks        Spring rate, lbf/in.
// m        Total mass, lbm.
// ki        Torque motor gain, lbf/mA.
// ps        Supply pressure, psia.
// pd        Drain pressure, psia.
// px        Control pressure, psia.
// sg        Fluid specific gravity.
// ws        Supply area gradient, sqin/in.
// wd        Discharge area gradient, sqin/in.
// wfxd        Discharge flow out, pph.
// wfsx        Supply flow in, pph.
// stops        0=go.
// 
// Output:
// sys        Packed system of Input and Output.
// 
// Differential IO:
// ps        Input # 1, supply pressure, psia.
// pd        Input # 2, drain pressure, psia.
// px        Input # 3, control pressure, psia.    (cause=0)
// wfx        Input # 3, control flow out, pph.    (cause=1)
// pes        Input # 4, supply end pressure, psia.
// ped        Input # 5, drain end pressure, psia.
// pel        Input # 6, load land bitter end pressure, psia.
// plr        Input # 7, inside external land pressure, psia.
// pld        Input # 8, outside external land pressure, psia.
// mA        Input # 9, torque motor current, mA.
// fext        Input # 10, external load toward drain, lbf.
// wfs        Output # 1, supply flow in, pph.
// wfd        Output # 2, drain flow out, pph.
// wfx        Output # 3, control flow out, pph.    (cause=0)
// px        Output # 3, control pressure, psia     (cause=1)
// wfse        Output # 4, supply end flow out, pph.
// wfde        Output # 5, drain end flow out, pph.
// wfle        Output # 6, load land bitter end flow out, pph.
// wflr        Output # 7, external land flow into rod side, pph.
// wfld        Output # 8, external land flow out drain side, pph.
// dxdt        Output # 9, spool velocity toward drain, in/sec.
// x         Output # 10, spool displacement toward drain, in.
// 
// Local:
// ad        Drain window area, sqin.
// as        Supply discharge window area, sqin.
// dwdc        Flow conversion, pph/cis.
// 
// States:
// dxdt        Spool velocity toward drain, in/sec.
// x        Spool displacement toward drain, in.
// 
// Functions called:
// or_wptoa    Orifice area.
// ssqrt        Signed square root.
// Copyright (C) 2018 - Dave Gutz
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
// Oct 13, 2018    DA Gutz    Created
// **************************************************************************
function [sys] = lti_trivalve_a(ahs,ahd,alr,ald,ale,bdamp,%cd,ks,m,ki,cause,ps,pd,px,sg,ws,wd,wfsx,wfxd,stops)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Parameters.
    dwdc = 129.93948*sg;
    ad = or_wptoa(wfxd, px, pd, %cd, sg);
    as = or_wptoa(wfsx, ps, px, %cd, sg);

    // Partials.
    dwfsda = wfsx / max(as, 1.0D-16);
    dwfsdp = wfsx / (2*(ps-px));
    dasdx = ws;
    dwfdda = wfxd / max(ad, 1.0D-16);
    dwfddp = wfxd/(2*(px-pd));
    daddx = -wd;
    dwfxdx = dwfsda*dasdx-dwfdda*daddx;
    dwfxdpx = dwfsdp+dwfddp;

    // Connections and system construction.
    as = [-bdamp, -ks] * 386 / m;
    as = [as;  1,0];
    bs = [0, 0, 0, ahs, -ahd, -ale, alr, -ald, ki, 1];
    bs = bs * 386 / m;
    bs = [bs; 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    if mtlb_logic(stops,"<>",0) then
        // Freeze states if on stops.
        bs = 0*bs;
    end;
    // Pressure causality:
    if mtlb_logic(cause,"==",0) then
        cs = [  0, dwfsda*dasdx;
                0, dwfdda*daddx;
                0, dwfxdx;
                (-dwdc)*ahs, 0;
                dwdc*ahd, 0;
                dwdc*ale, 0;
                dwdc*alr, 0;
                dwdc*ald, 0;
                1,        0;
                0,        1];
        es = [  dwfsdp,0,-dwfsdp,0,0,0,0,0,0,0;
                0,-dwfddp,dwfddp,0,0,0,0,0,0,0;
                dwfsdp,dwfddp,-dwfxdpx,0,0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0;
                0,0,0,0,0,0,0,0,0,0];
        // Flow causality:
    else
        if mtlb_logic(cause,"==",1) then
            cs = [  0,(dwfsda*dasdx-(dwfxdx*dwfsdp)/dwfxdpx);
                    0,(dwfdda*daddx+(dwfxdx*dwfddp)/dwfxdpx);
                    0, dwfxdx/dwfxdpx;
                    (-dwdc)*ahs, 0;
                    dwdc*ahd,    0;
                    dwdc*ale,    0;
                    dwdc*alr,    0;
                    dwdc*ald,    0;
                    1,           0;
                    0,           1];

            es = [  (dwfsdp-(dwfsdp*dwfsdp)/dwfxdpx),((-dwfddp)*dwfsdp)/dwfxdpx,dwfsdp/dwfxdpx,0,0,0,0,0,0,0;
                    (dwfsdp*dwfddp)/dwfxdpx,((dwfddp*dwfddp)/dwfxdpx-dwfddp),(-dwfddp)/dwfxdpx,0,0,0,0,0,0,0;
                    dwfsdp/dwfxdpx,dwfddp/dwfxdpx,-1/dwfxdpx,0,0,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0;
                    0,0,0,0,0,0,0,0,0,0];
        else
            error("Improper cause input to trivalve_a.")
            // ! L.111: mtlb(resume) can be replaced by resume() or resume whether resume is an M-file or not.
//            mtlb(resume);
        end;
    end;

    // Form the system.
    sys = pack_ss(as, bs, cs, es);

endfunction
