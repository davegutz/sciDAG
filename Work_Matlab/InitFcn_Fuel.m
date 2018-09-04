%% InitFcn_Fuel
% 24-May-2017       DA Gutz     Created
% Revisions



% Always need to be in model root for time stamp functions to work
cd(MOD.modelRoot.Path)

% Reset model inputs
ResetZ_Fuel

if length(Z.INPUTS_TUNE_T_C_S_D_V)~=5
    error('Z.INPUTS_TUNE_T_C_S_D_V must be 1x5 with DESC CONDITION, STEADY, DYNAMIC, and VECTORS file names');
else
    Z.desc  = Z.INPUTS_TUNE_T_C_S_D_V{1};
    Z.strC  = Z.INPUTS_TUNE_T_C_S_D_V{2};
    Z.strS  = Z.INPUTS_TUNE_T_C_S_D_V{3};
    Z.strD  = Z.INPUTS_TUNE_T_C_S_D_V{4};
    Z.strV  = Z.INPUTS_TUNE_T_C_S_D_V{5};
end

InitFcn_VEN_Subsystem
ic.ifc.mA_WFM   = F.WFM_TM_NULL;
ic.ifc          = OrderAllFields(ic.ifc);
MOD.swmain      = MOD.fullUp;
MOD             = OrderAllFields(MOD);

% Data connections
V.usemAwfm  = Z.data.use.mAwfm*Z.data.enable;
V.useWfs    = Z.data.use.wfs*Z.data.enable;
V.useWfr    = Z.data.use.wfr*Z.data.enable;
if Z.data.enable && Z.data.SOURCE
    DS.V.p1soADJ        = DS.V.p1so;
    DS.V.p1soADJ(:,2)   = DS.V.p1soADJ(:,2) + ic.ifc.p1c  - DS.V.p1so(1,2); 
    DS.V.xmvADJ         = DS.V.mv_x;
    DS.V.xmvADJ(:,2)    = DS.V.xmvADJ(:,2)  + ic.ifc.mv.x - DS.V.mv_x(1,2);
    DS.V.wf1cADJ        = DS.V.wf1c;
    DS.V.wf1cADJ(:,2)   = DS.V.wf1cADJ(:,2) + ic.ifc.wf1c - DS.V.wf1c(1,2); 
    DS.V.wfrADJ         = DS.V.wfr;
    DS.V.wfrADJ(:,2)    = DS.V.wfrADJ(:,2)  + ic.ifc.wfr  - DS.V.wfr(1,2); 
else
    DS.V.p1soADJ = [0 100; 0 0];
    DS.V.xmvADJ  = [0 100; 0 0];
    DS.V.wf1cADJ = [0 100; 0 0];
    DS.V.wfrADJ  = [0 100; 0 0];
end

