%% InitFcn_VEN_Subsystem
% 24-Feb-2017       DA Gutz     Created
% Revisions

%
if MOD.verbose-MOD.linearizing>0, fprintf('%s/InitFcn:  beginning init...', bdroot); timestamper;end

% Load list of variables that need to be checked as only in STEADY
F414_Fuel_SteadyParameters

% Re-nominalize
F414_Fuel_Renom

% parameters dependent on config
if Z.selectAC < 0
    GEO.ifc.mvtv    = GEOD.ifc.mvtvpfrt;
else
    GEO.ifc.mvtv    = GEOD.ifc.mvtvprod;
end
switch(Z.selectAC)
    case {1, 2}  % Gripen:INS6 Single Engine (SE)
        sBoostSE
    otherwise  %     -400
        sBoost
end
switch(Z.selectAC)
    case {1}  % Gripen
        dLineDampG100
    otherwise  %     -400:INS6
        dLineDamp100
end

%%Initialization
% if ~MOD.batch && ~Z.handTuning, 
if ~MOD.batch

    % Load STEADY tune
    F414_Fuel_STEADY
    % parameters dependent on config 
    if Z.selectAC < 0
        GEO.ifc.mvtv    = GEOD.ifc.mvtvpfrt;
    else
        GEO.ifc.mvtv    = GEOD.ifc.mvtvprod;
    end
    switch(Z.selectAC)
        case {1, 2}  % Gripen:INS6 Single Engine (SE)
            sBoostSE
        otherwise  %     -400
            sBoost
    end
    switch(Z.selectAC)
        case {1}  % Gripen
            dLineDampG100
            AC_MODE = 1;
        otherwise  %     -400:INS6
            dLineDamp100
            AC_MODE = 0;
    end
    
    % Load data
    loadData_VEN_Subsystem
    if MOD.verbose-MOD.linearizing > 0, fprintf('Loaded reference data\n'); end
    

    % Reinit FADEC
    F414_FADEC
    
    % Load initialization or create if needed
    try

        % Force reinit if stuff changed
        if ~Z.handTuning
            fnThisFile = sprintf('CALLBACKS/%s.m', mfilename); %#ok<NASGU>
            F414_Fuel_Check_Stamps
            if ~MOD.linearizing, fprintf('Loading/creating %s...', fnMat); end
            if (dfnGEO_File>dfnMat || dfnTune_File>dfnMat || dfnThisFile>dfnMat) && ~exist('testMe', 'var')
                
                % Renom GEO
                if ~MOD.linearizing, F414_Fuel_GEO_Renom, end
                
                % Tune GEO
                if ~isempty(Z.strS)
                    try
                        eval(sprintf('%s', char(Z.strS)));
                    catch ERR
                       error('%s bad', char(Z.strS)); 
                    end
                    fprintf('loaded tune file %s...', char(Z.strS));
                end
                
                % Throw error to force regeneration of .mat
                error('regenerate...');
            end
            
            % Load if ok
            evalin('base', sprintf('load %s;', fnMat));
        end
        
        % Set case
        F414_Fuel_Set_Case
        caseSav = Z.case; restoreCase = 1;

    catch ERR
        if ~MOD.linearizing
            str = sprintf('%s does not exist or needs regeneration.   Do you wish to create it? [y/n]', fnMat);
            rep = inputdlg(str, 'CREATE NEW INIT CASE?');
            clear str
        end
        if MOD.linearizing || rep{:}=='y'
            % Run new case
            runInitVEN_SubsystemStandalone  % Run the iteration case
            F414_Fuel_Set_Case
            restoreCase = 0;
        else
            error('No initialization file');
        end
    end
    clear fnGEO_File dfnGEO_File fnMat dfnMat

    % Dynamic tuning
    F414_Fuel_DYNAMIC

    % Transient parameter entry
    F414_Fuel_VECTORS


    % Assign input signals
    F414_VEN_SubsystemSignalManagement
    
    if restoreCase, Z.case = caseSav; end
    clear caseSav restoreCase
    if ~Z.handTuning && MOD.verbose-MOD.linearizing > 3
        if MOD.fullUp
            fprintf('\nDone.\n%s:   Got init_%s_%s.mat\n', mfilename, Z.case, char(Z.strS));
        else
            fprintf('\nDone.\n%s:   Got initVEN_Subsystem_%s_%s.mat\n', mfilename, Z.case, char(Z.strS));
        end
    end
end
clear caseSav


FP.dwdc     = 129.93948*FP.sg;
FP.avis     = 9.312e-5 * .00155 * FP.sg * FP.kvis;
FP.tvp_margin   = -1e6;
FP.tvp      = 5;        % Assumed
try
    ic.xn25     = ic.venstart.N*E.N25100Pct/E.xnvent;
catch
    ic.xn25     = Z.xn25;
end
GEO.venstart.reg.c  = GEO.venstart.reg.cbase * FP.kvis / 0.46; % /* Dampings defined at .46 centistokes,
% JP5 at 250F per C. Hopkins 8/10/92. */
GEO.venstart.bi.c   = GEO.venstart.bi.cbase * FP.kvis / 0.46;

% Transient parameter entry  run again  TODO - figure out why and fix this
F414_Fuel_VECTORS

% Miscellaneous Initialization
ic.venstart.rrv.x   = GEO.venstart.rrv.xmin;
ic.venstart.load.act_c.x = Z.xven;

% Offset for null current error
ic.F.VEN_LOAD_X = Z.fxven + Z.dFXVENX;
ic.F.VEN_LOAD_Xl = max(min(ic.F.VEN_LOAD_X, max(F.A8_GAIN_SCH_Y)), min(F.A8_GAIN_SCH_Y));
ic.F.VEN_LOAD_Xln= max(min(ic.F.VEN_LOAD_X, max(F.A8_NULL_SHIFT(:,1))), min(F.A8_NULL_SHIFT(:,1)));
ic.F.A8_GAIN    = interp2(F.A8_GAIN_SCH_X, F.A8_GAIN_SCH_Y, F.A8_GAIN_SCH_Z', 0, ic.F.VEN_LOAD_Xl);
ic.F.A8_NULL    = interp1(F.A8_NULL_SHIFT(:,1), F.A8_NULL_SHIFT(:,2), ic.F.VEN_LOAD_Xln); 
ic.F.A8_ERR     = (ic.F.A8_NULL+F.A8_NULL_ADJ-ic.venstart.mA)/F.A8_GAIN_ADJ/ic.F.A8_GAIN;
ic.F.A8_REF     = (4.7-Z.xven)/4.7*100 - ic.F.A8_ERR;
if ~MOD.batch, ic.F.WFM_MV_REF = ic.ifc.mv.x /0.5*100; end
if MOD.batch ic.venstart.fxven = Z.fxven; end
% Distribute actuators
ic.venstart.load.act_s12    = ic.venstart.load.act_c;
ic.venstart.load.act_s12.x  = ic.venstart.load.act_s12.x + ic.venstart.fxven/GEO.venstart.load.Km;
ic.venstart.load.act_s4     = ic.venstart.load.act_s12;
ic.venstart.load.act_s8     = ic.venstart.load.act_s12;
ic.venstart.load.c4_12.xi   = ic.venstart.load.act_s4.x;
ic.venstart.load.c4_12.xo   = ic.venstart.load.act_s12.x;
ic.venstart.load.c12_8.xi   = ic.venstart.load.act_s12.x;
ic.venstart.load.c12_8.xo   = ic.venstart.load.act_s8.x;
ic.venstart.load.c8_4.xi    = ic.venstart.load.act_s8.x;
ic.venstart.load.c8_4.xo    = ic.venstart.load.act_s4.x;

E   = OrderAllFields(E);
ic  = OrderAllFields(ic);
Z   = OrderAllFields(Z);
MOD = OrderAllFields(MOD);
GEO = OrderAllFields(GEO);

if MOD.verbose-MOD.linearizing > 0
    fprintf('%s:  running %s_%s\n', mfilename, char(Z.strD), char(Z.strV));
    fprintf('%s/InitFcn:  complete init...', bdroot); timestamper;
end

clear fnThisFile dfnThisFile
clear fnTune_File dfnTune_File
clear fnC_File dfnC_File
% loadData_VEN_Subsystem
% load reference data from engine or bench
% 25-Apr-2017       DA Gutz     Created
% Revisions


if Z.data.enable
    try
        % rigVal2000
        if Z.data.rigVal2000
            fprintf('%s: LOADING rigVal2000 DATA...', mfilename);
            DS = loadRig2000_DataVEN_Subsystem(Z.data.file, 0, MOD);
            MOD.tFinal = DS.tFinal;
            if Z.data.use.xn25
                try Z.xn25 = DS.V.speed_r(1,2)*17210/8108;              end %#ok<*TRYNC>
            end
            if Z.data.use.mAven
                try Z.mAven= DS.V.current_r(1,2); Z.V.mAven = DS.V.current_r;   end
            end
            if Z.data.use.a8
                try Z.xven = 4.7 - DS.V.lvdt_r(1,2)/100*4.7;
                    Z.V.xven = 4.7 - DS.V.lvdt_r/100*4.7;                       end
            end
            if Z.data.use.ps
                try Z.ps   = DS.V.boost_r(1,2);Z.V.ps = DS.V.boost_r; catch ERR, end
            end
            DS.V.PFVARD = DS.V.rod_r;
            DS.V.PFVAHD = DS.V.rod_r*0;
            DS.V.PFEHSV = DS.V.supply_r;
            DS.V.PFRTN  = DS.V.boost_r;
            DS.V.TRSMO  = DS.V.rod_r*0;
            DS.V.A8MAD  = DS.V.current_r;
            DS.V.mAven  = DS.V.A8MAD;
            Z.dmA_A8    = DS.V.A8MAD;
            Z.dmA_A8(:,2)  = Z.dmA_A8(:,2)- DS.V.A8MAD(1,2);
            DS.V.QN25   = DS.V.speed_r*17210/8108;
            DS.V.A8ACV  = DS.V.lvdt_r;
            DS.V.xn25   = DS.V.QN25;
        else
            if Z.data.SOURCE,
                % SOURCE
                fprintf('%s: LOADING SOURCE DATA...', mfilename);
                result_Fn    = sprintf('%s.ven', Z.data.file);
                DS = loadSourceDataSubsystem(result_Fn, 0, MOD, DS);
                result_Fn    = sprintf('%s.ifc', Z.data.file);
                DS = loadSourceDataSubsystem(result_Fn, 0, MOD, DS);
                result_Fn    = sprintf('%s.hs', Z.data.file);
                DS = loadSourceDataSubsystem(result_Fn, 0, MOD, DS);
                result_Fn    = sprintf('%s.mvsv', Z.data.file);
                DS = loadSourceDataSubsystem(result_Fn, 0, MOD, DS);
                MOD.tFinal = DS.tFinal;
                if Z.data.use.fxven
                    try Z.fxven = DS.V.fxven(1,2);                  end %#ok<*TRYNC>
                end
                if Z.data.use.xn25
                    try Z.xn25 = DS.V.xn25(1,2);                    end %#ok<*TRYNC>
                end
                if Z.data.use.wf36
                    try Z.wf36 = DS.V.wf36(1,2); Z.V.wf36 = DS.V.wf36;      end
                end
                if Z.data.use.mAven
                    try Z.mAven= DS.V.mAven(1,2); Z.V.mAven = DS.V.mAven;   end
                end
                if Z.data.use.mAwfm
                    try Z.mAwfm= DS.V.mAwfm(1,2); Z.V.mAwfm = DS.V.mAwfm;   end
                end
                if Z.data.use.a8
                    try Z.xven = 4.7 - DS.V.a8(1,2)/100*4.7;
                        Z.V.xven = 4.7 - DS.V.a8/100*4.7;                   end
                end
                if Z.data.use.a8ref
                    try Z.a8ref = DS.V.a8ref(1,2); Z.V.a8ref = DS.V.a8ref;  end
                end
                if Z.data.use.pr
                    try Z.pr   = DS.V.pr(1,2);catch ERR, end
                end
                if Z.data.use.ps
                    try Z.ps   = DS.V.ps(1,2);Z.V.ps  = DS.V.ps; catch ERR, end
                end
            else  %RET
            end
        end
        F414_Fuel_Set_Case
    catch ERR
        keyboard
        error('Could not load and read data file %s', Z.data.file)
    end
else
    ic.venstart.fxven   = Z.fxven;
    ic.venstart.N       = Z.xn25*E.xnvent/E.N25100Pct;
    ic.venstart.pamb    = Z.pamb;
    F414_Fuel_Set_Case
end

% Fill in the blanks
default('DS.V.wf36', '[0 100; Z.wf36    Z.wf36]');
default('DS.V.xn25', '[0 100; Z.xn25    Z.xn25]');
default('DS.V.xven', '[0 100; Z.xven    Z.xven]');
default('DS.V.fxven', '[0 100; Z.fxven   Z.fxven]');
default('DS.V.pr  ', '[0 100; Z.pr      Z.pr]');
default('DS.V.ps  ', '[0 100; Z.ps      Z.ps]');
default('DS.V.a8  ', '[0 100; (4.7-Z.xven)/4.7*100 (4.7-Z.xven)/4.7*100]');
default('DS.V.PFEHSV', '[0 100; 0 0]');
default('DS.V.PFVARD', '[0 100; 0 0]');
default('DS.V.PFVAHD', '[0 100; 0 0]');
default('DS.V.PFRTN ', '[0 100; 0 0]');
default('DS.V.TRSMO ', '[0 100; 0 0]');
default('DS.V.A8MAD ', '[0 100; 0 0]');
default('DS.V.QN25', '[0 100; 0 0]');
default('DS.V.A8ACV ', '[0 100; 0 0]');

% Running with MOD.fullUp
default('DS.V.mA_mv', '[0 100; 0 0]');
default('DS.V.p1so', '[0 100; 0 0]');
default('DS.V.ps3 ', '[0 100; 0 0]');
