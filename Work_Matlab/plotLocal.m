function [lastFig, axTIME] = plotLocal(P, D, PSV, ZRET, lastFig, tShort, titleStr, lastFigIn, desc)
nax = 0;
% Figure 1
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,1);
plot(P.time, [P.pd]);hold on; grid on
plot(P.time, [P.prod P.ps P.pr]);
if ZRET
    plot(PSV.time, PSV.pd, 'b--', PSV.time, PSV.prod, 'r--', PSV.time, PSV.ps, 'y--');
    xlabel('Time, s');ylabel('see legend');legend({'pd, psia', 'prod, psia', 'ps, psia', 'pr, psia', 'PFEHSV', 'PFVARD', 'PFRTN'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
else
    xlabel('Time, s');ylabel('see legend');legend({'pd, psia', 'prod, psia', 'ps, psia', 'pr, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
end
title(titleStr, 'Interpreter', 'none')
text(0, 4200, desc,'fontsize',6, 'interpreter', 'none');
text(0, 3700, sprintf('BETA=%06ld psi', round(P.BETA)));
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,2); %#ok<*AGROW>
plot(P.time, [P.px]);
grid;xlabel('Time, s');ylabel('see legend');legend({'Px, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)  = subplot(3,1,3);
plot(P.time, [P.phead P.prod]);hold on; grid on
if ZRET
    plot(PSV.time, PSV.phead, 'b--', PSV.time, PSV.prod, 'r--');
    xlabel('Time, s');ylabel('see legend');legend({'phead, psia', 'prod, psia', 'PFVAA8P', 'PFVARD'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
else
    xlabel('Time, s');ylabel('see legend');legend({'phead, psia', 'prod, psia'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
end
if tShort, xlim([0 tShort]); end

% Figure 2
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,1);
plot(P.time, [P.pa_x P.reg_x P.bias_x]);
ylim([-0.05 0.30]);
grid;xlabel('Time, s');ylabel('see legend');legend({'pa_x, in', 'reg_x, in', 'bias_x, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 0.307, desc,'fontsize',6, 'interpreter', 'none');
text(0, 0.25, sprintf('BETA=%06ld psi', round(P.BETA)));
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,2);
plot(P.time, [P.ehsv_x]);
grid;xlabel('Time, s');ylabel('see legend');legend({'ehsv_x, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(3,1,3);
plot(P.time, [P.X]);
grid;xlabel('Time, s');ylabel('see legend');legend({'X, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end


% Figure 3
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,1);
plot(P.time, [P.pump_wf P.wfload P.rline_wf P.hline_wf P.uf_net]);
grid;xlabel('Time, s');ylabel('see legend');legend({'pump_wf, pph', 'wfload, pph', 'rline_wf, pph', 'hline_wf', 'uf_net, lbf'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 10100, desc,'fontsize',6, 'interpreter', 'none');
text(0, -5050, sprintf('BETA=%06ld psi', round(P.BETA)));
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,2);
plot(D.ehsv.In.mA.Time, P.mA); hold on
plot(P.time, P.dxdt);
grid;xlabel('Time, s');ylabel('see legend');legend({'mA', 'v ven, in/sec'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end


% Figure 4
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,1);
plot(P.time, [P.xn25 P.fxven]);hold on; grid on;
if ZRET
    plot(PSV.time, PSV.xn25, 'b--', PSV.time, PSV.load, 'y--');
    xlabel('Time, s');ylabel('see legend');legend({'xn25, rpm', 'fxven, lbf', 'N25, rpm', 'TRSMO'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
else
    xlabel('Time, s');ylabel('see legend');legend({'xn25, rpm', 'fxven, lbf'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
end
title(titleStr, 'Interpreter', 'none')
text(0, 31000, desc,'fontsize',6, 'interpreter', 'none');
text(0, 2000, sprintf('BETA=%06ld psi', round(P.BETA)));
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,1,2);
plot(P.time, [P.wfs P.wfr P.wfstart]);
grid;xlabel('Time, s');ylabel('see legend');legend({'wfs, pph', 'wfr, pph', 'wfstart, pph'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end

% Figure 5
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,1);
plot(P.time, [P.x_4 P.x_8 P.x_12 P.X]);hold on; grid on
if ZRET
    plot(PSV.time, PSV.x, 'm--');
    xlabel('Time, s');ylabel('see legend');legend({'x_4, in', 'x_8, in', 'x_12, in', 'X, in', 'xact, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
else
    xlabel('Time, s');ylabel('see legend');legend({'x_4, in', 'x_8, in', 'x_12, in', 'X, in'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
end
title(titleStr, 'Interpreter', 'none')
text(0, 4.405, desc,'fontsize',6, 'interpreter', 'none');
text(0, 4.35, sprintf('BETA=%06ld psi', round(P.BETA)));
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,2);
plot(P.time, [P.fxin_4 P.fxin_8 P.fxin_12 P.fx_totaldelivered]);
grid;xlabel('Time, s');ylabel('see legend');legend({'fxin_4, lbf', 'fxin_8, lbf', 'fxin_12, lbf', 'fx_totDel, lbf'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,4);
plot(P.time, [P.uf_mod_4 P.uf_mod_8 P.uf_mod_12]);
grid;xlabel('Time, s');ylabel('see legend');legend({'uf_mod_4, lbf', 'uf_mod_8, lbf', 'uf_mod_12, lbf'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,3);
plot(P.time, [P.FG_4 P.FG_8 P.FG_12 P.FWSUM_4 P.FWSUM_8 P.FWSUM_12]);
grid;xlabel('Time, s');ylabel('see legend');legend({'FG_4, lbf', 'FG_8, lbf', 'FG_12, lbf', 'FWSUM_4, lbf', 'FWSUM_8, lbf', 'FWSUM_12, lbf'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end

% Figure 6
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,1);
plot(P.timef, [P.A8_POS_REF P.A8_POS ]);grid on; hold on;
if ZRET
    plot(PSV.time, PSV.a8ref, 'b--', PSV.time, PSV.a8pos, 'r--');
    xlabel('Time, s');ylabel('see legend');legend({'A8_POS_REF, %', 'A8_POS, %', 'A8REF', 'A8ACV'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
else
    xlabel('Time, s');ylabel('see legend');legend({'A8_POS_REF, %', 'A8_POS, %'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
end
title(titleStr, 'Interpreter', 'none', 'interpreter', 'none')
text(0, 15.45, desc,'fontsize',6, 'interpreter', 'none');
text(0,14, sprintf('BETA=%06ld psi', round(P.BETA)));
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,2);
plot(P.timef, [P.VEN_LOAD_X]);
hold on
plot(P.time, [P.fxven]);hold on; grid on
if ZRET
    plot(PSV.time, PSV.load, 'r--');
    xlabel('Time, s');ylabel('see legend');legend({'VEN_LOAD_X, lbf', 'fxven, lbf', 'TRSMO'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
else
    xlabel('Time, s');ylabel('see legend');legend({'VEN_LOAD_X, lbf', 'fxven, lbf'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
end
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,3);
plot(P.timef, [P.A8_POS_REF_DT  P.A8_TM P.A8_LOCK]);
grid;xlabel('Time, s');ylabel('see legend');legend({'A8_POS_REF_DT, %/s', 'A8_TM', 'A8_LOCK'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,4);
plot(P.timef, [P.A8_ERR P.A8_TM_DEM P.A8_NULL P.A8_GAIN]);hold on; grid on
if ZRET
    plot(PSV.time, PSV.a8mad, 'r--');
    xlabel('Time, s');ylabel('see legend');legend({'A8_ERR, %s', 'A8_TM_DEM, mA', 'A8_NULL, mA', 'A8_GAIN, mA/%', 'A8MAD, mA'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
else
    xlabel('Time, s');ylabel('see legend');legend({'A8_ERR, %s', 'A8_TM_DEM, mA', 'A8_NULL, mA', 'A8_GAIN, mA/%'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
end

if tShort, xlim([0 tShort]); end

% Figure 7
lastFig     = lastFig+1;
figure(lastFig);clf;
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,1);
plot(P.timef, [P.A8_TM_DEM_LK P.A8_TM_DEM P.A8_A_POS_RATE P.A8_RATE_THRSH P.nA8_RATE_THRSH P.A8_LK_DETECT]);
grid;xlabel('Time, s');ylabel('see legend');legend({'A8_TM_DEM_LK', 'A8_TM_DEM, mA', 'A8_A_POS_RATE, %/s', 'A8_RATE_THRSH, %/s', '-A8_RATE_THRSH, %/s', 'A8_LK_DETECT'}, 'interpreter', 'none', 'Location', 'NorthEast', 'FontSize', 6)
title(titleStr, 'Interpreter', 'none')
text(0, 104, desc,'fontsize',6, 'interpreter', 'none');
text(0, 90, sprintf('BETA=%06ld psi', round(P.BETA)));
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,2);
plot(P.timef, [P.ERROR P.ERR_THRES P.nERR_THRES]);
hold on
plot(P.timef020, P.A8P_BIAS);
grid;xlabel('Time, s');ylabel('see legend');legend({'ERROR, %', 'ERR_THRES, %', '-ERR_THRES, %', 'A8P_BIAS, %'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,4);
plot(P.timef, [P.A8_POS_DT P.RATE_THRES P.nRATE_THRES]);
grid;xlabel('Time, s');ylabel('see legend');legend({'A8_POS_DT, %/s', 'RATE_THRES, %', '-RATE_THRES, %'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end
nax         = nax + 1;
axTIME(lastFigIn, nax)    = subplot(2,2,3);
plot(P.timef, [P.A8_HYDRO_TRIP P.A8_HYDRO_FAIL P.A8_LK_DETECT]);
grid;xlabel('Time, s');ylabel('see legend');legend({'A8_HYDRO_TRIP', 'A8_HYDRO_FAIL', 'A8_LK_DETECT'}, 'interpreter', 'none', 'Location', 'SouthEast', 'FontSize', 6)
if tShort, xlim([0 tShort]); end


return
% plotInitVEN_Subsystem
% Plot results of iterations
% 09-Nov-2012       DA Gutz     Created

global SYS
global MOD

return

% Open Loop Bode
% keyboard
if ~exist('held', 'var')
    titleStr = sprintf('InitVEN_Subsystem level=%ld', MOD.level);
    nfigs = nfigs+1; figure(nfigs); figOL=nfigs;
    POL = bodeoptions('cstprefs');
    POL.PhaseWrapping = 'on';
    POL.XLim=[0 1000];
%     POL.YLim=[-210 -45];
%     POL.YLimMode = {'auto', 'manual'};
    title.str = sprintf('Open Loop Bode');
    figTitle(figOL) = title;
end
figure(figOL), bode(SYS.sysOL, SYS.W, POL);grid
if ~exist('held', 'var'), hold('on'); grid('on'); end
% keyboard

% Open Loop Nichols
if ~exist('held', 'var')
    nfigs = nfigs+1;
    figure(nfigs);
    figOLN=nfigs;
    POLN = nicholsoptions('cstprefs');
    POLN.PhaseWrapping = 'off';
    POLN.PhaseMatching = 'on';
    POLN.PhaseMatchingFreq = '0';
    POLN.PhaseMatchingValue = '0';
    POLN.XLim=[0 360];
    POL.XLimMode = {'manual'};
    title.str = sprintf('Open Loop Nichols');
    figTitle(figOLN) = title;
end
figure(figOLN), nichols(SYS.sysOL, SYS.W, POLN);
if ~exist('held', 'var'), hold('on'); end

% Closed loop Bode
if ~exist('held', 'var')
    nfigs = nfigs+1; figure(nfigs); figCLSA=nfigs;
%     PCLD = BODEOPTIONS('cstprefs');
    PCLD = bodeoptions('cstprefs');
    PCLD.PhaseWrapping = 'on';
    PCLD.PhaseMatchingValue = 0;
    title.str = sprintf('Closed Loop SA Governor');
    figTitle(figCLSA) = title;
end
figure(figCLSA), bode(SYS.sysCL, SYS.WCLSA, PCLD);
if ~exist('held', 'var'), hold('on'); grid('on'); end
% Closed loop Bode with outer comp
if ~exist('held', 'var')
    nfigs = nfigs+1; figure(nfigs); figCLSAO=nfigs;
    title.str = sprintf('Closed Loop SA Governor');
    figTitle(figCLSAO) = title;
end
figure(figCLSAO), bode(SYS.sysCLO, SYS.WCLSA, PCLD);
if ~exist('held', 'var'), hold('on'); grid('on'); end



if ~exist('held', 'var')
    nfigs = nfigs+1; figure(nfigs); figCLSTEP=nfigs;
    title.str = sprintf('Closed Loop Step SA Response');
    figTitle(figCLSTEP) = title;
end
if ~exist('held', 'var'), hold('on'); grid('on'); end
figure(figCLSTEP), step(SYS.sysCL);


if(0)
    if ~exist('held', 'var') %#ok<UNRCH>
        nfigs = nfigs+1; figure(nfigs); figCLRAMP=nfigs;
        title.str = sprintf('Closed Loop Ramp Generic Servo Actuator Response');
        figTitle(figCLRAMP) = title;
    end
    rampSav = MOD.RATE; tFinalSav = MOD.tFinal;
    MOD.RATE = 75; 
    MOD.tFinal = SYS.TCLSA(end)*3;
    figure(figCLRAMP),
    sim('InitVEN_Subsystem', MOD.tFinal);
    if MOD.lti
        plot(tout, yout(:,4))
    else
        plot(tout, yout(:,2))
    end
    MOD.RATE = rampSav; MOD.tFinal = tFinalSav;
    if ~exist('held', 'var'), hold all; end
    if caseNo == nCases, plot(tout, yout(:,1), ':k'); grid, end
end

%Describing function
if ~exist('held', 'var')
    titleStr = sprintf('Servo Actuator Tool');
    nfigs = nfigs+1; figure(nfigs); figDESC1=nfigs;
    nfigs = nfigs+1; figure(nfigs); figDESC2=nfigs;
    PC = bodeoptions('cstprefs');
    PC.PhaseWrapping = 'on';
    title.str = sprintf(' Compensator');
    figTitle(figDESC1) = title;
    figTitle(figDESC2) = title;
end
figure(figDESC1), nyquist(SYS.sysOL, {0.1, 200});
if ~exist('held', 'var'), hold('on');grid('off'); end
axis([-5 2 -5 1])
figure(figDESC2), nyquist(SYS.sysOL, {0.01, 200});
if ~exist('held', 'var'), hold('on');grid('off'); end
axis([-10 2 -80 20])
if caseNo == nCases
    figure(figDESC1)
    [re, im, ~, ~] = backlashDF([0:0.1:1.9 1.90:0.01:1.99]);
    plot(re, im, 'r-')
    [re, im, ~, ~] = backlashDF([1.0 1.4 1.6 ]);
    plot(re, im, 'r.')
    figure(figDESC2)
    [re, im, ~, ~] = backlashDF([0:0.1:1.9 1.90:0.01:1.99]);
    plot(re, im, 'r-')
    [re, im, ~, ~] = backlashDF(1.9:0.01:1.99);
    plot(re, im, 'r.')
end


nL = length(legendV);
legendV{nL+1} = sprintf('%2i %s:%6.1fdB/%7.1f*/%5.1f/%4.1frps/%6.3fs', caseNo, desc, SYS.Gm, SYS.Pm, F.SWG*MOD.HWG, w45_rps, t5settle_sec);
