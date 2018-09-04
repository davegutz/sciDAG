%% StopFcn_VEN_Subsystem
% 11-Apr-2017   DA Gutz         Created


warning off MATLAB:xlswrite:AddSheet

%%Adopted features
if ~MOD.linearizing && ~MOD.swVerify && MOD.plotting
    if MOD.verbose-MOD.linearizing>0, fprintf('%s/StopFcn:  writing output files...', bdroot); timestamper;end
    default('lastFig', '0');
    default('swHcopy', '1');
    if swHcopy && ~MOD.linearizing, close all, lastFig=0; end
    try
        runV = sprintf('%s_%s_%s_%sV', Z.case, char(Z.strS), char(Z.strD), Z.strV);
        runF = sprintf('%s_%s_%s_%sF', Z.case, char(Z.strS), char(Z.strD), Z.strV);
        psfileV = sprintf('./figures/%s_%s.ps', bdroot, runV);
        psfileF = sprintf('./figures/%s_%s.ps', bdroot, runF);
        try  % logic to catch error if user 'Xs' windows
            copyfile(psfileV,'./figures/tempV.ps');
            copyfile(psfileF,'./figures/tempF.ps');
            notemp = 0;
        catch ERR
            notemp = 1;
        end
        fprintf('%s/StopFcn:  completed %s\n...', bdroot, runF); timestamper;
        if MOD.plottingV
            [VAT, DAV, lastFig] = plot_VEN_Subsystem(bdroot, runV, E, lastFig, swHcopy, MOD, Z.desc);
        end
        if MOD.plottingF
            [MAT, DAM, lastFig] = plot_FuelSystem(bdroot, runF, E, lastFig, swHcopy, Z.desc);
        end
    catch ERR
        if ~notemp, copyfile('./figures/tempV.ps', psfileV); end
        if ~notemp, copyfile('./figures/tempF.ps', psfileF); end
        if ~notemp, delete('./figures/tempV.ps'); delete('./figures/tempF.ps'); end
        fprintf('\n\n********%s:  if linearizing, set MOD.linearizing=1;\n\n', mfilename);
        rethrow(ERR)
    end
    if ~notemp, delete('./figures/tempV.ps'); delete('./figures/tempF.ps'); end
end
clear runV runF notemp psfileV psfileF
% warning on Simulink:Engine:SolverMinStepSizeWarn


warning on MATLAB:xlswrite:AddSheet
warning on Simulink:SampleTime:NoMoreSampleTimeColors
%%%End %%%


