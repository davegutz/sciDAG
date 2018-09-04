function [P, DV, lastFig]= plot_F414_FuelSystem(bdroot, titleName, E, lastFig, swHcopy, desc)
% function [DV, lastFig} = plot_F414_FuelSystem(ifcname, venname, titlename, lastFig, swHcopy, desc)
% plot full F414 fuel system
% 16-Jun-2016   DA Gutz     Created
% Plot cdf file reading
% Inputs:
% ifcname       Name ifc.dat
% venname       Name ven.dat
% titlename     Name .titl
% lastFig       last used figure number (starts with lastFig+1)[0]
% swHcopy       hardcopy command [0]
% Outputs:
% DV             The data
% lastFig   The number of the latest figure
% Sample usage:  > [DV, lastFig]= plot_F414_FuelSystem('opLine06_INS6.ifc.dat', 'opLine06_INS6.ven.dat', 'opLine06_INS6.titl', 0, 0)
% plot 0 and make hardcopies of the plots for recorP.


%%Initialize
warning off 'MATLAB:linkaxes:RequireDataAxes'
clear DV
nax     = 0;
naxN    = 0;

%%From GRC:  Assign log variables to workspace
% lognames = logsout.getElementNames;
% for k=1:numel(lognames)
%     logname_var = ['LOG_' regexprep(lognames{k},'(\W)','_')];
%     assignin('caller',logname_var,logsout.getElement(lognames{k}).Values);
% end

%%Read in the data
dat         = evalin('base', 'logsout.getElement(''VEN'')');
DV          = dat.Values;
dat         = evalin('base', 'logsout.getElement(''MAIN'')');
DM          = dat.Values;
clear dat
P.time      = DM.eng.ps3.Time;
P.ps3       = DM.eng.ps3.Data;
P.ng        = DM.eng.xn25.Data*100/E.N25100Pct;
P.wf36      = DM.eng.wf36.Data;
P.mv_x      = DM.ifc.Calc.Comp.fmv.mv.Result.x.Data;
P.mvsv_x    = DM.ifc.Calc.Comp.fmv.mvsv.SPOOL.x.Data;
P.mvtv_x    = DM.ifc.Calc.Comp.mvtv.Result.x.Data;
P.hs_x      = DM.ifc.Calc.Comp.hs.Result.x.Data;
P.check_x   = P.hs_x*0 -.2;
P.prt_x     = P.hs_x*0 -.2;
P.fvg_x     = P.hs_x*0 -.5;
P.cvg_x     = P.hs_x*0 -.5;
P.p1c       = DM.ifc.Calc.Press.p1c.Data;
P.p2        = DM.ifc.Calc.Press.p2.Data;
P.p3        = DM.ifc.Calc.Press.p3.Data;
P.prt       = DM.ifc.Calc.Press.prt.Data;
P.pr        = DM.ifc.Calc.Press.pr.Data;
P.pd        = DM.ifc.PD.Data;
P.px        = DM.ifc.Calc.Press.px.Data;
P.ptank     = DM.ac.Mon_ABOOST.ptank.Data;
P.pengine   = DM.ac.Mon_ABOOST.pengine.Data;
P.poc       = DM.supply.Calc.POC.Data;
P.pocs      = DM.supply.Calc.POCS.Data;
P.pmainp    = DM.supply.Calc.PMAINP.Data;
P.pb1       = DM.bvs.Calc.PB1.Data;
P.pb2       = DM.bvs.Calc.PB2.Data;
P.psven     = DM.bvs.PSVEN.Data;
P.wffilt    = DM.bvs.Calc.WFFILT.Data;
P.wf1p      = DM.ifc.WF1P.Data;
P.wfengine  = DM.supply.WFENGINE.Data;
P.wftank    = DM.ac.Mon_ABOOST.wftank.Data;
P.wfb2      = DM.supply.Calc.WFB2.Data;
P.wfabocx1  = DM.supply.Calc.WFABOCX1.Data;
P.wfocmx1   = DM.supply.Calc.WFOCMX1.Data;
P.wf1cx     = DM.ifc.Calc.Flow.wf1cx.Data;
P.wf1c      = DM.ifc.Calc.Flow.wf1c.Data;
P.wf1mv     = DM.ifc.Calc.Flow.wf1mv.Data;
P.wf3       = DM.ifc.Calc.Flow.wf3.Data;
P.wfmd      = DM.ifc.In.wfmd.Data;
P.wf1vg     = DM.ifc.In.wf1vg.Data;
P.wf1v      = DM.ifc.In.wf1v.Data;
P.wftvb     = DM.ifc.Calc.Flow.wftvb.Data;

%%Titles etc
if ~exist('saves', 'dir'), mkdir('saves'), end
lastFigIn = lastFig+1;
titleStr    = sprintf('%s_%s', bdroot, desc);
fileStr    = sprintf('%s_%s', bdroot, titleName);


%%Plots

% Figure 1
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,1);
plot(P.time, [P.ng]);
ylim([-5 115]);
grid;xlabel('Time, s');ylabel('see legend');legend({'N25, %'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 122, fileStr,'fontsize',6, 'interpreter', 'none');
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,2);
plot(P.time, [P.ps3]);
ylim([0 500]);
grid;xlabel('Time, s');ylabel('see legend');legend({'PS3, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
nax         = nax + 1;
axTIME(lastFigIn, nax)  = subplot(3,1,3);
plot(P.time, [P.wf36]);
ylim([0 20000]);
grid;xlabel('Time, s');ylabel('see legend');legend({'WF36, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


% Figure 2
lastFig     = lastFig+1;
figure(lastFig);clf;
naxN         = naxN + 1;
axNGR(lastFigIn, naxN)    = subplot(2,1,1);
plot(P.ng, [P.ps3]);
ylim([0 580]);
grid;xlabel('NG, %');ylabel('see legend');legend({'PS3, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(75.99, 580, fileStr,'fontsize',6, 'interpreter', 'none');
naxN         = naxN + 1;
axNGR(lastFigIn, naxN)  = subplot(2,1,2);
plot(P.ng, [P.wf36]);
ylim([0 20000]);
grid;xlabel('NG, %');ylabel('see legend');legend({'WF36, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


% Figure 3
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,1);
plot(P.time, [P.mv_x P.mvsv_x P.mvtv_x P.hs_x P.check_x P.prt_x]);
ylim([-0.2 0.7]);
grid;xlabel('Time, s');ylabel('see legend');legend({'mv_x, in', 'mvsv_x, in', 'mvtv_x, in', 'hs_x, in', 'check_x, in', 'prt_x, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 0.723, fileStr,'fontsize',6, 'interpreter', 'none');
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,2);
plot(P.time, [P.fvg_x P.cvg_x]);
ylim([-0.5 4]);
grid;xlabel('Time, s');ylabel('see legend');legend({'fvg_x, in', 'cvg_x, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


% Figure 4
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,1);
plot(P.time, [P.ptank P.pengine P.pb1 P.pb2 P.psven P.pmainp]);
grid;xlabel('Time, s');ylabel('see legend');legend({'ptank, psia', 'pengine, psia', 'pb1, psia', 'pb2, psia', 'psven, psia', 'pmainp, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 206, fileStr,'fontsize',6, 'interpreter', 'none');
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,2);
plot(P.time, [P.wftank P.wfengine P.wffilt P.wfb2 P.wfocmx1 P.wf1p]);
grid;xlabel('Time, s');ylabel('see legend');legend({'wftank, pph', 'wfengine, pph', 'wffilt, pph', 'wfb2, pph', 'wfocmx1, pph', 'wf1p, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


% Figure 5
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,1);
plot(P.time, [P.p1c P.p2 P.p3 P.prt P.pr P.pd P.px]);
grid;xlabel('Time, s');ylabel('see legend');legend({'p1c, psia', 'p2, psia', 'p3, psia', 'prt, psia', 'pr, psia', 'pd, psia', 'px, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 2130, fileStr,'fontsize',6, 'interpreter', 'none');
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,2);
plot(P.time, [P.wf1cx P.wf1c P.wf1mv P.wf3 P.wfmd P.wf1vg P.wf1v P.wftvb]);
grid;xlabel('Time, s');ylabel('see legend');legend({'wf1cx, pph', 'wf1c, pph', 'wf1mv, pph', 'wf3, pph', 'wfmd, pph', 'wf1vg, pph', 'wf1v, pph', 'wftvb, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,3);
plot(P.time, P.p2-P.p3);
grid;xlabel('Time, s');ylabel('see legend');legend({'p2-p3, psid'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)


%%Synchronize x-axes
linkaxes(axTIME,'x');
if exist('axNGR', 'var'), linkaxes(axNGR,'x'); end %#ok<*NODEF>

if swHcopy,
    for figNum = lastFigIn:1:lastFig,
        hardfigurecolor(figNum, sprintf('%s_%s', bdroot, titleName), figNum-lastFigIn+1)
    end
end

warning on 'MATLAB:linkaxes:RequireDataAxes'

return
   
% plot_opLine_lti_F414_FuelSystemPlot
% Plot results of exercise full F414 fuel system
% 7-Jan-2013   DA Gutz     Created


% Model path
if L.swINS6
    modelPath = 'F414_Fuel/Main/';
else
    modelPath = 'F414_Fuel/Main/';
end
modelTopPath = 'F414_Fuel';


clear SYS
L.wmax1 = 10000*2*pi;  % 3e3;
L.fmax1   = 10000;   %100
L.wmax2   = 10000*2*pi; % 600;
L.wmax3   = 10000*2*pi;   % 3e4
L.fmax2   = 10000;  % 6e3
L.fmax3   = 10000;  % 6e2
L.fmax4   = 10000;  % 100
%%Open loop response pump Fig 1
if L.swPPUMP
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodePUMP=L.nfigs; figure(M.figBodePUMP);
        M.PPUMP = bodeoptions('cstprefs');
        M.PPUMP.PhaseWrapping='off'; M.PPUMP.Grid='on'; M.PPUMP.FreqScale='log';
        M.PPUMP.Title.Interpreter = 'none';
        M.PPUMP.OutputLabels.Interpreter = 'none';
        M.PPUMP.InputLabels.Interpreter = 'none';
        M.PPUMP.Title.String = '';
        M.PPUMP.MagLowerLimMode = 'manual';
        M.PPUMP.MagLowerLim = -80;
        M.PPUMP.FreqUnits = 'Hz';
        M.PPUMP.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodePUMP) = {'Pressure Subsystem'}; %#ok<*SAGROW>
    end
    clear LIN
    %     LIN.ioLin(1)    = linio('lti_F414_FuelSystem/eboost', 2, 'in', 'off');
    if L.swbase
        LIN.ioLin(1)    = linio([modelPath 'xn25'], 1, 'in', 'off');
        if swINS6
            LIN.ioLin(2)    = linio([modelPath 'wf1psum'], 1, 'out', 'off');
        else
            LIN.ioLin(2)    = linio([modelPath 'p1sum'], 1, 'out', 'off');
        end
        LIN.ioLin(3)    = linio([modelPath 'mvsub'], 7, 'none', 'on');  % p1 feedback disabled
        LIN.ioLin(4)    = linio([modelPath 'ven'], 2, 'none', 'on');  % wfsven feedback disabled
        LIN.ioLin(5)    = linio([modelPath 'ven'], 3, 'none', 'on');  % wfrven feedback disabled
        LIN.ioLin(6)    = linio([modelPath 'mvsub'], 4, 'none', 'on');  % wfc feedback disabled
        LIN.ioLin(7)    = linio([modelPath 'vgline'], 2, 'none', 'on');  % wfcvy feedback disabled
    else
        LIN.ioLin(1)    = linio([modelPath 'xn25'], 1, 'in', 'off');
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6'], 2, 'out', 'off');
    end
    LIN.sys_F414_FuelSystem_PPUMP  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_PPUMP = LIN.sys_F414_FuelSystem_PPUMP;
    figure(M.figBodePUMP); bodeplot(LIN.sys_F414_FuelSystem_PPUMP, M.PPUMP);
    [SYS.pump.mag, SYS.pump.phase, SYS.pump.w] = bode(LIN.sys_F414_FuelSystem_PPUMP, {1, L.wmax1});
    LRES(L.nCases).pump = SYS.pump;
    if ~L.held, hold('on'); end
else
     M.figBodePUMP = 999;
end

%%Closed loop PUMPS Stability Fig 2 and 3
if L.swINLET
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeINLET=L.nfigs; figure(M.figBodeINLET);
        M.INLET = bodeoptions('cstprefs');
        M.INLET.PhaseWrapping='off'; M.INLET.Grid='on'; M.INLET.FreqScale='log';
        M.INLET.Title.Interpreter = 'none';
        M.INLET.OutputLabels.Interpreter = 'none';
        M.INLET.InputLabels.Interpreter = 'none';
        M.INLET.Title.String = '';
        M.INLET.MagLowerLimMode = 'manual';
        M.INLET.MagLowerLim = -80;
        M.INLET.FreqUnits = 'Hz';
        M.INLET.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeINLET) = {'INLET'}; %#ok<*SAGROW>
    end
    clear LIN
    if L.swbase && ~swINS6
        LIN.ioLin(1)    = linio([modelPath 'eboost/wfengine'], 1, 'in', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost/man_n_vm_inlet'], 2, 'out', 'on');
        LIN.ioLin(3)    = linio([modelPath 'eboost/ip_wpdtops_boost'], 1, 'none', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost/man_n_vm_inlet'], 1, 'none', 'on');
    else
        LIN.ioLin(1)    = linio([modelPath 'eboost_ins6/wfengine'], 1, 'in', 'on');             % wfengine
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6/man_n_vm_vsin'], 1, 'out', 'on');      % pboost
        LIN.ioLin(3)    = linio([modelPath 'eboost_ins6/man_n_vm_inlet'], 2, 'none', 'on');     % wfboost
        LIN.ioLin(4)    = linio([modelPath 'eboost_ins6/man_n_vm_inlet'], 1, 'none', 'on');     % pengine
    end
    LIN.sys_F414_FuelSystem_INLET  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeINLET); bodeplot(LIN.sys_F414_FuelSystem_INLET, M.INLET);
    if ~L.held, hold('on'); end
else
     M.figBodeINLET = 999;
end

%     save ModelData magCLPUMPS wCLPUMPS

if L.swBOOST
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeBOOST=L.nfigs; figure(M.figBodeBOOST);
        M.BOOST = bodeoptions('cstprefs');
        M.BOOST.PhaseWrapping='off'; M.BOOST.Grid='on'; M.BOOST.FreqScale='log';
        M.BOOST.Title.Interpreter = 'none';
        M.BOOST.OutputLabels.Interpreter = 'none';
        M.BOOST.InputLabels.Interpreter = 'none';
        M.BOOST.Title.String = '';
        M.BOOST.MagLowerLimMode = 'manual';
        M.BOOST.MagLowerLim = -80;
        M.BOOST.FreqUnits = 'Hz';
        M.BOOST.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeBOOST) = {'BOOST Pump'}; %#ok<*SAGROW>
    end
    clear LIN
    if L.swbase && ~swINS6
        LIN.ioLin(1)    = linio([modelPath 'eboost/Gain'], 1, 'none', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost/ip_wpdtops_boost'], 1, 'out', 'on');
        LIN.ioLin(3)    = linio([modelPath 'eboost/man_n_vm_inlet'], 2, 'in', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost/f414_filter'], 1, 'none', 'on');
    else
        LIN.ioLin(1)    = linio([modelPath 'eboost_ins6/Gain'], 1, 'none', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6/ip_wpstopd_boost'], 1, 'out', 'on');
        LIN.ioLin(3)    = linio([modelPath 'eboost_ins6/man_n_mv_inlet'], 2, 'none', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost_ins6/mom_1_vsin'], 1, 'in', 'on');
    end
    LIN.sys_F414_FuelSystem_BOOST  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeBOOST); bodeplot(LIN.sys_F414_FuelSystem_BOOST, M.BOOST);
    if ~L.held, hold('on'); end
else
     M.figBodeBOOST = 999;
end

%%Boost subsystem
if L.swBOOSTSYS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeBOOSTSYS=L.nfigs; figure(M.figBodeBOOSTSYS);
        M.BOOSTSYS = bodeoptions('cstprefs');
        M.BOOSTSYS.PhaseWrapping='off'; M.BOOSTSYS.Grid='on'; M.BOOSTSYS.FreqScale='log';
        M.BOOSTSYS.Title.Interpreter = 'none';
        M.BOOSTSYS.OutputLabels.Interpreter = 'none';
        M.BOOSTSYS.InputLabels.Interpreter = 'none';
        M.BOOSTSYS.Title.String = '';
        M.BOOSTSYS.MagLowerLimMode = 'manual';
        M.BOOSTSYS.MagLowerLim = -80;
        M.BOOSTSYS.FreqUnits = 'Hz';
        M.BOOSTSYS.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeBOOSTSYS) = {'BOOST SUBSYSTEM'}; %#ok<*SAGROW>
    end
    clear LIN
    if L.swbase && ~swINS6
        LIN.ioLin(1)    = linio([modelPath 'eboost/wfengine'], 1, 'none', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost/vol_1_psven'], 1, 'out', 'off');
        LIN.ioLin(3)    = linio([modelPath 'eboost/man_n_mv_fab'], 1, 'in', 'off');
        LIN.ioLin(4)    = linio([modelPath 'eboost/wfs_ven'], 1, 'none', 'on');
        LIN.ioLin(5)    = linio([modelPath 'eboost/wfr_ven'], 1, 'none', 'on');
        LIN.ioLin(6)    = linio([modelPath 'eboost/xn25'], 1, 'none', 'on');
        LIN.ioLin(7)    = linio([modelPath 'eboost/man_n_mm_aboc'], 1, 'none', 'on');
    else
        LIN.ioLin(1)    = linio([modelPath 'eboost_ins6/pengine'], 1, 'none', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6/vol_1_psven'], 1, 'out', 'off');
        LIN.ioLin(3)    = linio([modelPath 'eboost_ins6/man_n_mv_fab'], 1, 'in', 'off');
        LIN.ioLin(4)    = linio([modelPath 'eboost_ins6/wfs_ven'], 1, 'none', 'on');
        LIN.ioLin(5)    = linio([modelPath 'eboost_ins6/wfr_ven'], 1, 'none', 'on');
        LIN.ioLin(6)    = linio([modelPath 'eboost_ins6/xn25'], 1, 'none', 'on');
        LIN.ioLin(7)    = linio([modelPath 'eboost_ins6/man_n_mm_aboc'], 1, 'none', 'on');
    end
    LIN.sys_F414_FuelSystem_BOOSTSYS  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeBOOSTSYS); bodeplot(LIN.sys_F414_FuelSystem_BOOSTSYS, M.BOOSTSYS);
    if ~L.held, hold('on'); end
else
     M.figBodeBOOSTSYS = 999;
end

%%Boost volume subsystem
if L.swBOOSTVOLSYS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeBOOSTVOLSYS=L.nfigs; figure(M.figBodeBOOSTVOLSYS);
        M.BOOSTVOLSYS = bodeoptions('cstprefs');
        M.BOOSTVOLSYS.PhaseWrapping='off'; M.BOOSTVOLSYS.Grid='on'; M.BOOSTVOLSYS.FreqScale='log';
        M.BOOSTVOLSYS.Title.Interpreter = 'none';
        M.BOOSTVOLSYS.OutputLabels.Interpreter = 'none';
        M.BOOSTVOLSYS.InputLabels.Interpreter = 'none';
        M.BOOSTVOLSYS.Title.String = '';
        M.BOOSTVOLSYS.MagLowerLimMode = 'manual';
        M.BOOSTVOLSYS.MagLowerLim = -80;
        M.BOOSTVOLSYS.FreqUnits = 'Hz';
        M.BOOSTVOLSYS.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeBOOSTVOLSYS) = {'BOOST SUBSYSTEM'}; %#ok<*SAGROW>
    end
    clear LIN
    if L.swbase && ~swINS6
        LIN.ioLin(1)    = linio([modelPath 'eboost/man_n_vm_inlet'], 2, 'in', 'off');
        LIN.ioLin(2)    = linio([modelPath 'eboost/vol_1_psven'], 1, 'out', 'off');
        LIN.ioLin(3)    = linio([modelPath 'eboost/wfs_ven'], 1, 'none', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost/wfr_ven'], 1, 'none', 'on');
        LIN.ioLin(5)    = linio([modelPath 'eboost/ip_wpdtops_boost'], 1, 'none', 'on');
    else
        LIN.ioLin(1)    = linio([modelPath 'eboost_ins6/ip_wpstopd_boost'], 1, 'in', 'on');
        LIN.ioLin(2)    = linio([modelPath 'eboost_ins6/vol_1_psven'], 1, 'out', 'off');
        LIN.ioLin(3)    = linio([modelPath 'eboost_ins6/wfs_ven'], 1, 'none', 'on');
        LIN.ioLin(4)    = linio([modelPath 'eboost_ins6/wfr_ven'], 1, 'none', 'on');
        LIN.ioLin(5)    = linio([modelPath 'eboost_ins6/man_n_mv_fab'], 1, 'none', 'on');
    end
    LIN.sys_F414_FuelSystem_BOOSTVOLSYS  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeBOOSTVOLSYS); bodeplot(LIN.sys_F414_FuelSystem_BOOSTVOLSYS, M.BOOSTVOLSYS);
    if ~L.held, hold('on'); end
else
     M.figBodeBOOSTVOLSYS = 999;
end



clear SYS
L.wmax1 = 10000*2*pi;  % 3e3;
L.fmax1 = 10000;   %100
L.wmax2 = 10000*2*pi; % 600;
L.wmax3 = 10000*2*pi;   % 3e4
L.fmax2 = 10000;  % 6e3
L.fmax3 = 10000;  % 6e2
L.fmax4 = 120;  % 100

%%Open loop response TV loop Fig 1
if L.swOLTV
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeOLTV=L.nfigs; figure(M.figBodeOLTV);
        M.POLTV = bodeoptions('cstprefs');
        M.POLTV.PhaseWrapping='on'; M.POLTV.Grid='on'; M.POLTV.FreqScale='log';
        M.POLTV.Title.Interpreter = 'none';
        M.POLTV.OutputLabels.Interpreter = 'none';
        M.POLTV.InputLabels.Interpreter = 'none';
        M.POLTV.Title.String = '';
        M.POLTV.MagLowerLimMode = 'manual';
        M.POLTV.MagLowerLim = -100;
        M.POLTV.FreqUnits = 'Hz';
        M.POLTV.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeOLTV) = {'Open Loop Throttling Valve'}; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'F414_IFC/VALVE_A_mvtv/OpenLoopIn'], 1, 'in', 'on');
    LIN.ioLin(2)    = linio([modelPath 'F414_IFC/VALVE_A_mvtv/openLoopOut'], 1, 'out', 'on');
    LIN.sys_F414_FuelSystem_OLTV  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_OLTV = LIN.sys_F414_FuelSystem_OLTV;
    figure(M.figBodeOLTV); bodeplot(LIN.sys_F414_FuelSystem_OLTV, M.POLTV);
    [SYS.oltv.mag, SYS.oltv.phase, SYS.oltv.w] = bode(LIN.sys_F414_FuelSystem_OLTV, {1, L.wmax1});
    [SYS.oltv.gain, SYS.oltv.Pm, SYS.oltv.Wp, SYS.oltv.Wg]    = margin(SYS.oltv.mag, SYS.oltv.phase, SYS.oltv.w);
    SYS.oltv.Gm = 20*log10(SYS.oltv.gain);
    SYS.oltv.fp     = SYS.oltv.Wp/2/pi;
    SYS.oltv.fg     = SYS.oltv.Wg/2/pi;
    LRES(L.nCases).oltv = SYS.oltv;
    if ~L.held, hold('on'); end
else
     M.figBodeOLTV = 999;
end


%%Closed loop MFP Stability Fig 2 and 3
if L.swCLMFP
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeCLMFP=L.nfigs; figure(M.figBodeCLMFP);
        M.POLMFP = bodeoptions('cstprefs');
        M.POLMFP.PhaseWrapping='on'; M.POLMFP.Grid='on';
        M.POLMFP.Title.Interpreter = 'none';
        M.POLMFP.OutputLabels.Interpreter = 'none';
        M.POLMFP.InputLabels.Interpreter = 'none';
        M.POLMFP.Title.String = '';
        M.POLMFP.FreqScale='linear';
        M.POLMFP.PhaseVisible='off';
        M.POLMFP.Ylim = [-40 60];   % 20 is zeta=.05
        M.POLMFP.FreqUnits='Hz';
        M.POLMFP.Xlim = [0 L.fmax3];
        L.figTitle(M.figBodeCLMFP) = {'Pump Sensitivity'}; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'F414_SUPPLY_BUS'], 4, 'inout', 'off');
    LIN.sys_F414_FuelSystem_CLMFP  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeCLMFP); bodeplot(LIN.sys_F414_FuelSystem_CLMFP, M.POLMFP);
    [magCLMFP, ~, wCLMFP] = bode(LIN.sys_F414_FuelSystem_CLMFP);
    maxMagCLMFP     = max(magCLMFP);
    wMaxMagCLMFP    = min(wCLMFP(find(magCLMFP >= max(magCLMFP)))); %#ok<FNDSB>
    LRES(L.nCases).clmfp.magDB   = 20*log10(maxMagCLMFP);
    LRES(L.nCases).clmfp.zeta    = Mp2Zeta(maxMagCLMFP);
    LRES(L.nCases).clmfp.fn      = wMaxMagCLMFP/sqrt(1-2*LRES(L.nCases).clmfp.zeta^2)/2/pi;
    if ~L.held, hold('on'); end
else
     M.figBodeCLMFP = 999;
end

% save ModelData magCLMFP wCLMFP

if L.swCLMFPS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeCLMFPs=L.nfigs; figure(M.figBodeCLMFPs);
        M.POLMFPs = bodeoptions('cstprefs');
        M.POLMFPs.PhaseWrapping='on'; M.POLMFP.Grid='on';
        M.POLMFPs.Title.Interpreter = 'none';
        M.POLMFPs.OutputLabels.Interpreter = 'none';
        M.POLMFPs.InputLabels.Interpreter = 'none';
        M.POLMFPs.Title.String = '';
        M.POLMFPs.FreqScale='linear';
        M.POLMFPs.PhaseVisible='off';
        M.POLMFPs.Ylim = [-40 60];   % 20 is zeta=.05
        M.POLMFPs.FreqUnits='Hz';
        M.POLMFPs.Xlim = [0 L.fmax4];
        L.figTitle(M.figBodeCLMFPs) = {'Pump Sensitivity Zoom'}; %#ok<*SAGROW>
    end
    if ~L.swCLMFP
        clear LIN
        LIN.ioLin(1)    = linio([modelPath 'F414_SUPPLY_BUS'], 4, 'inout', 'off');
        LIN.sys_F414_FuelSystem_CLMFP  = linearize(modelTopPath, LIN.ioLin);
    end
    figure(M.figBodeCLMFPs); bodeplot(LIN.sys_F414_FuelSystem_CLMFP, M.POLMFPs);
    [magCLMFPs, ~, wCLMFPs] = bode(LIN.sys_F414_FuelSystem_CLMFP, {0.01, 2*pi*L.fmax1});
    maxMagCLMFPs     = max(magCLMFPs);
    wMaxMagCLMFPs    = min(wCLMFPs(find(magCLMFPs >= max(magCLMFPs)))); %#ok<FNDSB>
    LRES(L.nCases).clmfps.magDB   = 20*log10(maxMagCLMFPs);
    LRES(L.nCases).clmfps.zeta    = Mp2Zeta(maxMagCLMFPs);
    LRES(L.nCases).clmfps.fn      = wMaxMagCLMFPs/sqrt(1-2*LRES(L.nCases).clmfps.zeta^2)/2/pi;
    if ~L.held, hold('on'); end
else
     M.figBodeCLMFPs = 999;
end

%%Closed loop response full system Fig 4 and Fig 5
if L.swCL
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeCL=L.nfigs; figure(M.figBodeCL);
        M.PCL = bodeoptions('cstprefs');
        M.PCL.PhaseWrapping='off'; M.PCL.Grid='on'; M.PCL.FreqScale='log';
        M.PCL.Title.Interpreter = 'none';
        M.PCL.OutputLabels.Interpreter = 'none';
        M.PCL.InputLabels.Interpreter = 'none';
        M.PCL.Title.String = '';
        M.PCL.MagLowerLimMode = 'manual';
        M.PCL.MagLowerLim = -100;
        M.PCL.Ylim = [-180 180];
        M.PCL.FreqUnits='Hz';
        M.PCL.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeCL) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'F414_IFC/FMV/HALFVALVE_LAG_mv/Position'], 1, 'in', 'on');
    LIN.ioLin(2)    = linio([modelPath 'F414_ENGINE_SYSTEM/wf36'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem  = linearize(modelTopPath, LIN.ioLin);
    figure(M.figBodeCL); bodeplot(LIN.sys_F414_FuelSystem, M.PCL);
    if ~L.held, hold('on'); end
else
     M.figBodeCL = 999;
end

% Step Wf demand
if L.swCLSTP
    if stepWfDmd
        if ~L.held
            L.nfigs = L.nfigs+1; figure(L.nfigs); M.figStepL=L.nfigs;
            L.figTitle(M.figStepL) = L.title; %#ok<*SAGROW>
        end
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'F414_IFC/FMV/HALFVALVE_LAG_mv/Position'], 1, 'in', 'on');
    LIN.ioLin(2)    = linio([modelPath 'F414_ENGINE_SYSTEM/wf36q1000'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem = LIN.sys_F414_FuelSystem;
    if stepWfDmd
        t       = 0:0.00001:0.4;
        figure(M.figStepL); step(LIN.sys_F414_FuelSystem, t);
        if ~L.held, hold('on'); end
    end
    % Transients
    if ~L.held
        L.nfigs = L.nfigs+1; M.figStep=L.nfigs; figure(M.figStep);
        L.figTitle(M.figStep) = L.title; %#ok<*SAGROW>
    end
    t       = 0:0.000001:0.4;
    y     = step(LIN.sys_F414_FuelSystem, t);
    switch(testCase)
        case 'ven'
            yout = [yout y(:,2,2)*L.wfldvenStep];
        otherwise
            yout = [yout y(:,1,1)*L.wfStep];
    end
else
     M.figStepL = 999;
     M.figStep  = 999;
end


clear SYS

if L.swOLVEN
    %%Open loop response VEN loop Fig 6
    if ~L.held
        L.nfigs = L.nfigs+1; figure(L.nfigs); M.figBodeOLVEN=L.nfigs;
        M.POLVEN = bodeoptions('cstprefs');
        M.POLVEN.Grid='on'; M.POLVEN.FreqScale='log';
        M.POLVEN.PhaseWrapping = 'on';
        M.POLVEN.Title.Interpreter = 'none';
        M.POLVEN.OutputLabels.Interpreter = 'none';
        M.POLVEN.InputLabels.Interpreter = 'none';
        M.POLVEN.Title.String = '';
        M.POLVEN.MagLowerLimMode = 'manual';
        M.POLVEN.MagLowerLim = -100;
        M.POLVEN.FreqUnits='Hz';
        M.POLVEN.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeOLVEN) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'ven/vensubpress/pumpActVenPistonVen'], 3, 'in', 'on');
    LIN.ioLin(2)    = linio([modelPath 'ven/vensubpress/Gain'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem_OLVEN  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_OLVEN = LIN.sys_F414_FuelSystem_OLVEN;
    figure(M.figBodeOLVEN); bodeplot(LIN.sys_F414_FuelSystem_OLVEN, M.POLVEN);
    [SYS.olven.mag, SYS.olven.phase, SYS.olven.w] = bode(LIN.sys_F414_FuelSystem_OLVEN, {1, L.wmax1}, M.POLVEN);
    [SYS.olven.gain, SYS.olven.Pm, SYS.olven.Wp, SYS.olven.Wg]    = margin(SYS.olven.mag, SYS.olven.phase, SYS.olven.w);
    SYS.olven.fp    = SYS.olven.Wp/2/pi;
    SYS.olven.fg    = SYS.olven.Wg/2/pi;
    SYS.olven.Gm = 20*log10(SYS.olven.gain);
    LRES(L.nCases).olven = SYS.olven;
    if ~L.held, hold('on'); end
else
     M.figBodeOLVEN = 999;
end


if L.swVGD
    %%Disturbance response FVG/CVG Fig 7
    clear SYS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeVGD=L.nfigs; figure(M.figBodeVGD);
        M.POLVGD = bodeoptions('cstprefs');
        M.POLVGD.PhaseWrapping='on'; M.POLVGD.Grid='on'; M.POLVGD.FreqScale='log';
        M.POLVGD.Title.Interpreter = 'none';
        M.POLVGD.OutputLabels.Interpreter = 'none';
        M.POLVGD.InputLabels.Interpreter = 'none';
        M.POLVGD.Title.String = '';
        M.POLVGD.MagLowerLimMode = 'manual';
        M.POLVGD.MagLowerLim = 0;
        M.POLVGD.FreqUnits = 'Hz';
        M.POLVGD.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeVGD) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelTopPath 'afvg'], 1, 'in', 'off');
    LIN.ioLin(2)    = linio([modelTopPath 'acvg'], 1, 'in', 'off');
    LIN.ioLin(3)    = linio([modelPath 'mvsub'], 3, 'out', 'off');
    LIN.ioLin(4)    = linio([modelPath 'eboost'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem_VGD  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_VGD = LIN.sys_F414_FuelSystem_VGD;
    figure(M.figBodeVGD); bodeplot(LIN.sys_F414_FuelSystem_VGD, M.POLVGD, {0.6, L.wmax2});
    if ~L.held, hold('on'); end
else
     M.figBodeVGD = 999;
end

if L.swVG
    %%Transfer response FVG/CVG Fig 8
    clear SYS
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeVGT=L.nfigs; figure(M.figBodeVGT);
        M.POLVGT = bodeoptions('cstprefs');
        M.POLVGT.PhaseWrapping='on'; M.POLVGT.Grid='on'; M.POLVGT.FreqScale='log';
        M.POLVGT.Title.Interpreter = 'none';
        M.POLVGT.OutputLabels.Interpreter = 'none';
        M.POLVGT.InputLabels.Interpreter = 'none';
        M.POLVGT.Title.String = '';
        M.POLVGT.MagLowerLimMode = 'manual';
        M.POLVGT.MagLowerLim = 0;
        M.POLVGT.FreqUnits = 'Hz';
        M.POLVGT.Xlim = [0.6 L.fmax3];
        L.figTitle(M.figBodeVGT) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelTopPath 'afvg'], 1, 'in', 'off');
    LIN.ioLin(2)    = linio([modelTopPath 'acvg'], 1, 'in', 'off');
    LIN.ioLin(3)    = linio([modelPath 'vgActLine'], 1, 'out', 'off');
    LIN.ioLin(4)    = linio([modelPath 'vgActLine'], 2, 'out', 'off');
    LIN.sys_F414_FuelSystem_VGT  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_VGT = LIN.sys_F414_FuelSystem_VGT;
    figure(M.figBodeVGT); bodeplot(LIN.sys_F414_FuelSystem_VGT, M.POLVGT, {0.6, L.wmax2});
    if ~L.held, hold('on'); end
else
     M.figBodeVGT = 999;
end

%%Open loop response SV loop Fig 9
if L.swSV
    clear SYS
    olSave  = D.startValve.openLoop;
    D.startValve.openLoop = 1;
    if ~L.held
        L.nfigs = L.nfigs+1; M.figBodeOLSV=L.nfigs; figure(M.figBodeOLSV);
        M.POLSV = bodeoptions('cstprefs');
        M.POLSV.PhaseWrapping='on'; M.POLSV.Grid='on'; M.POLSV.FreqScale='log';
        M.POLSV.Title.Interpreter = 'none';
        M.POLSV.OutputLabels.Interpreter = 'none';
        M.POLSV.InputLabels.Interpreter = 'none';
        M.POLSV.Title.String = '';
        M.POLSV.MagLowerLimMode = 'manual';
        M.POLSV.MagLowerLim = -100;
        M.POLSV.FreqUnits = 'Hz';
        M.POLSV.Xlim = [0.6 L.fmax2];
        L.figTitle(M.figBodeOLSV) = L.title; %#ok<*SAGROW>
    end
    clear LIN
    LIN.ioLin(1)    = linio([modelPath 'ven/xsvOL'], 1, 'in', 'off');
    LIN.ioLin(2)    = linio([modelPath 'ven/GainOLSV'], 1, 'out', 'off');
    LIN.sys_F414_FuelSystem_OLSV  = linearize(modelTopPath, LIN.ioLin);
    LRES(L.nCases).LIN.sys_F414_FuelSystem_OLSV = LIN.sys_F414_FuelSystem_OLSV;
    figure(M.figBodeOLSV); bodeplot(LIN.sys_F414_FuelSystem_OLSV, M.POLSV);
    [SYS.olsv.mag, SYS.olsv.phase, SYS.olsv.w] = bode(LIN.sys_F414_FuelSystem_OLSV, {1, L.wmax3});
    [SYS.olsv.gain, SYS.olsv.Pm, SYS.olsv.Wp, SYS.olsv.Wg]    = margin(SYS.olsv.mag, SYS.olsv.phase, SYS.olsv.w);
    SYS.olsv.Gm = 20*log10(SYS.olsv.gain);
    SYS.olsv.fp     = SYS.olsv.Wp/2/pi;
    SYS.olsv.fg     = SYS.olsv.Wg/2/pi;
    LRES(L.nCases).olsv = SYS.olsv;
    if ~L.held, hold('on'); end
    D.startValve.openLoop     = olSave;
else
     M.figBodeOLSV = 999;
end

%Sleep 5
myTimer = timer('TimerFcn','fprintf(''Made plots'')','StartDelay',5);
start(myTimer)
wait(myTimer)
clear myTimer
% runLTI_Study
% exercise full F414 fuel system
% 29-Nov-2012   DA Gutz     Created
% 18-Apr-2013   DA Gutz     ICD conditons called out


%%User inputs - make sure to use correct user input file and comment out others


% Initialize
clear L GEO MOD M LRES E F FP LIN V Z D COMP
bdclose all; close all; close all hidden
if ~exist('./figures', 'dir'), mkdir('./figures'), end
L.swHcopy = 1;



[nTok, tokens, ctokens]=tokenize(gcs, '/');
MOD.linearizing = 1;
MOD.swven = 0;
if isempty(tokens) || ~strcmp(tokens{1}, 'F414_Fuel')
    load_system('F414_Fuel')
    % Prevent strange algebraic loop error
    set_param('F414_Fuel','AlgebraicLoopSolver','LineSearch')
end
stepWfDmd = 0;      % 1 to run linear lti step response.   Usually doesn't work
Z.handTuning = 0;
L.swHcopy = 1;


try
    %%Top of redo loop
    % Critical inputs: all these inputs may be typed at command line or added to UserIn_TV or a
    % file called by it.
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('testCase',     '''default''');   % Operating condition
    default('L.overplot',       '0');       % ???
    default('L.swUseFile',      '0');       % use input file for From Workspace transients running
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.swINS6',         '0');       % Used with swComparePumps investigation to look at INS6 config, otherwise f414-400
    default('L.wfStep',         '50');      % wf pph metering step size when running in time mode (ignored)
    default('L.wfldvenStep',    '0');       % ven load pph step size for swsimpleven when running in time mode (ignored)
    default('L.sw_pipe',        '0');       % 0 = engine, 1=HON pipe, 2=handvalve
    default('L.swPPUMP',        '0');       % 1 = plot compare pumps
    default('L.swINLET',        '0');       % 1 = plot compare pumps
    default('L.swBOOST',        '0');       % 1 = plot compare pumps
    default('L.swBOOSTSYS',     '0');       % 1 = plot compare pumps
    default('L.swBOOSTVOLSYS',  '0');       % 1 = plot compare pumps
    default('L.swOLVEN',        '0');       % 1 = plot open loop VEN
    default('L.swOLTV',         '1');       % 1 = plot open loop throttle valve
    default('L.swCLMFP',        '0');       % 1 = plot closed loop MFP sensitivity response
    default('L.swCLMFPS',       '1');       % 1 = plot closed loop SCALED MFP sensitivity response
    default('L.swCL',           '0');       % 1 = plot closed loop fuel response
    default('L.swCLSTP',        '0');       % 1 = plot closed loop fuel response step
    default('L.swVGD',          '0');       % 1 = plot VG disturbance
    default('L.swVG',           '0');       % 1 = plot VG transfer response
    default('L.swSV',           '0');       % 1 = plot start valve transfer response
    default('L.swComparePumps',           '0');
    
    %%Loop
    [nRedo,~] = size(caseVector);
    redo = nRedo > 0;
    if ~redo, nRedo = 1; end
    if ~L.overplot, clear L.nCases M, end
    for iRedo = 1:nRedo
        try temp = L.nCases; %#ok<NASGU>
        catch ERR
            L.held      = 0;
            L.nCases    = 0;
            M.leg       = {};
            yout        = [];
            L.nfigs     = 0;
            close all
            clear LRES legOLVEN legOLTV legCLMFP OLD
        end
        MOD.linearizing = 1;    % Initialization control in .slx file for clean init IC
        
        Z.INPUTS_TUNE_T_C_S_D_V = caseVector{iRedo};
        Z.desc = Z.INPUTS_TUNE_T_C_S_D_V{1};
        Z.strC = Z.INPUTS_TUNE_T_C_S_D_V{2};
        Z.strS = Z.INPUTS_TUNE_T_C_S_D_V{3};
        Z.strD = Z.INPUTS_TUNE_T_C_S_D_V{4};
        
        InitFcn_F414_Fuel
        
        L.nCases          = L.nCases + 1;
        M.leg(L.nCases)   = {sprintf('%ld', L.nCases)};
        
        LRES(L.nCases).GEO    = GEO; %#ok<*SAGROW>
        OLD(L.nCases).GEO     = GEO;  OLD(L.nCases).MOD     = MOD;
        OLD(L.nCases).ic      = ic;
        
        
        %%Calculate and plot responses
        MOD = OrderAllFields(MOD);
        ic  = OrderAllFields(ic);
        L   = OrderAllFields(L);
        if L.nCases==1, fprintf('%s\n', char(sprintf('F414_Fuel-%s%s, %6.0f/%6.4f/%3.3f', char(Z.strC), char(Z.strS), FP.beta, FP.sg, FP.kvis))); end
        fprintf('Case %ld of %ld:...', L.nCases, nRedo);
        plot_opLine_lti_F414_FuelSystem
        L.held = 1;
        COMP(L.nCases).StudyName  = StudyName;
        COMP(L.nCases).source     = Z.strC;
        COMP(L.nCases).MOD        = MOD;
        COMP(L.nCases).Z          = Z;
        COMP(L.nCases).FP         = FP;
        COMP(L.nCases).ic         = ic;
        COMP(L.nCases).GEO        = GEO;
        
        
        %%Save case title information
        try
            caseTitle{L.nCases}  = Z.desc;
        catch ERR
            caseTitle{L.nCases}  = sprintf('%02ld', L.nCases);
        end
        
        
        %%Plot steps
        if L.swComparePumps
            %%Add legends
            for i = 1:L.nfigs,
                figure(i)
                switch i
                    case M.figBodePUMP
                        for j = 1:L.nCases
                            M.legPUMP{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legPUMP, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeINLET
                        for j = 1:L.nCases
                            M.legINLET{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legINLET, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeBOOST
                        for j = 1:L.nCases
                            M.legBOOST{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legBOOST, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeBOOSTSYS
                        for j = 1:L.nCases
                            M.legBOOSTSYS{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legBOOSTSYS, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeBOOSTVOLSYS
                        for j = 1:L.nCases
                            M.legBOOSTVOLSYS{j} = sprintf('%s-%s:', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legBOOSTVOLSYS, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    otherwise
                        if L.nCases < 11,
                            legend(M.leg, 'interpreter', 'none', 'FontSize', 6)
                        end
                end
            end
        else
            if L.swCLSTP
                figure(M.figStep)
                switch(testCase)
                    case 'start'
                        plot(t, yout),  axis([-0.05 max(t) 0 4]), ylabel('wf36, pph'), grid
                    case {'tv', 'irp', 'slsirp'}
                        plot(t, yout),  axis([-0.05 max(t) 0 4]), ylabel('wf36, pph'), grid
                    case 'ven'
                        plot(t, yout),  axis([-0.05 max(t) -200*abs(wfldvenStep) 200*abs(wfldvenStep)]), ylabel('wflVen, pph'), grid
                    otherwise
                        plot(t, yout),  axis([-0.05 max(t) -2 6]), ylabel('wf36, pph'), grid
                end
            end
            
            %%Calculate title
            if L.nCases==1
                L.title = {sprintf('F414_Fuel-%s-%s, %6.0f/%6.4f/%3.3f', char(StudyName), char(Z.strS), FP.beta, FP.sg, FP.kvis)};
            end
            
            %%Add legends
            for i = 1:L.nfigs,
                figure(i)
                switch i
                    case M.figBodeOLTV
                        for j = 1:L.nCases
                            M.legOLTV{j} = sprintf('%s-%s: f/Gm/Pm= %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).oltv.fg, LRES(j).oltv.Gm, LRES(j).oltv.Pm);
                        end
                        legend(M.legOLTV, 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeCLMFP
                        for j = 1:L.nCases
                            M.legCLMFP{j} = sprintf('%s-%s: fn/z=%5.1f/%5.2f', M.leg{j}, caseTitle{j}, LRES(j).clmfp.fn, LRES(j).clmfp.zeta);
                        end
                        legend(M.legCLMFP, 'location', 'NorthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeCLMFPs
                        for j = 1:L.nCases
                            M.legCLMFPs{j} = sprintf('%s-%s: fn/z=%5.1f/%5.2f', M.leg{j}, caseTitle{j}, LRES(j).clmfps.fn, LRES(j).clmfps.zeta);
                        end
                        legend(M.legCLMFPs, 'location', 'NorthEast', 'interpreter', 'none', 'FontSize', 6)
                        grid on
                    case M.figBodeCL
                        for j = 1:L.nCases
                            M.legCL{j} = sprintf('%s-%s: f/Gm/Pm= %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).oltv.fg, LRES(j).oltv.Gm, LRES(j).oltv.Pm);
                        end
                        legend(M.legCL, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case  M.figStep
                        for j = 1:L.nCases
                            M.legCL{j} = sprintf('%s-%s: f/Gm/Pm= %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).oltv.fg, LRES(j).oltv.Gm, LRES(j).oltv.Pm);
                        end
                        legend(M.legCL, 'location', 'SouthEast', 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeOLVEN
                        for j = 1:L.nCases
                            M.legOLVEN{j} = sprintf('%s-%s: %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).olven.fg, LRES(j).olven.Gm, LRES(j).olven.Pm);
                        end
                        legend(M.legOLVEN, 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeVGD
                        for j = 1:L.nCases
                            M.legVGD{j} = sprintf('%s-%s', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legVGD, 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeVGT
                        for j = 1:L.nCases
                            M.legVGD{j} = sprintf('%s-%s', M.leg{j}, caseTitle{j});
                        end
                        legend(M.legVGD, 'interpreter', 'none', 'FontSize', 6)
                    case M.figBodeOLSV
                        for j = 1:L.nCases
                            M.legOLSV{j} = sprintf('%s-%s: f/Gm/Pm= %5.1f/%5.1f/%5.1f', M.leg{j}, caseTitle{j}, LRES(j).olsv.fg, LRES(j).olsv.Gm, LRES(j).olsv.Pm);
                        end
                        legend(M.legOLSV, 'interpreter', 'none', 'FontSize', 6)
                    otherwise
                        if L.nCases < 11,
                            legend(M.leg, 'interpreter', 'none', 'FontSize', 6)
                        end
                end
            end
        end
        fprintf('\n');
    end
    
    %%Titles
    for i = 1:L.nfigs,
        figure(i)
        h = axes('Position',[0 0 1 1],'Visible','off');
        set(gcf,'CurrentAxes',h)
        text(0.01, 0.980, char(L.title),       'Interpreter', 'none', 'FontSize', 12)
        text(0.05, 0.945, char(L.figTitle(i)), 'Interpreter', 'none', 'FontSize', 10)
    end
    
    
    % Save parameters to csv file
    WriteAllFieldsArray(COMP, ['.\saves\' StudyName] );
    
    
    %%Hardcopy
    L.swHcopy = 1;
    if L.swHcopy,
        for figNum = 1:L.nfigs,
            hardfigurecolor(figNum, StudyName, figNum)
            myTimer = timer('TimerFcn','fprintf(''Made hardcopy\n'')','StartDelay',4);
            start(myTimer)
            wait(myTimer)
        end
        %Sleep 1
        clear myTimer
    end
catch ERR
    MOD.linearizing = 0; %#ok<STRNU>
    clear iRedo i j n t h redo xref temp y yout err
    clear wCLMFP wMaxMagCLMFP xrefALL xrefGE xrefHON xrefSUN
    clear figNum filen filename filenameALL filenameGE filenameSUN
    clear maxMagCLMFP
    clear filenameHON hdr nRedo olSave overplot magCLMFP
    rethrow(ERR)
end

%%Cleanup
% Bring Fig 1 to fore
% Z.handTuning = 0;
MOD.linearizing = 0;
if ~L.swComparePumps, figure(M.figBodeOLTV); end
clear iRedo i j n t h redo xref temp y yout err
clear wCLMFP wMaxMagCLMFP xrefALL xrefGE xrefHON xrefSUN
clear figNum filen filename filenameALL filenameGE filenameSUN
clear maxMagCLMFP
