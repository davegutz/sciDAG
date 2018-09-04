function [P, D, lastFig]= plot_VEN_Subsystem(bdroot, titleName, E, lastFig, swHcopy, MOD, desc)
% function [D, lastFig} = plot_FuelSystem(ifcname, venname, titlename, lastFig, swHcopy, MOD)
% plot full      fuel system
% 16-Jun-2016   DA Gutz     Created
% Plot cdf file reading
% Inputs:
% ifcname       Name ifc.dat
% venname       Name ven.dat
% titlename     Name .titl
% lastFig       last used figure number (starts with lastFig+1)[0]
% swHcopy       hardcopy command [0]
% Outputs:
% D             The data
% lastFig   The number of the latest figure
% Sample usage:  > [D, lastFig]= plot_FuelSystem('opLine06_INS6.ifc.dat', 'opLine06_INS6.ven.dat', 'opLine06_INS6.titl', 0, 0)
% plot 0 and make hardcopies of the plots for recorP.


%%Initialize
warning off 'MATLAB:linkaxes:RequireDataAxes'
clear D
nax     = 0;
% naxN    = 0;

%%From GRC:  Assign log variables to workspace
% lognames = logsout.getElementNames;
% for k=1:numel(lognames)
%     logname_var = ['LOG_' regexprep(lognames{k},'(\W)','_')];
%     assignin('caller',logname_var,logsout.getElement(lognames{k}).Values);
% end

%%Read in the data
dat         = evalin('base', 'logsout.getElement(''VEN'')');
D           = dat.Values;
datf        = evalin('base', 'logsout.getElement(''FADEC'')');
DF          = datf.Values;
P.BETA      = evalin('base', 'FP.beta');
clear dat
ZRET    = evalin('base', 'Z.data.RET && Z.data.enable;');
tShort  = evalin('base', 'Z.data.tShort');
if ZRET
    DSV = evalin('base', 'DS.V;');
    PSV.time    = DSV.PFEHSV(:,1);
    PSV.pd      = DSV.PFEHSV(:,2);
    PSV.pr      = DSV.PFRTN(:,2)*0;
    PSV.ps      = DSV.PFRTN(:,2);
    PSV.prod    = DSV.PFVARD(:,2);
    PSV.phead   = DSV.PFVAA8P(:,2);
    PSV.a8pos   = DSV.A8ACV(:,2);
    PSV.x       = 4.7-PSV.a8pos/100*4.7;
    PSV.a8mad   = DSV.A8MAD(:,2);
    PSV.xn25    = DSV.QN25(:,2)*172.1;
    PSV.load    = DSV.TRSMO(:,2);
    PSV.a8ref   = DSV.TRSMO(:,2)*0;
else
    if MOD.fullUp
        PSV.time    = D.I.xn25.Time;
        P.time      = D.I.xn25.Time;
        P.rpm       = D.I.xn25.Data/E.xnmainpt*E.xnvent;
        P.xn25      = D.I.xn25.Data;
    else
        PSV.time    = D.I.xn25_rpm.Time;
        P.time      = D.I.xn25_rpm.Time;
        P.rpm       = D.I.xn25_rpm.Data/E.xnmainpt*E.xnvent;
        P.xn25      = D.I.xn25_rpm.Data;
    end
end
P.time      = D.pd.Time;
P.xn25      = D.pump.In.rpm.Data*E.xnmainpt/E.xnvent;
P.pd        = D.pd.Data;
P.ps        = D.I.ps_psia.Data;
P.pr        = D.I.pr_psia.Data;
P.px        = D.px.Data;
P.prod      = D.prod.Data;
P.phead     = D.phead.Data;
P.pa_x      = D.pumpAct.x.Data;
P.reg_x     = D.reg.Result.x.Data;
P.bias_x    = D.bias.Result.x.Data;
P.ehsv_x    = D.ehsv.SPOOL.x.Data;
P.X         = D.actSys.X.Data;
P.pump_wf   = D.pump.Result.wf.Data;
P.wfload    = D.wfload.Data;
P.rline_wf  = D.rline_wf.Data;
P.hline_wf  = D.hline_wf.Data;
P.uf_net    = D.actSys.uf.Data;
P.x_4       = D.actSys.O_4.Result.x.Data;
P.x_8       = D.actSys.O_8.Result.x.Data;
P.x_12      = D.actSys.O_12.Result.x.Data;
P.fxin_4    = D.actSys.fxin_4.Data;
P.fxin_8    = D.actSys.fxin_8.Data;
P.fxin_12   = D.actSys.fxin_12.Data;
P.fx_totaldelivered = D.actSys.fx_totaldelivered.Data;
P.uf_mod_4  = D.actSys.O_4.Result.uf_mod.Data;
P.uf_mod_8  = D.actSys.O_8.Result.uf_mod.Data;
P.uf_mod_12 = D.actSys.O_12.Result.uf_mod.Data;
P.FG_4      = D.actSys.O_4.Result.FG.Data;
P.FG_8      = D.actSys.O_8.Result.FG.Data;
P.FG_12     = D.actSys.O_12.Result.FG.Data;
P.FWSUM_4   = D.actSys.O_4.Result.FWSUM.Data;
P.FWSUM_8   = D.actSys.O_8.Result.FWSUM.Data;
P.FWSUM_12  = D.actSys.O_12.Result.FWSUM.Data;
P.mA        = D.ehsv.In.mA.Data;
P.dxdt      = D.actSys.V.Data;
P.fxven     = D.I.fxven_lbf.Data;
P.wfs       = D.wfs.Data;
P.wfr       = D.wfr.Data;
P.wfstart   = D.wfstart.Data;
P.timef     = DF.ASI040.A8_POS.Time;
P.timef020  = DF.ASI040.A8P_BIAS.Time;
P.A8_POS_REF    = DF.ASI040.A8_POS_REF.Data;
P.A8_POS    = DF.ASI040.A8_POS.Data;
P.A8_LOCK   = DF.ASI040.A8_LOCK.Data;
P.A8_TM     = DF.ASI040.A8_TM.Data;
P.VEN_LOAD_X= DF.ASI040.VEN_LOAD_X.Data;
P.A8_POS_REF_DT     = DF.ASI040.A8_POS_REF_DT.Data;
P.A8_ERR    = DF.ASI040.A8_ERR.Data;
P.A8_TM_DEM = DF.ASI040.A8_TM_DEM.Data;
P.A8_NULL   = DF.ASI040.A8_NULL.Data;
P.A8_GAIN   = DF.ASI040.A8_GAIN.Data;
P.A8_TM_DEM_LK= DF.ASL041.A8_TM_DEM_LK.Data;
P.ERROR     = DF.ASL040.ERROR.Data;
P.ERR_THRES = DF.ASL040.ERR_THRES.Data;
P.nERR_THRES= -DF.ASL040.ERR_THRES.Data;
P.A8_POS_DT =  DF.A8_POS_DT.Data;
P.RATE_THRES = DF.ASL040.RATE_THRES.Data;
P.nRATE_THRES= -DF.ASL040.RATE_THRES.Data;
P.A8_HYDRO_TRIP = DF.A8_HYDRO_TRIP.Data;
P.A8_HYDRO_FAIL = DF.A8_HYDRO_FAIL.Data;
P.A8_TM_DEM_LK= DF.ASL041.A8_TM_DEM_LK.Data;
P.A8_LK_DETECT= DF.ASL041.A8_LK_DETECT.Data;
P.A8_A_POS_RATE = DF.ASL041.A8_A_POS_RATE.Data;
P.A8_RATE_THRSH = DF.ASL041.A8_RATE_THRSH_ADJ.Data;
P.nA8_RATE_THRSH = -DF.ASL041.A8_RATE_THRSH_ADJ.Data;
P.A8P_BIAS   = DF.ASI040.A8P_BIAS.Data;


%%Titles etc
if ~exist('saves', 'dir'), mkdir('saves'), end
lastFigIn = lastFig+1;
titleStr    = sprintf('%s_%s', bdroot, desc);
fileStr    = sprintf('%s_%s', bdroot, titleName);


%%Plots
[lastFig, axTIME] = plotLocal(P, D, PSV, ZRET, lastFig, 0, titleStr, lastFigIn, fileStr);
if tShort
    [lastFig, axTIMEs] = plotLocal(P, D, PSV, ZRET, lastFig, tShort, titleStr, lastFigIn, fileStr);
end

%%Synchronize x-axes
linkaxes(axTIME,'x');
if tShort, linkaxes(axTIMEs, 'x'); end
if exist('axNGR', 'var'), linkaxes(axNGR,'x'); end %#ok<*NODEF>

if swHcopy
    T=timer('TimerFcn',@(~,~)disp('Waiting 3 sec in plot_VEN_Subsystem.m...'), 'StartDelay', 3);
    for figNum = lastFigIn:1:lastFig
        hardfigurecolor(figNum, sprintf('%s_%s', bdroot, titleName), figNum-lastFigIn+1)
        start(T)
        wait(T)
    end
    delete(T)
end

warning on 'MATLAB:linkaxes:RequireDataAxes'

return




