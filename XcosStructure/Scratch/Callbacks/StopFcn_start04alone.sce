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

if 1  & Tf>0 then
    
figs($+1) = figure("Figure_name", 'MAIN_FLOW_1', "Position", [10,30,610,460]);
subplot(221)
overplot(['WF1V', 'wf1v'], ['r-', 'b--'], 'VEN Start Discharge Flow')
subplot(222)
overplot(['WF1MV', 'wf1mv'], ['r-', 'b--'], 'MV Supply Flow')
subplot(223)
overplot(['WF1S', 'wf1s'], ['r-', 'b--'], 'Sense Flow')
subplot(224)
overplot(['WFMV', 'mv_wfd', 'WFAREA'], ['r-', 'b--', 'g-'], 'MV Discharge Flow')

figs($+1) = figure("Figure_name", 'MAIN_FLOW_2', "Position", [10,50,610,460]);
subplot(221)
overplot(['WF3', 'wf3'], ['r-', 'b--'], 'Throttle Valve Discharge Flow')
subplot(222)
overplot(['WFMD', 'wfmd'], ['r-', 'b--'], 'Main Discharge Flow')
subplot(224)
overplot(['WF36', 'wf36'], ['r-', 'b--'], 'Engine Flow')

figs($+1) = figure("Figure_name", 'MAIN_PRESS_1', "Position", [10,70,610,460]);
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

figs($+1) = figure("Figure_name", 'MAIN_POS', "Position", [10,90,610,600]);
subplot(321)
overplot(['MV_POS', 'mv_xin'], ['r-',  'b--'], 'MV Poaition')
subplot(322)
overplot(['HS_POS', 'hs_x'], ['r-',  'b--'], 'Head Sensor Position')
subplot(323)
overplot(['TV_POS', 'mvtv_x'], ['r-',  'b--'], 'Throttle Valve Position')
subplot(325)
overplot(['SV_POS', 'start_x'], ['r-',  'b--'], 'Start Valve Position')

figs($+1) = figure("Figure_name", 'VDPP', "Position", [10,90,610,600]);
subplot(321)
overplot(['vdpp_rpm', 'vdpp_pd', 'VDPP_PL'], ['o--',  'k--', 'r-'], 'VDPP')
subplot(322)
overplot(['vdpp_ps'], ['o--'], 'VDPP')
subplot(323)
overplot(['vdpp_disp'], ['k--'], 'VDPP')
subplot(324)
overplot(['VDPP_WF', 'vdpp_wf'], ['r-',  'b--'], 'VDPP Flow')
subplot(325)
overplot(['VDPP_MTDQP'], ['r-'], 'VDPP')
subplot(326)
overplot(['VDPP_EFF_VOL'], ['b-'], 'VDPP')

figs($+1) = figure("Figure_name", 'VEN', "Position", [30,110,610,600]);
subplot(221)
overplot(['PACT_X', 'pact_x'], ['r-',  'b--'], 'Pump Act Stroke')
subplot(222)
overplot(['VLINK_FTPA', 'vlink_ftpa'], ['r-',  'b--'], 'Pump Act Loads')
subplot(223)
overplot(['PACT_FEXTH', 'pact_fexth'], ['r-',  'b--'], 'Pump Act Load')
end

mprintf('Completed %s\n', sfilename())  
