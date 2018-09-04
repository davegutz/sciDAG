%% F414_Fuel_Renom
% Renominalize inputs and variables
% 13-Sep-2017   DA Gutz     Created


% Reset
if ~Z.handTuning
    Z.handTuning        = 0;
    Z.dFXVENX           = 0;
    Z.data.enable       = 0;
    GEO.mv.xmin         = 0.;
    Z.data.RET          = 0;
    Z.data.SOURCE       = 0;
    Z.data.file         = '';
    Z.data.rigVal2000   = 0;
    Z.data.tShort       = 0;
    Z.data.use.a8       = 0;
    Z.data.use.a8ref    = 0;
    Z.data.use.fxven    = 0;
    Z.data.use.mAven    = 0;
    Z.data.use.mAwfm    = 0;
    Z.data.use.pr       = 0;
    Z.data.use.ps       = 0;
    Z.data.use.wf36     = 0;
    Z.data.use.wfr      = 0;
    Z.data.use.wfs      = 0;
    Z.data.use.xn25     = 0;
    Z.A8_POS_REF_NoisePower = 0;
    Z.A8_POS_NoisePower     = 0;
    F414_Fuel_GEO_Renom
end
MOD.swmain          = 0;
MOD.swven           = 1;
MOD.VTIME           = 1e-4;
MOD.tBeginInterrupt = 1e32;
MOD.frictionless    = 0;
Z.data.tShort       = 0;
Z.VEN_NoisePower    = 0;
Z.openLoopA8        = 0;
Z.openLoopWFM       = 0;
Z.dPOS_A8           = [  0  100; 0   0]';
Z.dA8leak           = [  0  100; 0   0]';
Z.swFrzP1           = 0;
Z.swUseSOURCExmv    = 0;
default('Z.precx', 'Z.pamb+3');
default('Z.xven', '4.5');
