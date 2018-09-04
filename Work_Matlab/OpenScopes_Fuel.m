%% OpenScopes_Fuel :   open relevant scopes in F414_Fuel
% DA Gutz 31-May-2017   Created


open_system('F414_VEN_Subsystem/Plots/Scope_VEN_1', 0);

% find all scope blocks as MATLAB figures:
set(0, 'showhiddenhandles', 'on')
scope = findobj(0, 'Tag', 'SIMULINK_SIMSCOPE_FIGURE');
for i=1:length(scope)
    % this is the callback of the "autoscale" button:
    simscope('ScopeBar', 'ActionIcon', 'Find', scope(i))
end
set(0, 'showhiddenhandles', 'off')

switch(MOD.type{:})
    case{'opLine07_INS6_VER_mvsv'}
        open_system('F414_WFM_Subsystem/F414_Fuel_System/MVSV_Verification/Scope_MVSV_Ver_1')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/MVSV_Verification/Scope_MVSV_Ver_2')
    case{'opLine07_INS6_VER_mv'}
        open_system('F414_WFM_Subsystem/F414_Fuel_System/MV_Verification/Scope_MV_Ver_1')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/MV_Verification/Scope_MV_Ver_2')
    case{'opLine07_INS6_VER_fmv'}
        open_system('F414_WFM_Subsystem/F414_Fuel_System/FMV_Verification/Scope_FMV_Ver_1')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/FMV_Verification/Scope_FMV_Ver_2')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/FMV_Verification/Scope_FMV_Ver_3')
    case{'opLine07_INS6_VER'}
        open_system('F414_WFM_Subsystem/F414_Fuel_System/MVSV_Verification/Scope_MVSV_Ver_1')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/MVSV_Verification/Scope_MVSV_Ver_2')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/MV_Verification/Scope_MV_Ver_1')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/MV_Verification/Scope_MV_Ver_2')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/FMV_Verification/Scope_FMV_Ver_1')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/FMV_Verification/Scope_FMV_Ver_2')
        open_system('F414_WFM_Subsystem/F414_Fuel_System/FMV_Verification/Scope_FMV_Ver_3')
end



% find all scope blocks as MATLAB figures:
set(0, 'showhiddenhandles', 'on')
scope = findobj(0, 'Tag', 'SIMULINK_SIMSCOPE_FIGURE');
for i=1:length(scope)
    % this is the callback of the "autoscale" button:
    simscope('ScopeBar', 'ActionIcon', 'Find', scope(i))
end
set(0, 'showhiddenhandles', 'off')
