// Copyright (C) 2019 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, suvebject to the following conditions:
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
// Jan 1, 2019  DA Gutz     Created
// 
function overplot(st, c, %title)
    xtitle(%title)
    [n, m] = size(st);
    [nc, mc] = size(c);
    for i=1:m
        plot(evstr(st(i)+'.time'), evstr(st(i)+'.values'), c(i))
    end
    set(gca(),"grid",[1 1])
    legend(st);
endfunction

global LINCOS_OVERRIDE figs sys_f cpr scs_m LIN MOD
global DI DV
mprintf('In %s\n', sfilename())

if ~MOD.logAll then
    mprintf("Data not logged.  Set MOD.logAll=''t'' to do so and re-run.\n")
    mprintf('Completed %s\n', sfilename())  
    return
end

try cpr = %cpr; end
try close(figs); end
figs=[];

if MOD.plotEnable  & Tf>1e-6 then

    tWALL = WALL.time(:,1);
    WFMD = struct('time', tWALL, 'values', WALL.values(:,1));
    WF36 = struct('time', tWALL, 'values', WALL.values(:,2));
    WF1V = struct('time', tWALL, 'values', WALL.values(:,4));
    tIDATA = IDATA.time(:,1);
    P1SO = struct('time', tIDATA, 'values', IDATA.values(:,1));
    P3 = struct('time', tIDATA, 'values', IDATA.values(:,2));
    P2MP3 = P1SO; P2MP3.values = P1SO.values-P3.values;
    PD = struct('time', tIDATA, 'values', IDATA.values(:,3));
    PX = struct('time', tIDATA, 'values', IDATA.values(:,4));
    P1 = struct('time', tIDATA, 'values', IDATA.values(:,5));
    WFAREA = struct('time', tIDATA, 'values', IDATA.values(:,6));
    WFMV = struct('time', tIDATA, 'values', IDATA.values(:,7));
    WF3 = struct('time', tIDATA, 'values', IDATA.values(:,10));
    WF1MV = struct('time', tIDATA, 'values', IDATA.values(:,11));
    WF1S = struct('time', tIDATA, 'values', IDATA.values(:,12));
    WF3S = struct('time', tIDATA, 'values', IDATA.values(:,13));
    WF3SX = struct('time', tIDATA, 'values', IDATA.values(:,14));
    WFL3S = struct('time', tIDATA, 'values', IDATA.values(:,15));
    WFC = struct('time', tIDATA, 'values', IDATA.values(:,16));
    MV_POS = struct('time', tIDATA, 'values', IDATA.values(:,17));
    TV_POS = struct('time', tIDATA, 'values', IDATA.values(:,18));
    HS_POS = struct('time', tIDATA, 'values', IDATA.values(:,19));

    tPALL = PALL.time(:,1);
    PDVEN = struct('time', tPALL, 'values', PALL.values(:,1));
    P_NOZIN = struct('time', tPALL, 'values', PALL.values(:,2));
    PS3 = struct('time', tPALL, 'values', PALL.values(:,3));
    P1SV = struct('time', tPALL, 'values', PALL.values(:,4));

    // AC Supply
    tADATA = ADATA.time(:,1);
    ACMOTIVEPULL = struct('time', tADATA, 'values', ADATA.values(:,1));
    PACBMIX = struct('time', tADATA, 'values', ADATA.values(:,2));
    PENGINE = struct('time', tADATA, 'values', ADATA.values(:,3));
    PDACBST = struct('time', tADATA, 'values', ADATA.values(:,4));
    PDACMBST = struct('time', tADATA, 'values', ADATA.values(:,5));
    PSACMBST = PDACBST;
    PSACBST = struct('time', tADATA, 'values', ADATA.values(:,6));
    WFACBST = struct('time', tADATA, 'values', ADATA.values(:,7));
    WFACMBST = struct('time', tADATA, 'values', ADATA.values(:,8));
    WFBYPASS = struct('time', tADATA, 'values', ADATA.values(:,9));
    WFENGINE = struct('time', tADATA, 'values', ADATA.values(:,10));
    WFTANK = struct('time', tADATA, 'values', ADATA.values(:,11));

    // EBOOST
    tBDATA = BDATA.time(:,1);
    DPBOOST = struct('time', tBDATA, 'values', BDATA.values(:,1));
    DPMFP = struct('time', tBDATA, 'values', BDATA.values(:,2));
    P_1 = struct('time', tBDATA, 'values', BDATA.values(:,3));
    PB1 = struct('time', tBDATA, 'values', BDATA.values(:,4));
    PB2 = struct('time', tBDATA, 'values', BDATA.values(:,5));
    PMAINP = struct('time', tBDATA, 'values', BDATA.values(:,7));
    POC = struct('time', tBDATA, 'values', BDATA.values(:,8));
    WF1P = struct('time', tBDATA, 'values', BDATA.values(:,9));
    WFB2 = struct('time', tBDATA, 'values', BDATA.values(:,10));
    WFOC = struct('time', tBDATA, 'values', BDATA.values(:,13));
    XNMAIN = struct('time', tBDATA, 'values', BDATA.values(:,15));
    XNVEN = struct('time', tBDATA, 'values', BDATA.values(:,16));
    PSMFP = struct('time', tBDATA, 'values', BDATA.values(:,17));
    WFFILT = struct('time', tBDATA, 'values', BDATA.values(:,18));  // dag 5/25/2019
    WFENGINEb = struct('time', tBDATA, 'values', BDATA.values(:,11));  // dag 5/25/2019

    // VEN
    tVDATA = VDATA.time(:,1);
    PD_VEN = struct('time', tVDATA, 'values', VDATA.values(:,2));
    PROD = struct('time', tVDATA, 'values', VDATA.values(:,4));
    PHEAD = struct('time', tVDATA, 'values', VDATA.values(:,5));
    PX_V = struct('time', tVDATA, 'values', VDATA.values(:,6));
    PS_HLINE = struct('time', tVDATA, 'values', VDATA.values(:,7));
    PS_RLINE = struct('time', tVDATA, 'values', VDATA.values(:,8));
    WFS_START = struct('time', tVDATA, 'values', VDATA.values(:,10));
    VLOAD_WFLLK = struct('time', tVDATA, 'values', VDATA.values(:,11));
    VLOAD_WFLOAD = struct('time', tVDATA, 'values', VDATA.values(:,12));
    WF_VDPP = struct('time', tVDATA, 'values', VDATA.values(:,13));
    WFVX_START = struct('time', tVDATA, 'values', VDATA.values(:,14));
    BIAS_WFVE = struct('time', tVDATA, 'values', VDATA.values(:,15));
    WFS_R =  struct('time', tVDATA, 'values', VDATA.values(:,16));
    WFD_R =  struct('time', tVDATA, 'values', VDATA.values(:,17));
    WFX_R =  struct('time', tVDATA, 'values', VDATA.values(:,18));
    WFSE_R =  struct('time', tVDATA, 'values', VDATA.values(:,19));
    WFS_RRV =  struct('time', tVDATA, 'values', VDATA.values(:,20));
    WFD_RRV =  struct('time', tVDATA, 'values', VDATA.values(:,21));
    WFVX_RRV =  struct('time', tVDATA, 'values', VDATA.values(:,22));
    WFR_VEN =  struct('time', tVDATA, 'values', VDATA.values(:,23));
    WFS_VEN =  struct('time', tVDATA, 'values', VDATA.values(:,24));
    ACTSYS_WFH = struct('time', tVDATA, 'values', VDATA.values(:,25));
    ACTSYS_WFR = struct('time', tVDATA, 'values', VDATA.values(:,26));
    SV_POS = struct('time', tVDATA, 'values', VDATA.values(:,27));
    TRI_X = struct('time', tVDATA, 'values', VDATA.values(:,28));
    BIAS_X = struct('time', tVDATA, 'values', VDATA.values(:,29));
    X_PACT  = struct('time', tVDATA, 'values', VDATA.values(:,30));
    X_RRV  = struct('time', tVDATA, 'values', VDATA.values(:,31));
    X_VEHSV  = struct('time', tVDATA, 'values', VDATA.values(:,32));
    BIAS_FEXT = struct('time', tVDATA, 'values', VDATA.values(:,33));
    XVEN = struct('time', tVDATA, 'values', VDATA.values(:,34));
    VVEN = struct('time', tVDATA, 'values', VDATA.values(:,35));
    TRI_V = struct('time', tVDATA, 'values', VDATA.values(:,36));
    TRI_MODE = struct('time', tVDATA, 'values', VDATA.values(:,37));
    VE_UF = struct('time', tVDATA, 'values', VDATA.values(:,38));
    VE_UF_NET = struct('time', tVDATA, 'values', VDATA.values(:,39));
    VE_MODE = struct('time', tVDATA, 'values', VDATA.values(:,40));
    TRI_UF =  struct('time', tVDATA, 'values', VDATA.values(:,41));

    // VEN Load
    tLDATA = LDATA.time(:,1);
    VEWFHD = struct('time', tLDATA, 'values', LDATA.values(:,1));
    VEWFHx = struct('time', tLDATA, 'values', LDATA.values(:,2));
    VEWFRD = struct('time', tLDATA, 'values', LDATA.values(:,3));
    VEWFSH = struct('time', tLDATA, 'values', LDATA.values(:,4));
    VEWFRx = struct('time', tLDATA, 'values', LDATA.values(:,5));
    VEWFSR = struct('time', tLDATA, 'values', LDATA.values(:,6));
    vewfhd = DV.ehsv.SPOOL.wf.wfhd;
    vewfh = DV.ehsv.SPOOL.wf.wfh;
    vewfrd = DV.ehsv.SPOOL.wf.wfrd;
    vewfsh = DV.ehsv.SPOOL.wf.wfsh;
    vewfr = DV.ehsv.SPOOL.wf.wfr;
    vewfsr = DV.ehsv.SPOOL.wf.wfsr;
    VEGS = struct('time', tLDATA, 'values', LDATA.values(:,15)); // dag 6/16/2019
    vegs = DV.ehsv.SPOOL.gainScale; // dag 6/16/2019
    VEV = struct('time', tLDATA, 'values', LDATA.values(:,16));
    VEMA = struct('time', tLDATA, 'values', LDATA.values(:,17));
    VEX = struct('time', tLDATA, 'values', LDATA.values(:,18));
    VEXD = struct('time', tLDATA, 'values', LDATA.values(:,19));
    VEWFHx = struct('time', tLDATA, 'values', LDATA.values(:,20));// dag 6/11/2019
//    VEWFH = ACTSYS_WFH;// dag 6/11/2019
    VEWFRx = struct('time', tLDATA, 'values', LDATA.values(:,21));  // dag 6/11/2019
//    VEWFR = ACTSYS_WFR;// dag 6/11/2019
    VEWFS = struct('time', tLDATA, 'values', LDATA.values(:,22));
    VEWFD = struct('time', tLDATA, 'values', LDATA.values(:,23));

    tYDATA = YDATA.time(:,1);
    VDPP_RPM = struct('time', tYDATA, 'values', YDATA.values(:,1));
    PACT_WFLKOUT = struct('time', tYDATA, 'values', YDATA.values(:,2));
    PACT_DISP = struct('time', tYDATA, 'values', YDATA.values(:,3));
    VDPP_WF = struct('time', tYDATA, 'values', YDATA.values(:,4));
    PACT_WFR = struct('time', tYDATA, 'values', YDATA.values(:,5));
    PACT_WFH = struct('time', tYDATA, 'values', YDATA.values(:,6));
    VDPP_MTDQP = struct('time', tYDATA, 'values', YDATA.values(:,7));
    VDPP_EFF_VOL = struct('time', tYDATA, 'values', YDATA.values(:,8));
    VDPP_PL = struct('time', tYDATA, 'values', YDATA.values(:,9));

    clear tWALL tIDATA tPALL tVDATA tADATA tBDATA tLDATA tYDATA

    vload_wfload = DV.wfload;
    vload_wfload.values = vload_wfload.values + start_wfs.values;
    wf1v = DI.ifc.In.wf1v;
    wf1mv = DI.ifc.Calc.Flow.wf1mv;
    wf1s = DI.ifc.Calc.Flow.wf1s;
    mv_wfd = DI.ifc.Calc.Flow.wfmv;
    wf3 = DI.ifc.Calc.Flow.wf3;
    wf3s = DI.ifc.Calc.Flow.wf3s;
    wf3sx = DI.ifc.Calc.Flow.lnp3s.wf3sx;
    wfmd = wf3;
    wf36 = DI.eng.wf36;
    p1c = DI.ifc.Calc.Press.p1c;
    ifc_px = DI.ifc.Calc.Press.px;
    p2 = DI.ifc.Calc.Press.p2;
    p3 = DI.ifc.Calc.Press.p3;
    p2mp3 = p2; p2mp3.values = p2.values-p3.values;
    pd = DI.ifc.PD;
    pnozin = DI.eng.pnozin;
    mv_x = DI.ifc.Calc.Comp.fmv.mv.Result.x;
    hs_x = DI.ifc.Calc.Comp.hs.Result.x;
    mvtv_x = DI.ifc.Calc.Comp.mvtv.Result.x;
    start_x = mvtv_x;start_x.values = start_x.values*G.ven.vsv.xmax;
    vdpp_rpm = DV.pump.In.rpm;
    vdpp_ps = DV.I.ps_psia;
    vdpp_disp = DV.pump.In.disp;
    vdpp_wf = DV.pump.Result.wf;
    pact_x = DV.pumpAct.x;
    pact_v = DV.pumpAct.dxdt;
    vlink_ftpa = DV.pumpAct.ftpa;
    pact_fexth = DV.pumpAct.pa_fexth;
    pact_wfr = DV.pumpAct.wfr;
    pact_tqrs = DV.pumpAct.tqrs;
    pact_tqa = DV.pumpAct.tqa;
    tri_x = DV.reg.Result.x;
    tri_v = DV.reg.Result.dxdt;
    vlink_wflkout = DV.wflkout;
    tri_px = DV.reg.In.px;
    vload_wfload = DV.wfload;
    tri_wfx = DV.reg.Result.wf.wfx;
    rrv_wfs = DV.rrv.Result.wf.wfs;
    rrv_wfd = DV.rrv.Result.wf.wfd;
    rrv_wfvx = DV.rrv.Result.wf.wfvx;
    rrv_x = DV.rrv.Result.x;
    bias_wfve = DV.bias.Result.wf.wfve;
    bias_x = DV.bias.Result.x;
    tri_wfse = DV.reg.Result.wf.wfse;
    tri_wfs = DV.reg.Result.wf.wfs;
    start_wfs = DV.reg.Result.wf.wfs; start_wfs.values = start_wfs.values*0;
    if MOD.atWork then
        pact_tqpv = DV.pumpAct.tqpv;
        pact_tqc = DV.pumpAct.tqc;
        pact_uf_net = DV.pumpAct.uf_net;
        tri_uf = DV.reg.Result.force.uf;
        tri_uf_net = DV.reg.Result.uf_net;
        tri_uf_mod = DV.reg.Result.uf_mod;
    end

    // EBOOST
    pmpin = DI.supply.Calc.PMPIN;
    pmainp = DI.supply.Calc.PMAINP;
    poc = DI.supply.Calc.POC;
    wf1p = DI.supply.WF1P;
    wfoc = DI.supply.Calc.WFOC;
    xnven = DI.supply.In.XN25; xnven.values = xnven.values/G.eng.N25100Pct*G.eng.xnvent;
    xnmain = DI.supply.In.XN25; xnmain.values = xnmain.values/G.eng.N25100Pct*G.eng.xnmainpt;
    if MOD.atWork then
        dpmfp = p1;   dpmfp.values(:,1) = dpmfp.values(:,1)-pmpin.values(:,1);  // dag 5/23/2019
    end
    dpboost = DI.bvs.Calc.DPBOOST;  // dag 5/25/2019
    
    // ACBOOST
    ACmotivepull = DI.ac.Mon_ABOOST.ACmotivepull;
    pacbmix = DI.ac.Mon_ABOOST.pacbmix;
    pdacbst = DI.ac.Mon_ABOOST.pdacbst;
    pdacmbst = DI.ac.Mon_ABOOST.pdacmbst;
    pengine = DI.ac.Mon_ABOOST.pengine;
    psacbst = DI.ac.Mon_ABOOST.psacbst;
    psacmbst = pdacbst;
    wfacbst = DI.ac.Mon_ABOOST.wfacbst;
    wfacmbst = DI.ac.Mon_ABOOST.wfacmbst;
    wfbypass = DI.ac.Mon_ABOOST.wfbypass;
    wfengine = DI.ac.Mon_ABOOST.wfengine;
    wftank = DI.ac.Mon_ABOOST.wftank;

    x_vehsv = DV.ehsv.SPOOL.x;
    wfj_vehsv = DV.ehsv.SPOOL.wfj;
    dxdt_vehsv = DV.ehsv.SPOOL.dxdt;

    phead = DV.actSys.O_4.In.ph;
    prod_ = DV.actSys.O_4.In.pr;

    // Main Plots
    if MOD.plotMain | MOD.plotAll then
        figs($+1) = figure("Figure_name", 'MAIN_FLOW_1', "Position", [40,30,610,460]);
        subplot(221)
        overplot(['WF1V', 'wf1v'], ['r-', 'b--'], 'VEN Start Discharge Flow')
        subplot(222)
        overplot(['WF1MV', 'wf1mv'], ['r-', 'b--'], 'MV Supply Flow')
        subplot(223)
        overplot(['WF1S', 'wf1s'], ['r-', 'b--'], 'Sense Flow')
        subplot(224)
        overplot(['WFMV', 'mv_wfd', 'WFAREA'], ['r-', 'b--', 'g-'], 'MV Discharge Flow')

        figs($+1) = figure("Figure_name", 'MAIN_FLOW_2', "Position", [40,50,610,460]);
        subplot(221)
        overplot(['WF3', 'wf3'], ['r-', 'b--'], 'Throttle Valve Discharge Flow')
        subplot(222)
        overplot(['WFMD', 'wfmd'], ['r-', 'b--'], 'Main Discharge Flow')
        subplot(223)
        overplot(['WF3S', 'wf3s', 'WF3SX', 'wf3sx','WFL3S'], ['r-', 'b--', 'c--', 'm--', 'k-'], 'Flow MV Discharge to Head Sense')
        subplot(224)
        overplot(['WF36', 'wf36'], ['r-', 'b--'], 'Engine Flow')

        figs($+1) = figure("Figure_name", 'MAIN_PRESS_1', "Position", [40,70,610,460]);
        subplot(321)
        overplot(['P1SO', 'p1c', 'P1SV'], ['r-', 'b--', 'c-'], 'MV Supply Pressure')
        subplot(322)
        overplot(['P3', 'p3'], ['r-', 'b--'], 'MV Discharge Pressure')
        subplot(323)
        overplot(['PD', 'pd'], ['r-', 'b--'], 'TV Discharge Pressure')
        subplot(324)
        overplot(['P_NOZIN', 'pnozin'], ['r-', 'b--'], 'Nozzle Pressure')
        subplot(325)
        overplot(['PX', 'ifc_px'], ['r-', 'b--'], 'MVTV Control Pressure')
        subplot(326)
        overplot(['P2MP3', 'p2mp3'], ['r-', 'b--'], 'MV Delta Pressure')

        figs($+1) = figure("Figure_name", 'MAIN_POS', "Position", [40,80,610,600]);
        subplot(321)
        overplot(['MV_POS', 'mv_x', 'mv_xin'], ['r-',  'b--', 'k-'], 'MV Poaition')
        subplot(322)
        overplot(['HS_POS', 'hs_x'], ['r-',  'b--'], 'Head Sensor Position')
        subplot(324)
        overplot(['P2MP3', 'p2mp3'], ['r-', 'b--'], 'MV Delta Pressure')
        subplot(323)
        overplot(['TV_POS', 'mvtv_x'], ['r-',  'b--'], 'Throttle Valve Position')
        subplot(325)
        overplot(['SV_POS', 'start_x'], ['r-',  'b--'], 'Start Valve Position')

    end  // plotMain

    if MOD.plotAC | MOD.plotAll then

        figs($+1) = figure("Figure_name", 'AC Supply', "Position", [40,90,810,600]);
        subplot(331)
        overplot(['WFENGINE', 'wfengine'], ['r-',  'b--'], 'Engine Supply Flow')
        subplot(332)
        overplot(['PACBMIX', 'pacbmix', 'PENGINE', 'pengine'], ['r-',  'b--','k-', 'c--'], 'Mix Pressure') //dag 5/25/2019
        subplot(333)
        overplot(['WFACBST', 'wfacbst'], ['r-', 'b--'], 'Aircraft Boost Flow')
        subplot(334)
        overplot(['PDACBST', 'pdacbst'], ['r-', 'b--'], 'Aircraft Boost Pressures')  // dag 5/25/2019
        subplot(335)
        overplot(['WFACMBST', 'wfacmbst'], ['r-', 'b--'], 'Aircraft Motive Boost Flow')
        subplot(336)
        overplot(['PDACMBST', 'pdacmbst'], ['r-', 'b--'], 'Aircraft Motive Boost Pressures')  // dag 5/25/2019
        subplot(337)
        overplot(['WFTANK', 'wftank'], ['r-', 'b--'], 'Aircraft Tank Flow')
        subplot(338)
        overplot(['ACMOTIVEPULL', 'ACmotivepull'], ['r-', 'b--'], 'Aircraft Motive Status')  // dag 5/25/2019
        subplot(339)
        overplot(['PENGINE', 'pengine'], ['r-',  'b--'], 'Engine Supply Pressure')

    end // plotAC

    // VEN plots
    if MOD.plotVEN | MOD.plotAll then

        figs($+1) = figure("Figure_name", 'VEN EHSV 1', "Position", [40,70,810,600]);
        subplot(321)
        overplot(['PS_RLINE', 'rlineps'], ['r-', 'b--'], 'VEN EHSV Rod Pressure')
        if MOD.atWork then
            subplot(322)
            overplot(['PS_HLINE', 'hlineps'], ['r-', 'b--'], 'VEN EHSV Head Pressure')
        else
            subplot(322)
            overplot(['PS_HLINE'], ['r-'], 'VEN EHSV Head Pressure')
        end
        subplot(323)
        overplot(['vdpp_pd'], ['k-'], 'VEN EHSV Pressures')
        subplot(324)
        overplot(['vdpp_ps'], ['b-'], 'VEN EHSV Pressures')
        subplot(325)
        overplot(['VEGS', 'vegs'], ['r-', 'b--'], 'VEN EHSV Gain Scalar')
        
        figs($+1) = figure("Figure_name", 'VEN EHSV 2', "Position", [40,90,810,600]);
        subplot(331)
        overplot(['VEWFS', 'wfs_vehsv'], ['r-',  'b--'], 'VEN EHSV Supply Flow')
        subplot(332)
        overplot(['VEWFD', 'wfd_vehsv'], ['r-',  'b--'], 'VEN EHSV Return Flow')
        subplot(333)
        overplot(['VEWFHx', 'wfh_vehsv'], ['r-', 'b--'], 'VEN EHSV Head Flow')// dag 6/11/2019
        subplot(334)
        overplot(['VEWFRx', 'wfr_vehsv'], ['r-', 'b--', 'k-', 'c--'], 'VEN EHSV Rod Flow')// dag 6/11/2019
        subplot(335)
        overplot(['VEMA', 'vmA'], ['r-', 'c--'], 'mA')
        subplot(336)
        overplot(['VEX', 'x_vehsv'], ['r-', 'b--'], 'VEN EHSV Position')
        subplot(337)
        overplot(['VEV', 'dxdt_vehsv'], ['r-', 'b--'], 'VEN EHSV Velocity')
        if MOD.atWork then
            subplot(338)
            overplot(['rlineps', 'hlineps', 'vdpp_pd', 'vdpp_ps'], ['m-', 'c--', 'k-', 'b-'], 'VEN EHSV Pressures')
        else
            subplot(338)
            overplot(['rlineps', 'vdpp_pd', 'vdpp_ps'], ['m-', 'k-', 'b-'], 'VEN EHSV Pressures')
        end
        subplot(339)
        overplot(['VEXD', 'VEX'], ['r-', 'c--'], 'VEN EHSV Position')

        figs($+1) = figure("Figure_name", 'VEN EHSV 3', "Position", [60,70,810,600]);
        subplot(321)
        overplot(['VEWFHD', 'vewfhd'], ['r-', 'b--'], 'VEN EHSV HD flow')
        subplot(322)
        overplot(['VEWFRD', 'vewfrd'], ['r-', 'b--'], 'VEN EHSV RD flow')
        subplot(323)
        overplot(['VEWFSH', 'vewfsh'], ['r-', 'b--'], 'VEN EHSV SH flow')
        subplot(324)
        overplot(['VEWFSR', 'vewfsr'], ['r-', 'b--'], 'VEN EHSV SR flow')
        subplot(325)
        overplot(['VEWFHx', 'wfh_vehsv', 'ACTSYS_WFH', 'wfh_vact'], ['r-', 'b--', 'm-', 'k--'], 'VEN EHSV Head Flow')
        subplot(326)
        overplot(['VEWFRx', 'wfr_vehsv', 'ACTSYS_WFR', 'wfr_vact'], ['r-', 'b--', 'm-', 'k--'], 'VEN EHSV Rod Flow')

        figs($+1) = figure("Figure_name", 'VEN ACT', "Position", [40,110,610,600]);
        subplot(221)
        overplot(['VVEN', 'v_ven'], ['r-',  'b--'], 'VEN Act Velocity')
        subplot(222)
        overplot(['XVEN', 'x_ven'], ['r-',  'b--'], 'VEN Act Position')
        subplot(223)
        overplot(['PHEAD', 'phead'], ['r-',  'b--'], 'VEN Act Head')
        subplot(224)
        overplot(['PROD', 'prod_'], ['r-',  'b--'], 'VEN Act Rod')


        figs($+1) = figure("Figure_name", 'VEN Misc', "Position", [40,130,610,600]);
        subplot(331)
        overplot(['PACT_WFLKOUT', 'vlink_wflkout'], ['r-',  'b--'], 'Pump Act Leakage')
        subplot(332)
        overplot(['PACT_WFR', 'pact_wfr'], ['r-',  'b--'], 'Pump Act Leakage')
        subplot(333)
        overplot(['PD_VEN', 'vdpp_pd'], ['r-',  'b--'], 'Pump Discharge Pressure')
        subplot(334)
        overplot(['PX_V', 'tri_px'], ['r-',  'b--'], 'Pump Control Pressure')
        subplot(335)
        overplot(['VLOAD_WFLOAD', 'vload_wfload'], ['r-',  'b--'], 'Total Load Flow')
        subplot(336)
        overplot(['WFX_R', 'tri_wfx'], ['r-',  'b--'], 'Regulator Control Flow')
        subplot(337)
        overplot(['WFS_VEN', 'WFR_VEN'], ['r-',  'k-'], 'VEN Interface Flows')

        figs($+1) = figure("Figure_name", 'Rod Relief Valve', "Position", [40,150,610,600]);
        subplot(221)
        overplot(['WFS_RRV', 'rrv_wfs'], ['r-',  'b--'], 'Suppy flow')
        subplot(222)
        overplot(['WFD_RRV', 'rrv_wfd'], ['r-',  'b--'], 'Discharge flow')
        subplot(223)
        overplot(['WFVX_RRV', 'rrv_wfvx'], ['r-',  'b--'], 'Motion flow')
        subplot(224)
        overplot(['X_RRV', 'rrv_x'], ['r-',  'b--'], 'Position')

        figs($+1) = figure("Figure_name", 'Bias Piston', "Position", [40,170,610,600]);
        subplot(221)
        overplot(['BIAS_FEXT', 'bias_fext'], ['r-',  'b--'], 'Force')
        subplot(222)
        overplot(['BIAS_WFVE', 'bias_wfve'], ['r-',  'b--'], 'Force')
        subplot(223)
        overplot(['BIAS_X', 'bias_x'], ['r-',  'b--'], 'Position')

        figs($+1) = figure("Figure_name", 'TRI', "Position", [60,290,610,600]);
        subplot(322)
        overplot(['TRI_V', 'tri_v'], ['r-',  'b--'], 'Regulator Motion')
        if MOD.atWork then
            subplot(321)
            overplot(['TRI_UF', 'tri_uf_mod'], ['r-',  'b--'], 'Regulator Motion')
        else
            subplot(321)
            overplot(['TRI_UF'], ['r-'], 'Regulator Motion')
        end
        subplot(324)
        overplot(['TRI_X', 'tri_x'], ['r-',  'b--'], 'Regulator Motion')
        subplot(326)
        overplot(['TRI_MODE'], ['r-'], 'Regulator Motion')

        figs($+1) = figure("Figure_name", 'pcham Volume', "Position", [40,190,610,600]);
        subplot(339)
        overplot(['PD_VEN', 'vdpp_pd'], ['r-',  'b--'], 'Pump Discharge Pressure')
        subplot(331)
        overplot(['WFD_RRV', 'rrv_wfd'], ['r-',  'b--'], 'Rod Relief Discharge Flow')
        subplot(332)
        overplot(['VDPP_WF', 'vdpp_wf'], ['r-',  'b--'], 'Pump Discharge Flow')
        subplot(333)
        overplot(['WFSE_R', 'tri_wfse'], ['r-',  'b--'], 'Regulator Motion Flow')
        subplot(334)
        overplot(['WFS_R', 'tri_wfs'], ['r-',  'b--'], 'Regulator Supply Flow')
        subplot(335)
        overplot(['WFVX_RRV', 'rrv_wfvx'], ['r-',  'b--'], 'Rod Relief Motion Flow')
        subplot(336)
        overplot(['VLOAD_WFLOAD', 'vload_wfload'], ['r-',  'b--'], 'Total Load Flow')
        subplot(337)
        overplot(['WFS_START', 'start_wfs'], ['r-',  'b--'], 'Start Valve Flow')
        subplot(338)
        overplot(['WFVX_START'], ['r-'], 'Start Valve Motion Flow')

    end // plotVEN

    // VENpump plots
    if MOD.plotVENpump | MOD.plotAll then

        figs($+1) = figure("Figure_name", 'VDPP', "Position", [40,210,610,600]);
        subplot(321)
        overplot(['VDPP_RPM', 'vdpp_rpm', 'vdpp_pd', 'VDPP_PL'], ['r-', 'b--', 'k--', 'm-'], 'VDPP')
        subplot(322)
        overplot(['vdpp_ps'], ['b--'], 'VDPP')
        subplot(323)
        overplot(['PACT_DISP', 'vdpp_disp'], ['r-', 'b--'], 'VDPP')
        subplot(324)
        overplot(['VDPP_WF', 'vdpp_wf'], ['r-',  'b--'], 'VDPP Flow')
        subplot(325)
        overplot(['VDPP_MTDQP'], ['r-'], 'VDPP')
        subplot(326)
        overplot(['VDPP_EFF_VOL'], ['b-'], 'VDPP')

        figs($+1) = figure("Figure_name", 'VEN pact', "Position", [120,220,610,600]);
        subplot(331)
        overplot(['PACT_V', 'pact_v'], ['r-',  'b--'], 'Pump Act Velocity')
        if MOD.atWork then
            subplot(332)
            overplot(['PACT_UF_NET', 'pact_uf_net'], ['r-', 'b--'], 'Pump Act Forces')
            subplot(335)
            overplot(['PACT_TQRS', 'pact_tqrs'], ['r-',  'b--'], 'Pump linkage')
            subplot(336)
            overplot(['PACT_TQA', 'pact_tqa'], ['r-',  'b--'], 'Pump linkage')
            subplot(337)
            overplot(['PACT_TQPV', 'pact_tqpv'], ['r-',  'b--'], 'Pump linkage')
            subplot(338)
            overplot(['PACT_TQC', 'pact_tqc'], ['r-',  'b--'], 'Pump linkage')
        else
            subplot(332)
            overplot(['PACT_UF_NET'], ['r-'], 'Pump Act Forces')
            subplot(335)
            overplot(['PACT_TQRS'], ['r-'], 'Pump linkage')
            subplot(336)
            overplot(['PACT_TQA'], ['r-'], 'Pump linkage')
            subplot(337)
            overplot(['PACT_TQPV'], ['r-'], 'Pump linkage')
            subplot(338)
            overplot(['PACT_TQC'], ['r-'], 'Pump linkage')
        end
        subplot(333)
        overplot(['PACT_FEXTH', 'pact_fexth'], ['r-',  'b--'], 'Pump Act Force')
        subplot(334)
        overplot(['VLINK_FTPA', 'vlink_ftpa'], ['r-',  'b--'], 'Pump linkage')

        figs($+1) = figure("Figure_name", 'VEN pact friction', "Position", [140,230,610,600]);
        subplot(221)
        overplot(['PACT_V', 'pact_v'], ['r-',  'b--'], 'Pump Act Velocity')
        subplot(222)
        overplot(['PACT_X', 'pact_x'], ['r-', 'b--'], 'Pump Act Pos')
        subplot(223)
        overplot(['PACT_UF', 'PACT_UF_NET'], ['k-',  'm-'], 'Pump Act Force')
        subplot(224)
        overplot(['PACT_MODE'], ['r-'], 'Pump linkage mode')
        
        figs($+1) = figure("Figure_name", 'VEN ACT friction', "Position", [140,250,610,600]);
        subplot(221)
        overplot(['VVEN', 'v_ven'], ['r-',  'b--'], 'VEN Act Velocity')
        subplot(222)
        overplot(['XVEN', 'x_ven'], ['r-',  'b--'], 'VEN Act Position')
        subplot(223)
        overplot(['VE_UF', 'VE_UF_NET'], ['k-',  'm-'], 'VEN Act Force')
        subplot(224)
        overplot(['VE_MODE'], ['r-'], 'VEN act mode')

        figs($+1) = figure("Figure_name", 'VEN Position', "Position", [40,230,610,600]);
        subplot(321)
        overplot(['PACT_X', 'pact_x'], ['r-',  'b--'], 'Pump Act Stroke')
        subplot(322)
        overplot(['PACT_V', 'pact_v'], ['r-',  'b--'], 'Pump Act Velocity')
        subplot(323)
        overplot(['TRI_X', 'tri_x'], ['r-',  'b--'], 'Regulator Position')
        subplot(324)
        overplot(['SV_POS', 'start_x'], ['r-',  'b--'], 'Start Valve Position')
        subplot(325)
        overplot(['BIAS_X', 'bias_x'], ['r-',  'b--'], 'Position')

    end  // plotVENpump

    if MOD.plotEBOOST | MOD.plotAll

        figs($+1) = figure("Figure_name", 'EBOOST', "Position", [40,130,610,600]);
        subplot(331)
        overplot(['WFOC', 'wfoc'], ['r-',  'b--'], 'Oil Cooler Flow')
        subplot(332)
        overplot(['WF1P', 'wf1p'], ['r-',  'b--'], 'Main Pump Flow')
        subplot(333)
        overplot(['WFB2', 'wfb2'], ['r-',  'b--'], 'Boost Pump Flow')
        subplot(334)
        overplot(['WFFILT', 'wffilt'], ['r-',  'b--'], 'Filter Flow')
        subplot(335)
        overplot(['PB1', 'pb1'], ['r-',  'b--'], 'Boost Pump Discharge Pressure')
        subplot(336)
        overplot(['PB2', 'pb2', 'POC', 'poc'], ['r-',  'b--', 'k-', 'c--'], 'Filter Discharge and Oil Cooler Discharge Pressures')
        subplot(337)
        overplot(['PMAINP', 'PSMFP', 'pmainp'], ['r-', 'k-', 'b--'], 'Main Pump Supply Pressure')

        figs($+1) = figure("Figure_name", 'EBOOST Pump', "Position", [40,130,610,600]);
        subplot(331)
        overplot(['DPBOOST', 'dpboost'], ['r-',  'b--'], 'Pump Pressure Rises')
        subplot(332)
        overplot(['XNVEN', 'xnven'], ['r-',  'b--'], 'Boost Pump RPM')
        subplot(333)
        overplot(['XNMAIN', 'xnmain'], ['r-',  'b--'], 'Main Fuel Pump RPM')
        subplot(334)
        overplot(['PENGINE', 'pengine'], ['r-',  'b--'], 'Engine Supply Pressure')
        if MOD.atWork then
            subplot(335)
            overplot(['P_1', 'P1SO', 'p1c', 'p1'], ['k-', 'r-', 'b--', 'c--'], 'MFP Discharge Pressure') // dag 5/23/2019
        else
            subplot(335)
            overplot(['P_1', 'P1SO', 'p1c'], ['k-', 'r-', 'b--'], 'MFP Discharge Pressure') // dag 5/23/2019
        end
        subplot(336)
        overplot(['PMAINP', 'pmainp'], ['r-',  'b--'], 'MFP Supply Pressure')
        if MOD.atWork then
            subplot(337)
            overplot(['DPMFP', 'dpmfp'], ['r-',  'b--'], 'MFPump Pressure Rises') // dag 5/23/2019
        else
            subplot(337)
            overplot(['DPMFP'], ['r-'], 'MFPump Pressure Rises') // dag 5/23/2019
        end
        subplot(338)
        overplot(['WFENGINEb', 'wfengine'], ['r-',  'b--'], 'Engine Supply Flow')

    end // plotEBOOST

end   // MOD.plotEnable

if MOD.exportFigs then
    for i = 1:length(figs)
        xs2png(figs(i), 'results/'+root+string(i)+'.png')
        xs2pdf(figs(i), 'results/'+root+string(i)+'.pdf', 'landscape')
    end
end

mprintf('Completed %s\n', sfilename())  
