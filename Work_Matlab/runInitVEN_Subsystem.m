%% runInitVEN_Subsystem   Iterate using goal attain (to solve InitVEN_Subsystem).
% Inputs
% swReplot              Replot from .mat file already run
% useFuser              Use the F data in genConditionsgenericServoActuator_
% verbose               Print diagnostics, increasing levels with increasing value
%
% Outputs
% goal            Make global so visible by system calculations for reference only
% weight          Solver optimization control.
% F               FADEC parameters
% SYS             Linear systems
% MOD             Model parameters
% RT              Response results tables
% stateFile.mat   Saved value of random variables, to allow reproducibility of results
% noStateFile     Indicator that stateFile.mat already exists
% titl            Plot title.

%%Revisions
% 03-Mar-2017   DA Gutz     Created from DP1847 Servo Actuator design


warning('off', 'MATLAB:declareGlobalBeforeUse');

% Setup
% Switch used by InitFcn to request one solution using ic, Z inputs instead of file
% close all; close all hidden


% clear globals
% default('MOD.batch', '1');
if MOD.batch
    clear E GEO FP MOD strS
    MOD.batch = 1;
end
% nfigs = 0;
% clear figTitle
% legendV = [];
% if MOD.fullUp
%     titleStr = sprintf('init');
% else
%     titleStr = sprintf('initVEN_Subsystem');
% end
% 
% Commonly used switches
swReplot        = 0;    % 0 is normal.  Replot or recompute csv file from .mat file
swCSVOnly       = 0;    % 0 is normal.  When replotting, do only the csv file update
% swHard          = 1;    % 1 is normal.  Save figures in ../figures/case.eps
% swPropNote      = 1;    % 1 is normal.  Print proprietary note on figures

% Calculations based on switches

% Folders for saving stuff
if ~exist('saves', 'dir'), mkdir('saves'), end

% Conditions for cases in loop.
if MOD.batch
    clear num txt raw
    [num,txt,raw]   = xlsread('InitVEN_Subsystem_in.csv');
    inputNames  = raw(1,:);
    conditions  = raw(2:end,:);
    [nC, mI] = size(conditions);
    for iActive = 1:length(inputNames)
        if strcmp(inputNames{iActive}, 'active'), break; end
    end
    nCases = sum(cell2mat(conditions(:,iActive)));
else
    active  = 1;
    nCases  = 1;
    nC      = 1;
    desc = sprintf('{''%4.0f% %5.0flbf''}', Z.xn25/E.N25100Pct*100, Z.fxven);
% 	strS        = Z.strS;
end
% Open record files
[fid, fidMsg]   = fopen('saves/runInitVEN_Subsystem.csv',     'wt');
if -1==fid,
    error('Failed to open saves/runInitVEN_Subsystem.csv:  %s.  Is it still open in excel?', fidMsg)
end
if ~fprintf(fid, 'active, desc, MOD.verbose, ') ||...
        ~fprintf(fid, 'FP.sg, FP.kvis,') ||...
        ~fprintf(fid, 'Z.fxven, Z.dFXVENX, Z.xn25, Z.wf36, Z.pr, Z.ps, Z.pamb, strS,') ||...
        ~fprintf(fid, 'RES.x1_xehsv, RES.x2_prod, RES.x3_xbi, RES.x4_pd, RES.x5_disp, RES.x_xreg, RES.x_px, ic.venstart.phead,') ||...
        ~fprintf(fid, 'RES.e1_eall, RES.e2_eprod, RES.e3_ebi, RES.e4_epx, RES.e5_epcham, RES.e_regf, RES.e_pumpf,') || ...
        ~fprintf(fid, 'RES.VEN_LOAD_X,RES.A8_NULL,RES.A8_ERR,RES.mA,') || ...
        ~fprintf(fid, 'icv.eall.noSoln, icv.eprod.noSoln, icv.ebi.noSoln, icv.epx.noSoln,  icv.epcham.noSoln,\n');
end

% Loop through operating conditions and hardware configurations.  Put out a
% summary plot with all information for each configuration.
if MOD.batch
    nNamesVec = size(inputNames, 2);
    nNames = size(conditions, 2);
    if nNamesVec ~= nNames, error('Parameter ''inputNames'' must be same width as ''conditions'''); end
end
caseNo = 0;
for iCase = 1:nC,
    try
        icSav = ic; Z_Sav = Z; FP_Sav = FP;
    catch ERR
    end
    if MOD.batch
        clear ic Z FP strS
        for jName=1:nNames, eval(sprintf('%s = conditions{iCase, jName};', inputNames{jName})); end
        if ~active
            try
                ic = icSav; Z = Z_Sav; FP = FP_Sav;
            catch ERR
            end
            continue
        end
        clear E GEO MOD
        MOD.batch = 1;
        PreLoadFcn_Fuel
        MOD.kludgy      = 0;
        Z.strS          = strS;
        Z.handTuning    = 1;
        ic.venstart.N   = Z.xn25/E.xnvent*E.N25100Pct;
        ic.venstart.mA  = 0;
        InitFcn_VEN_Subsystem
    else
    end
    caseNo = caseNo + 1;
    % TODO:  eliminate MODi, GEOi
    clear GEOi FPi MODi
    global GEOi %#ok<*TLEV>
    global MODi
    GEOi    = GEO;
    FPi     = FP;
    MODi    = MOD;
    GEOV    = GEO.venstart;
    GEOVL   = GEO.venstart.load;
    MODi.verbose = verbose;
    MODi.loaded = 0; %#ok<*STRNU>
    
    if MOD.fullUp
        inistrT  = sprintf('init');
    else
        inistrT  = sprintf('initVEN_Subsystem');
    end
    ic.venstart.fxven   = Z.fxven;
    ic.venstart.N       = Z.xn25*8108/17210;
    ic.venstart.pr      = Z.pr;
    ic.venstart.ps      = Z.ps;
    ic.venstart.pump.ps = ic.venstart.ps;
    ic.venstart.pamb    = Z.pamb;
    if ~swReplot,
        % inputs
        MODi.verbose    = verbose;
        
        swNoSolve       = 0;
        swFrozen        = 0;
        GUESS.xn25        = interp1(E.xn25_g(1,:),  E.xn25_g(2,:),    ic.venstart.fxven);
        GUESS.x1_xehsv    = interp1(E.xehsv_g(1,:), E.xehsv_g(2,:),   ic.venstart.fxven);
        GUESS.x2_prod     = interp1(E.prod_g(1,:),  E.prod_g(2,:),    ic.venstart.fxven);
        GUESS.x3_xbi      = interp1(E.xbias_g(1,:), E.xbias_g(2,:),   ic.venstart.fxven);
        GUESS.x4_pd       = interp1(E.pd_g(1,:),    E.pd_g(2,:),      ic.venstart.fxven);
        GUESS.x5_disp     = interp1(E.disp_g(1,:),  E.disp_g(2,:),    ic.venstart.fxven)*GUESS.xn25/Z.xn25;
        GUESS.x_xreg      = interp1(E.xreg_g(1,:),  E.xreg_g(2,:),    ic.venstart.fxven);
        ic.venstart.x1_xehsv    = GUESS.x1_xehsv;
        ic.venstart.x2_prod     = GUESS.x2_prod;
        ic.venstart.x3_xbi      = GUESS.x3_xbi;
        ic.venstart.x4_pd       = GUESS.x4_pd;
        ic.venstart.x5_disp     = GUESS.x5_disp;
        ic.venstart.x_xreg      = GUESS.x_xreg;
        F414_Fuel_Set_Case
        if ~MOD.linearizing 
            fprintf('\n%s case %ld of %ld:    %s\n', mfilename, caseNo, nCases, savstrT);
            fprintf('%s:  beginning case...', mfilename); timestamper;
        else
            fprintf(' Initializing...');
        end
        [ic, GEOi] = F414_Fuel_System_Balance_VENstandalone(ic, GEOi, FPi, MODi, Z, E, savstrT, F);
        if ic.ps<100
            Z.ps = round(ic.ps*10)/10;
        else
            Z.ps = round(ic.ps);
        end
        if ic.pr<100
            Z.pr = round(ic.pr*10)/10;
        else
            Z.pr = round(ic.pr);
        end
        F414_Fuel_Set_Case
        RES.x_disp  = ic.venstart.pump.disp;
        RES.x1_xehsv= ic.venstart.load.ehsv.x;
        RES.x2_prod = ic.venstart.x2_prod;
        RES.x3_xbi  = ic.venstart.bi.x;
        RES.x4_pd   = ic.venstart.pd;
        RES.x5_disp = ic.venstart.x5_disp;
        RES.x_xreg  = ic.venstart.reg.x;
        RES.x_px    = ic.venstart.x_px;
        RES.e1_eall = ic.venstart.e1_eall;
        RES.e2_eprod= ic.venstart.e2_eprod;
        RES.e3_ebi  = ic.venstart.e3_ebi;
        RES.e4_epx  = ic.venstart.e4_epx;
        RES.e5_epcham= ic.venstart.e5_epcham;
        RES.e_regf  = ic.venstart.e_regf;
        RES.e_pumpf = ic.venstart.e_pumpf;
        RES.VEN_LOAD_X  = ic.F.VEN_LOAD_X;
        RES.A8_NULL     = ic.F.A8_NULL;
        RES.A8_ERR      = ic.F.A8_ERR;
        RES.mA          = ic.venstart.mA;
        if ~MOD.linearizing
            fprintf('%s:    x1_xehsv     x2_prod         x3_xbi      x4_pd            x5_disp      x_xreg       x_px          -->  e1_eall      e2_eprod       e3_ebi       e4_epx        e5_epcham     e_regf       e_pumpf\n', savstr);
            fprintf('%%------------   ITEM %ld of %ld.  %s ---%%\n', caseNo, nCases, desc );
            fprintf('%s:  ending case...', mfilename); timestamper;
        end
        icv     = ic.venstart;
        if ~MOD.linearizing
            if  ~fprintf(fid,        '%ld,%s,',  active, desc) ||...
                ~fprintf(fid,   '%13.8g,', MODi.verbose)||...
                ~fprintf(fid,   '%13.8g,', FP.sg, FP.kvis)||...
                ~fprintf(fid,   '%13.8g,', Z.fxven, Z.dFXVENX, Z.xn25, Z.wf36, ic.venstart.pr, ic.venstart.ps, Z.pamb)||...
                ~fprintf(fid,   '%s,',     char(Z.strS))||...
                ~fprintf(fid,   '%13.8g,', RES.x1_xehsv, RES.x2_prod, RES.x3_xbi, RES.x4_pd, RES.x5_disp, RES.x_xreg, RES.x_px, ic.venstart.phead)||...
                ~fprintf(fid,   '%13.8g,', RES.e1_eall, RES.e2_eprod, RES.e3_ebi, RES.e4_epx, RES.e5_epcham, RES.e_regf, RES.e_pumpf) ||...
                ~fprintf(fid,   '%13.8g,', RES.VEN_LOAD_X,RES.A8_NULL,RES.A8_ERR,RES.mA) ||...
                ~fprintf(fid,   '%ld,',    icv.eall.noSoln, icv.eprod.noSoln, icv.ebi.noSoln, icv.epx.noSoln,  icv.epcham.noSoln) ||...
                ~fprintf(fid,   '\n');
               error('Failed to write to runInitVEN_Subsystem.csv')
            end
        end
    end
    
    RES = OrderAllFields(RES);
    MODi = OrderAllFields(MODi);
    GEO  = GEOi;
    ic  = OrderAllFields(ic);
    
    
    % Plot and save results
    if MOD.fullUp
        saveRoot = sprintf('init_%s', savstr);
    else
        saveRoot = sprintf('initVEN_Subsystem_%s', savstr);
    end
    if swReplot,
        conditionsS = conditions;
        nCasesS     = nCases;
        caseNoS      = caseNo;
        fidS        = fid;
        swReplotS   = swReplot;
        swCSVOnlyS  = swCSVOnly;
        eval(sprintf('load saves/%s', saveRoot));
        conditions = conditionsS;
        nCases      = nCasesS;
        caseNo      = caseNoS;
        fid         = fidS;
        swReplot    = swReplotS;
        swCSVOnly   = swCSVOnlyS;
    else
        eval(sprintf('save saves/%s ic RES GUESS FP GEO GEOD AC_     AC_GRIPEN AC_MODE E', saveRoot));
        if ~MOD.linearizing, fprintf('Saved to saves/%s.mat', saveRoot); end
    end %swReplot
    if (~swReplot && ~swCSVOnly),
    end
end
stcfid  = fclose(fid);
if stcfid,  error('Failed to close csv file'), end
clear GEOi FPi savstr savstrT saveRoot strS stcfid titleStr temp tRun swHard swHcopy swNoSolve swPropNote swReplot 
clear legendV caseNo

MOD.batch = 0;

