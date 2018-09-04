%% PreLoadFcn_Fuel
% 24-May2017       DA Gutz     Created
% Revisions



setPath

% Executive defaults
default('verbose',          '3');
default('MOD.tFinal',       '0.8');
default('MOD.DECIMATE',     '4');
default('MOD.tInit',        '0.01');
default('MOD.verbose',      '1');
default('MOD.plotting',     '0');
default('MOD.plottingF',    '0');
default('MOD.plottingV',    '1');
default('MOD.kludgy',       '0');   % Use structured initialization
default('MOD.ctstd',        '518.67');
default('MOD.F2R',          '459.67');
default('MOD.cpstd',        '14.696');
default('MOD.tInterrupt',   '0.02');
default('MOD.tBeginInterrupt',  '1e32');
default('MOD.linearizing',  '0');
default('MOD.swVerify',     '0');   % for overplotting data
default('MOD.run',          '{''0#, 0#mod, N25=17210rpm, Wf=9060pph, 14.7psia, 0.79sg, 1.3cstokes''}');
default('MOD.batch',        '0');   % Doing batch initialization
default('MOD.tRunInit',     '1');   % set to 1 to do single point initialization solver
default('MOD.frictionless', '0');   % set to 1 to eliminate friction terms
default('MOD.disableAC',    '0');   % set to 1 to freeze pengine
default('MOD.fullUp',       '1');   % all subsystems active
default('MOD.swmain', 'MOD.fullUp');% main subsystem
default('MOD.swven',        '1');   % VEN subsystem active

% Input defaults
default('swHcopy',          '1');

ResetZ_Fuel

default('DS.V.pdven',       '[0 100; 0 0]');
default('DS.V.prod',        '[0 100; 0 0]');
default('DS.V.phead',       '[0 100; 0 0]');
default('DS.V.pb1',         '[0 100; 0 0]');
default('DS.V.x_reg',       '[0 100; 0 0]');
default('DS.V.x_ven',       '[0 100; 0 0]');
default('DS.V.xn25',        '[0 100; 0 0]');
default('DS.V.mA_ven',      '[0 100; 0 0]');
default('V.dmAwfm',         '[0 100; 0 0]');
default('DS.V.p1soADJ',     '[0 100; 0 0]');
default('DS.V.xmvADJ',      '[0 100; 0 0]');
default('DS.V.wf1cADJ',     '[0 100; 0 0]');
default('DS.V.wfrADJ',      '[0 100; 0 0]');
default('DS.V.xD_mV',       '[0 100; 0 0]');
default('DS.V.mv_x',        '[0 100; 0 0]');
default('DS.V.pmd',         '[0 100; 0 0]');
default('DS.V.pnozin',      '[0 100; 0 0]');
default('DS.V.psven',       '[0 100; 0 0]');
default('DS.V.p3',          '[0 100; 0 0]');
default('DS.V.p2',          '[0 100; 0 0]');
default('DS.V.p1',          '[0 100; 0 0]');
default('DS.V.pb2',         '[0 100; 0 0]');
default('DS.V.wfocmx1',     '[0 100; 0 0]');
default('DS.V.wftvb',       '[0 100; 0 0]');
default('DS.V.wfb2',        '[0 100; 0 0]');
default('DS.V.wfmd',        '[0 100; 0 0]');
default('DS.V.wfengine',    '[0 100; 0 0]');
default('DS.V.wfmv',        '[0 100; 0 0]');
default('DS.V.wfr',         '[0 100; 0 0]');
default('DS.V.wfs',         '[0 100; 0 0]');
default('DS.V.wf1c',        '[0 100; 0 0]');
default('DS.V.wf1p',        '[0 100; 0 0]');
default('DS.V.e_mv',        '[0 100; 0 0]');
default('DS.V.ef_mv',       '[0 100; 0 0]');
default('DS.V.mvtv_x',      '[0 100; 0 0]');
default('DS.V.x_hs',        '[0 100; 0 0]');
default('DS.V.pengine',     '[0 100; 0 0]');
default('FP.sg',            '0.79');
default('FP.beta',          '159200');
default('FP.kvis',          '1.3');
FP.dwdc     = 129.93948*FP.sg;
FP.avis     = 9.312e-5 * .00155 * FP.sg * FP.kvis;
FP.tvp_margin   = -1e6;
FP.tvp      = 5;        % Assumed

BusObjects;

% Engine
try temp = E.spcn25; %#ok<NASGU>
catch ERR,
    F414_Engine
end

% FADEC
try temp = F.Tminor; %#ok<NASGU>
catch ERR,
    F414_FADEC
end

% Fuel System
clear GEO
GEO.mv.xmin     = 0.;
try [GEO, GEOD, D]     = F414_Geometry(GEO, MOD, FP, Z, D);
catch ERR,
    [GEO, GEOD, D]     = F414_Geometry(GEO, MOD, FP, Z);
end

%%Model_Version: 1 - INS6; 0 -     
Model_Version = 0;
initializing = 0;

clear temp
% ResetZ_Fuel
% reset inputs prior to new case
% 06-Dec-2017   DA Gutz     Created


if ~MOD.batch
    try Zsav = Z;
        clear Z
        Z.INPUTS_TUNE_T_C_S_D_V = Zsav.INPUTS_TUNE_T_C_S_D_V;
    catch ERR
        clear Z
    end
    clear Zsav
end
default('Z.selectAC',       '0');       %     -400=0, Grippen=1,     -INS6=2,     -400-PFRT=-1
default('Z.awfb',           '0.00001'); % TODO add thermal bypass.   Area Wf Thermal bypass, sqin
default('Z.vdxdt',          '0.0');     % TODO add thermal bypass.  For initializing at velocity of, in/s. 
default('Z.xn25',           '17210');   % Initial N25, rpm
default('Z.pcn25r',         '0');       % Initial N25, rpm corrected.  Not used
default('Z.precx',          '14.7');    % Pressure recirculation thermal bypass return pressure at discharge of flowbody, psia 
default('Z.wf36',           '9060');    % Engine burn flow, pph
default('Z.fxven',          '00000');   % VEN Load, lbf total all three
default('Z.xven',           '4.5');     % VEN position, 0 is full extend, in
default('Z.pamb',           '14.7');    % Ambient pressure, psia
default('Z.pr',             '-9');      % VEN filter supply, psia
default('Z.ps',             '-9');      % VEN filter discharge, psia
default('Z.case',       '''00000_00000_17210_09060_00147_79_13''');  % File name
default('Z.strS',       '''sNone''');   % Empty Steady case 
default('Z.strD',       '''dNone''');   % 5% doublet dynamic inputs
default('Z.strV',       '''vD5''');     % 5% doublet vector inputs
default('Z.handTuning',    '0');        % set to 1 to experiment with GEO values on successive runs.   Leave 0 to have model geometry defined fresh and clean each run
default('Z.openLoopWFM',   '0');        % Set to 1 to open POS loop
default('Z.openLoopA8',    '0');        % Set to 1 to open POS loop
default('Z.INPUTS_TUNE_T_C_S_D_V', '{''title'', ''cNone'', ''sNone'', ''dNone'', ''vD5''}'); 
default('Z.dFXVENX',        '0');       % Transient input FADEC load model error
default('Z.VEN_NoisePower', '0');       % Ven load noise
default('Z.data.enable',    '1');       % Drive model with data in file
default('Z.data.file',  '''takeoffCondition01''');    % Data file
default('Z.data.RET',       '0');       % using Rapid Engine test data format
default('Z.data.SOURCE',    '1');       % using source data format
default('Z.data.rigVal2000','0');       % verify against y2K rig data
default('Z.data.use.fxven', '0');       % enable this signal
default('Z.data.use.xn25',  '0');       % enable this signal
default('Z.data.use.wf36',  '0');       % enable this signal
default('Z.data.use.mAven', '0');       % enable this signal
default('Z.data.use.a8',    '0');       % enable this signal
default('Z.data.use.a8ref', '0');       % enable this signal
default('Z.data.use.pr',    '0');       % enable this signal
default('Z.data.use.ps',    '0');       % enable this signal
default('Z.data.use.mAwfm', '1');       % enable this signal
default('Z.data.use.wfs',   '0');       % enable this signal
default('Z.data.use.wfr',   '0');       % enable this signal
default('Z.freezeNg',       '0');       % freeze speed at ic conditon
default('Z.dmA_A8',  '[ 0 1000; 0 0]'';'); % Deviation of A8 mA from initial, mA
default('Z.dPOS_A8', '[ 0 1000; 0 0]'';'); % Deviaiton of A8 closed loop ref, %
default('Z.dmA_WFM', '[ 0 1000; 0 0]'';'); % Deviation of Wf mA from initial, mA
default('Z.dPOS_WFM','[ 0 1000; 0 0]'';'); % Deviation of Wf closed loop ref, %
default('Z.dA8leak', '[ 0 1000; 0 0]'';'); % Deviaiton of A8 rod leak area, sqin
default('Z.dxmv',    '[ 0 1000; 0 0]'';'); % Deviation of metereing valve pos, in
default('Z.sAC',            '1');       % scalar on a/c pump speed, to match rig data
default('Z.swFrzP1',        '0');       % Freeze P1 to ic inside IFC.   Useful for debugging
default('Z.swUseSOURCExmv', '0');       % Drive mv pos with SOURCE
default('Z.tPumpFail',      'inf');     % Time at pump fail instant, sec
default('AC_    ',          'Simulink.Variant(''AC_MODE==0'');');
default('AC_GRIPEN',        'Simulink.Variant(''AC_MODE==1'');');
default('AC_MODE',          '0');
default('Z.A8_POS_REF_NoisePower',  '0');   % Noise pos ref from CPR gov
