// Copyright (C) 2019  - Dave Gutz
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
// Mar 14, 2019    DA Gutz     Created
//

// Top of script
global figs G R RES Ctrl Sen Act Cmp020SM Cmp025SM PerfUnInst
Title=G.context_file_base+' / '+G.run_file_base;
F.A8_LOOP_THRES = 18;
F.A8_LOOP_PERSIS = 0.1;
F.A8_LOOP_DTLIM = 20;
F.A8_RATE_THRSH_ADJ = 4.000;
F.A8_LK_PERSIST = 0.240+.1;
F.A8P_OP_QT_THR = 0.5;
F.A8P_CL_QT_THR = -0.5;
F.A8P_OP_NFR_THR = 1;
F.A8P_CL_NFR_THR = -1;
F.A8P_CL_ERR_THR = -2;
F.A8P_OP_ERR_THR = 2;

[nz, mz] = size(G.zoom);
if mz==2 then
    zooming = %t;
    xlims = G.zoom;
else
    zooming = %f;
    xlims = [];
end
if ~zooming then
    wid = winsid();
    if wid(1)==100001 then
        xdel(wid(2:$))
    else
        xdel(winsid())
    end
    figs=[];
end

tR = Ctrl.A8_POS.time(:,1);
DT = tR(2)-tR(1);

// Leak calculations
R.A8_LEAK_RAT_MAX = struct('time', tR, 'values', tR*0+F.A8_RATE_THRSH_ADJ);
R.A8_LEAK_RAT_MIN = struct('time', tR, 'values', tR*0-F.A8_RATE_THRSH_ADJ);
R.A8_LEAK_RATE = struct('time', tR, 'values', 1*(abs(Ctrl.A8_A_POS_RATE.values)<F.A8_RATE_THRSH_ADJ));
R.A8_LEAK_LEVEL = struct('time', tR, 'values', 1*(Ctrl.A8_TM_DEM.values<Ctrl.A8_TM_DEM_LK.values));
R.A8_LEAK_FAULT = struct('time', tR, 'values', R.A8_LEAK_LEVEL.values.*R.A8_LEAK_RATE.values);
R.A8_LEAK_TIM = struct('time', tR, 'values', tR*0);
cume = 0; prev0 = []; nowT = []; numIncident = []; firstLeak = []; RES.A8_LEAK_TIM_First = [];
for i = 1:length(R.A8_LEAK_TIM.values)
    if R.A8_LEAK_FAULT.values(i)>0 then
        cume = cume + DT;
        R.A8_LEAK_TIM.values(i) = cume;
    else
        cume = 0;
    end
    nowT($+1) = R.A8_LEAK_TIM.values(i)>0;
    if i<2 then
        prev0(1) = %t;
    else
        prev0($+1) = R.A8_LEAK_TIM.values(i-1)==0;
    end
    if prev0(i) & nowT(i) then
        numIncident($+1) = numIncident(i-1)+1;
    else if i>1 then
            numIncident($+1) = numIncident(i-1);
        else
            numIncident($+1) = 0;
        end
    end
    firstLeak($+1) = numIncident(i)== 1;
    RES.A8_LEAK_TIM_First($+1) = (1.*firstLeak(i))*R.A8_LEAK_TIM.values(i);
end
R.A8_LEAK_TRIP_TIME_LIM = struct('time', tR, 'values', tR*0+F.A8_LK_PERSIST);
RES.A8_LEAK_TIME = max(R.A8_LEAK_TIM.values);
RES.A8_LEAK_TIME_MARGIN = F.A8_LK_PERSIST - RES.A8_LEAK_TIME;
RES.A8_First_Leak_Time = max(RES.A8_LEAK_TIM_First);
RES.A8_First_Leak_TimeMargin = F.A8_LK_PERSIST - RES.A8_First_Leak_Time;
//[R.A8_LEAK_LEVEL.time R.A8_LEAK_LEVEL.values R.A8_LEAK_RATE.values R.A8_LEAK_FAULT.values R.A8_LEAK_TIM.values prev0 nowT numIncident firstLeak RES.A8_LEAK_TIM_first]

// Hydro calculations
R.A8_HYDRO_ERR_MIN = struct('time', tR, 'values', tR*0-F.A8_LOOP_THRES);
R.A8_HYDRO_ERR_MAX = struct('time', tR, 'values', tR*0+F.A8_LOOP_THRES);
R.A8_HYDRO_RAT_MIN = struct('time', tR, 'values', tR*0-F.A8_LOOP_DTLIM);
R.A8_HYDRO_RAT_MAX = struct('time', tR, 'values', tR*0+F.A8_LOOP_DTLIM);
R.A8_HYDRO_ERRTRIP_HI = struct('time', tR, 'values', 1*(Ctrl.A8_ERR.values>R.A8_HYDRO_ERR_MAX.values));
R.A8_HYDRO_ERRTRIP_LO = struct('time', tR, 'values', 1*(Ctrl.A8_ERR.values<R.A8_HYDRO_ERR_MIN.values));
R.A8_HYDRO_RAT_LO = struct('time', tR, 'values', 1*(Ctrl.A8_POS_DT.values<R.A8_HYDRO_RAT_MAX.values));
R.A8_HYDRO_RAT_HI = struct('time', tR, 'values', 1*(Ctrl.A8_POS_DT.values>R.A8_HYDRO_RAT_MIN.values));
R.A8_HYDRO_FAULT_HI = struct('time', tR, 'values', R.A8_HYDRO_ERRTRIP_HI.values.*R.A8_HYDRO_RAT_LO.values);
R.A8_HYDRO_FAULT_LO = struct('time', tR, 'values', R.A8_HYDRO_ERRTRIP_LO.values.*R.A8_HYDRO_RAT_HI.values);
R.A8_HYDRO_ERR_HI = struct('time', tR, 'values', max(Ctrl.A8_ERR.values, 0).*R.A8_HYDRO_RAT_LO.values);
R.A8_HYDRO_ERR_LO = struct('time', tR, 'values', min(Ctrl.A8_ERR.values, 0).*R.A8_HYDRO_RAT_HI.values);
R.A8_HYDRO_TIME_HI = struct('time', tR, 'values', tR*0);
cume = 0;
for i = 1:length(R.A8_HYDRO_FAULT_HI.values)
    if R.A8_HYDRO_FAULT_HI.values(i)>0 then
        R.A8_HYDRO_TIME_HI.values(i) = cume;
        cume = cume + DT;
    else
        cume = 0;
    end
end
R.A8_HYDRO_FAIL_HI = struct('time', tR, 'values', 1*(R.A8_HYDRO_TIME_HI.values>F.A8_LOOP_PERSIS));
R.A8_HYDRO_TIME_LO = struct('time', tR, 'values', tR*0);
cume = 0;
for i = 1:length(R.A8_HYDRO_FAULT_LO.values)
    if R.A8_HYDRO_FAULT_LO.values(i)>0 then
        R.A8_HYDRO_TIME_LO.values(i) = cume;
        cume = cume + DT;
    else
        cume = 0;
    end
end
R.A8_HYDRO_FAIL_LO = struct('time', tR, 'values', 1*(R.A8_HYDRO_TIME_LO.values>F.A8_LOOP_PERSIS));
R.A8_HYDRO_TRIP_TIME_LIM = struct('time', tR, 'values', tR*0+F.A8_LOOP_PERSIS);
RES.Hydro_ERR_HI = max(R.A8_HYDRO_ERR_HI.values);
RES.Hydro_ERR_LO = min(R.A8_HYDRO_ERR_LO.values);
RES.Hydro_Time_HI = max(R.A8_HYDRO_TIME_HI.values);
RES.Hydro_Time_LO = max(R.A8_HYDRO_TIME_LO.values);
RES.Hydro_Err_Margin_HI = F.A8_LOOP_THRES - RES.Hydro_ERR_HI;
RES.Hydro_Err_Margin_LO = -(-F.A8_LOOP_THRES - RES.Hydro_ERR_LO);
RES.Hydro_TimeMargin_HI = F.A8_LOOP_PERSIS - RES.Hydro_Time_HI;
RES.Hydro_TimeMargin_LO = F.A8_LOOP_PERSIS - RES.Hydro_Time_LO;
RES.Hydro_Err_Margin = min(RES.Hydro_Err_Margin_HI, RES.Hydro_Err_Margin_LO);
RES.HydroTripTimeMargin = min(RES.Hydro_TimeMargin_HI, RES.Hydro_TimeMargin_LO);
RES.HydroError = max(RES.Hydro_ERR_HI, -RES.Hydro_ERR_LO);

// Stuck Calculations
R.A8P_upper_quiet = struct('time', tR, 'values', tR*0+F.A8P_OP_QT_THR);
R.A8P_lower_quiet = struct('time', tR, 'values', tR*0+F.A8P_CL_QT_THR);
R.A8P_free_op_trip = struct('time', tR, 'values', tR*0+F.A8P_OP_NFR_THR);
R.A8P_free_cl_trip = struct('time', tR, 'values', tR*0+F.A8P_CL_NFR_THR);
R.A8P_Ref_drift_cl_trip = struct('time', tR, 'values', tR*0+F.A8P_CL_ERR_THR);
R.A8P_Ref_drift_op_trip = struct('time', tR, 'values', tR*0+F.A8P_OP_ERR_THR);
Ctrl.A8P_OP_STK_ = Ctrl.A8P_OP_STK; Ctrl.A8P_OP_STK_.values = Ctrl.A8P_OP_STK.values+8;
Ctrl.A8P_CL_STK_ = Ctrl.A8P_CL_STK; Ctrl.A8P_CL_STK_.values = Ctrl.A8P_CL_STK_.values+6;
Ctrl.A8P_QUIET_ = Ctrl.A8P_QUIET; Ctrl.A8P_QUIET_.values = Ctrl.A8P_QUIET_.values+4;
Ctrl.A8P_STEADY_ = Ctrl.A8P_STEADY; Ctrl.A8P_STEADY_.values = Ctrl.A8P_STEADY_.values + 2;
Ctrl.A8P_NUM_REQ_ = Ctrl.A8P_NUM_REQ; Ctrl.A8P_NUM_REQ_.values = Ctrl.A8P_NUM_REQ_.values -2;
Ctrl.A8P_NUM_ = Ctrl.A8P_NUM; Ctrl.A8P_NUM_.values = Ctrl.A8P_NUM_.values - 4;
Ctrl.A8P_OP_ENABLE_ = Ctrl.A8P_OP_ENABLE; Ctrl.A8P_OP_ENABLE_.values = Ctrl.A8P_OP_ENABLE_.values - 6;
Ctrl.A8P_CL_ENABLE_ = Ctrl.A8P_CL_ENABLE; Ctrl.A8P_CL_ENABLE_.values = Ctrl.A8P_CL_ENABLE_.values - 8;

if G.plot_summary then

    figs($+1) = figure("Figure_name", Title, "Position",  [440,0,500,460]); clf();
    subplot(211)
    overplot_zoom(['Ctrl.A8_POS_REF', 'Ctrl.A8_POS', 'Ctrl.A8P_BIAS'], ['b-', 'g-', 'r-'], 'Stroke  '+Title, xlims)
    subplot(212)
    overplot_zoom(['Ctrl.A8_TM_DEM', 'R.A8_LEAK_FAULT', 'Ctrl.A8P_QUIET', 'Ctrl.A8P_CL_RECENT', 'Ctrl.A8DT_REF'], ['k-', 'b-', 'g-', 'r-', 'm-'], 'TM Current', xlims)

else

    figs($+1) = figure("Figure_name", 'A8 Servo  ' +Title, "Position",  [440,0,500,460]); clf();
    subplot(221)
    overplot_zoom(['Ctrl.A8_POS_REF', 'Ctrl.A8_POS', 'Ctrl.A8P_BIAS_LIM', 'Ctrl.A8P_BIAS'], ['b-', 'g-', 'r-', 'k--'], 'Stroke  '+Title, xlims)

    figs($+1) = figure("Figure_name", 'Lim Cycle  ' +Title, "Position",  [480,0,500,460]); clf();
    subplot(111)
    overplot_zoom(['Ctrl.A8_TM_DEM', 'Ctrl.A8_TM_DEM_LK', 'Ctrl.A8P_POS_DT', 'Ctrl.A8P_REF_DRIFT', 'Ctrl.A8P_QUIET', 'Ctrl.A8P_STEADY' ], ['r-', 'r--', 'b-', 'k-', 'r-', 'b--'], 'TM Current', xlims)

    if 0
    figs($+1) = figure("Figure_name", 'A8 Servo Init ' +Title, "Position",  [480,0,500,460]); clf();
    subplot(221)
    overplot_zoom(['Ctrl.A8_POS_REF', 'Ctrl.SI0411'], ['b-', 'g--'], 'Ref  '+Title, xlims)
    subplot(223)
    overplot_zoom(['Ctrl.A8_ERR', 'Ctrl.SI0402'], ['k-', 'c--'], 'TM Current', xlims)
    subplot(222)
    overplot_zoom(['Ctrl.A8_POS_REF', 'Ctrl.SI0411', 'Ctrl.SI0406'], ['b-', 'g--', 'm--'], 'Ref  '+Title, xlims)
    end

    figs($+1) = figure("Figure_name", 'Leak Fail  '+Title, "Position", [440,30,1000,660]); clf();
    subplot(321)
    overplot_zoom(['Ctrl.A8_TM_DEM', 'Ctrl.A8_TM_DEM_LK', 'Act.XMAVEN', 'Act.XMAVNC'], ['r-', 'r--', 'k-', 'm--'], 'Leak Error  ' +Title, xlims, [-25 60])
    subplot(322)
    overplot_zoom(['Ctrl.A8_A_POS_RATE', 'R.A8_LEAK_RAT_MAX', 'R.A8_LEAK_RAT_MIN'], ['b-', 'b--', 'b--'], 'Rate', xlims)
    subplot(323)
    overplot_zoom(['R.A8_LEAK_FAULT'], ['c-'], 'Leak Trip', xlims)
    subplot(324)
    ylims = [0 F.A8_LK_PERSIST];
    overplot_zoom(['R.A8_LEAK_TIM', 'R.A8_LEAK_TRIP_TIME_LIM'], ['r-', 'c--', 'r--'], 'Leak Trip Time', xlims, ylims)
    subplot(325)
    overplot_zoom(['Ctrl.A8_LEAK'], ['r--'], 'Leak Fail', xlims)
    subplot(326)
    overplot_zoom(['Ctrl.A8_TM_NULL_SHIFT'], ['r--'], 'Null Shift', xlims)

    figs($+1) = figure("Figure_name", 'Hydro Fail  '+Title, "Position", [440,60,1000,660]); clf();
    subplot(321)
    overplot_zoom(['Ctrl.A8_ERR', 'R.A8_HYDRO_ERR_MAX', 'R.A8_HYDRO_ERR_MIN', 'R.A8_HYDRO_ERRTRIP_HI', 'R.A8_HYDRO_ERRTRIP_LO'], ['r-', 'r--', 'r--', 'm-', 'c--'], 'Hydro Error  ' + Title, xlims)
    subplot(322)
    overplot_zoom(['Ctrl.A8_A_POS_RATE', 'R.A8_HYDRO_RAT_MAX', 'R.A8_HYDRO_RAT_MIN', 'R.A8_HYDRO_RAT_HI', 'R.A8_HYDRO_RAT_LO'], ['b-', 'b--', 'b--', 'm-', 'c--'], 'Rate', xlims)
    subplot(323)
    overplot_zoom(['R.A8_HYDRO_FAULT_HI', 'R.A8_HYDRO_FAULT_LO'], ['c-', 'k--'], 'Hydro Trip', xlims)
    subplot(324)
    ylims = [0 F.A8_LOOP_PERSIS];
    overplot_zoom(['R.A8_HYDRO_TIME_HI', 'R.A8_HYDRO_TIME_LO', 'R.A8_HYDRO_TRIP_TIME_LIM'], ['r-', 'c--', 'r--'], 'Hydro Trip Time', xlims, ylims)
    subplot(325)
    overplot_zoom(['Ctrl.A8_HYDRO_TRIP', 'Ctrl.A8_HYDRO_FAIL'], ['c-', 'r--'], 'Hydro Fail', xlims)


    figs($+1) = figure("Figure_name", 'Stuck  '+Title, "Position", [440,90,1000,660]); clf();
    subplot(321)
    overplot_zoom(['Ctrl.A8P_POS_DT', 'R.A8P_upper_quiet', 'R.A8P_lower_quiet'], ['r-', 'r--', 'r--'], 'Quiet  '+Title, xlims)
    subplot(322)
    overplot_zoom(['Ctrl.A8P_OP_STK', 'Ctrl.A8P_NUM_REQ', 'Ctrl.A8P_CL_STK', 'Ctrl.A8P_BIAS', 'Ctrl.LZ0423'], ['m-', 'b-', 'r-', 'g-', 'c-'], 'Sticking', xlims)
    subplot(323)
    overplot_zoom(['Ctrl.A8_POS_REF', 'Ctrl.A8_POS', 'Ctrl.A8P_POS_REF_FILT', 'Ctrl.A8P_POS_FILT_LOC'], ['r-', 'k-', 'r--', 'k--'], 'Results', xlims)
    subplot(324)
    overplot_zoom(['Ctrl.A8P_MOTION', 'Ctrl.A8P_REF_DRIFT', 'R.A8P_free_op_trip', 'R.A8P_free_cl_trip', 'R.A8P_Ref_drift_cl_trip', 'R.A8P_Ref_drift_op_trip'], ['r-', 'b-', 'r--', 'r--', 'b--', 'b--'], 'RunFree', xlims)
    subplot(325)
    ylims = [-10 10];
    overplot_zoom(['Ctrl.A8P_OP_STK_', 'Ctrl.A8P_CL_STK_', 'Ctrl.A8P_QUIET_', 'Ctrl.A8P_STEADY_', 'Ctrl.A8P_STK_WATCH', 'Ctrl.A8P_NUM_REQ_', 'Ctrl.A8P_NUM_', 'Ctrl.A8P_OP_ENABLE_', 'Ctrl.A8P_CL_ENABLE_'], ['r-', 'r--', 'b-', 'g--', 'm-', 'c--', 'c-', 'k--', 'k-'], 'Status', xlims, ylims)
    subplot(326)
    ylims = [-1 20];
    Ctrl.PLA_q10 = Ctrl.PLA; Ctrl.PLA_q10.values = Ctrl.PLA_q10.values/10;
    overplot_zoom(['Ctrl.A8P_OP_STK_SOON', 'Ctrl.A8P_CL_STK_SOON', 'Ctrl.AB_PERM', 'Ctrl.PLA_q10'], ['m-', 'r-', 'c--', 'k'], 'Status', xlims, ylims)

    figs($+1) = figure("Figure_name", 'Load  '+Title, "Position", [440,120,1000,660]); clf();
    subplot(321)
    overplot_zoom(['Act.VEN_LOAD', 'Ctrl.VEN_LOAD_X', 'Act.VEN_LOAD_CALC', 'Act.VEN_FRICTION'], ['k-', 'g--', 'r--', 'm-'], 'Load  '+Title, xlims)
    subplot(322)
    overplot_zoom(['Act.PDVEND', 'Act.PDVEN'], ['k--', 'r-'], 'Pressure', xlims)
    subplot(323)
    overplot_zoom(['Act.VEN_SVENO', 'Act.VEN_SVENC'], ['g-', 'r-'], 'Scalars', xlims)
    subplot(324)
    overplot_zoom(['Act.VEN_FMO', 'Act.VEN_FMC'], ['g-', 'r-'], 'Force Margin', xlims)
    subplot(325)
    overplot_zoom(['Act.VEN_FMO', 'Act.VEN_FMC'], ['g-', 'r-'], 'Force Margin', xlims)
    subplot(326)
    overplot_zoom(['Act.VEN_XDTD', 'Act.VEN_XDT'], ['g-', 'r-'], 'Rate', xlims)

    figs($+1) = figure("Figure_name", 'CPR  '+Title, "Position", [440,150,1000,660]); clf();
    subplot(321)
    overplot_zoom(['Ctrl.CPR_BIAS_ADJ'], ['b-'], 'Bias  '+Title, xlims)
    subplot(322)
    overplot_zoom(['Ctrl.CPR_REF', 'Ctrl.CPR'], ['b-', 'g-'], 'CPR', xlims)
    subplot(323)
    overplot_zoom(['Ctrl.CMODE_WF', 'Ctrl.CMODE_A8'], ['k-', 'r-'], 'CMODE', xlims)
    subplot(324)
    overplot_zoom(['Ctrl.A8_POS_REF', 'Ctrl.A8_POS', 'Ctrl.A8_FLOOR'], ['b-', 'g-', 'c--'], 'A8', xlims)
    subplot(325)
    overplot_zoom(['Cmp020SM.SMW', 'Cmp025SM.SMW'], ['r-', 'b-'], 'SM', xlims)
    Fn_q100 = PerfUnInst.Fn; Fn_q100.values = Fn_q100.values/100;
    subplot(326)
    overplot_zoom(['Ctrl.PLA', 'Fn_q100'], ['k-', 'g-'], 'PLA', xlims)

    figs($+1) = figure("Figure_name", 'Null  '+Title, "Position", [440,180,1000,660]); clf();
    subplot(321)
    overplot_zoom(['Ctrl.A8_POS_REF', 'Ctrl.A8_POS', 'Ctrl.A8_FLOOR'], ['b-', 'g-', 'c--'], 'A8  '+Title, xlims)
    subplot(322)
    overplot_zoom(['Ctrl.A8_ERR', 'Ctrl.A8_GAIN'], ['b-', 'g-'], 'Gain', xlims)
    subplot(323)
    A8_NullDmd = Ctrl.A8_TM_NULL_SHIFT; A8_NullDmd.values = Ctrl.A8_ERR.values.*Ctrl.A8_GAIN.values;
    overplot_zoom(['A8_NullDmd', 'Ctrl.A8_TM_NULL_SHIFT', 'Ctrl.A8P_STK_WATCH'], ['b-', 'g-', 'k-'], 'Loop', xlims)
    subplot(324)
    ylims = [-10 10];
    overplot_zoom(['Ctrl.A8P_OP_STK_', 'Ctrl.A8P_CL_STK_', 'Ctrl.A8P_QUIET_', 'Ctrl.A8P_STK_WATCH'], ['r-', 'r--', 'b-','g-'], 'Status', xlims, ylims)

end  // ~G.plot_summary
