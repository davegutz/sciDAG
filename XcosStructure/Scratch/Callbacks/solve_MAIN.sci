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
// SOFTWARGEO.eng.
// Mar 27, 2019 DA Gutz Created
//
function [INI, G] = solve_MAIN(INI, G, FP)
    // Initialize engine main flow path including engine

    // Inputs: wf36, xn25
    // Outputs: t25, pr=pb1, ps=pb2
    INI.eng.wf36 = INI.wf36;
    INI.eng.xn25 = INI.xn25;
    INI.eng.pcn25 = INI.eng.xn25/G.eng.N25100Pct*100;
    INI.eng.dpnoz = rev_lookup(INI.eng.wf36, G.mline.noz);
    INI.eng.ps3 = lookup(INI.eng.wf36, G.eng.ps3t);
    INI.eng.pcn25r = lookup(INI.eng.wf36, G.eng.pcn25rt);
    INI.eng.t25 = lookup(INI.eng.wf36, G.eng.t25t);
    INI.eng.pnozin = min((INI.eng.wf36/540)^2*130, INI.eng.dpnoz+INI.eng.ps3);
    //INI.eng.dpcd = max( 171.5*(INI.eng.wf36/17000)^2 , 40);
    //INI.eng.pcd = INI.eng.pnozin+INI.eng.dpcd;
    INI.eng.pcd = or_awpdtops(0.0793, INI.eng.wf36, INI.eng.pnozin, 1.0, FP.sg);
    INI.eng.dpcd = INI.eng.pcd - INI.eng.pnozin;
    INI.pd = INI.eng.pcd;
    INI.vo_pnozin.p = INI.eng.pnozin;
    INI.vo_pnozin.wf = INI.eng.wf36;
    INI.main_line.p = INI.eng.pcd;
    INI.main_line.wf = INI.eng.wf36;
    INI.xn25 = INI.eng.xn25;
    INI.acsupply.acbst.NRpm = INI.eng.xn25*INI.sAC;
    INI.acsupply.acmbst.NRpm = INI.eng.xn25*INI.sAC;
    INI.ptank = INI.pamb+3;
    INI.wfb = 0; //*********** TODO: add thermal bypass model
    // INI.wf1mv = DS.V.wf1mv(initInd, 2);
    // INI.wf1s = DS.V.wf1s(initInd, 2);
    // INI.wf1w = DS.V.wf1w(initInd, 2);

    // Supply
    INI.wf1v = 0;
    INI.wfc = 0; // init
    INI.wfccvg = 0; // init
    INI.wfcfvg = 0; // init
    INI.wf1cvg = 0; // init
    INI.wf1fvg = 0; // init

    // Initialize aircraft supply system
    // Inputs: pamb, wfengine=wfac=wf36, xn25 et.al.
    // Outputs: pengine
    [INI.acsupply, G.acsupply] = solve_AC(INI.acsupply, INI.ptank, INI.eng.ps3, INI.eng.wf36, G.acsupply, FP);

    INI.pengine = INI.acsupply.pengine;
    INI.ebp.pengine = INI.pengine;
    INI.ven.pengine = INI.pengine;
    INI.wfmd = INI.eng.wf36;


    // Initialize fuel system loop
    // Loop to solve P1 f(wf1leak)
    INI.countlk = 0;
    INI.wf1vg = 0; // TODO: add wf1vg (FVG+CVG) to iteration and model
    INI.wf1leak = INI.wf1vg;
    INI.wf1leakm = -1000;
    // if INI.verbose-INI.linearizing > 0, fprintf('\n'); end

    while (abs(INI.wf1leak - INI.wf1leakm)>1e-16 & INI.countlk<25)
        INI.wf1leakm = INI.wf1leak;
        INI.countlk = INI.countlk + 1;
        // check valve
        if(INI.xn25 >= 9466.)
            INI.wf1cx = INI.wfmd + INI.wf1vg + INI.wf1v + INI.wfc;
        else
            INI.wf1cx = 0.;
        end
        // Initialize installed engine pump system
        // Inputs: pengine, wf1cx, wf1v, wfb, wfs, wfr
        // Outputs: wfengine, p1, psven=pb1, prven=pb2
        INI = Init_BOOST_INST(INI, G, FP);
        INI.pmainp = INI.ebp.mfp.ps;
        INI.p1 = INI.ebp.mfp.pd;
        // Initialize IFC
        // Inputs: p1, wfmd=wf36, pd, wf1vg=wf1cvg+wf1fvg, wf1v=wfstart, pc, awfb
        // Outputs: wf1c, wfb
        INI.precx = INI.pamb;
        INI.pc = INI.pmainp;
        INI.eng.wf36 = INI.eng.wf36;
        INI.vo_p1.p = INI.p1;
        INI.vo_p1.wf = INI.wf1leak;
        INI.precx = INI.precx;
        INI.ifc.p1 = INI.p1;
        INI = solve_IFC(INI, G.ifc, FP);
        INI.wf1leak = INI.wfc + INI.wf1vg;
        if INI.verbose-INI.linearizing > 3
            mprintf('MAIN(%ld): wf1leak=%f/%f\n', INI.countlk, INI.wf1leak, INI.wf1leakm);
        end
    end
    if INI.countlk >=25
        mprintf('\n*****WARNING(%s): loop counter maximum. wf1leak=%f, wf1leakm=%f\n', mfilename, INI.wf1leak, INI.wf1leakm);
    end
    // end loop

endfunction

function [INI, G] = solve_AC(INI, ptank, ps3, wf36, G, FP)
    // Inputs: pamb, wfengine=wfac=wf36, xn25 et.al.
    // Outputs: pengine

    // Outputs

    // Name changes
    acb = G.acbst;
    acmb = G.acmbst;
    amotor = G.motor;
    iacb = INI.acbst;
    iacmb = INI.acmbst;

    INI.ltank.wf = wf36;
    INI.lengine.wf = wf36;
    iltank = INI.ltank;
    ilengine = INI.lengine;
    FP.dwdc = 129.93948*FP.sg;
    FP.avis = 9.312e-5 * .00155 * FP.sg * FP.kvis;
    FP.tvp_margin = -1e6;
    FP.tvp = 5; // Assumed

    Qac_init = wf36 / FP.dwdc;
    iacb.q = Qac_init;
    S_init = 0.5; //initial loop value
    S_max = 1;
    S_min = 0;
    count = 0;

    // AC tank pressure
    Pac = ps3; //(Add to upper level)
    Pacm = ptank; //(Add to upper level)

    // Top of loop
    // fprintf('pass Pac Pacm S_now S_max S_min\n');
    while (abs(Pac - Pacm)>1e-6 & S_init<1 & count<50)
        iacmb.q = Qac_init * S_init;
        imotor.wf = iacmb.q * FP.dwdc;

        // Calculate pressures
        Pac_init =ptank;

        // Pump pressure
        fcx = 5.851 * Qac_init / (3.85 * acb.w2 * acb.r2^2 * iacb.NRpm);
        hcx = acb.a + (acb.b + (acb.c + acb.d * fcx) * fcx) * fcx;
        iacb.dP_Pump = 1.022e-6 * hcx * FP.sg * (acb.r2^2 - acb.r1^2) * iacb.NRpm^2;
        iacb.Pd_Pump = ptank + iacb.dP_Pump;
        fcx = 5.851 * Qac_init / (3.85 * acmb.w2 * acmb.r2^2 * iacmb.NRpm);
        hcx = acmb.a + (acmb.b + (acmb.c + acmb.d * fcx) * fcx) * fcx;
        iacmb.dP_Pump = 1.022e-6 * hcx * FP.sg * (acmb.r2^2 - acmb.r1^2) * iacmb.NRpm^2;
        iacmb.Pd_Pump = iacb.Pd_Pump + iacmb.dP_Pump;
        clear fcx hcx

        // Orifice:(Q, Area) --> dP
        imotor.dP = sign(Qac_init) * amotor.dp*(imotor.wf/amotor.wf)^2;

        ilengine.p = iacmb.Pd_Pump - imotor.dP;
        Pac = iacb.Pd_Pump;
        Pacm = ilengine.p;
        count = count + 1;
        S_now = S_init;
        // mprintf('%ld %5.1f %5.1f %5.2f %5.2f %5.2f\n', count, Pac, Pacm, S_now, S_max, S_min);
        if Pacm > Pac
            S_init = (S_now + S_max)/2;
            S_min = max(S_min, S_now);
        else
            S_init = (S_now + S_min)/2;
            S_max = min(S_max, S_now);
        end

    end
    // mprintf('pass Pac Pacm S_now S_max S_min\n');
    iltank.p = Pac_init;
    iltank.wf = iacb.q * FP.dwdc;
    INI.pengine = ilengine.p;
    INI.wfbypass = iacb.q * FP.dwdc * (1-S_init);
    INI.wfacbst = iacb.q * FP.dwdc;
    INI.wfacmbst = iacmb.q * FP.dwdc;
    iacb.Ps_Pump = Pac_init;
    INI.ltank.p = Pac_init;
    INI.pacbsts = Pac_init;
    INI.pacbst = iacb.Pd_Pump;
    INI.pacmbst = iacmb.Pd_Pump;
    INI.ptank = ptank;
    G.acbst = acb;
    G.acmbst = acmb;
    G.motor = amotor;
    INI.acbst = iacb;
    INI.acmbst = iacmb;
    INI.motor = imotor;
    INI.ltank = iltank;
    INI.lengine = ilengine;
    INI.S_init = S_init;
endfunction

function ic = Init_BOOST_INST(ic, GEO, FP)
    // 29-Apr-2012 DA Gutz Created
    // 05-Jun-2017 DA Gutz PB1,PB2 names

    // Inputs: pengine, wfc, wfcvg, wfb, wfs, wfr
    // Outputs: wfengine, p1, pb2, prven=pb1

    // Name changes
    ice = ic.ebp;
    icv = ic.ven;
    GEOE = GEO.ebp;
    GEOV = GEO.ven;
    ice.wfr = ic.wfr;
    ice.wfs = ic.wfs;

    ice.mfp.N = ic.xn25 * GEO.eng.xnmainpt/GEO.eng.xn25p;
    ice.boost.N = ic.xn25 * GEO.eng.xnvent/GEO.eng.xn25p;

    ic.wf1p = ic.wf1cx + ic.wfb;
    ic.wfoc = ic.wf1p - ic.wfccvg - ic.wfcfvg - ic.wfc;
    ic.wffilt = ic.wfoc + ic.wfs;
    ic.wfb2 = ic.wffilt - ice.wfr;
    ic.wfengine = ic.wfb2;
    [dummy, icv.boost.dp] = ip_wtodp(GEOE.boost.a, GEOE.boost.b, GEOE.boost.c, GEOE.boost.d, GEOE.boost.r1, 0,  GEOE.boost.r2, GEOE.boost.w2, ice.boost.N, ic.wfb2, FP.sg, GEOE.boost.tau);
    ic.pb1 = ic.pengine + icv.boost.dp;
    icv.filt.dp = ic.pb1-or_awpstopd(GEOE.or_filt.ao, ic.wffilt, ic.pb1, GEOE.or_filt.cd, FP.sg);
    ic.pb2 = ic.pb1 - icv.filt.dp;
    ice.focOr.dp = ic.pb2-or_awpstopd(GEOE.focOr.ao, ic.wfoc, ic.pb2, GEOE.focOr.cd, FP.sg);
    ic.poc = ic.pb2 - ice.focOr.dp;
    [dummy, ice.mfp.dp] = ip_wtodp(GEOE.mfp.a, GEOE.mfp.b, GEOE.mfp.c, GEOE.mfp.d, GEOE.mfp.r1, 0, GEOE.mfp.r2, GEOE.mfp.w2, ice.mfp.N, ic.wf1p, FP.sg, GEOE.mfp.tau);
    ic.p1 = ice.mfp.dp + ic.poc;

    // Assign
    ice.inlet.wf = ic.wfengine;
    ice.inlet.p = ic.pengine;
    ice.pb1 = ic.pb1;
    ice.boost.wf = ic.wfb2;
    ice.boost.ps = ic.pengine;
    ice.boost.pd = ic.pb1;
    ice.vo_pb1.p = ic.pb1;
    ice.vo_pb1.wf = ic.wffilt;
    ice.filt.wf = ic.wffilt;
    ice.filt.p = ic.pb1;
    ice.filt.ps = ic.pb1;
    ice.filt.pd = ic.pb2;
    ice.vo_pb2.p = ic.pb2;
    ice.vo_pb2.wf = ic.wffilt;
    ice.fab.wf = ic.wffilt - ic.wfs;
    ice.fab.p = ic.pb2;
    ice.aboc.p = ic.pb2;
    ice.aboc.wf = ic.wffilt - ic.wfs;
    ice.faboc = ice.aboc;
    ice.vo_poc.p = ic.poc;
    ice.vo_poc.wf = ic.wfoc;
    ice.focOr.wf = ic.wfoc;
    ic.wfabocx1 = ic.wfoc;
    ic.wfocmx1 = ic.wfoc;
    ice.focOr.ps = ic.pb2;
    ice.focOr.pd = ic.poc;
    ice.ocm1.p = ic.poc;
    ice.ocm1.wf = ic.wfocmx1;
    ice.ocm2.p = ic.poc;
    ice.ocm2.wf = ic.wf1p;
    ice.mfp.ps = ic.poc;
    ice.mfp.pd = ic.p1;
    ice.mfp.wf = ic.wf1p;

    // Re-assign
    ic.ebp = ice;
    ic.ven = icv;
endfunction
