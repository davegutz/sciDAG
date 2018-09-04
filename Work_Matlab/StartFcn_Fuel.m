%% StartFcn_Fuel
% 24-May-2017       DA Gutz     Created
% Revisions
warning off 'Simulink:Commands:OpenSystemBlockNotFound'
warning off 'Simulink:blocks:LegendInfoNA'

if MOD.linearizing
    return;
end

% VEN
if MOD.swven
    open_system('F414_Fuel/Plots/Plots_VEN/Scope_VEN_1');
%     open_system('F414_Fuel/Plots/Plots_VEN/Scope_VEN_Sys');
    open_system('F414_Fuel/Plots/Plots_VEN/Scope_A8_POS');
%     open_system('F414_Fuel/Plots/Plots_VEN/Scope_A8_POS_1');
    open_system('F414_Fuel/Plots/Plots_VEN/Scope_A8_FAIL');
else
    close_system('F414_Fuel/Plots/Plots_VEN/Scope_VEN_1', 0);
    close_system('F414_Fuel/Plots/Plots_VEN/Scope_VEN_Sys', 0);
    close_system('F414_Fuel/Plots/Plots_VEN/Scope_A8_POS', 0);
    close_system('F414_Fuel/Plots/Plots_VEN/Scope_A8_POS_1', 0);
    close_system('F414_Fuel/Plots/Plots_VEN/Scope_A8_FAIL', 0);
end

if MOD.swven && Z.data.enable && Z.data.rigVal2000
    open_system('F414_Fuel/Plots/Plots_VEN/RIGVAL2000/Scope_VEN_RIG2000_1');
else
    close_system('F414_Fuel/Plots/Plots_VEN/RIGVAL2000/Scope_VEN_RIG2000_1', 0);
end

if MOD.swven && Z.data.RET && Z.data.enable
    open_system('F414_Fuel/Plots/Plots_VEN/RET/Scope_VEN_RET_1');
else
    close_system('F414_Fuel/Plots/Plots_VEN/RET/Scope_VEN_RET_1', 0);
end

if MOD.swven && Z.data.SOURCE && Z.data.enable
    open_system('F414_Fuel/Plots/Plots_VEN/SOURCE/Scope_VEN_SOURCE_1');
else
    close_system('F414_Fuel/Plots/Plots_VEN/SOURCE/Scope_VEN_SOURCE_1', 0);
end

if MOD.swven && MOD.frictionless
    open_system('F414_Fuel/Plots/Plots_VEN/Scope_VEN_Init');
    open_system('F414_Fuel/Plots/Plots_VEN/Scope_VEN_Init1');
else
    close_system('F414_Fuel/Plots/Plots_VEN/Scope_VEN_Init', 0);
    close_system('F414_Fuel/Plots/Plots_VEN/Scope_VEN_Init1', 0);
end


% MAIN
if MOD.swmain
    open_system('F414_Fuel/Plots/Plots_MAIN/Scope_MAIN_1');
%     open_system('F414_Fuel/Plots/Plots_MAIN/Scope_MAIN_2');
%     open_system('F414_Fuel/Plots/Plots_MAIN/Scope_MAIN_3');
%     open_system('F414_Fuel/Plots/Plots_MAIN/Scope_MAIN_4');
    open_system('F414_Fuel/Plots/Plots_MAIN/Scope_WFM_POS');
else
    close_system('F414_Fuel/Plots/Plots_MAIN/Scope_MAIN_1', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/Scope_MAIN_2', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/Scope_MAIN_3', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/Scope_MAIN_4', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/Scope_WFM_POS', 0);
end

if MOD.swmain && Z.data.SOURCE && Z.data.enable
    open_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_1');
    open_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_2');
    open_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_3');
    open_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_4');
    open_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_5');
    open_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_6');
    open_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_WFM_POS');
else
    close_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_1', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_2', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_3', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_4', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_5', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_6', 0);
    close_system('F414_Fuel/Plots/Plots_MAIN/SOURCE/Scope_MAIN_SOURCE_WFM_POS', 0);
end


warning on 'Simulink:blocks:LegendInfoNA'
