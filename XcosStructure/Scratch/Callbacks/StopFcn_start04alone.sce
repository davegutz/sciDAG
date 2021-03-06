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
P2 = struct('time', tIDATA, 'values', IDATA.values(:,2));
P_3 = struct('time', tIDATA, 'values', IDATA.values(:,3));
PX = struct('time', tIDATA, 'values', IDATA.values(:,4));
WFAREA = struct('time', tIDATA, 'values', IDATA.values(:,5));
WFMV = struct('time', tIDATA, 'values', IDATA.values(:,6));
WF3 = struct('time', tIDATA, 'values', IDATA.values(:,9));
WF1MV = struct('time', tIDATA, 'values', IDATA.values(:,10));
WF1S = struct('time', tIDATA, 'values', IDATA.values(:,11));
MV_POS = struct('time', tIDATA, 'values', IDATA.values(:,12));
TV_POS = struct('time', tIDATA, 'values', IDATA.values(:,13));
HS_POS = struct('time', tIDATA, 'values', IDATA.values(:,14));
tPALL = PALL.time(:,1);
PDVEN = struct('time', tPALL, 'values', PALL.values(:,1));
P_NOZIN = struct('time', tPALL, 'values', PALL.values(:,2));
PS3 = struct('time', tPALL, 'values', PALL.values(:,3));
tXALL = XALL.time(:,1);
SV_POS = struct('time', tXALL, 'values', XALL.values(:,1));
clear tWALL tIDATA tPALL tXALL


vload_wfload = vload_wfl;
vload_wfload.values = vload_wfload.values + start_wfs.values;


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
subplot(224)
overplot(['WF36', 'wf36'], ['r-', 'b--'], 'Engine Flow')

figs($+1) = figure("Figure_name", 'MAIN_PRESS_1', "Position", [40,70,610,460]);
subplot(321)
overplot(['P1SO', 'p1so'], ['r-', 'b--'], 'MV Supply Pressure')
subplot(322)
overplot(['P2', 'p2'], ['r-', 'b--'], 'MV Discharge Pressure')
subplot(323)
overplot(['P_3', 'p3'], ['r-', 'b--'], 'TV Discharge Pressure')
subplot(324)
overplot(['P_NOZIN', 'pnozin'], ['r-', 'b--'], 'Nozzle Pressure')
subplot(325)
overplot(['PX', 'px'], ['r-', 'b--'], 'MVTV Control Pressure')

figs($+1) = figure("Figure_name", 'MAIN_POS', "Position", [40,90,610,600]);
subplot(321)
overplot(['MV_POS', 'mv_xin'], ['r-',  'b--'], 'MV Poaition')
subplot(322)
overplot(['HS_POS', 'hs_x'], ['r-',  'b--'], 'Head Sensor Position')
subplot(323)
overplot(['TV_POS', 'mvtv_x'], ['r-',  'b--'], 'Throttle Valve Position')
subplot(325)
overplot(['SV_POS', 'start_x'], ['r-',  'b--'], 'Start Valve Position')

figs($+1) = figure("Figure_name", 'VDPP', "Position", [40,90,610,600]);
subplot(321)
overplot(['VDPP_RPM', 'vdpp_rpm', 'vdpp_pd', 'VDPP_PL'], ['r-', 'b--', 'k--', 'o-'], 'VDPP')
subplot(322)
overplot(['vdpp_ps'], ['o--'], 'VDPP')
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

mprintf('Completed %s\n', sfilename())  
