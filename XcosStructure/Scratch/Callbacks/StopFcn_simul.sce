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

global LINCOS_OVERRIDE figs sys_f cpr scs_m LIN  time_tic time_toc
global DI DV
mprintf('In %s\n', sfilename())  
try cpr = %cpr; end

try close(figs); end
figs=[];

// Calculate run time.   tic is in InitFcn
time_toc = getdate();
mprintf('Run took %8.3f seconds\n', etime(time_toc, time_tic));

if 1  & Tf>1e-6 then

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
WFAREA = struct('time', tIDATA, 'values', IDATA.values(:,5));
WFMV = struct('time', tIDATA, 'values', IDATA.values(:,6));
WF3 = struct('time', tIDATA, 'values', IDATA.values(:,9));
WF1MV = struct('time', tIDATA, 'values', IDATA.values(:,10));
WF1S = struct('time', tIDATA, 'values', IDATA.values(:,11));
WF3S = struct('time', tIDATA, 'values', IDATA.values(:,12));
WF3SX = struct('time', tIDATA, 'values', IDATA.values(:,13));
WFL3S = struct('time', tIDATA, 'values', IDATA.values(:,14));
MV_POS = struct('time', tIDATA, 'values', IDATA.values(:,15));
TV_POS = struct('time', tIDATA, 'values', IDATA.values(:,16));
HS_POS = struct('time', tIDATA, 'values', IDATA.values(:,17));
tPALL = PALL.time(:,1);
PDVEN = struct('time', tPALL, 'values', PALL.values(:,1));
P_NOZIN = struct('time', tPALL, 'values', PALL.values(:,2));
PS3 = struct('time', tPALL, 'values', PALL.values(:,3));
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

tVDATA = VDATA.time(:,1);
SV_POS = struct('time', tVDATA, 'values', VDATA.values(:,4));

tLDATA = LDATA.time(:,1);


tVE = VE_WFS.time(:,1);
VEWFS = struct('time', tVE, 'values', VE_WFS.values(:,1));
VEWFD = struct('time', tVE, 'values', VE_WFD.values(:,1));
VEWFH = struct('time', tVE, 'values', VE_WFH.values(:,1));
VEWFR = struct('time', tVE, 'values', VE_WFR.values(:,1));
VEX = struct('time', tVE, 'values', VEHSV_X.values(:,1));
VEXD = struct('time', tVE, 'values', VEHSV_XD.values(:,1));
VEV = struct('time', tVE, 'values', VEHSV_V.values(:,1));
VEMA = struct('time', tVE, 'values', VEHSV_MA.values(:,1));
XVEN = struct('time', tVE, 'values', VX.values(:,1));
VVEN = struct('time', tVE, 'values', VV.values(:,1));
//tBDATA = BDATA.time(:,1);
//DP_BOOST = struct('time', tBDATA, 'values', BDATA.values(:,1));
//DP_MFP = struct('time', tBDATA, 'values', BDATA.values(:,2));

clear tWALL tIDATA tPALL tVDATA tADATA tVE tBDATA tLDATA

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
mv_xin = DI.ifc.Calc.Comp.fmv.mv.Result.x;
hs_x = DI.ifc.Calc.Comp.hs.Result.x;
mvtv_x = DI.ifc.Calc.Comp.mvtv.Result.x;
start_x = mvtv_x;start_x.values = start_x.values*G.ven.vsv.xmax;
vdpp_rpm = DV.pump.In.rpm;
vdpp_pd = DV.pd;
vdpp_ps = DV.I.ps_psia;
vdpp_disp = DV.pump.In.disp;
vdpp_wf = DV.pump.Result.wf;
pact_x = DV.pumpAct.x;
pact_v = DV.pumpAct.dxdt;
vlink_ftpa = DV.pumpAct.ftpa;
pact_fexth = DV.pumpAct.pa_fexth;
pact_wfr = DV.pumpAct.wfr;
tri_x = DV.reg.Result.x;
vlink_wflkout = DV.wflkout;
tri_px = DV.reg.In.px;
vload_wfload = DV.wfload;
tri_wfx = DV.reg.Result.wf.wfx;
rrv_wfs = DV.rrv.Result.wf.wfs;
rrv_wfd = DV.rrv.Result.wf.wfd;
rrv_wfvx = DV.rrv.Result.wf.wfvx;
rrv_x = DV.rrv.Result.x;
bias_fext = DV.bias.In.fexth;
bias_wfve = DV.bias.Result.wf.wfve;
bias_x = DV.bias.Result.x;
tri_wfse = DV.reg.Result.wf.wfse;
tri_wfs = DV.reg.Result.wf.wfs;
start_wfs = DV.reg.Result.wf.wfs; start_wfs.values = start_wfs.values*0;

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
wfs_vehsv = DV.ehsv.SPOOL.wfs;
wfd_vehsv = DV.ehsv.SPOOL.wfd;
wfj_vehsv = DV.ehsv.SPOOL.wfj;
dxdt_vehsv = DV.ehsv.SPOOL.dxdt;
wfh_vehsv = DV.actSys.wfh;
wfr_vehsv = DV.actSys.wfr;

x_ven = DV.actSys.O_4.Result.x;
v_ven = DV.actSys.O_4.Result.dxdt;
phead = DV.actSys.O_4.In.ph;
prod_ = DV.actSys.O_4.In.pr;


if 0 then
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
overplot(['P1SO', 'p1c'], ['r-', 'b--'], 'MV Supply Pressure')
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
overplot(['MV_POS', 'mv_xin'], ['r-',  'b--'], 'MV Poaition')
subplot(322)
overplot(['HS_POS', 'hs_x'], ['r-',  'b--'], 'Head Sensor Position')
subplot(324)
overplot(['P2MP3', 'p2mp3'], ['r-', 'b--'], 'MV Delta Pressure')
subplot(323)
overplot(['TV_POS', 'mvtv_x'], ['r-',  'b--'], 'Throttle Valve Position')
subplot(325)
overplot(['SV_POS', 'start_x'], ['r-',  'b--'], 'Start Valve Position')

figs($+1) = figure("Figure_name", 'AC Supply', "Position", [40,90,810,600]);
subplot(331)
overplot(['WFENGINE', 'wfengine'], ['r-',  'b--'], 'Engine Supply Flow')
subplot(332)
overplot(['PACBMIX', 'pacbmix'], ['r-',  'b--'], 'Mix Pressure')
subplot(333)
overplot(['WFACBST', 'wfacbst'], ['r-', 'b--'], 'Aircraft Boost Flow')
subplot(334)
overplot(['PSACBST', 'psacbst', 'PDACBST', 'pdacbst'], ['r-', 'b--', 'k-', 'c--'], 'Aircraft Boost Pressures')
subplot(335)
overplot(['WFACMBST', 'wfacmbst'], ['r-', 'b--'], 'Aircraft Motive Boost Flow')
subplot(336)
overplot(['PSACMBST', 'psacmbst', 'PDACMBST', 'pdacmbst'], ['r-', 'b--', 'k-', 'c--'], 'Aircraft Motive Boost Pressures')
subplot(337)
overplot(['WFTANK', 'wftank'], ['r-', 'b--'], 'Aircraft Tank Flow')
subplot(339)
overplot(['PENGINE', 'pengine'], ['r-',  'b--'], 'Engine Supply Pressure')
end

figs($+1) = figure("Figure_name", 'VEN EHSV', "Position", [40,110,810,600]);
subplot(221)
overplot(['rlineps'], ['m-'], 'VEN EHSV Pressures')
subplot(222)
overplot(['hlineps'], ['c--'], 'VEN EHSV Pressures')
subplot(223)
overplot(['vdpp_pd'], ['k-'], 'VEN EHSV Pressures')
subplot(224)
overplot(['vdpp_ps'], ['b-'], 'VEN EHSV Pressures')

figs($+1) = figure("Figure_name", 'VEN EHSV', "Position", [40,110,810,600]);
subplot(331)
overplot(['VEWFS', 'wfs_vehsv'], ['r-',  'b--'], 'VEN EHSV Supply Flow')
subplot(332)
overplot(['VEWFD', 'wfd_vehsv'], ['r-',  'b--'], 'VEN EHSV Return Flow')
subplot(333)
overplot(['VEWFH', 'wfh_vehsv'], ['r-', 'b--'], 'VEN EHSV Head Flow')
subplot(334)
overplot(['VEWFR', 'wfr_vehsv'], ['r-', 'b--', 'k-', 'c--'], 'VEN EHSV Rod Flow')
subplot(335)
overplot(['VEMA', 'vmA'], ['r-', 'c--'], 'mA')
subplot(336)
overplot(['VEX', 'x_vehsv'], ['r-', 'b--'], 'VEN EHSV Position')
subplot(337)
overplot(['VEV', 'dxdt_vehsv'], ['r-', 'b--'], 'VEN EHSV Velocity')
subplot(338)
overplot(['rlineps', 'hlineps', 'vdpp_pd', 'vdpp_ps'], ['m-', 'c--', 'k-', 'b-'], 'VEN EHSV Pressures')
subplot(339)
overplot(['VEXD', 'VEX'], ['r-', 'c--'], 'VEN EHSV Position')

figs($+1) = figure("Figure_name", 'VEN ACT', "Position", [40,120,610,600]);
subplot(221)
overplot(['VV', 'v_ven'], ['r-',  'b--'], 'VEN Act Velocity')
subplot(222)
overplot(['VX', 'x_ven'], ['r-',  'b--'], 'VEN Act Position')
subplot(223)
overplot(['PHEAD', 'phead'], ['r-',  'b--'], 'VEN Act Head')
subplot(224)
overplot(['PROD', 'prod_'], ['r-',  'b--'], 'VEN Act Rod')

if 0 then

figs($+1) = figure("Figure_name", 'BOOST System', "Position", [40,140,610,600]);
subplot(221)
overplot(['DP_BOOST', 'prod_'], ['r-',  'b--'], 'VEN Act Rod')

end


if 0 then

figs($+1) = figure("Figure_name", 'VDPP', "Position", [40,90,610,600]);
subplot(321)
overplot(['VDPP_RPM', 'vdpp_rpm', 'vdpp_pd', 'VDPP_PL'], ['r-', 'b--', 'k--', 'm-'], 'VDPP')
subplot(322)
overplot(['vdpp_ps'], ['b--'], 'VDPP')
subplot(323)
overplot(['VDPP_DISP', 'vdpp_disp'], ['r-', 'b--'], 'VDPP')
subplot(324)
overplot(['VDPP_WF', 'vdpp_wf'], ['r-',  'b--'], 'VDPP Flow')
subplot(325)
overplot(['VDPP_MTDQP'], ['r-'], 'VDPP')
subplot(326)
overplot(['VDPP_EFF_VOL'], ['b-'], 'VDPP')

figs($+1) = figure("Figure_name", 'VEN', "Position", [40,110,610,600]);
subplot(321)
overplot(['PACT_X', 'pact_x'], ['r-',  'b--'], 'Pump Act Stroke')
subplot(322)
overplot(['PACT_V', 'pact_v'], ['r-',  'b--'], 'Pump Act Velocity')
subplot(323)
overplot(['VLINK_FTPA', 'vlink_ftpa'], ['r-',  'b--'], 'Pump Act Loads')
subplot(324)
overplot(['PACT_FEXTH', 'pact_fexth'], ['r-',  'b--'], 'Pump Act Load')
subplot(325)
overplot(['PACT_WFR', 'pact_wfr'], ['r-',  'b--'], 'Pump Act Flow')
subplot(326)
overplot(['TRI_X', 'tri_x'], ['r-',  'b--'], 'Regulator Position')

figs($+1) = figure("Figure_name", 'VEN Misc', "Position", [40,130,610,600]);
subplot(321)
overplot(['PACT_WFLKOUT', 'vlink_wflkout'], ['r-',  'b--'], 'Pump Act Leakage')
subplot(322)
overplot(['PACT_WFR', 'pact_wfr'], ['r-',  'b--'], 'Pump Act Leakage')
subplot(323)
overplot(['VEN_PD', 'vdpp_pd'], ['r-',  'b--'], 'Pump Discharge Pressure')
subplot(324)
overplot(['VEN_PX', 'tri_px'], ['r-',  'b--'], 'Pump Control Pressure')
subplot(325)
overplot(['VLOAD_WFLOAD', 'vload_wfload'], ['r-',  'b--'], 'Total Load Flow')
subplot(326)
overplot(['TRI_WFX', 'tri_wfx'], ['r-',  'b--'], 'Regulator Control Flow')

figs($+1) = figure("Figure_name", 'Rod Relief Valve', "Position", [40,150,610,600]);
subplot(221)
overplot(['RRV_WFS', 'rrv_wfs'], ['r-',  'b--'], 'Suppy flow')
subplot(222)
overplot(['RRV_WFD', 'rrv_wfd'], ['r-',  'b--'], 'Discharge flow')
subplot(223)
overplot(['RRV_WFVX', 'rrv_wfvx'], ['r-',  'b--'], 'Motion flow')
subplot(224)
overplot(['RRV_X', 'rrv_x'], ['r-',  'b--'], 'Position')

figs($+1) = figure("Figure_name", 'Bias Piston', "Position", [40,170,610,600]);
subplot(221)
overplot(['BIAS_FEXT', 'bias_fext'], ['r-',  'b--'], 'Force')
subplot(222)
overplot(['BIAS_WFVE', 'bias_wfve'], ['r-',  'b--'], 'Force')
subplot(223)
overplot(['BIAS_X', 'bias_x'], ['r-',  'b--'], 'Position')

figs($+1) = figure("Figure_name", 'pcham Volume', "Position", [40,190,610,600]);
subplot(339)
overplot(['VEN_PD', 'vdpp_pd'], ['r-',  'b--'], 'Pump Discharge Pressure')
subplot(331)
overplot(['RRV_WFD', 'rrv_wfd'], ['r-',  'b--'], 'Rod Relief Discharge Flow')
subplot(332)
overplot(['VDPP_WF', 'vdpp_wf'], ['r-',  'b--'], 'Pump Discharge Flow')
subplot(333)
overplot(['TRI_WFSE', 'tri_wfse'], ['r-',  'b--'], 'Regulator Motion Flow')
subplot(334)
overplot(['TRI_WFS', 'tri_wfs'], ['r-',  'b--'], 'Regulator Supply Flow')
subplot(335)
overplot(['RRV_WFVX', 'rrv_wfvx'], ['r-',  'b--'], 'Rod Relief Motion Flow')
subplot(336)
overplot(['VLOAD_WFLOAD', 'vload_wfload'], ['r-',  'b--'], 'Total Load Flow')
subplot(337)
overplot(['START_WFS', 'start_wfs'], ['r-',  'b--'], 'Start Valve Flow')

end

end

mprintf('Completed %s\n', sfilename())  
