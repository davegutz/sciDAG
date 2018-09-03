function BoInfo = BusObjects()
% BUSOBJECTS returns a Bo array containing bus object information 
% 
% The order of bus element attributes is as follows:
%   ElementName, Dimensions, DataType, SampleTime, Complexity, SamplingMode 
BoInfo = { ...
    { ...
     'FuelPropertyBus', ...
'', ... 
'Bus to support fuel properties', { ...
    {'sg',    1, 'double', -1, 'real', 'Sample'}; ...
    {'beta',  1, 'double', -1, 'real', 'Sample'}; ...
    {'kvis',  1, 'double', -1, 'real', 'Sample'}; ...
    {'dwdc',  1, 'double', -1, 'real', 'Sample'}; ...
    {'avis',  1, 'double', -1, 'real', 'Sample'}; ...
    } ...
    } ...
    { ...
     'PumpCurveBus', ...
'', ... 
'Bus to support pump curves', { ...
    {'cd',  1, 'double', -1, 'real', 'Sample'}; ...
    {'cf',  1, 'double', -1, 'real', 'Sample'}; ...
    {'cn',  1, 'double', -1, 'real', 'Sample'}; ...
    {'cs',  1, 'double', -1, 'real', 'Sample'}; ...
    {'ct',  1, 'double', -1, 'real', 'Sample'}; ...
    } ...
    } ...
    { ...
     'triValveWin', ...
'', ... 
'Bus to support triValve geometry', { ...
    {'CLEAR',  1, 'double', -1, 'real', 'Sample'}; ...
    {'DBIAS',  1, 'double', -1, 'real', 'Sample'}; ...
    {'DORIFD',  1, 'double', -1, 'real', 'Sample'}; ...
    {'DORIFS',  1, 'double', -1, 'real', 'Sample'}; ...
    {'HOLES',  1, 'double', -1, 'real', 'Sample'}; ...
    {'SBIAS',  1, 'double', -1, 'real', 'Sample'}; ...
    {'UNDERLAP',  1, 'double', -1, 'real', 'Sample'}; ...
    {'WD',  1, 'double', -1, 'real', 'Sample'}; ...
    {'WS',  1, 'double', -1, 'real', 'Sample'}; ...
    } ...
    } ...
    }';
% Create bus objects in the MATLAB base workspace
Simulink.Bus.cellToObject(BoInfo)


%% F414_Fuel_Check_Stamps
% Check time stamps for changes
% 13-Sep-2017   DA Gutz     Created


if MOD.fullUp
    fnMat = sprintf('saves/init_%s_%s.mat', Z.case, char(Z.strS));
else
    fnMat = sprintf('saves/initVEN_Subsystem_%s_%s.mat', Z.case, char(Z.strS));
end
dfnMat          = getStamp(fnMat);
fnGEO_File      = sprintf('INPUTS/F414_Geometry.m');
dfnGEO_File     = getStamp(fnGEO_File);
fnTune_File     = sprintf('INPUTS/TUNE/STEADY/%s.m', char(Z.strS));
dfnTune_File    = getStamp(fnTune_File);
fnC_File        = sprintf('INPUTS/TUNE/CONDITION/%s.m', char(Z.strC));
dfnC_File       = getStamp(fnC_File);
dfnThisFile     = getStamp(fnThisFile);

%% F414_Fuel_DYNAMIC
% Load dynamic tune parameters
% 13-Sep-2017   DA Gutz     Created


% Tuning file
if ~isempty(Z.strD)
    if iscell(Z.strD)
        strDC = regexprep(Z.strD, '^-', '');
        strDC = regexprep(strDC, '^_', '');
        Z.strD = '';
        for j=1:length(strDC)
            [fl, p]= grep('-i -r', {ssParams{:}}, [strDC{j} '.m']);
            if p.pcount
                error('%s:  a ''ssParam'' element that rebalances initial condition is contained in file %s.\nIt should be in STEADY.m', mfilename, strDC{j});
            end
            eval(sprintf('%s', strDC{j}));
            Z.strD  = [Z.strD '_' strDC{j}];
            if MOD.verbose-MOD.linearizing > 2, fprintf('Loaded DYNAMIC file %s\n', Z.strD{j}); end
        end
        Z.strD = cellstr(Z.strD);
        Z.strD = regexprep(Z.strD, '^_', '');
    else
        [fl, p]= grep('-i -r', {ssParams{:}}, [Z.strD '.m']);
        if p.pcount
            error('%s:  a ''ssParam'' element that rebalances initial condition is contained in file %s.\nIt should be in STEADY.m', mfilename, Z.strD{j});
        end
        eval(sprintf('%s', Z.strD));
        if MOD.verbose-MOD.linearizing > 2,  fprintf('Loaded DYNAMIC file %s\n', Z.strD); end
    end
end

%% F414_Fuel_GEO_Renom
% Load GEO
% 13-Sep-2017   DA Gutz     Created


clear GEO
GEO.mv.xmin     = 0.;
try [GEO, GEOD, D]     = F414_Geometry(GEO, MOD, FP, Z, D);
catch ERR,
    [GEO, GEOD, D]     = F414_Geometry(GEO, MOD, FP, Z);
end

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

%% F414_Fuel_Set_Case
% Set Z.case parameter for plots and file names
% 13-Sep-2017   DA Gutz     Created


try strS = char(Z.strS);
catch ERR
    if ~exist('strS', 'var')
        defaulting  = 1;
    else
        defaulting = 0;
        strSSav = strS;
    end
    strS        = 'x';
end
if MOD.fullUp
    Z.case =  sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%02ld_%02ld',...
        round(Z.selectAC), round(Z.fxven), round(Z.dFXVENX), round(Z.xn25), round(Z.wf36), round(Z.pamb*10),...
        round(FP.sg*100), round(FP.kvis*10));
    savstrT = sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%02ld_%02ld_%s',...
        round(Z.selectAC), round(ic.venstart.fxven), round(Z.dFXVENX), round(ic.venstart.N*E.N25100Pct/E.xnvent), round(Z.wf36), round(ic.venstart.pamb*10),...
        round(FP.sg*100), round(FP.kvis*10), strS);
    savstr = sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%02ld_%02ld_%s',...
        round(Z.selectAC), round(ic.venstart.fxven), round(Z.dFXVENX),  round(ic.venstart.N*E.N25100Pct/E.xnvent), round(Z.wf36), round(ic.venstart.pamb*10),...
        round(FP.sg*100), round(FP.kvis*10), strS);
else
    Z.case =  sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%03ld_%03ld_%02ld_%02ld',...
        round(Z.selectAC), round(Z.fxven), round(Z.dFXVENX), round(Z.xn25), round(Z.wf36), round(Z.pamb*10),...
        round(Z.pr*10), round(Z.ps), round(FP.sg*100), round(FP.kvis*10));
    savstrT = sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%03ld_%03ld_%02ld_%02ld_%s',...
        round(Z.selectAC), round(ic.venstart.fxven), round(Z.dFXVENX), round(ic.venstart.N*E.N25100Pct/E.xnvent), round(Z.wf36), round(ic.venstart.pamb*10),...
        round(ic.venstart.pr*10), round(ic.venstart.ps), round(FP.sg*100), round(FP.kvis*10), strS);
    savstr = sprintf('%02ld_%05ld_%05ld_%05ld_%05ld_%03ld_%03ld_%03ld_%02ld_%02ld_%s',...
        round(Z.selectAC), round(ic.venstart.fxven), round(Z.dFXVENX),  round(ic.venstart.N*E.N25100Pct/E.xnvent), round(Z.wf36), round(ic.venstart.pamb*10),...
        round(Z.pr*10), round(Z.ps), round(FP.sg*100), round(FP.kvis*10), strS);
end
if exist('defaulting', 'var')
    if defaulting
        clear strS;
    else
        if exist('strSSav', 'var')
            strS = strSSav;
            clear strSSav
        end
    end
end

%% F414_Fuel_STEADY_1
% Load Steady tune parameters
% 13-Sep-2017   DA Gutz     Created

% Tuning file
if ~isempty(Z.strV)
    if iscell(Z.strV)
        for j=1:length(Z.strV)
            [fl, p]= grep('-i -r', {ssParams{:}}, [Z.strV{j} '.m']);
            if p.pcount
                error('%s:  a ''ssParam'' element that rebalances initial condition is contained in file %s.\nIt should be in STEADY.m', mfilename, Z.strV{j});
            end
            eval(sprintf('%s', Z.strV{j}));
            if ~MOD.linearizing, fprintf('Loaded VECTORS file %s\n', Z.strV{j}); end
        end
    else
        [fl, p]= grep('-i -r', {ssParams{:}}, [Z.strV '.m']);
        if p.pcount
            error('%s:  a ''ssParam'' element that rebalances initial condition is contained in file %s.\nIt should be in STEADY.m', mfilename, Z.strV{j});
        end
        eval(sprintf('%s', Z.strV));
        if ~MOD.linearizing, fprintf('Loaded VECTORS file %s\n', Z.strV); end
    end
else
    if ~MOD.linearizing,fprintf('Not loading VECTORS file\n');end
end



%% F414_Fuel_STEADY_2
% Load Steady tune parameters
% 13-Sep-2017   DA Gutz     Created


% Tuning file
if ~isempty(Z.strC)
    if iscell(Z.strC)
        strCC = regexprep(Z.strC, '^-', '');
        strCC = regexprep(strCC, '^_', '');
        Z.strC = '';
        for j=1:length(Z.strC)
            eval(sprintf('%s', Z.strC{j}));
            Z.strC  = [Z.strC '_' strCC{j}];
            if MOD.verbose-MOD.linearizing > 2, fprintf('Loaded CONDITION file %s\n', Z.strC{j});end
        end
        Z.strC = cellstr(Z.strC);
        Z.strC = regexprep(Z.strC, '^_', '');
    else
        eval(sprintf('%s', Z.strC));
        if MOD.verbose-MOD.linearizing > 2, fprintf('Loaded CONDITION file %s\n', Z.strC);end
    end
else
    if MOD.verbose-MOD.linearizing > 2, fprintf('Not loading CONDITION file\n');end
end
if ~isempty(Z.strS)
    if iscell(Z.strS)
        strSC = regexprep(Z.strS, '^-', '');
        strSC = regexprep(strSC, '^_', '');
        Z.strS = '';
        for j=1:length(strSC)
            eval(sprintf('%s', strSC{j}));
            Z.strS  = [Z.strS '_' strSC{j}];
            if MOD.verbose-MOD.linearizing > 2,  fprintf('Loaded STEADY file %s\n', strSC{j}); end
        end
        Z.strS = cellstr(Z.strS);
        Z.strS = regexprep(Z.strS, '^_', '');
    else
        eval(sprintf('%s', Z.strS));
        if MOD.verbose-MOD.linearizing > 2,  fprintf('Loaded STEADY file %s\n', Z.strS); end
    end
else
    Z.strS = 'sNone';
    if MOD.verbose-MOD.linearizing > 2,  fprintf('Not loading STEADY file\n');end
end

function ic = Fuel_System_Balance(ic, GEO, FP, MOD)
%%function ic = Fuel_System_Balance(ic, GEO, FP, MOD)
% 01-Mar-2017   DA Gutz     Created



RNULL   = 0.002;    % Estimate of regulator null disp, in. 
DPNORM  = 500;      % Estimate of pressure above supply without lead, psi
DPLEAK  = 120;      % Estimate of pressure above supply bled, psi
DBIAS   = 0;        %#ok<NASGU> % Dead zone of drain, + is underlap, in
AVG_DISP    = 0.5;

% Name changes
icv         = ic.venstart;
ic.venstart.load.fxven  = icv.fxven;
icvl        = ic.venstart.load;
GEOV        = GEO.venstart;
GEOVL       = GEOV.load;
RGEO        = GEOV.reg;
BIGEO       = GEOV.bi;
PAGEO       = GEOV.pa;
% TODO add start valve SGEO        = GEOV.start;
GEOP        = GEOV.pump;
icv.pump.N  = icv.N;
AHEAD       = GEOVL.act_c.ah;
AROD        = GEOVL.act_c.ar;
icvl.act_c.v= 0;           % Constraint
icv.wfdstart= 0;
icv.pump.N  = icv.N;
icv.pump.ps = icv.ps;
icvl.ehsv.x = icv.x1_xehsv;
icv.reg.x   = icv.x2_xreg;
icv.bi.x    = icv.x3_xbi;
icv.pump.pd = icv.x4_pd;
icv.phead   = (icv.x5_prod*AROD - icvl.fxven + icv.pamb*(AHEAD-AROD))/AHEAD;
icvl.ehsv.adh   = interp1(GEOVL.ehsv.awin_dh(:,1), GEOVL.ehsv.awin_dh(:,2), icvl.ehsv.x, 'linear', 'extrap');
icvl.ehsv.ash   = interp1(GEOVL.ehsv.awin_sh(:,1), GEOVL.ehsv.awin_sh(:,2), -icvl.ehsv.x, 'linear', 'extrap');
icvl.ehsv.adr   = interp1(GEOVL.ehsv.awin_dr(:,1), GEOVL.ehsv.awin_dr(:,2), -icvl.ehsv.x, 'linear', 'extrap');
icvl.ehsv.asr   = interp1(GEOVL.ehsv.awin_sr(:,1), GEOVL.ehsv.awin_sr(:,2), icvl.ehsv.x, 'linear', 'extrap');
icvl.ehsv.wfhd  = or_aptow(icvl.ehsv.adh,   icv.phead, icv.ps,     GEOVL.ehsv.cd, FP.sg);
icvl.ehsv.wfsh  = or_aptow(icvl.ehsv.ash,   icv.x4_pd,     icv.phead, GEOVL.ehsv.cd, FP.sg);
icvl.ehsv.wfrd  = or_aptow(icvl.ehsv.adr,   icv.x5_prod,  icv.ps,     GEOVL.ehsv.cd, FP.sg);
icvl.ehsv.wfsr  = or_aptow(icvl.ehsv.asr,   icv.x4_pd,     icv.x5_prod,  GEOVL.ehsv.cd, FP.sg);
icvl.wfb        = or_aptow(GEOVL.act_c.ab,  icv.x5_prod,  icv.phead, GEOVL.act_c.cd, FP.sg);
icvl.wfrl       = or_aptow(GEOVL.act_c.arl, icv.x5_prod,  icv.pr,     GEOVL.act_c.cd, FP.sg);
icvl.wfhl       = or_aptow(GEOVL.act_c.ahl, icv.phead, icv.pr,     GEOVL.act_c.cd, FP.sg);
icvl.ehsv.wfllk = GEOVL.ehsv_klk * FP.sg *((icv.x4_pd - icv.pr) / FP.avis)^GEOVL.ehsv_powlk;
icvl.ehsv.wflk  = abs(la_kptow(GEOVL.ehsv.kel, icv.x4_pd, icv.pr, FP.kvis));
icvl.ehsv.wfj   = abs(or_aptow(GEOVL.ehsv.ael, icv.x4_pd, icv.pr, GEOVL.ehsv.cdl, FP.sg));
icvl.ehsv.wfr   = icvl.ehsv.wfsr    - icvl.ehsv.wfrd;
icvl.ehsv.wfh   = icvl.ehsv.wfsh    - icvl.ehsv.wfhd;
icvl.ehsv.wfd   = icvl.ehsv.wflk    + icvl.ehsv.wfj + icvl.ehsv.wfrd + icvl.ehsv.wfhd;
icvl.ehsv.wfs   = icvl.ehsv.wflk    + icvl.ehsv.wfj + icvl.ehsv.wfsr + icvl.ehsv.wfsh;
icvl.wfl        = icvl.ehsv.wfs     + icvl.ehsv.wfllk;
[RGEO.as, RGEO.ad]  = ven_reg_win(icv.reg.x, RGEO.win);


% Pump disp loop
% icv.pump.disp   = icv.x_disp;
icv.e_pcham = 999;
icv.pump.disp  = 0.05;
icv.pump.dmax  = 0.15;
icv.pump.dmin  = 0.02;
icv.pump.count = 0;
while (abs(icv.e_pcham) > 1e-12  && icv.pump.count<50)
    icv.pump.count  = icv.pump.count+1;
    icv.pump        = calc_pos_pump_a(GEOP, icv.pump, FP); % inputs:   N, pd, ps, disp  % outputs:  wf
    icv.pump.pa.x   = asin(icv.pump.disp / GEOV.cdv);
    icv.pump.theta  = 180 / pi * icv.pump.pa.x;
    icv.tqrs        = interp1(GEOV.ytqrs(:,1),  GEOV.ytqrs(:,2), icv.pump.theta, 'linear');
    icv.ftpa        = interp1(GEOV.ytqa(:,1),   GEOV.ytqa(:,2),  icv.pump.theta, 'linear') * PAGEO.ah / GEOV.cftpa;
    icv.tqpv        = GEOV.ctqpv * (icv.x4_pd - icv.ps);
    icv.tqa         = icv.tqrs + icv.tqpv;
    icv.px          = icv.ps + icv.tqa/icv.ftpa;
    icv.pa.x        = icv.pump.pa.x;
    icv.reg.wfs     = or_aptow(RGEO.as, icv.x4_pd, icv.px, RGEO.cd, FP.sg);
    icv.reg.wfd     = or_aptow(RGEO.ad, icv.px, icv.ps, RGEO.cd, FP.sg);
    icv.reg.wfx     = icv.reg.wfs - icv.reg.wfd;
    icv.wfx         = icv.reg.wfx;
    icv.e_pcham    = (icv.pump.wf - icv.reg.wfs - icvl.ehsv.wfs - icvl.ehsv.wfllk) /(icv.N * AVG_DISP);
    if icv.e_pcham > 0
        icv.pump.dmax = icv.pump.disp;
        icv.pump.disp = (icv.pump.disp + icv.pump.dmin)/2;
    else
        icv.pump.dmin = icv.pump.disp;
        icv.pump.disp = (icv.pump.disp + icv.pump.dmax)/2;
    end
    if MOD.verbose>3
        fprintf('F414_Fuel_System_Balance_VEN(%ld): %12.8f, ', icv.pump.count, icv.pump.disp);
        fprintf('%12.8f, ', icv.e_pcham);  fprintf('\n');
    end
end
icv.x_disp = icv.pump.disp;

% Balance errors
icv.wflkout     = la_lrecptow(GEOV.leako.l, GEOV.leako.r, GEOV.leako.ecc, GEOV.leako.rad_clear, icv.px, icv.ps, FP.kvis);
icv.pa.wfr      = 0;    % motionless
icv.pa.wfh      = 0;    % motionless
icv.reg.wfde    = 0;  % motionless init
icv.reg.wflr    = 0;  % motionless init
icv.reg.wfld    = 0;  % motionless init
icv.reg.wfle    = 0;  % motionless init
icv.bi.wfr      = 0;  % motionless init
icv.bi.wfh      = 0;  % motionless init
icv.e1_px       = -(icv.wfx - icv.wflkout)/3000;
icv.e2_all      = ((icvl.ehsv.wfsh - icvl.ehsv.wfhd + icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfrl - icvl.wfhl))/(max(abs(icv.fxven),500)*10);
icv.e3_regf     = -((icv.x4_pd-icv.ps)*RGEO.ahs + RGEO.fspr - GEOV.fsb - GEOV.ksb*icv.bi.x - (GEOV.ksb+RGEO.ks)*icv.reg.x)/((icv.x4_pd-icv.ps)/1000);
icv.e4_bif      = ((icv.bi.x+icv.reg.x)*GEOV.ksb - (icv.x5_prod-icv.ps)*(BIGEO.ah-BIGEO.ar) + GEOV.fsb)/(max(abs(icv.fxven),50)*10);
icv.e5_prod     = -(icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfb - icvl.wfrl)/(max(abs(icv.fxven),50)/1);

    
% Assign
icvl.mA         = icvl.ehsv.x/GEOVL.ehsv.kix + GEOVL.ehsv.mAnull;
icv.mA          = icvl.mA;
icv.vo_pcham.p  = icv.x4_pd;
icv.vo_pcham.wf = icv.pump.wf;
icv.vo_px.p     = icv.px;
icv.vo_px.wf    = icv.wflkout;
icvl.vo_hcham.p = icv.phead;
icvl.vo_hcham.wf= 0;
icvl.vo_rcham.p = icv.x5_prod;
icvl.vo_rcham.wf= 0;
icvl.hline.p    = icv.phead;
icvl.hline.wf   = -(icvl.ehsv.wfhd-icvl.ehsv.wfsh);
icvl.rline.p    = icv.x5_prod;
icvl.rline.wf   = icvl.ehsv.wfsr-icvl.ehsv.wfrd;
icv.start.wf    = 0;  % TODO add start valve
icv.start.wfvx  = 0;  % motionless init
icv.wfl         = icvl.ehsv.wfs + icvl.ehsv.wfllk + icv.start.wf;
icv.wfs         = icv.pump.wf   + icv.pa.wfr      - icv.reg.wfd  - icv.reg.wfde   + icv.reg.wflr  - icv.reg.wfld -...
                  icv.reg.wfle  + icv.bi.wfh      + icv.bi.wfr   - icv.start.wfvx - icv.wflkout;
icv.wfr         = icvl.ehsv.wfd + icvl.ehsv.wfllk + icvl.wfrl    + icvl.wfhl;

% Re-assign
ic.venstart         = icv;
ic.venstart.load    = icvl;

if MOD.verbose>3
    fprintf('%12.8f, ', icv.x_disp,   icv.x1_xehsv,   icv.x2_xreg,    icv.x3_xbi,     icv.x4_pd,  icv.x5_prod);
    fprintf('%12.8f, ', icv.e_pcham,  icv.e1_px,      icv.e2_all,     icv.e3_regf,    icv.e4_bif, icv.e5_prod);  fprintf('\n');
end

return



function [icp] = calc_pos_pump_a(GEOP, icp, FP)
% Pump flow calculation
% inputs:   N, pd, ps, disp
% outputs:  wf

% /* Check for cavitation */
if icp.ps < FP.tvp + FP.tvp_margin,
    fprintf('icp supply icpure below tvp+margin in calc for %s\n', mfilename);
    icp.ps = FP.tvp + FP.tvp_margin;
end

% /* Pressure terms */
icp.pl  = icp.pd - icp.ps;

%/* Flow terms */
icp.mtdqp     = FP.avis * .10471976 * icp.N / icp.pl;
icp.eff_vol   = 1. -...
    GEOP.curve.cs / icp.mtdqp -...
    GEOP.curve.ct * 1825 * ssqrt(icp.pl / FP.sg) / icp.N / (sgn(icp.disp) * max(abs(icp.disp), 1e-24))^ .3333333 -...
    GEOP.curve.cn;
icp.cis = icp.eff_vol * icp.disp * icp.N / 60.;
icp.gpm = icp.cis / 3.85;
icp.wf  = icp.cis * FP.dwdc;
return

function wf = la_lrecptow(l, r, e, c, ps, pd, kvis)
%%la_lrecptow
% Purpose:    Calculate laminar flow
% Author:     Dave Gutz   22-Jul-92   Created
%
% Inputs:
% l         Length, in
% r         Radius, in
% e         Eccentricity, in
% c         Radial clearance, in
% ps        Supply pressure, psia
% pd        Discharge pressure, psia
% kvis      Kinematic viscosity, centistokes
%
% Output:
% wf        Flow, pph
%#define la_lrecptow(L, R, E, C, PS, PD, KVIS)\
%                    (4.698e8 * (R) *((C)*(C)*(C)) / (KVIS) /\
%		     (L) * (1. + 1.5 * sqr((E)/(C))) * ((PS) - (PD)))


%#codegen

wf = 4.698e8*r*(c*c*c)/kvis/l*(1.+1.5*(e/c)^2)*(ps-pd);






function [ic, GEO] = Fuel_System_Balance_standalone(ic, GEO, FP, MOD, Z, E, str, F)
%%function [ic, GEO] = Fuel_System_Balance_standalone(ic, GEO, FP, MOD, Z, E, str, F)
% 01-Mar-2017   DA Gutz     Created
% 05-Jun-2017   DA Gutz     PB1,PB2 names

RNULL   = 0.002;    %#ok<*NASGU> % Estimate of regulator null disp, in.
DPNORM  = 500;      % Estimate of pressure above supply without lead, psi
DPLEAK  = 120;      % Estimate of pressure above supply bled, psi
DBIAS   = 0;        % Dead zone of drain, + is underlap, in
AVG_DISP    = 0.5;

% Name changes
icv         = ic.venstart;
ic.venstart.load.fxven  = icv.fxven;
icvl        = ic.venstart.load;
GEOV        = GEO.venstart;
GEOVL       = GEOV.load;
RGEO        = GEOV.reg;
BIGEO       = GEOV.bi;
PAGEO       = GEOV.pa;
%TODO add start valve SGEO        = GEOV.start;
GEOP        = GEOV.pump;
icv.pump.N  = icv.N;
AHEAD       = GEOVL.act_c.ah;
AROD        = GEOVL.act_c.ar;
icvl.act_c.v= 0;           % Constraint
icv.wfdstart= 0;
icvl.ehsv.x = icv.x1_xehsv;

% UBCs
icvl.ehsv.wfs   = 0;  % init
icv.wfs         = 0;  % init
icv.wfr         = 0;  % init
icv.pa.wfr      = 0;  % motionless
icv.pa.wfh      = 0;  % motionless
icv.reg.wfde    = 0;  % motionless init
icv.reg.wflr    = 0;  % motionless init
icv.reg.wfld    = 0;  % motionless init
icv.reg.wfle    = 0;  % motionless init
icv.bi.wfr      = 0;  % motionless init
icv.bi.wfh      = 0;  % motionless init
icv.start.wf    = 0;  % TODO add start valve
icv.start.wfvx  = 0;  % motionless init
icv.prm         = 0;
icv.psm         = 0;
icv.wfrm        = 0;
icv.wfsm        = 0;

% xehsv loop
% Inputs:  pr, ps
% Outputs:   xehsv, prod, xbi, pd, xreg, disp, px, wfx, wflkout
icv.eall = iterateInit(icvl.ehsv.x+0.006, icvl.ehsv.x-0.004, 200, 'xehsv_all'); 
while (   (abs(icv.eall.e)>0.001   ||...
    abs(icv.pr-icv.prm)>1e-6 || abs(icv.ps-icv.psm)>1e-6 ||...
    abs(icv.wfr-icv.wfrm)>1e-3 || abs(icv.wfs-icv.wfsm)>1e-3   ) &&...
    icv.eall.count<25) 
    icv.eall.count  = icv.eall.count+1;
    icv.x1_xehsv    = icv.eall.x;
    icvl.ehsv.x     = icv.x1_xehsv;
    icv.wfrm        = icv.wfr;
    icv.wfsm        = icv.wfs;
    icv.prm         = icv.pr;
    icv.psm         = icv.ps;
    ic.wfr          = icv.wfr;
    ic.wfs          = icv.wfs;
    % Calculate ps and pr if either as input < 0
    if Z.ps<0 || Z.pr<0 || (MOD.fullUp && Z.data.enable && Z.data.SOURCE) || (MOD.fullUp && ~(Z.data.enable && ~(Z.data.use.pr||Z.data.use.ps)))
        [ic, GEO] = init_Engine_FuelSys(ic, Z, E, FP, GEO, MOD);
        ic.pr       = ic.pb1;
        ic.ps       = ic.pb2;
        ic.xn25     = ic.eng.xn25;
        icv.filt    = ic.venstart.filt;
        icv.vo_pb1  = ic.venstart.vo_pb1;
        icv.vo_pb2  = ic.venstart.vo_pb2;
    else
        ic.pr       = Z.pr;
        ic.ps       = Z.ps;
        ic.xn25     = Z.xn25;
    end
    icv.pr  = ic.pr;
    icv.ps  = ic.ps;
    icvl.ehsv.adh   = interp1(GEOVL.ehsv.awin_dh(:,1), GEOVL.ehsv.awin_dh(:,2), icvl.ehsv.x,    'linear', 'extrap');
    icvl.ehsv.ash   = interp1(GEOVL.ehsv.awin_sh(:,1), GEOVL.ehsv.awin_sh(:,2), -icvl.ehsv.x,   'linear', 'extrap');
    icvl.ehsv.adr   = interp1(GEOVL.ehsv.awin_dr(:,1), GEOVL.ehsv.awin_dr(:,2), -icvl.ehsv.x,   'linear', 'extrap');
    icvl.ehsv.asr   = interp1(GEOVL.ehsv.awin_sr(:,1), GEOVL.ehsv.awin_sr(:,2), icvl.ehsv.x,    'linear', 'extrap');

    % prod loop
    % Inputs:  pr, ps, xehsv 
    % Outputs:   prod, xbi, pd, xreg, disp, px, wfx, wflkout
   % icv.eprod = iterateInit(6000, 0, 1, 'prod_prodVol');   DAG 4/26/2017
    icv.eprod = iterateInit(6000, icv.ps, 1, 'prod_prodVol');
    while (abs(icv.eprod.e) > 1e-15  && icv.eprod.count<20 && abs(icv.eprod.dx)>0)
        icv.eprod.count = icv.eprod.count+1;
        icv.x2_prod     = icv.eprod.x;
        icv.phead       = (icv.x2_prod*AROD - icvl.fxven + icv.pamb*(AHEAD-AROD))/AHEAD;
        icvl.ehsv.wfhd  = or_aptow(icvl.ehsv.adh,   icv.phead,      icv.ps,     GEOVL.ehsv.cd,  FP.sg);
        icvl.ehsv.wfrd  = or_aptow(icvl.ehsv.adr,   icv.x2_prod,    icv.ps,     GEOVL.ehsv.cd,  FP.sg);
        icvl.wfb        = or_aptow(GEOVL.act_c.ab,  icv.x2_prod,    icv.phead,  GEOVL.act_c.cd, FP.sg);
        icvl.wfrl       = or_aptow(GEOVL.act_c.arl, icv.x2_prod,    icv.ps,     GEOVL.act_c.cd, FP.sg);
        icvl.wfhl       = or_aptow(GEOVL.act_c.ahl, icv.phead,      icv.ps,     GEOVL.act_c.cd, FP.sg);

        % xbi loop
        % Inputs:  pr, ps, prod, ehsv.wfs
        % Outputs:   xbi, pd, xreg, disp, px, wfx, wflkout
        icv.ebi = iterateInit(GEOV.bi.xmax, GEOV.bi.xmin, 1, 'xbi_ebi');
        while (abs(icv.ebi.e) > 1e-13  && icv.ebi.count<50 && abs(icv.ebi.dx)>0)
            icv.ebi.count   = icv.ebi.count+1;
            icv.bi.x        = icv.ebi.x;
            icv.x3_xbi      = icv.ebi.x;
            
            % pd loop
            % Inputs:  pr, ps, prod, ehsv.wfs, xbi
            % Outputs:   pd, xreg, disp, px, wfx, wflkout, wfr, wfs
            % icv.pump.pd     = icv.x4_pd;
            icv.epx = iterateInit(6000, icv.ps, 1, 'pd_epx');
            while (abs(icv.epx.e   ) > 1e-11  && icv.epx.count<50 && abs(icv.epx.dx)>0)
                icv.epx.count  = icv.epx.count+1;
                icv.pump.pd     = icv.epx.x ;
                icv.x4_pd       = icv.epx.x ;
                
                % Pump disp loop
                % Inputs:    pr, ps, pd, prod, ehsv.wfs, xbias
                % Outputs:   xreg, disp, px, wfx, wflkout
                icv.reg.x           = max(min(((icv.x4_pd-icv.ps)*RGEO.ahs + RGEO.fspr - GEOV.fsb - GEOV.ksb*icv.bi.x)/(GEOV.ksb+RGEO.ks), RGEO.xmax), RGEO.xmin);
                icv.x_xreg          = icv.reg.x;
                icv.pump.N          = icv.N;
                icv.pump.ps         = icv.ps;
                [RGEO.as, RGEO.ad]  = ven_reg_win(icv.reg.x, RGEO.win);
                icvl.ehsv.wfllk     = GEOVL.ehsv_klk * FP.sg *((icv.x4_pd - icv.ps) / FP.avis)^GEOVL.ehsv_powlk;
                icvl.ehsv.wfsh  = or_aptow(icvl.ehsv.ash,   icv.x4_pd,     icv.phead,   GEOVL.ehsv.cd, FP.sg);
                icvl.ehsv.wfsr  = or_aptow(icvl.ehsv.asr,   icv.x4_pd,     icv.x2_prod, GEOVL.ehsv.cd, FP.sg);
                icvl.ehsv.wflk  = abs(la_kptow(GEOVL.ehsv.kel, icv.x4_pd, icv.ps, FP.kvis));
                icvl.ehsv.wfj   = abs(or_aptow(GEOVL.ehsv.ael, icv.x4_pd, icv.ps, GEOVL.ehsv.cdl, FP.sg));
                icvl.ehsv.wfr   = icvl.ehsv.wfsr    - icvl.ehsv.wfrd;
                icvl.ehsv.wfh   = icvl.ehsv.wfsh    - icvl.ehsv.wfhd;
                icvl.ehsv.wfd   = icvl.ehsv.wflk    + icvl.ehsv.wfj + icvl.ehsv.wfrd + icvl.ehsv.wfhd;
                icvl.ehsv.wfs   = icvl.ehsv.wflk    + icvl.ehsv.wfj + icvl.ehsv.wfsr + icvl.ehsv.wfsh;
                icvl.wfl            = icvl.ehsv.wfs     + icvl.ehsv.wfllk;
                icv.epcham  = iterateInit(0.30, 0.02, 1, 'disp_pcham');
                while (abs(icv.epcham.e      ) > 1e-15  && icv.epcham.count<50 && abs(icv.epcham.dx)>0)
                    icv.epcham.count= icv.epcham.count+1;
                    icv.pump.disp   = icv.epcham.x;
                    icv.x5_disp     = icv.pump.disp;
                    icv.pump        = calc_pos_pump_a(GEOP, icv.pump, FP); % inputs:   N, pd, ps, disp  % outputs:  wf
                    icv.pump.pa.x   = asin(icv.pump.disp/ GEOV.cdv);
                    icv.pump.theta  = 180 / pi * icv.pump.pa.x;
                    icv.tqrs        = interp1(GEOV.ytqrs(:,1),  GEOV.ytqrs(:,2), icv.pump.theta, 'linear');
                    icv.ftpa        = interp1(GEOV.ytqa(:,1),   GEOV.ytqa(:,2),  icv.pump.theta, 'linear') * PAGEO.ah / GEOV.cftpa;
                    icv.tqpv        = GEOV.ctqpv * (icv.x4_pd - icv.ps);
                    icv.tqa         = icv.tqrs + icv.tqpv;
                    icv.px          = icv.ps + icv.tqa/icv.ftpa;
                    icv.x_px        = icv.px;
                    icv.pa.x        = icv.pump.pa.x;
                    icv.reg.wfs     = or_aptow(RGEO.as, icv.x4_pd, icv.px, RGEO.cd, FP.sg);
                    icv.reg.wfd     = or_aptow(RGEO.ad, icv.px, icv.ps, RGEO.cd, FP.sg);
                    icv.reg.wfx     = icv.reg.wfs - icv.reg.wfd;
                    icv.wfx         = icv.reg.wfx;

                    icv.epcham.e    = (icv.pump.wf - icv.reg.wfs - icvl.ehsv.wfs - icvl.ehsv.wfllk);
                    icv.epcham = iterate(icv.epcham, MOD.verbose>3, 6, 0);
                end   % epcham
                
                icv.x_disp      = icv.epcham.x;
                icv.e_regf      = 0;
                icv.e_px        = 0;
                icv.wflkout     = la_lrecptow(GEOV.leako.l, GEOV.leako.r, GEOV.leako.ecc, GEOV.leako.rad_clear, icv.px, icv.ps, FP.kvis);
                icv.epx.e   = -(icv.wflkout - icv.wfx);
                icv.epx = iterate(icv.epx, MOD.verbose>3, 6, 0);
            end % epx
            

            icv.ebi.e   = ((icv.bi.x+icv.reg.x)*GEOV.ksb - (icv.x2_prod-icv.ps)*(BIGEO.ah-BIGEO.ar) + GEOV.fsb);
            icv.ebi = iterate(icv.ebi, MOD.verbose>3, 6, 1);
        end % ebi
        
        icv.eprod.e     = -(icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfb - icvl.wfrl);
        icv.eprod = iterate(icv.eprod, MOD.verbose>3, 5, 1);
    end % eprod
    
    icv.wfs         = icv.pump.wf   + icv.pa.wfr      - icv.reg.wfd  - icv.reg.wfde   + icv.reg.wflr  - icv.reg.wfld -...
        icv.reg.wfle  + icv.bi.wfh      + icv.bi.wfr   - icv.start.wfvx - icv.wflkout;
    icv.wfr         = icvl.ehsv.wfd + icvl.ehsv.wfllk + icvl.wfrl    + icvl.wfhl;
    ic.wfr          = icv.wfr;
    ic.wfs          = icv.wfs;
    icv.eall.e  = -(icvl.ehsv.wfsh - icvl.ehsv.wfhd + icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfrl - icvl.wfhl);
    icv.eall = iterate(icv.eall, MOD.verbose-MOD.linearizing>2, 12, 1);  % Poorly behaved, use successive approximations (16)
    if MOD.verbose>4, fprintf('p-prm,ps-psm,wfr-wfrm,wfs-wfsm=%f,%f,%f,%f\n', icv.pr-icv.prm, icv.ps-icv.psm, icv.wfr-icv.wfrm, icv.wfs-icv.wfsm); end
end % eall


% This recalculation makes a useful double-check of the script
icv.e1_eall     = -(icvl.ehsv.wfsh - icvl.ehsv.wfhd + icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfrl - icvl.wfhl);
icv.e2_eprod    = -(icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfb - icvl.wfrl);
icv.e3_ebi      = ((icv.bi.x+icv.reg.x)*GEOV.ksb - (icv.x2_prod-icv.ps)*(BIGEO.ah-BIGEO.ar) + GEOV.fsb);
icv.e4_epx      = -(icv.wfx - icv.wflkout);
icv.e5_epcham   = (icv.pump.wf - icv.reg.wfs - icvl.ehsv.wfs - icvl.ehsv.wfllk);
icv.e_regf      = -((icv.x4_pd-icv.ps)*RGEO.ahs + RGEO.fspr - GEOV.fsb - GEOV.ksb*icv.bi.x - (GEOV.ksb+RGEO.ks)*icv.reg.x);
icv.e_pumpf     = (icv.px-icv.ps)*icv.ftpa - icv.tqa;

% Assign
icv.disp        = icv.x_disp;
icv.pd          = icv.x4_pd;
icv.prod        = icv.x2_prod;
icvl.mA         = icvl.ehsv.x/GEOVL.ehsv.kix + GEOVL.ehsv.mAnull;
icv.mA          = icvl.mA;
icv.vo_pcham.p  = icv.x4_pd;
icv.vo_pcham.wf = icv.pump.wf;
icv.vo_px.p     = icv.px;
icv.vo_px.wf    = icv.wflkout;
icvl.vo_hcham.p = icv.phead;
icvl.vo_hcham.wf= 0;
icvl.vo_rcham.p = icv.x2_prod;
icvl.vo_rcham.wf= 0;
icvl.hline.p    = icv.phead;
icvl.hline.wf   = -(icvl.ehsv.wfhd-icvl.ehsv.wfsh);
icvl.rline.p    = icv.x2_prod;
icvl.rline.wf   = icvl.ehsv.wfsr-icvl.ehsv.wfrd;
icv.wfl         = icvl.ehsv.wfs + icvl.ehsv.wfllk + icv.start.wf;

ic.F.VEN_LOAD_X = icv.fxven + Z.dFXVENX;
ic.F.A8_TM_DEM  = icv.mA;
ic.F.VEN_LOAD_Xl = max(min(ic.F.VEN_LOAD_X, max(F.A8_GAIN_SCH_Y)), min(F.A8_GAIN_SCH_Y));
ic.F.VEN_LOAD_Xln= max(min(ic.F.VEN_LOAD_X, max(F.A8_NULL_SHIFT(:,1))), min(F.A8_NULL_SHIFT(:,1)));
ic.F.A8_GAIN    = interp2(F.A8_GAIN_SCH_X, F.A8_GAIN_SCH_Y, F.A8_GAIN_SCH_Z', 0, ic.F.VEN_LOAD_Xl);
ic.F.A8_NULL    = interp1(F.A8_NULL_SHIFT(:,1), F.A8_NULL_SHIFT(:,2), ic.F.VEN_LOAD_Xln); 
ic.F.A8_ERR     = (ic.F.A8_NULL+F.A8_NULL_ADJ-ic.F.A8_TM_DEM)/F.A8_GAIN_ADJ/ic.F.A8_GAIN;
ic.F.A8_REF     = (4.7-Z.xven)/4.7*100 - ic.F.A8_ERR;

if MOD.verbose>2
    fprintf('%s: ', str);
    fprintf('%12.8f, ',     icv.x1_xehsv,   icv.x2_prod,    icv.x3_xbi,     icv.x4_pd,      icv.x5_disp,    icv.x_xreg, icv.x_px);
    fprintf('-->');
    fprintf('%12.8f, ',     icv.e1_eall,    icv.e2_eprod,   icv.e3_ebi,     icv.e4_epx,     icv.e5_epcham,  icv.e_regf, icv.e_pumpf);  fprintf('\n');
end

% Re-assign
ic.venstart         = icv;
ic.venstart.load    = icvl;
return

function ice = iterateInit(xmax, xmin, eInit, str)
% function ice = iterateInit(xmax, xmin, eInit)
% Generic iteration initializer
% Inputs: 
%   xmax    Maximum value of x
%   min     Minimum value of x
%   eInit   Initial error
% Outputs:
%   ice     Initialized structure

ice.xmax    = xmax;
ice.xmin    = xmin;
ice.e       = eInit;
ice.ep      = eInit;
ice.xp      = ice.xmax;
ice.x       = ice.xmin;   % Do min and max first
ice.dx      = ice.x - ice.xp;
ice.de      = ice.e - ice.ep;
ice.count   = 0;
ice.str     = str;

return

function ice = iterate(ice, verbose, succCount, enNoSoln)
% function ice = iterate(ice, verbose)
% Generic iteration calculation, method of successive approximations for
% succCount then Newton-Rapheson as needed - works with iterateInit.
% Inputs: ice.e
% Outputs: ice.x
ice.de   = ice.e - ice.ep;
ice.des  = sign(ice.de)*max(abs(ice.de), 1e-16);
ice.dx   = ice.x - ice.xp;
if verbose
    fprintf('%s(%ld): %12.8f/%12.8f/%12.8f ', ice.str, ice.count, ice.xmin, ice.x, ice.xmax);
    fprintf('%12.8f      /%12.8f/%12.8f ', ice.e, ice.des, ice.dx);  fprintf('\n');
end

% Check min max sign change
if ice.count == 2
    ice.noSoln = 0;  % initialize
    if ice.e*ice.ep >= 0  && enNoSoln  % No solution possible
        ice.noSoln = 1;
        if abs(ice.ep) < abs(ice.e)
            ice.x   = ice.xp;
        end
        ice.ep  = ice.e;
        ice.limited = 0;
        if verbose
            fprintf('%s:  No solution.  Leaving x at most likely limit value and recalculating...\n', ice.str);
        end
        return
    else
        ice.noSoln = 0;
    end
end
if ice.count==3 && ice.noSoln  % Stop after recalc and noSoln
    ice.e = 0;
    return
end
ice.xp  = ice.x;
ice.ep  = ice.e;
if ice.count == 1
    ice.x   = ice.xmax;  % Do min and max first
else
    if ice.count > succCount
        ice.x = max(min(ice.x - ice.e/ice.des*ice.dx, ice.xmax),ice.xmin);
        if ice.e > 0
            ice.xmax    = ice.xp;
        else
            ice.xmin    = ice.xp;
        end
    else
        if ice.e > 0
            ice.xmax    = ice.xp;
            ice.x       = (ice.xmin + ice.x)/2;
        else
            ice.xmin    = ice.xp;
            ice.x       = (ice.xmax + ice.x)/2;
        end
    end
    if ice.x==ice.xmax || ice.x==ice.xmin
        ice.limited = 0;
    else
        ice.limited = 1;
    end
end 
return

function h = holeArea(x, d)
% Hole area
r       = d/2;
x       = max( (min(x, d-1e-16)), 1e-16);
frac    = 1 - x / r;
if frac>1e-16
    h    = atan( sqrt(1 - frac*frac) / frac);
else if(frac < -1e-16)
        h    = pi + atan( sqrt(1 - frac*frac) / frac);
    else
        h    = pi / 2;
    end
end
h    = r * r * h   -   (r - x) * sqrt(x * (2*r - x));
h = max(h, 1e-16);
return

function [ic, GEO] = init_Engine_FuelSys(ic, Z, E, FP, GEO, MOD)
% Initialize engine
% Inputs:  wf36, xn25
% Outputs: t25, pr=pb1, ps=pb2
ic.eng.wf36     = Z.wf36;
ic.eng.xn25     = Z.xn25;

ic.eng.pcn25    = ic.eng.xn25/E.N25100Pct*100;
ic.eng.dpnoz    = interp1(E.dpnoz(:,1), E.dpnoz(:,2), ic.eng.wf36, 'linear', 'extrap');
ic.eng.ps3      = interp1(E.ps3(:,1), E.ps3(:,2), ic.eng.wf36, 'linear', 'extrap');
ic.eng.pcn25r   = interp1(E.pcn25r(:,1), E.pcn25r(:,2), ic.eng.wf36, 'linear', 'extrap');
ic.eng.t25      = ((ic.eng.pcn25*E.N25100Pct)/(ic.eng.pcn25r*E.N25c100Pct))^2*MOD.ctstd;
ic.eng.pnozin   = min((ic.eng.wf36/540)^2*130, ic.eng.dpnoz+ic.eng.ps3);
ic.eng.dpcd     = max(or_awtop(GEO.c_d.Ao, ic.eng.wf36, 0, GEO.c_d.cd, FP.sg), 40);
ic.eng.pcd      = ic.eng.pnozin+ic.eng.dpcd;
ic.pd           = ic.eng.pcd;
ic.vo_pnozin.p  = ic.eng.pnozin;
ic.vo_pnozin.wf = ic.eng.wf36;
ic.main_line.p  = ic.eng.pcd;
ic.main_line.wf = ic.eng.wf36;
ic.xn25                 = ic.eng.xn25;
ic.acboost.acbst.NRpm   = ic.eng.xn25*Z.sAC;
ic.acboost.acmbst.NRpm  = ic.eng.xn25*Z.sAC;
try
    ic.acboostg.acbst.NRpm   = GEO.acboostg.acbst.Npump*Z.sAC;
    ic.acboostg.acmbst.NRpm  = GEO.acboostg.acbst.Npump*Z.sAC; % not used
    ic.acboosti.acbst.NRpm   = ic.eng.xn25*Z.sAC;
    ic.acboosti.acmbst.NRpm  = ic.eng.xn25*Z.sAC;
catch ERR
    ic.acboostg.acbst.NRpm   = ic.acboost.acbst.NRpm;
    ic.acboostg.acmbst.NRpm  = ic.acboost.acmbst.NRpm; 
    ic.acboosti.acbst.NRpm   = ic.acboost.acbst.NRpm;
    ic.acboosti.acmbst.NRpm  = ic.acboost.acmbst.NRpm;
end
ic.pamb         = Z.pamb;
ic.ptank        = ic.pamb+3;
ic.wfb = 0;   %***********TODO add thermal bypass model
% ic.wf1mv        = DS.V.wf1mv(initInd, 2);
% ic.wf1s         = DS.V.wf1s(initInd, 2);
% ic.wf1w         = DS.V.wf1w(initInd, 2);

% Supply
ic.wf1v     = 0;
ic.wfc      = 0;  % init
ic.wfccvg   = 0;  % init
ic.wfcfvg   = 0;  % init
ic.wf1cvg   = 0;  % init
ic.wf1fvg   = 0;  % init


% Initialize aircraft supply system
% Inputs:   pamb, wfengine=wfac=wf36, xn25 et.al.
% Outputs:  pengine
[ic.acboost,  GEO.acboost]    = F414_Fuel_System_Init_AC_(ic.acboost,   ic.ptank, ic.eng.ps3, ic.eng.wf36, GEO.acboost,  FP);
try
    [ic.acboostg, GEO.acboostg]   = F414_Fuel_System_Init_AC_g(ic.acboostg, ic.ptank, ic.eng.ps3, ic.eng.wf36, GEO.acboostg, FP);
catch ERR
    ic.acboostg     = ic.acboost;
    GEO.acboostg    = GEO.acboost;
    GEO.acboostg.lmp1   = GEO.acboost.ltank;
    GEO.acboostg.lmp2   = GEO.acboost.ltank;
    GEO.acboostg.lextra = GEO.acboost.ltank;
    GEO.acboostg.vo_pah = GEO.engboost.vo_poc;
    GEO.acboostg.a_drop.Ao       = 0;
    GEO.acboostg.a_drop.cd       = 1;
    ic.acboostg.lmp1    = ic.acboost.ltank;
    ic.acboostg.lmp2    = ic.acboost.ltank;
    ic.acboostg.lextra  = ic.acboost.ltank;
    ic.acboostg.vo_pah.p = 0;
    ic.acboostg.vo_pah.wf = 0;
end
try
    [ic.acboosti, GEO.acboosti]   = F414_Fuel_System_Init_AC_i(ic.acboosti, ic.ptank, ic.eng.ps3, ic.eng.wf36, GEO.acboosti, FP);
catch ERR
    ic.acboosti     = ic.acboost;
    GEO.acboosti    = GEO.acboost;
end
switch(Z.selectAC)
    case {0, -1}  %     -400
        ic.pengine  = ic.acboost.pengine;
    case 1  % Gripen
        ic.pengine = ic.acboostg.pengine;
    case 2  % INS6
        ic.pengine = ic.acboosti.pengine;
end
ic.engboost.pengine = ic.pengine;
ic.venstart.pengine = ic.pengine;
ic.wfmd             = ic.eng.wf36;


% Initialize fuel system loop
% Loop to solve P1 f(wf1leak)
ic.countlk  = 0;
ic.wf1vg    = 0;        % TODO add wf1vg (FVG+CVG) to iteration and model
ic.wf1leak   = ic.wf1vg;
ic.wf1leakm  = -1000;
% if MOD.verbose-MOD.linearizing > 0, fprintf('\n'); end

while (abs(ic.wf1leak - ic.wf1leakm)>1e-16 && ic.countlk<25)
    ic.wf1leakm  = ic.wf1leak;
    ic.countlk  = ic.countlk + 1;
    % check valve
    if(ic.xn25 >= 9466.)
        ic.wf1cx    = ic.wfmd + ic.wf1vg + ic.wf1v + ic.wfc;
    else
        ic.wf1cx    = 0.;
    end
    % Initialize installed engine pump system
    % Inputs:   pengine, wf1cx, wf1v, wfb, wfs, wfr
    % Outputs:  wfengine, p1, psven=pb1, prven=pb2
    ic          = F414_Fuel_System_Init_BOOST_INST_(ic, GEO, E, FP);
    ic.pmainp   = ic.engboost.mfp.ps;
    ic.p1       = ic.engboost.mfp.pd;
    % Initialize IFC
    % Inputs:   p1, wfmd=wf36, pd, wf1vg=wf1cvg+wf1fvg, wf1v=wfstart, pc, awfb
    % Outputs:  wf1c, wfb
    ic.precx    = Z.pamb;
    ic.pc       = ic.pmainp;
    ic.eng.wf36 = ic.eng.wf36;
    ic.vo_p1.p  = ic.p1;
    ic.vo_p1.wf = ic.wf1leak;
    ic.precx    = Z.precx;
    ic.ifc.p1   = ic.p1;
    ic          = F414_Fuel_System_Init_IFC_(ic, GEO, Z, FP, MOD);
    ic.wf1leak  = ic.wfc + ic.wf1vg;
    if MOD.verbose-MOD.linearizing > 3
        fprintf('    (%ld):  wf1leak=%f/%f\n', ic.countlk, ic.wf1leak, ic.wf1leakm);
    end
end
if ic.countlk >=25
    fprintf('\n*****WARNING(%s):  loop counter maximum.    wf1leak=%f, wf1leakm=%f\n', mfilename, ic.wf1leak, ic.wf1leakm);
end
% end loop

return
function [ic, GEO] = F414_Fuel_System_Init_AC_(ic, ptank, ps3, wf36, GEO, FP)
%%function ic = F414_Fuel_System_Init_AC_(ic)
% 29-Apr-2012   DA Gutz     Created


% Inputs:   pamb, wfengine=wfac=wf36, xn25 et.al.
% Outputs:  pengine

% Outputs

% Name changes
acb     = GEO.acbst;
acmb    = GEO.acmbst;
amotor  = GEO.motor;
iacb    = ic.acbst;
iacmb   = ic.acmbst;

ic.ltank.wf     = wf36;
ic.lengine.wf   = wf36;
iltank  = ic.ltank;
ilengine = ic.lengine;
Qac_init   = wf36 / FP.dwdc;
iacb.q     = Qac_init;
S_init = 0.5;  %initial loop value
S_max  = 1;
S_min  = 0;
count  = 0;

% AC tank pressure
Pac    = ps3;    %(Add to upper level)
Pacm   = ptank;      %(Add to upper level)

% Top of loop
% fprintf('pass  Pac    Pacm    S_now S_max  S_min\n');
while (abs(Pac - Pacm)>1e-6 && S_init<1 && count<50)
    iacmb.q             = Qac_init * S_init;
    imotor.wf           = iacmb.q * FP.dwdc;
        
    % Calculate pressures
    Pac_init            =ptank;
    
    % Pump pressure
    fcx             = 5.851 * Qac_init / (3.85 * acb.w2 * acb.r2^2 * iacb.NRpm);
    hcx             = acb.a + (acb.b + (acb.c + acb.d * fcx) * fcx) * fcx;
    iacb.dP_Pump    = 1.022e-6 * hcx * FP.sg * (acb.r2^2 - acb.r1^2) * iacb.NRpm^2;
    iacb.Pd_Pump    = ptank + iacb.dP_Pump;
    fcx             = 5.851 * Qac_init / (3.85 * acmb.w2 * acmb.r2^2 * iacmb.NRpm);
    hcx             = acmb.a + (acmb.b + (acmb.c + acmb.d * fcx) * fcx) * fcx;
    iacmb.dP_Pump   = 1.022e-6 * hcx * FP.sg * (acmb.r2^2 - acmb.r1^2) * iacmb.NRpm^2;
    iacmb.Pd_Pump   = iacb.Pd_Pump + iacmb.dP_Pump;
    clear fcx hcx
    
    %%%Orifice:(Q, Area) --> dP
    imotor.dP       = sign(Qac_init) * amotor.dp*(imotor.wf/amotor.wf)^2;

    ilengine.p      = iacmb.Pd_Pump - imotor.dP;
    Pac             = iacb.Pd_Pump;
    Pacm            = ilengine.p;
    count           = count + 1;
    S_now           = S_init;
%     fprintf('%ld   %5.1f   %5.1f  %5.2f %5.2f  %5.2f\n', count, Pac, Pacm, S_now, S_max, S_min);
    if Pacm > Pac
        S_init  = (S_now + S_max)/2;
        S_min   = max(S_min, S_now);
    else
        S_init  = (S_now + S_min)/2;
        S_max   = min(S_max, S_now);
    end
    
end
% fprintf('pass  Pac    Pacm    S_now S_max  S_min\n');
iltank.p            = Pac_init;
iltank.wf           = iacb.q * FP.dwdc;
ic.pengine          = ilengine.p;
ic.wfbypass         = iacb.q * FP.dwdc * (1-S_init);
ic.wfacbst          = iacb.q * FP.dwdc;
ic.wfacmbst         = iacmb.q * FP.dwdc;
iacb.Ps_Pump        = Pac_init;
ic.ltank.p  = Pac_init;
ic.pacbsts          = Pac_init;
ic.pacbst           = iacb.Pd_Pump;
ic.pacmbst          = iacmb.Pd_Pump;
ic.ptank            = ptank;
GEO.acbst   = acb;
GEO.acmbst  = acmb;
GEO.motor   = amotor;
ic.acbst    = iacb;
ic.acmbst   = iacmb;
ic.motor    = imotor;
ic.ltank    = iltank;
ic.lengine  = ilengine;
ic.S_init   = S_init;


function ic = F414_Fuel_System_Init_BOOST_(ic, GEO, E, FP)
%%function [ic, GEOE] = F414_Fuel_System_Init_BOOST_(ic, GEO, E, FP)
% 29-Apr-2012   DA Gutz     Created
% 05-Jun-2017   DA Gutz     PB1,PB2 names


% Inputs:   pengine, wf1mv, wf1cvg, wf1fvg, wf1v, wfb, wfs, wfr, wf1s
% Outputs:  wfengine, p1, pb2, prven=pb2

% Name changes
ice = ic.engboost;
icv = ic.venstart;
GEOE = GEO.engboost;
GEOV = GEO.venstart;
ice.wfr     = ic.wfr;
ice.wfs     = ic.wfs;

ice.mfp.N  = ic.xn25 * E.xnmainpt/E.xn25p;
icv.boost.N  = ic.xn25 * E.xnvent/E.xn25p;

% Loop to solve P1 f(wf1leak)
ice.count   = 0;
ic.wf1leak  = 0;
ic.wf1leakm = -1000;
while (abs(ic.wf1leak - ic.wf1leakm)>1e-16 && ice.count<25)
    % Check valve
    if(ic.xn25 >= 9466.)
        ic.wf1cx    = ic.wf1mv + ic.wf1leak + ic.wf1cvg + ic.wf1fvg + ic.wf1s + ic.wf1v;
    else
        ic.wf1cx    = 0.;
    end
    ic.wf1leakm     = ic.wf1leak;
    ice.count       = ice.count + 1;
    ic.wf1p         = ic.wf1cx + ic.wfb;
    ic.wfoc         = ic.wf1p - ic.wfccvg - ic.wfcfvg - ic.wfc - ic.wf1leak;
    ic.wffilt       = ic.wfoc + ic.wfs;
    ic.wfb2         = ic.wffilt - ice.wfr;
    ic.wfengine     = ic.wfb2;
    [~, icv.boost.dp] = ip_wtodp(GEOV.boost.a, GEOV.boost.b, GEOV.boost.c, GEOV.boost.d, GEOV.boost.r1, GEOV.boost.r2, GEOV.boost.r2, GEOV.boost.w2, icv.boost.N, ic.wfb2, FP.sg, GEOV.boost.tau);
    ic.pb1          = ic.pengine + icv.boost.dp;
    icv.filt.dp     = ic.pb1-or_awtop(GEOV.filt.Ao,  -ic.wffilt, ic.pb1, GEOV.filt.cd, FP.sg);
    ic.pb2          = ic.pb1 - icv.filt.dp;
    ice.focOr.dp    = ic.pb2-or_awtop(GEOE.focOr.Ao, -ic.wfoc,   ic.pb2, GEOE.focOr.cd, FP.sg);
    ic.poc          = ic.pb2 - ice.focOr.dp;
    [~, ice.mfp.dp] = ip_wtodp(GEOE.mfp.a, GEOE.mfp.b, GEOE.mfp.c, GEOE.mfp.d, GEOE.mfp.r1, GEOE.mfp.r2, GEOE.mfp.r2, GEOE.mfp.w2, ice.mfp.N, ic.wf1p, FP.sg, GEOE.mfp.tau);
    ic.p1           = ice.mfp.dp + ic.poc;
    ice.wf1leako    = or_aptow(GEOE.wf1leak.Ao, ic.p1, ic.poc, 0.61, FP.sg);
    ice.wf1leakl    = la_kptow(GEOE.wf1leak.k,  ic.p1, ic.poc, FP.kvis);
    ic.wf1leak      = ice.wf1leako + ice.wf1leakl;
end
if ice.count >=25
    fprintf('\n*****WARNING(%s):  loop counter maximum.    wf1leak = %f, wf1leakm = %f\n', mfilename, ic.wf1leak, ic.wf1leakm);
end
% end loop

% Assign
ice.wf1leak     = ic.wf1leak;
ice.inlet.wf    = ic.wfengine;
ice.inlet.p     = ic.pengine;
icv.pengine     = ic.pengine;
icv.boost.wf    = ic.wfb2;
icv.boost.ps    = ic.pengine;
icv.boost.pd    = ic.pb1;
icv.vo_pb1.p    = ic.pb1;
icv.filt.wf     = ic.wffilt;
icv.filt.p      = ic.pb1;
icv.filt.ps     = ic.pb1;
icv.filt.pd     = ic.pb2;
icv.vo_pb2.p    = ic.pb2;
icv.vo_pb2.wf   = ic.wffilt;
ice.fab.wf      = ic.wffilt - ic.wfs;
ice.fab.p       = ic.pb2;
ice.aboc.p      = ic.pb2;
ice.aboc.wf     = ic.wffilt - ic.wfs;
ice.faboc       = ice.aboc;
ice.vo_poc.p    = ic.poc;
ice.vo_poc.wf   = ic.wfoc;
ice.focOr.wf    = ic.wfoc;
ic.wfabocx1     = ic.wfoc;
ic.wfocmx1      = ic.wfoc;
ice.focOr.ps    = ic.pb2;
ice.focOr.pd    = ic.poc;
ice.ocm1.p      = ic.poc;
ice.ocm1.wf     = ic.wfocmx1;
ice.ocm2.p      = ic.poc;
ice.ocm2.wf     = ic.wf1p;
ice.mfp.ps      = ic.poc;
ice.mfp.pd      = ic.p1;
ice.wf1leak.wf  = ic.wf1leak;
ice.wf1leak.ps  = ic.p1;
ice.wf1leak.pd  = ic.poc;
ice.mfp.wf      = ic.wf1p;

% Re-assign
ic.engboost = ice;
ic.venstart = icv;
function ic = F414_Fuel_System_Init_BOOST_INST_(ic, GEO, E, FP)
%%function [ic, GEOE] = F414_Fuel_System_Init_BOOST_INST_(ic, GEO, E, FP)
% 29-Apr-2012   DA Gutz     Created
% 05-Jun-2017   DA Gutz     PB1,PB2 names


% Inputs:   pengine, wfc, wfcvg, wfb, wfs, wfr
% Outputs:  wfengine, p1, pb2, prven=pb1

% Name changes
ice = ic.engboost;
icv = ic.venstart;
GEOE = GEO.engboost;
GEOV = GEO.venstart;
ice.wfr     = ic.wfr;
ice.wfs     = ic.wfs;

ice.mfp.N  = ic.xn25 * E.xnmainpt/E.xn25p;
icv.boost.N  = ic.xn25 * E.xnvent/E.xn25p;

ic.wf1p         = ic.wf1cx + ic.wfb;
ic.wfoc         = ic.wf1p - ic.wfccvg - ic.wfcfvg - ic.wfc;
ic.wffilt       = ic.wfoc + ic.wfs;
ic.wfb2         = ic.wffilt - ice.wfr;
ic.wfengine     = ic.wfb2;
[~, icv.boost.dp] = ip_wtodp(GEOV.boost.a, GEOV.boost.b, GEOV.boost.c, GEOV.boost.d, GEOV.boost.r1, GEOV.boost.r2, GEOV.boost.r2, GEOV.boost.w2, icv.boost.N, ic.wfb2, FP.sg, GEOV.boost.tau);
ic.pb1          = ic.pengine + icv.boost.dp;
icv.filt.dp     = ic.pb1-or_awtop(GEOV.filt.Ao, -ic.wffilt, ic.pb1, GEOV.filt.cd, FP.sg);
ic.pb2          = ic.pb1 - icv.filt.dp;
ice.focOr.dp    = ic.pb2-or_awtop(GEOE.focOr.Ao, -ic.wfoc, ic.pb2, GEOE.focOr.cd, FP.sg);
ic.poc          = ic.pb2 - ice.focOr.dp;
[~, ice.mfp.dp] = ip_wtodp(GEOE.mfp.a, GEOE.mfp.b, GEOE.mfp.c, GEOE.mfp.d, GEOE.mfp.r1, GEOE.mfp.r2, GEOE.mfp.r2, GEOE.mfp.w2, ice.mfp.N, ic.wf1p, FP.sg, GEOE.mfp.tau);
ic.p1           = ice.mfp.dp + ic.poc;

% Assign
ice.inlet.wf    = ic.wfengine;
ice.inlet.p     = ic.pengine;
icv.pb1         = ic.pb1;
icv.boost.wf    = ic.wfb2;
icv.boost.ps    = ic.pengine;
icv.boost.pd    = ic.pb1;
icv.vo_pb1.p    = ic.pb1;
icv.vo_pb1.wf   = ic.wffilt;
icv.filt.wf     = ic.wffilt;
icv.filt.p      = ic.pb1;
icv.filt.ps     = ic.pb1;
icv.filt.pd     = ic.pb2;
icv.vo_pb2.p    = ic.pb2;
icv.vo_pb2.wf   = ic.wffilt;
ice.fab.wf      = ic.wffilt - ic.wfs;
ice.fab.p       = ic.pb2;
ice.aboc.p      = ic.pb2;
ice.aboc.wf     = ic.wffilt - ic.wfs;
ice.faboc       = ice.aboc;
ice.vo_poc.p    = ic.poc;
ice.vo_poc.wf   = ic.wfoc;
ice.focOr.wf    = ic.wfoc;
ic.wfabocx1     = ic.wfoc;
ic.wfocmx1      = ic.wfoc;
ice.focOr.ps    = ic.pb2;
ice.focOr.pd    = ic.poc;
ice.ocm1.p      = ic.poc;
ice.ocm1.wf     = ic.wfocmx1;
ice.ocm2.p      = ic.poc;
ice.ocm2.wf     = ic.wf1p;
ice.mfp.ps      = ic.poc;
ice.mfp.pd      = ic.p1;
ice.mfp.wf      = ic.wf1p;

% Re-assign
ic.engboost = ice;
ic.venstart = icv;
function ic = F414_Fuel_System_Init_IFC_(ic, GEO, Z, FP, MOD)
%%function [ic, GEOE] = F414_Fuel_System_Init_IFC_(ic, GEO, Z, FP, MOD)
% 29-Apr-2012   DA Gutz     Created


% Initialize IFC
% Inputs:   p1, wfmd=wf36, pd, wf1vg=wf1cvg+wf1fvg, wf1v=wfstart, pc, awfb
% Outputs:  wf1c, wfb

% Name changes
icf         = ic.ifc;
GEOF        = GEO.ifc;
icf.p1      = ic.p1;
icf.wf1vg   = ic.wf1cvg + ic.wf1fvg;
icf.wf1f    = ic.wf1v;
icf.pc      = ic.pc;
icf.pd      = ic.pd;
icf.precx   = ic.precx;
icf.wfmd    = ic.eng.wf36;
icf.wf1v    = ic.wf1v;
icf.mvtv.pd = ic.pd;

%  Thermal bypass valve
icf.wfb     = or_aptow(Z.awfb, icf.p1, icf.precx, 1., FP.sg);
 
% Loop to solve p1c, xtv, px, and xhs
if MOD.verbose-MOD.linearizing > 3
    fprintf('\n');
end
try temp = icf.wf1w; %#ok<NASGU>
catch ERR %#ok<NASGU>
    icf.wf1w    = 0;
    ic.p1c      = icf.p1;
    ic.px       = ic.p1c-200;
    ic.xtv      = 0;
    ic.xhs      = 0;
    icf.wf1leak = 0;
end
ic.xtvm     = 0;
ic.xhsm     = 0;
ic.pxm      = -1000;
ic.p1cm     = -1000;
icf.wftvb   = 0;
ic.wftvbm   = -1000;
icf.count   = 0;
while ( (   abs(ic.p1c  - ic.p1cm)>1e-16 ||...
            abs(ic.xtv  - ic.xtvm)>1e-20 ||...
            abs(ic.px   - ic.pxm )>1e-20 ||...
            abs(icf.wftvb - ic.wftvbm )>1e-20 ||...
            abs(ic.xhs  - ic.xhsm)>1e-20) ...
            && icf.count<25 )
    icf.count   = icf.count + 1;
    ic.p1cm     = ic.p1c;
    ic.xtvm     = ic.xtv;
    ic.xhsm   	= ic.xhs;
    ic.pxm      = ic.px;
    ic.wftvbm   = icf.wftvb;

    icf.wf1cx   = icf.wfmd + icf.wf1vg - icf.wf1v + icf.wf1w + icf.wf1leak - icf.wftvb;

    % Check Valve
    ic.p1c      = icf.p1 - or_awtop(GEOF.check.ao, icf.wf1cx, 0., GEOF.check.cd, FP.sg);
    icf.p2      = ic.p1c;
    
    % PRT regulator
    icf.prt     = max(ic.p1c-(GEOF.prtv.fspr+0.01*GEOF.prtv.ks)/GEOF.prtv.ax1, icf.pc);

    % PR regulator
    icf.pr      = min(icf.pc+250, ic.p1c);
    
    %  Head sensor
    icf.lqx     = max(min(GEOF.hs.flap.ln/ic.xhs, GEOF.hs.flap.cf(end,1)), GEOF.hs.flap.cf(1,1));
    icf.hs.cf   = interp1(GEOF.hs.flap.cf(:,1), GEOF.hs.flap.cf(:,2), icf.lqx, 'linear', 'extrap');
    icf.p3      = icf.p2 + ((ic.px-icf.p2)*GEOF.hs.flap.an*(1+(icf.hs.cf*ic.xhs*4/GEOF.hs.flap.dn)^2)   ...
        - GEOF.hs.fspr - GEOF.hs.fb - ic.xhs*(GEOF.hs.ks + GEOF.hs.kb)) / GEOF.hs.ae;
    icf.p3mpd   = icf.p3 - icf.pd;
    icf.p2mp3   = icf.p2 - icf.p3;

    icf.wf1c        = icf.wf1cx + icf.wfb;
    icf.mv.wfd      = icf.wfmd;
    icf.mvtv.wfd    = icf.wfmd;
 
    %  Throttle valve
    icf.mvtv.ad = or_wptoa(icf.wfmd, icf.p3, icf.pd, GEOF.mvtv.cd, FP.sg);
    ic.xtv      = max(min(interp1(GEOF.mvtv.ad(:,2), GEOF.mvtv.ad(:,1), icf.mvtv.ad, 'linear', 'extrap'), GEOF.mvtv.xmax), GEOF.mvtv.xmin);
    ic.px      = (icf.p3*(GEOF.mvtv.ax1-GEOF.mvtv.ax4) - icf.prt*(GEOF.mvtv.ax1-GEOF.mvtv.ax2) - GEOF.mvtv.ks*ic.xtv - GEOF.mvtv.fspr) / GEOF.mvtv.ax2;
    icf.wftvb   = or_aptow(GEOF.a_tvb, icf.prt, ic.px, GEOF.cd_tvb, FP.sg);
    
    icf.wf1mv   = icf.wfmd;
    
    %  Metering valve
    icf.mv.a    = or_wptoa(icf.wf1mv, icf.p2, icf.p3, GEOF.mv.cd, FP.sg);
    icf.mv.x    = interp1(GEOF.mv.awin(:,2), GEOF.mv.awin(:,1), icf.mv.a);

    % MV Servovalve leakage f(p1c)
    icf.wf1leak   = or_aptow(GEOF.a1leak, icf.pr, icf.pc, 0.61, FP.sg) + ...
        la_kptow(GEOF.k1leak, icf.pr, icf.pc, FP.kvis);
    icf.wfr     = 0*(ic.p1c-icf.pc);       %  mvsv leakage estimate
    icf.wf1w    = icf.wfr;
    
    % Head sensor recalc for feedback
    icf.wfhs    = -icf.wftvb;
    ic.xhs      = GEOF.hs.flap.an*GEOF.hs.flap.cn/(icf.hs.cf*GEOF.hs.flap.dn*pi)/...
        sqrt( FP.sg*abs(ic.px-icf.p2)*(GEOF.hs.flap.an*GEOF.hs.flap.cn*19020/icf.wfhs)^2 - 1);
    ic.xhs      = max(min(ic.xhs, GEOF.hs.xmax), GEOF.hs.xmin);
    if MOD.verbose-MOD.linearizing > 4
        ic.wfcheck     = 19020*sqrt(FP.sg*abs(ic.px-icf.p2)/(1/(GEOF.hs.flap.an*GEOF.hs.flap.cn)^2 + 1/(icf.hs.cf*GEOF.hs.flap.dn*pi*ic.xhs)^2));
        fprintf('x=%16.12f, p2=%f, px=%f, wf=%f, wfcheck=%f\n', ic.xhs, icf.p2, ic.px, icf.wfhs, ic.wfcheck);
    end
    
    if MOD.verbose-MOD.linearizing > 4
        fprintf('IFC(%ld):  p1c=%f/%f, xtv=%14.12f/%14.12f, xhs=%14.12f/%14.12f, px=%f/%f\n', icf.count, ic.p1c, ic.p1cm, ic.xtv, ic.xtvm, ic.xhs, ic.xhsm, ic.px, ic.pxm);
    end
end
if icf.count >=25 && MOD.verbose-MOD.linearizing>3
    fprintf('\n*****WARNING(%s):  loop counter maximum.    p1=%f, p1m=%f, xtv=%14.12f, xtvm=%14.12f, xhs=%14.12f, xhsm=%14.12f\n', mfilename, ic.p1c, ic.p1cm, ic.xtv, ic.xtvm, ic.xhs, ic.xhsm);
end
% end loop

% Assign
icf.hs.x    = ic.xhs;
icf.mvtv.x  = ic.xtv;
icf.wf2s    = 0;
icf.wf3s    = 0;
icf.wfrt    = icf.wftvb;
icf.wfx     = icf.wftvb;
icf.wf1s    = -icf.wftvb;
icf.wfc     = -icf.wfrt + icf.wf1w + icf.wf1leak;
icf.p1c     = ic.p1c;
icf.px      = ic.px;
icf.xtv     = icf.mvtv.x;
icf.mvsv.x      = 0;
icf.vo_px1.wf   = 0;
icf.vo_px1.p    = (icf.pr+icf.pc)/2;
icf.vo_px2.wf   = 0;
icf.vo_px2.p    = (icf.pr+icf.pc)/2;
icf.check.x     = 0.31;
icf.ln_p3s.wf   = 0;
icf.ln_p3s.p    = icf.p3;
icf.vo_p3s.wf   = 0;
icf.vo_p3s.p    = icf.p3;
icf.vo_p2.wf    = icf.wfmd;
icf.vo_p2.p     = icf.p2;
icf.vo_p3.wf    = icf.wfmd;
icf.vo_p3.p     = icf.p3;
icf.vo_pd.wf    = icf.wfmd;
icf.vo_pd.p     = ic.pd;
icf.vo_px.wf    = icf.wf1s;
icf.vo_px.p     = icf.px;
icf.mo_p3s.wf   = 0;
icf.mo_p3s.p    = icf.vo_p3.p;



% Re-assign
ic.ifc = icf;
ic.wfc = icf.wfc;
function ic = F414_Fuel_System_Init_VEN(ic, GEO, E, FP, MOD)
%%function [ic, GEOE] = F414_Fuel_System_Init_VEN(ic, GEO, Z, FP, MOD)
% 29-Apr-2012   DA Gutz     Created

% Initialize IFC
% Inputs:   p1, wfmd=wf36, pd, wf1vg=wf1cvg+wf1fvg, wf1v=wfstart, pc, awfb
% Outputs:  wf1c, wfb

RNULL   = 0.002;    % Estimate of regulator null disp, in. 
DPNORM  = 500;      % Estimate of pressure above supply without lead, psi
DPLEAK  = 120;      % Estimate of pressure above supply bled, psi
DBIAS   = 0;        %#ok<NASGU> % Dead zone of drain, + is underlap, in

% Name changes
icv         = ic.venstart;
ic.venstart.load.fxven  = icv.fxven;
icvl        = ic.venstart.load;
GEOV        = GEO.venstart;
GEOVL       = GEOV.load;
RGEO        = GEOV.reg;
BIGEO       = GEOV.bi;
%TODO add start valve  SGEO        = GEOV.start;
GEOP        = GEOV.pump;
icv.pump.N  = icv.N;
AHEAD       = GEOVL.act_c.ah;
AROD        = GEOVL.act_c.ar;
icvl.act_c.v= 0;           % Constraint

%/* Initial guess for pressures and bias piston */
if icv.N >= 9466/E.N25100Pct*E.xnvent,
	icvl.prod    = ((icv.pr * (1 - (BIGEO.ah - BIGEO.ar) / RGEO.ahs) -...
        RGEO.fspr + RGEO.ks * RNULL) / RGEO.ahs +...
        (icv.fxven + icv.pamb * (AHEAD - AROD)) / AHEAD +...
        icv.pr) * (AHEAD / (AHEAD *...
        (1 - (BIGEO.ah - BIGEO.ar) /...
        RGEO.ahs) + AROD));
    if icv.fxven<0 && DPLEAK<DPNORM,
        icvl.prod = icv.pr + DPLEAK;
    else
        icvl.prod = icvl.prod - (DPNORM - DPLEAK);
    end
	icv.bi.x    = ((icvl.prod - icv.ps) * (BIGEO.ah - BIGEO.ar) - GEOV.fsb) / GEOV.ksb - RNULL;
	icv.bi.x    = max(min(icv.bi.x, BIGEO.xmax), BIGEO.xmin);
	icv.pd      = (-RGEO.fspr + GEOV.fsb + GEOV.ksb * icv.bi.x + (GEOV.ksb + RGEO.ks) * RNULL) / RGEO.ahs + icv.ps;
	icvl.prod    = ((icv.pr + icv.pd) * AHEAD + icv.fxven + icv.pamb * (AHEAD - AROD)) / (AHEAD + AROD);
    if (icv.fxven < 0) && (DPLEAK < DPNORM),
        icvl.prod = icv.pr + DPLEAK;
    else
        icvl.prod = icvl.prod - (DPNORM - DPLEAK);
    end
	icvl.phead   = (icv.pamb * (AHEAD - AROD) + icvl.prod * AROD - icv.fxven) / AHEAD;
else
	icvl.prod    = icv.pr;
    icvl.phead   = icv.pr;
	icv.bi.x    = BIGEO.xmin;
	icv.pd      = (-RGEO.fspr + GEOV.fsb + GEOV.ksb * icv.bi.x + (GEOV.ksb + RGEO.ks) * icv.reg.x) / RGEO.ahs + icv.ps;
end

% Pd Solution for top level flow balance
% Inputs:   pr, ps, pamb, fxven
% Outputs:  wfr, wfs, wfstart
icv.pdctx   = 40;
icv.pdct    = 0;
icv.pdctl   = 1e-2;
icv.pdx     = 7000;
icv.pdn     = icvl.prod;
icv.pd      = (icv.pdx+icv.pdn)/2;
icv.wfdstart= 0;
icv.reg.wfs  = 0;
icv.pderrn  = -999;
while( abs(icv.pderrn)>icv.pdctl && icv.pdct<icv.pdctx )
    icv.pdct       = icv.pdct + 1;

    % Load
    % Inputs:   pr,     ps, pd,     pamb,   fxven
    % Outputs:  wfl,    mA, prod,   phead,  x_ehsv
    icvl    = F414_Fuel_System_Init_VEN_Load(icvl, icv, GEOVL, FP, MOD);
    
    % Pump
    % Inputs:   ps, pd,         wfl,        wfdreg
    % Outputs:  px, pump.wf,    pump.disp,  wflkout
    icv     = F414_Fuel_System_Init_VEN_Pump(icv, icvl, GEOP, GEOV, FP, MOD);
    
    % Regulator
    % Inputs:   prod, ps, px, pd, wflkout
    % Outputs:  wfsreg,  x_reg, x_bias
    icv     = F414_Fuel_System_Init_VEN_Reg(icv, icvl, GEOV, FP, MOD);
	icv.pd_max = (-RGEO.fspr + GEOV.fsb + GEOV.ksb * BIGEO.xmax + (GEOV.ksb + RGEO.ks) * icv.reg.x) / RGEO.ahs + icv.ps;
	icv.pd_min = (-RGEO.fspr + GEOV.fsb + GEOV.ksb * BIGEO.xmin + (GEOV.ksb + RGEO.ks) * icv.reg.x) / RGEO.ahs + icv.ps;

    icv.pderrn = icv.pump.wf - icv.reg.wfs - icvl.ehsv.wfs - icvl.ehsv.wfllk;
%     icv.pderrn = -((-RGEO.fspr + GEOV.fsb + GEOV.ksb*icv.bi.x + (GEOV.ksb+RGEO.ks)*icv.reg.x)+ RGEO.ahs*icv.ps);
    icvl.wfl    = icvl.ehsv.wfs + icvl.ehsv.wfllk;
    if MOD.verbose-MOD.linearizing > 1
        fprintf('Vpdx(%ld):  pd=%11.6f, pderr=%14.12f, pumpwf=%7.1f, wfsreg=%7.1f, wfl=%7.1f,  pr=%f, ps=%f, pamb=%f, fxven=%f\n',...
            icv.pdct, icv.pd,  icv.pderrn, icv.pump.wf, icv.reg.wfs, icvl.wfl,icv.pr, icv.ps, icv.pamb, icv.fxven);
%         fprintf('Vpdx(%ld):  pd=%11.6f, pderr=%14.12f, x_reg=%f, x_bi=%f, ps=%f\n',...
%             icv.pdct, icv.pd,  icv.pderrn, icv.reg.x, icv.bi.x,  icv.ps);
    end
    if icv.pderrn > 0
        icv.pdn = icv.pd;
        icv.pd  = (icv.pd+icv.pdx)/2;
    else
        icv.pdx = icv.pd;
        icv.pd  = (icv.pd+icv.pdn)/2;
    end
end
if icv.pdct >= icv.pdctx && MOD.verbose-MOD.linearizing>1
    fprintf('\n*****WARNING(%s):  Vpdx pd=%f, pderr=%14.12f\n', mfilename, icv.pd, icv.pderrn);
end

% Assign
icv.mA          = icvl.mA;
icv.vo_pcham.p  = icv.pd;
icv.vo_pcham.wf = icv.pump.wf;
icv.vo_px.p     = icv.px;
icv.vo_px.wf    = icv.wflkout;
icvl.vo_hcham.p = icvl.phead;
icvl.vo_hcham.wf= 0;
icvl.vo_rcham.p = icvl.prod;
icvl.vo_rcham.wf= 0;
icvl.hline.p    = icvl.phead;
icvl.hline.wf   = -(icvl.ehsv.wfhd-icvl.ehsv.wfsh);
icvl.rline.p    = icvl.prod;
icvl.rline.wf   = icvl.ehsv.wfsr-icvl.ehsv.wfrd;
icv.start.wf    = 0;  % TODO add start valve
icv.start.wfvx  = 0;  % motionless init
icv.wfl         = icvl.ehsv.wfs + icvl.ehsv.wfllk + icv.start.wf;
icv.wfs         = icv.pump.wf   + icv.pa.wfr      - icv.reg.wfd  - icv.reg.wfde   + icv.reg.wflr  - icv.reg.wfld -...
                  icv.reg.wfle  + icv.bi.wfh      + icv.bi.wfr   - icv.start.wfvx - icv.wflkout;
icv.wfr         = icvl.ehsv.wfd + icvl.ehsv.wfllk + icvl.wfrl    + icvl.wfhl;

% Re-assign
ic.venstart         = icv;
ic.venstart.load    = icvl;
return

function [icvl]    = F414_Fuel_System_Init_VEN_Load(icvl, icv, GEOVL, FP, MOD)
%%function [icvl]    = F414_Fuel_System_Init_VEN_Load(icvl, icv, GEOVL, FP, MOD)
% 21-Feb-2017   DA Gutz     Created

AHEAD       = GEOVL.act_c.ah;
AROD        = GEOVL.act_c.ar;

% Loops to solve load
% Inputs:   pr,     ps, pd,     pamb,   fxven
% Outputs:  wfl,    mA, prod,   phead,  x_ehsv

icvl.lxctx  = 60;
icvl.lxct   = 0;
icvl.lxctl  = 1e-4;
icvl.lxxx   = GEOVL.ehsv.xmax;
icvl.lxxn   = GEOVL.ehsv.xmin;
icvl.ehsv.x = GEOVL.ehsv.mAnull*GEOVL.ehsv.kix-.01;
icvl.lxwferr  = -999;
while( abs(icvl.lxwferr)>icvl.lxctl && icvl.lxct<icvl.lxctx )
    icvl.lxct = icvl.lxct + 1;
    
    % Head chamber flow balance
    icvl.lkctx   = 60;
    icvl.lkct    = 0;
    icvl.lkctl   = 1e-8;
    icvl.lkpx    = icv.pd+10000;
    icvl.lkpn    = -1000;
    icvl.phead   = (icvl.lkpx+icvl.lkpn)/2;
%     icvl.prod   = (icvl.lkpx+icvl.lkpn)/2;
    icvl.lkerrn  = -999;
    while( abs(icvl.lkerrn)>icvl.lkctl && icvl.lkct<icvl.lkctx )
        icvl.lkct            = icvl.lkct + 1;
        icvl.ehsv.adh   = interp1(GEOVL.ehsv.awin_dh(:,1), GEOVL.ehsv.awin_dh(:,2), icvl.ehsv.x, 'linear', 'extrap');
        icvl.ehsv.ash   = interp1(GEOVL.ehsv.awin_sh(:,1), GEOVL.ehsv.awin_sh(:,2), -icvl.ehsv.x, 'linear', 'extrap');
        icvl.ehsv.adr   = interp1(GEOVL.ehsv.awin_dr(:,1), GEOVL.ehsv.awin_dr(:,2), -icvl.ehsv.x, 'linear', 'extrap');
        icvl.ehsv.asr   = interp1(GEOVL.ehsv.awin_sr(:,1), GEOVL.ehsv.awin_sr(:,2), icvl.ehsv.x, 'linear', 'extrap');
        icvl.prod       = (icvl.phead*AHEAD + icvl.fxven - icv.pamb*(AHEAD-AROD)) / AROD;
%         icvl.phead       = (icvl.prod*AROD + icvl.fxven - icv.pamb*(AHEAD-AROD)) / AHEAD;
        icvl.ehsv.wfhd  = or_aptow(icvl.ehsv.adh,   icvl.phead, icv.ps,     GEOVL.ehsv.cd, FP.sg);
        icvl.ehsv.wfsh  = or_aptow(icvl.ehsv.ash,   icv.pd,     icvl.phead, GEOVL.ehsv.cd, FP.sg);
        icvl.ehsv.wfrd  = or_aptow(icvl.ehsv.adr,   icvl.prod,  icv.ps,     GEOVL.ehsv.cd, FP.sg);
        icvl.ehsv.wfsr  = or_aptow(icvl.ehsv.asr,   icv.pd,     icvl.prod,  GEOVL.ehsv.cd, FP.sg);
        icvl.wfb        = or_aptow(GEOVL.act_c.ab,  icvl.prod,  icvl.phead, GEOVL.act_c.cd, FP.sg);
        icvl.wfrl       = or_aptow(GEOVL.act_c.arl, icvl.prod,  icv.pr,     GEOVL.act_c.cd, FP.sg);
        icvl.wfhl       = or_aptow(GEOVL.act_c.ahl, icvl.phead, icv.pr,     GEOVL.act_c.cd, FP.sg);
        icvl.lkerrn     = icvl.ehsv.wfsh - icvl.ehsv.wfhd + icvl.wfb - icvl.wfhl;   % Balance in head volume only using phead
%         icvl.lkerrn     = icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfb - icvl.wfrl;   % Balance in head volume only using phead
        if MOD.verbose-MOD.linearizing > 3
            fprintf('Vlk(%ld):  phead=%12.7f, lkerr=%14.12f, prod=%7.1f, xehsv=%f, pr=%f, ps=%f, pd=%f, pamb=%f, fxven=%f, \n', icvl.lkct, icvl.phead, icvl.lkerrn, icvl.prod, icvl.ehsv.x, icv.pr, icv.ps, icv.pd, icv.pamb, icv.fxven);
%             fprintf('Vlk(%ld):  prod=%12.7f, lkerr=%14.12f, phead=%7.1f, xehsv=%f, pr=%f, ps=%f, pd=%f, pamb=%f, fxven=%f, \n', icvl.lkct, icvl.prod, icvl.lkerrn, icvl.phead, icvl.ehsv.x, icv.pr, icv.ps, icv.pd, icv.pamb, icv.fxven);
        end
        if icvl.lkerrn > 0
            icvl.lkpn   = icvl.phead;
            icvl.phead  = (icvl.phead+icvl.lkpx)/2;
%             icvl.lkpn   = icvl.prod;
%             icvl.prod  = (icvl.prod+icvl.lkpx)/2;
        else
            icvl.lkpx   = icvl.phead;
            icvl.phead  = (icvl.phead+icvl.lkpn)/2;
%             icvl.lkpx   = icvl.prod;
%             icvl.prod  = (icvl.prod+icvl.lkpn)/2;
        end
    end
    icvl.mA  = icvl.ehsv.x/GEOVL.ehsv.kix + GEOVL.ehsv.mAnull;
    if icvl.lkct >= icvl.lkctx && MOD.verbose-MOD.linearizing>1
        fprintf('\n*****WARNING(%s):  Vlk phead=%f, lkerr=%14.12f\n', mfilename, icvl.phead, icvl.lkerrn);
    end
    % Balance overall flow using x
    if icvl.fxven>-4400 && icvl.fxven<0,
        icvl.lxwferr = (icvl.ehsv.wfsh - icvl.ehsv.wfhd + icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfrl - icvl.wfhl);
    else
        icvl.lxwferr = -(icvl.ehsv.wfsh - icvl.ehsv.wfhd + icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfrl - icvl.wfhl);
    end
    if MOD.verbose-MOD.linearizing > 2 
        fprintf('Vlwf(%ld):  xehsv=%11.8f, lxwferr=%14.12f, prod=%7.1f, pr=%f, ps=%f, pd=%f, pamb=%f, fxven=%f, \n', icvl.lxct, icvl.ehsv.x, icvl.lxwferr, icvl.prod, icv.pr, icv.ps, icv.pd, icv.pamb, icv.fxven);
    end
    if icvl.lxwferr > 0
        icvl.lxxn   = icvl.ehsv.x;
        icvl.ehsv.x = (icvl.ehsv.x+icvl.lxxx)/2;
    else
        icvl.lxxx   = icvl.ehsv.x;
        icvl.ehsv.x = (icvl.ehsv.x+icvl.lxxn)/2;
    end

end  % lxwferr
if icvl.lxct >= icvl.lxctx && MOD.verbose-MOD.linearizing>1
    fprintf('\n*****WARNING(%s):  Vlwf xehsv=%f, lxwferr=%14.12f\n', mfilename, icvl.ehsv.x, icvl.lxwferr);
end

icvl.ehsv.wfllk = GEOVL.ehsv_klk * FP.sg *((icv.pd - icv.pr) / FP.avis)^GEOVL.ehsv_powlk;
icvl.ehsv.wflk  = abs(la_kptow(GEOVL.ehsv.kel, icv.pd, icv.pr, FP.kvis));
icvl.ehsv.wfj   = abs(or_aptow(GEOVL.ehsv.ael, icv.pd, icv.pr, GEOVL.ehsv.cdl, FP.sg));
icvl.ehsv.wfr   = icvl.ehsv.wfsr    - icvl.ehsv.wfrd;
icvl.ehsv.wfh   = icvl.ehsv.wfsh    - icvl.ehsv.wfhd;
icvl.ehsv.wfd   = icvl.ehsv.wflk + icvl.ehsv.wfj + icvl.ehsv.wfrd + icvl.ehsv.wfhd;
icvl.ehsv.wfs   = icvl.ehsv.wflk + icvl.ehsv.wfj + icvl.ehsv.wfsr + icvl.ehsv.wfsh;
function icv     = F414_Fuel_System_Init_VEN_Pump(icv, icvl, GEOP, GEOV, FP, MOD)
%%function icv     = F414_Fuel_System_Init_VEN_Pump(icv, icvl, GEOP, GEOV, FP, MOD)
% 21-Feb-2017   DA Gutz     Created


% Pump
% Inputs:   ps, pd,         wfl,        wfdreg
% Outputs:  px, pump.wf,    pump.disp,  wflkout

PAGEO           = GEOV.pa;
icv.pump.N      = icv.N;
icv.pump.ps     = icv.ps;
icv.pump.pd     = icv.pd;
good_guess      = 0;
icv.pump.ldctx = 40;
icv.pump.ldct = 0;
AVG_DISP    = 0.5;
try temp = icv.pump.disp;
catch ERR
    icv.pump.disp = AVG_DISP;
end
while ~good_guess && icv.pump.ldct < icv.pump.ldctx,
    icv.pump    = calc_pos_pump_a(GEOP, icv.pump, FP);
    errn        = (icv.pump.wf - icv.reg.wfs - icvl.ehsv.wfs - icvl.ehsv.wfllk) /(2* icv.N * AVG_DISP);
    icv.pump.ldct     = icv.pump.ldct+1;
    if abs(errn) > 1e-6,
        icv.pump.disp   = max(icv.pump.disp - 0.95 * errn, 0);
    else good_guess = 1;
    end
    if MOD.verbose-MOD.linearizing > 2
        fprintf('Vdisp(%ld):  disp=%f, errn=%14.10f, wfpump=%14.12f, ps=%f, pd=%f, wfl=%f, wfsreg=%f,\n', icv.pump.ldct, icv.pump.disp, errn, icv.pump.wf, icv.ps, icv.pd, icv.reg.wfs+icvl.ehsv.wfllk, icv.reg.wfs);
    end
end
if icv.pump.ldct >= icv.pump.ldctx   && MOD.verbose-MOD.linearizing>1
    fprintf('\n*****WARNING(%s):  Vdisp disp=%f, errn=%f, wf=%14.12f, wfbal=%14.12f\n', mfilename, icv.pump.disp, errn, icv.pump.wf, icv.reg.wfd+icvl.wfl);
end
icv.pump.pa.x   = asin(icv.pump.disp / GEOV.cdv);
icv.pump.theta  = 180 / pi * icv.pump.pa.x;
icv.tqrs        = interp1(GEOV.ytqrs(:,1),  GEOV.ytqrs(:,2), icv.pump.theta, 'linear');
icv.ftpa        = interp1(GEOV.ytqa(:,1),   GEOV.ytqa(:,2),  icv.pump.theta, 'linear') * PAGEO.ah / GEOV.cftpa;
icv.tqpv        = GEOV.ctqpv * (icv.pd - icv.ps);
icv.tqa         = icv.tqrs + icv.tqpv;
icv.px          = icv.ps + icv.tqa / icv.ftpa;
icv.wflkout     = la_lrecptow(GEOV.leako.l, GEOV.leako.r, GEOV.leako.ecc, GEOV.leako.rad_clear, icv.px, icv.ps, FP.kvis);
icv.pa.x        = icv.pump.pa.x;
icv.pa.wfr      = 0;    % motionless
icv.pa.wfh      = 0;    % motionless
return

function icv     = F414_Fuel_System_Init_VEN_Reg(icv, icvl, GEOV, FP, MOD)
%%function icv     = F414_Fuel_System_Init_VEN_Reg(icv, icvl, GEOV, FP, MOD)
% 21-Feb-2017   DA Gutz     Created


% Regulator
% Inputs:   prod, ps, px, pd, wflkout
% Outputs:  wfsreg


RGEO        = GEOV.reg;
BIGEO       = GEOV.bi;

% Inputs:   prod, ps, px, pd, wflkout
% Outputs:  reg.wfd

icv.wfxctx   = 60;
icv.wfxct    = 0;
icv.wfxctl   = 1e-8;
% icv.regxx    = GEOV.reg.xmax;
% icv.regxn    = GEOV.reg.xmin;
icv.regxx   = -0.002;
icv.regxn   = -0.004;
icv.reg.x    = (icv.regxx + icv.regxn)/2;
icv.wfxerrn  = -999;
while( abs(icv.wfxerrn)>icv.wfxctl && icv.wfxct<icv.wfxctx )
    icv.wfxct       = icv.wfxct + 1;
    [RGEO.as, RGEO.ad]  = ven_reg_win(icv.reg.x, RGEO.win);
    icv.reg.wfs = or_aptow(RGEO.as, icv.pd, icv.px, RGEO.cd, FP.sg);
    icv.reg.wfd = or_aptow(RGEO.ad, icv.px, icv.ps, RGEO.cd, FP.sg);
    icv.reg.wfx = icv.reg.wfs - icv.reg.wfd;
    icv.wfx     = icv.reg.wfx;
    icv.wfxerrn = -(icv.wfx - icv.wflkout);
    if MOD.verbose-MOD.linearizing > 2
% prod, ps, px, pd, wflkout
        fprintf('Vwfx(%ld):  x=%10.8f, wfxerr=%14.12f, wfx=%7.1f, wfl=%7.1f, prod=%f, ps=%f, px=%f, pd=%f, wflkout=%f,\n', icv.wfxct, icv.reg.x, icv.wfxerrn, icv.wfx, icv.wflkout, icvl.prod, icv.ps, icv.px, icv.pd, icv.wflkout);
    end
    if icv.wfxerrn > 0
        icv.regxn   = icv.reg.x;
        icv.reg.x  = (icv.reg.x+icv.regxx)/2;
    else
        icv.regxx   = icv.reg.x;
        icv.reg.x  = (icv.reg.x+icv.regxn)/2;
    end
end
if icv.wfxct >= icv.wfxctx && MOD.verbose-MOD.linearizing>1
    fprintf('\n*****WARNING(%s): Vwfx x=%ld/%f, wfxerr=%14.12f\n', mfilename, icv.wfxct, icv.reg.x, icv.wfxerrn);
end

icv.reg.wfde    = 0;  % motionless init
icv.reg.wflr    = 0;  % motionless init
icv.reg.wfld    = 0;  % motionless init
icv.reg.wfle    = 0;  % motionless init
icv.bi.wfr      = 0;  % motionless init
icv.bi.wfh      = 0;  % motionless init
icv.bi.x    = max(min(((icvl.prod - icv.ps) * (BIGEO.ah - BIGEO.ar) - GEOV.fsb) / GEOV.ksb - icv.reg.x, BIGEO.xmax), BIGEO.xmin);
return


function [as, ad] = ven_reg_win(x, GEO)
xcrl    = max(min(-(x+GEO.DBIAS) - GEO.UNDERLAP, GEO.DORIFD), 0.);
xscl    = max(min((x+GEO.SBIAS), GEO.DORIFS), 0.);
thcrl   = acos(1. - xcrl * 2. / GEO.DORIFD);
thscl   = acos(1. - xscl * 2. / GEO.DORIFS);
alk     = GEO.CLEAR * (GEO.DORIFS + GEO.DORIFD)/2. * (pi - thcrl - thscl);
as     = GEO.HOLES * ( max(hole(max(min(x+GEO.SBIAS, GEO.DORIFS), 0.), GEO.DORIFS),...
			max(min(x+GEO.SBIAS, GEO.DORIFS),0.)*GEO.WS)...
			+ alk);
ad     = GEO.HOLES * ( max(holeArea(max(min(-(x+GEO.DBIAS) - GEO.UNDERLAP, GEO.DORIFD), 0.),...
		       GEO.DORIFD),...
			max(min(-(x+GEO.DBIAS) - GEO.UNDERLAP, GEO.DORIFD), 0.)*GEO.WD)...
		        + alk);
return



%% F414_VEN_SubsystemSignalManagement
% Assign test vectors for VEN system.   Called from InitFcn_VEN_Subsystem
% 19-Sep-2017       DA Gutz     Created
% Revisions


% Final assignment of vectors
V.fxven     = [0 100; ic.venstart.fxven   ic.venstart.fxven]';
if Z.data.use.fxven
    try
        V.fxven = DS.V.fxven;
    catch ERR
        error('DS.V.fxven not available.  Either correct or set Z.data.use.fxven=0;');
    end
end
V.useFxven  = Z.data.use.fxven*Z.data.enable;
V.xn25     = [0 100; ic.xn25   ic.xn25]';
if ~Z.data.use.xn25
    try
        V.xn25 = DS.V.xn25;
    catch ERR
        error('DS.V.xn25 not available.  Either correct or set Z.data.use.xn25=0;');
    end
end
V.useXn25   = Z.data.use.xn25*Z.data.enable;
V.wf36     = [0 100; Z.wf36   Z.wf36]';
if Z.data.use.wf36
    try
        V.wf36 = DS.V.wf36;
    catch ERR
        error('DS.V.wf36 not available.  Either correct or set Z.data.use.wf36=0;');
    end
end
V.useWf36   = Z.data.use.wf36*Z.data.enable;
V.mAven     = [0 100; ic.venstart.mA   ic.venstart.mA]';
if Z.data.use.mAven
    try
        if Z.data.SOURCE
            V.mAven = DS.V.mA_ven;
        else
            V.mAven = DS.V.mAven;
        end
    catch ERR
        error('DS.V.mAven not available.  Either correct or set Z.data.use.mAven=0;');
    end
end
V.usemAven  = Z.data.use.mAven*Z.data.enable;
V.dmAven        = V.mAven;
V.dmAven(:,2)   = V.mAven(:,2) - V.mAven(1,2);
if Z.data.use.a8
    try
        V.xven = Z.V.xven;
    catch ERR
        error('Z.V.xven not available.  Either correct or set Z.data.use.a8=0;');
    end
end
V.useXven   = Z.data.use.a8*Z.data.enable;
V.pr     = [0 100; ic.pr   ic.pr]';
if Z.data.use.pr
    error('DS.V.pr not available.  Either correct or set Z.data.use.pr=0;');
end
V.usePr     = Z.data.use.pr*Z.data.enable;
V.ps     = [0 100; ic.ps   ic.ps]';
if Z.data.use.ps
    try
        if Z.data.rigVal2000
            V.ps = DS.V.boost_r;
        else
            V.ps = DS.V.ps;
        end
    catch ERR
        error('DS.V.ps not available.  Either correct or set Z.data.use.ps=0;');
    end
end
V.usePs     = Z.data.use.ps*Z.data.enable;


%% Fuel_System_Inner_Loop_Init
%
%  Fuel System Inner Loop Control Initialization
%  Manxue Lu 01/17/2013
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% PPH & Stroke Conversion
FMV.PPH  = [0 232 292 354 381 454 526 605 691 781 882 988 1102 1223 1350 ...
            1485 1626 1773 1926 2088 2257 2432 2614 2801 2996 3200 3419 3653 ...
            3980 4194 4501 4833 5184 5567 5971 6407 6862 7343 7858 8398 8968 ...
            9563 10210 10877 11560 12286 13057 13858 14737 15640 16507 17288 17871];

ABTFMV.PPH  = [0 185 289 385 439 609 830 1089 1381 1711 2074 2483 2918 3403 ...
            3916 4465 5050 5668 6327 7022 7751 8514 9319 10156 11019 11939 12888 13869 ...            
            14880 15955 17061 18220 19468 20790 22198 23671 25175 26731 28353 30013 31705 ...
            33433 35141 37000 38783 40654 42635 44638 46858 49087 51357 53672 55725];
            
            
ABPFMV.PPH  = [0 164 188 229 243 278 314 351 388 426 464 503 541 581 619 658 ...
               697 736 775 814 853 893 932 972 1011 1051 1090 1131 ...
               1171 1212 1252 1295 1336 1379 1419 1463 1506 1550 1591 1636 1679 ...
               1725 1768 1813 1858 1904 1949 1995 2042 2088 2137 2184 2224];
                                       
FMV.STRK = [-0.02 0 0.008 0.016 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 ...
            0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 ...
            0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 ...
            0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5];
        
% Single Loop COntroller Setting
Tctrl  = 0.01;
Tminor = 0.01;


% Variable Structure - Core FMV
	ILC_WFM.tldFF1 = 0.088;
	ILC_WFM.TlgFF1 = 0.12;
	ILC_WFM.tldFF2 = 0;
	ILC_WFM.TlgFF2 = 0;       
	ILC_WFM.tldFB = 0.02;
	ILC_WFM.TlgFB = 0.008;      
	ILC_WFM.Kint = 0;
	ILC_WFM.IntLimMax = 0;
	ILC_WFM.IntLimMin = 0;
    ILC_WFM.PosRefRtMax = (1e+10);
	ILC_WFM.PosRefRtMin = -(1e+10);
	ILC_WFM.TlgPosRefRt = 0;
    ILC_WFM.PosRefRtThresMax = (1e+10);          % %stroke/s
	ILC_WFM.PosRefRtThresMin = -(1e+10);         % %stroke/s      
	ILC_WFM.x_LGSchedV1 = [1 1000];
	ILC_WFM.x_LGSchedV2 = [1, 200];
	ILC_WFM.y_LGSched = [14.88 14.88; 14.88 14.88];
    ILC_WFM.LpGKicPerm = 0;
    ILC_WFM.KicGscalar = 1;
    ILC_WFM.x_TMNullShiftV1 = [1, 200];  % load
	ILC_WFM.y_TMNullShift = [0 0];
    ILC_WFM.LPGain_Adj = 1;

	ACT_WFM.TMNull = 20;
	ACT_WFM.TMCMax = 60;
	ACT_WFM.TMCMin = -60;
	ACT_WFM.TMC_FixedPos = 0;           % N25_ISOCH_TM_DEM
    
    WFM_FixedPosCmd = 0;            % FA_N25_ISOCH
    WFM_TMDiscntCmd = 0;            % WFM_TM (B)

% Variable Structure - ABT FMV
    ILC_WFABT.tldFF1 = 0.088;
	ILC_WFABT.TlgFF1 = 0.14;    
	ILC_WFABT.tldFF2 = 0;
	ILC_WFABT.TlgFF2 = 0;     
	ILC_WFABT.tldFB = 0.022;
	ILC_WFABT.TlgFB = 0.008;   
	ILC_WFABT.Kint = 0;
	ILC_WFABT.IntLimMax = 0;
	ILC_WFABT.IntLimMin = 0;
    ILC_WFABT.PosRefRtMax = (1e+10);
	ILC_WFABT.PosRefRtMin = -(1e+10);
	ILC_WFABT.TlgPosRefRt = 0;
    ILC_WFABT.PosRefRtThresMax = (1e+10);          % %stroke/s
	ILC_WFABT.PosRefRtThresMin = -(1e+10);         % %stroke/s    
	ILC_WFABT.x_LGSchedV1 = [1 1000];
	ILC_WFABT.x_LGSchedV2 = [1, 200];
	ILC_WFABT.y_LGSched = [12.74 12.74; 12.74 12.74];
    ILC_WFABT.LpGKicPerm = 0;
    ILC_WFABT.KicGscalar = 1;
    ILC_WFABT.x_TMNullShiftV1 = [1, 200];  % load
	ILC_WFABT.y_TMNullShift = [0 0];
    ILC_WFABT.LPGain_Adj = 1;
    
	ACT_WFABT.TMNull = 15;
	ACT_WFABT.TMCMax = 75;
	ACT_WFABT.TMCMin = -45;
	ACT_WFABT.TMC_FixedPos = 0;           % na
    
    WFABT_FixedPosCmd = 0;            % na
    WFABT_TMDiscntCmd = 0;            % WFRT_TM (B)
            
% Variable Structure - ABP FMV
    ILC_WFABP.tldFF1 = 0.088;
	ILC_WFABP.TlgFF1 = 0.12;   
	ILC_WFABP.tldFF2 = 0;
	ILC_WFABP.TlgFF2 = 0;    
	ILC_WFABP.tldFB = 0.018;
	ILC_WFABP.TlgFB = 0.008;     
	ILC_WFABP.Kint = 0;
	ILC_WFABP.IntLimMax = 0;
	ILC_WFABP.IntLimMin = 0;
    ILC_WFABP.PosRefRtMax = (1e+10);
	ILC_WFABP.PosRefRtMin = -(1e+10);
	ILC_WFABP.TlgPosRefRt = 0;
    ILC_WFABP.PosRefRtThresMax = (1e+10);          % %stroke/s
	ILC_WFABP.PosRefRtThresMin = -(1e+10);         % %stroke/s
	ILC_WFABP.x_LGSchedV1 = [1 1000];
	ILC_WFABP.x_LGSchedV2 = [1, 200];
	ILC_WFABP.y_LGSched = [19.16 19.16; 19.16 19.16];
    ILC_WFABP.LpGKicPerm = 0;
    ILC_WFABP.KicGscalar = 1;
    ILC_WFABP.x_TMNullShiftV1 = [1, 200];  % load
	ILC_WFABP.y_TMNullShift = [0 0];
    ILC_WFABP.LPGain_Adj = 1;
    
	ACT_WFABP.TMNull = 15;
	ACT_WFABP.TMCMax = 70;
	ACT_WFABP.TMCMin = -50;
	ACT_WFABP.TMC_FixedPos = 0;           % N25_ISOCH_TM_DEM
    
    WFABP_FixedPosCmd = 0;            % na
    WFABP_TMDiscntCmd = 0;            % WFRP_TM (B) 
    
% Variable Structure - VEN
    ILC_VEN.tldFF1 = 0.02;
	ILC_VEN.TlgFF1 = 0.008;   
% 	ILC_VEN.tldFF2 = 0;
% 	ILC_VEN.TlgFF2 = 0;     
% 	ILC_VEN.tldFB = 0;
% 	ILC_VEN.TlgFB = 0;    
	ILC_VEN.tldFF2 = 0.02;  % dag 9/16/2013
	ILC_VEN.TlgFF2 = 0.02;       % dag 9/16/2013
	ILC_VEN.tldFB = 0.02;  % dag 9/16/2013
	ILC_VEN.TlgFB = 0.02;      % dag 9/16/2013
	ILC_VEN.Kint = 0;
	ILC_VEN.IntLimMax = 0;
	ILC_VEN.IntLimMin = 0;
    ILC_VEN.PosRefRtMax = (1e+10);
	ILC_VEN.PosRefRtMin = -(1e+10);
	ILC_VEN.TlgPosRefRt = 0.03;
    ILC_VEN.PosRefRtThresMax = (1e+10);          % %stroke/s
	ILC_VEN.PosRefRtThresMin = -(1e+10);         % %stroke/s
    %  Bad schedules  DAG 9/16/2013
    % 	ILC_VEN.x_LGSchedV1 = [24.4 70];
% 	ILC_VEN.x_LGSchedV2 = [1.5 8.5 9.2 14];         % load
% 	ILC_VEN.y_LGSched = [0 0 0 0; 0 0 1 1];         % Gain = 0 foe low load region? 
    ILC_VEN.x_LGSchedV1 = [ -10 10  20  30  40  50];
	ILC_VEN.x_LGSchedV2 = [ 0 10000 20000 30000];         % load
	ILC_VEN.y_LGSched   = [ 5.5 5.5 5.5 5.5 5.5 5.5;
                            5.5 5.5 3.5 3.5 3.5 3.5;
                            5.5 5.5 5.5 3.0 3.0 3.0;
                            5.5 5.5 5.5 5.5 2.5 2.5;]';
    ILC_VEN.LpGKicPerm = 0;
    ILC_VEN.KicGscalar = 1;
    %  Bad schedules  DAG 9/16/2013
%     ILC_VEN.x_TMNullShiftV1 = [9.72 14.696 33];     % load
% 	ILC_VEN.y_TMNullShift = [3 6 15];
    ILC_VEN.x_TMNullShiftV1 = [ -2000   0       10000   20000   30000   33500   35000   36000];
	ILC_VEN.y_TMNullShift   = [ 26.04   24.5    22.5    22.1    21      19      17      15];
    ILC_VEN.LPGain_Adj = 1;   
    
	ACT_VEN.TMNull = 0;
	ACT_VEN.TMCMax = 70;
	ACT_VEN.TMCMin = -25;
	ACT_VEN.TMC_FixedPos = -100;        % na
    
    VEN_FixedPosCmd = 0;            % AB_Lock (B)
    VEN_TMDiscntCmd = 0;            % !A8_TM (B)
    
% Variable Structure - FVG
    ILC_FVG.tldFF1 = 0.018;
	ILC_FVG.TlgFF1 = 0.0075;     
	ILC_FVG.tldFF2 = 0;
	ILC_FVG.TlgFF2 = 0;     
	ILC_FVG.tldFB = 0;
	ILC_FVG.TlgFB = 0;     
	ILC_FVG.Kint = 0;
	ILC_FVG.IntLimMax = 0;
	ILC_FVG.IntLimMin = 0;
	ILC_FVG.PosRefRtMax = 200;
	ILC_FVG.PosRefRtMin = -200;
	ILC_FVG.TlgPosRefRt = 0.025;
	ILC_FVG.PosRefRtThresMax = 45;          % %stroke/s
	ILC_FVG.PosRefRtThresMin = -45;         % %stroke/s
	ILC_FVG.x_LGSchedV1 = [1 1000];
	ILC_FVG.x_LGSchedV2 = [1, 200];         % load
	ILC_FVG.y_LGSched = [-4.59 -4.59; -4.59 -4.59]; % mA/%stroke
    ILC_FVG.LpGKicPerm = 0;
    ILC_FVG.KicGscalar = 1.45;
    ILC_FVG.x_TMNullShiftV1 = [1, 200];     % load
	ILC_FVG.y_TMNullShift = [0 0];          % mA
    ILC_FVG.LPGain_Adj = 1;   
    
	ACT_FVG.TMNull = 15;
	ACT_FVG.TMCMax = 75;
	ACT_FVG.TMCMin = -45;
	ACT_FVG.TMC_FixedPos = 0;           % na
    
    FVG_FixedPosCmd = 0;            % na
    FVG_TMDiscntCmd = 0;            % FVG_TM (B)    
    
% Variable Structure - CVG
    ILC_CVG.tldFF1 = 0.018;
	ILC_CVG.TlgFF1 = 0.0075;  
	ILC_CVG.tldFF2 = 0;
	ILC_CVG.TlgFF2 = 0;   
	ILC_CVG.tldFB = 0;
	ILC_CVG.TlgFB = 0;  
	ILC_CVG.Kint = 0;
	ILC_CVG.IntLimMax = 0;
	ILC_CVG.IntLimMin = 0;
	ILC_CVG.PosRefRtMax = 150;
	ILC_CVG.PosRefRtMin = -150;
	ILC_CVG.TlgPosRefRt = 0.025;
	ILC_CVG.PosRefRtThresMax = 30;          % %stroke/s
	ILC_CVG.PosRefRtThresMin = -30;         % %stroke/s
	ILC_CVG.x_LGSchedV1 = [1 1000];
	ILC_CVG.x_LGSchedV2 = [1, 200];         % load
	ILC_CVG.y_LGSched = [-3.388 -3.388; -3.388 -3.388];  % mA/%stroke
    ILC_CVG.LpGKicPerm = 0;
    ILC_CVG.KicGscalar = 1.6;
    ILC_CVG.x_TMNullShiftV1 = [1, 200];     % load
	ILC_CVG.y_TMNullShift = [0 0];
    ILC_CVG.LPGain_Adj = 1;   
    

	ACT_CVG.TMNull = 20;
	ACT_CVG.TMCMax = 80;
	ACT_CVG.TMCMin = -40;
	ACT_CVG.TMC_FixedPos = 0;       % na
    
    CVG_FixedPosCmd = 0;            % na
    CVG_TMDiscntCmd = 0;            % CVG_TM (B)        

    
function FVAL = genCaseInitVEN_Subsystem(X)
%%function FVAL = genCaseInitVEN_Subsystem(X)
% 05-Apr-2012       DA Gutz     Created from genCaseServoActuator
% Revisions:
% 25-Mar-2013       DA Gutz     Added lti* functions to reduce errors


global FPi
global MODi
global GEOi
global FVAL


%%Inputs
x = X.*MODi.S; % Apply ScaleServoActuator
switch(MODi.level)
    case 0
        x(1)=max(x(1), GEOi.venstart.load.ehsv.xmin );  % limit xehsv.   BIG TIME ERROR TRAP
        x(2)=max(x(2), GEOi.venstart.reg.xmin );  % limit xreg.    BIG TIME ERROR TRAP
        x(3)=max(x(3), GEOi.venstart.bi.xmin   );  % limit xbi.   BIG TIME ERROR TRAP
        x(4)=max(x(4), 100.   );  % limit pd.   BIG TIME ERROR TRAP
        x(5)=max(x(5), 100.   );  % limit prod.   BIG TIME ERROR TRAP
        evalin('base', sprintf('ic.venstart.x1_xehsv=%f;',     x(1)));
        evalin('base', sprintf('ic.venstart.x2_xreg=%f;',      x(2)));
        evalin('base', sprintf('ic.venstart.x3_xbi=%f;',       x(3)));
        evalin('base', sprintf('ic.venstart.x4_pd=%f;',        x(4)));
        evalin('base', sprintf('ic.venstart.x5_prod=%f;',      x(5)));
    otherwise
        % Calculate only
end
% initialize from files
if ~MODi.loaded,
    MODi.loaded = 1;
end

%%Make systems and evaluate response
% keyboard

%%Responses
[ic, GEOi] = evalin('base', sprintf('F414_Fuel_System_Balance_VENstandalone(ic, GEOi, FPi, MODi)'));
assignin('base', 'ic', ic);

switch(MODi.level)
    case {0, 1}
        FVAL = [ic.venstart.e1_px ic.venstart.e2_all ic.venstart.e3_regf ic.venstart.e4_bif ic.venstart.e5_prod];
        FVAL = norm(FVAL);
%         FVAL = (sum(abs(FVAL)))^2;
    otherwise
        FVAL = [ic.venstart.e1_px ic.venstart.e2_all ic.venstart.e3_regf ic.venstart.e4_bif ic.venstart.e5_prod];
        FVAL = norm(FVAL);
 end

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

warning off 'Simulink:SampleTime:NoMoreSampleTimeColors'
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
default('DS.V.prox_r', '[0 100; 0 0]');
function [D] = loadRig2000_DataVEN_Subsystem(result, startTime, MOD, D)
% Load data to drive model with old rig data from y 2000

%%19-Ma7-2017  DA Gutz         Created from loadSourceDataVEN_Subsystem.m


%%Default
if nargin<3, startTime = 0; end 

%%Load data.   It takes along time to load so remember last load when possible
resultVEN_Fn    = sprintf('DATA/%s', result);
sheet           = strrep(result, '.xlsx', '');
fnData          = sprintf('saves/%s.mat', result);
fnThisFile      = sprintf('CALLBACKS/%s.m', mfilename);
dfnThisFile     = getStamp(fnThisFile);
dfnData         = getStamp(fnData);
dresultVEN_Fn   = getStamp(resultVEN_Fn);
if  ~exist(fnData, 'file') ||...
    dfnThisFile > dfnData  ||...
    dresultVEN_Fn   > dfnData,

    
    if MOD.verbose-MOD.linearizing>0,fprintf('(%s): loading data...', mfilename);end;
    
    %%Load VEN
    [a, b, ~] = xlsread(resultVEN_Fn);
    inpVar = b;
    inpArr = a; 
    [~,nY] = size(inpArr);
    try
    for i=1:nY
        eval(sprintf('%s=a(:,%ld);', b{1,i}, i));
    end
    catch ERR
        fprintf('\nLook for problem with %s in file %s\n', a{1,i}, result);
        keyboard
    end
    pvec = find(time>=startTime);
    if isempty(pvec)
        startTime = 0;
        pvec = find(time>=0);
    end
    timeN = time(pvec)-startTime;
    try
    for i=1:nY,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    catch ERR %#ok<*NASGU>
        fprintf('\nLook for problem with D.V.%s = [timeN %s(pvec)] in file %s\n', var(:), var(:), result);
        keyboard
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;


    %%Postfix
    D.tFinal        = timeN(length(timeN));
    D.DTIME         = timeN(2)-timeN(1);
    D.startTime     = startTime;
    D.V             = orderfields(D.V);
    D               = orderfields(D);
    eval(sprintf('save %s D', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('\n%s:  loaded and saved to %s...\n', mfilename, fnData);end
else
    eval(sprintf('load %s', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('%s:  re-loaded from .mat...\n', mfilename); end
end

clear fnThisFile dfnThisFile

function [D] = loadSourceData(result, startTime, MOD, D)
% Load data to drive model with old source/f414 data

%%31-Mar-2016  DA Gutz         Created from loadFltData


%%Default
if nargin<3, startTime = 0; end 

%%Load data.   It takes along time to load so remember last load when possible
resultIFC_Fn    = sprintf('../f414_source_legacy/f414/%s.ifc.dat', result);
resultVEN_Fn    = sprintf('../f414_source_legacy/f414/%s.ven.dat', result);
resultMVSV_Fn   = sprintf('../f414_source_legacy/f414/%s.mvsv.dat', result);
resultHS_Fn     = sprintf('../f414_source_legacy/f414/%s.hs.dat', result);
fnData          = sprintf('saves/%s.mat', result);
fnThisFile      = sprintf('CALLBACKS/%s.m', mfilename);
dfnThisFile     = getStamp(fnThisFile);
dfnData         = getStamp(fnData);
dresultIFC_Fn   = getStamp(resultIFC_Fn);
dresultVEN_Fn   = getStamp(resultVEN_Fn);
dresultMVSV_Fn  = getStamp(resultMVSV_Fn);
dresultHS_Fn    = getStamp(resultHS_Fn);
if  ~exist(fnData, 'file') ||...
    dfnThisFile > dfnData  ||...
    dresultIFC_Fn   > dfnData ||...
    dresultVEN_Fn   > dfnData ||...
    dresultMVSV_Fn  > dfnData ||...
    dresultHS_Fn    > dfnData,

    
    if MOD.verbose-MOD.linearizing>0,fprintf('(%s): loading data...', mfilename);end;
    %%Load IFC
    [a, ~, nV] = importdata(resultIFC_Fn);
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;
    for i=1:nV
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i}, i));
    end
    inpVar = a.textdata;
    inpArr = a.data; %#ok<NASGU>
    pvec = find(timex>=startTime);
    if isempty(pvec)
        startTime = 0;
        pvec = find(timex>=0);
    end
    timeN = timex(pvec)-startTime;
    for i=1:nV,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.');end;
        end
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;
    
    %%Load VEN
    [a, ~, nY] = importdata(resultVEN_Fn);
    for i=1:nY
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i}, i));
    end
    inpVar = a.textdata;
    inpArr = a.data; %#ok<NASGU>
    for i=1:nY,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;

    %%Load MVSV
    [a, ~, nV] = importdata(resultMVSV_Fn);
    for i=1:nV
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i}, i));
    end
    inpVar = a.textdata;
    inpArr = a.data; %#ok<NASGU>
    pvec = find(timex>=startTime);
    timeN = timex(pvec)-startTime;
    for i=1:nV,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;
    
    %%Load HS
    [a, ~, nV] = importdata(resultHS_Fn);
    for i=1:nV
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i}, i));
    end
    inpVar = a.textdata;
    inpArr = a.data; %#ok<NASGU>
    pvec = find(timex>=startTime);
    timeN = timex(pvec)-startTime;
    for i=1:nV,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;

    %%Postfix
    D.tFinal        = timeN(length(timeN));
    D.DTIME         = timeN(5)-timeN(4);
    D.startTime     = startTime;
    D.sg            = D.V.sg(1, 2);
    D.kvis          = D.V.kvis(1, 2);
    D.beta          = D.V.beta(1, 2);
    D.dwdc          = D.sg*129.93948;
    D.V             = orderfields(D.V);
    D               = orderfields(D);
    eval(sprintf('save %s D', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('\n%s:  loaded and saved to %s...', mfilename, fnData);end
else
    eval(sprintf('load %s', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('%s:  re-loaded from .mat...', mfilename); end
end

clear fnThisFile dfnThisFile
function [D] = loadSourceDataSubsystem(result, startTime, MOD, D)
% Load data to drive model with old source/f414 data

%%31-Mar-2016  DA Gutz         Created from loadFltData

%%Default
if nargin<3, startTime = 0; end

%%Load data.   It takes along time to load so remember last load when possible
result_Fn       = sprintf('../f414_source_legacy/f414/%s.dat', result);
fnData          = sprintf('saves/%s.mat', result);
fnThisFile      = sprintf('CALLBACKS/%s.m', mfilename);
dfnThisFile     = getStamp(fnThisFile);
dfnData         = getStamp(fnData);
dresult_Fn   = getStamp(result_Fn);
if  ~exist(fnData, 'file') ||...
        dfnThisFile > dfnData  ||...
        dresult_Fn   > dfnData,
    
    
    if MOD.verbose-MOD.linearizing>0,fprintf('(%s): loading data...', mfilename);end;
    
    %%Load VEN
    [a, ~, ~] = importdata(result_Fn);
    inpVar = a.textdata(:,1);
    inpArr = a.data;
    [~,nY] = size(inpArr);
    try
        for i=1:nY
            eval(sprintf('%s=a.data(:,%ld);', a.textdata{i,1}, i));
        end
    catch ERR
        fprintf('\nLook for problem with %s in file %s\n', a.textdata{i,1}, result_Fn);
        keyboard
    end
    pvec = find(timex>=startTime);
    if isempty(pvec)
        startTime = 0;
        pvec = find(timex>=0);
    end
%     timeN = timex(pvec)-startTime;
    try
        for i=1:nY,
            if ~strcmp(inpVar{i}, '')
                var = strrep(inpVar{i}, '.', '_');
                var = strrep(var, ' ', '');
                eval(sprintf('pvecVar = find(~isnan(%s(pvec)));',  var(:)))
                timeN = timex(pvecVar)-startTime;
                eval(sprintf('D.V.%s = [timeN %s(pvecVar)];',  var(:), var(:)))
%                 eval(sprintf('clear %s;',  var(:)))
                if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
            end
        end
    catch ERR %#ok<*NASGU>
        fprintf('\nLook for problem with D.V.%s = [timeN %s(pvec)] in file %s\n', var(:), var(:), result_Fn);
        keyboard
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;
    
    
    %%Postfix
    D.tFinal        = timeN(length(timeN));
    D.DTIME         = timeN(2)-timeN(1);
    D.startTime     = startTime;
    D.V             = orderfields(D.V);
    D               = orderfields(D);
    eval(sprintf('save %s D', fnData)) 
    if MOD.verbose-MOD.linearizing>0, fprintf('\n%s:  loaded and saved to %s...\n', mfilename, fnData);end
else
    eval(sprintf('load %s', fnData))
    default('D.tFinal', '100');
    if MOD.verbose-MOD.linearizing>0, fprintf('%s:  %s re-loaded from .mat...\n', mfilename, result); end
end

function [D] = loadSourceDataVEN_Subsystem(result, startTime, MOD, D)
% Load data to drive model with old source/f414 data

%%31-Mar-2016  DA Gutz         Created from loadFltData


%%Default
if nargin<3, startTime = 0; end 

%%Load data.   It takes along time to load so remember last load when possible
resultVEN_Fn    = sprintf('../f414_source_legacy/f414/%s.ven.dat', result);
fnData          = sprintf('saves/%s.mat', result);
fnThisFile      = sprintf('CALLBACKS/%s.m', mfilename);
dfnThisFile     = getStamp(fnThisFile);
dfnData         = getStamp(fnData);
dresultVEN_Fn   = getStamp(resultVEN_Fn);
if  ~exist(fnData, 'file') ||...
    dfnThisFile > dfnData  ||...
    dresultVEN_Fn   > dfnData,

    
    if MOD.verbose-MOD.linearizing>0,fprintf('(%s): loading data...', mfilename);end;
    
    %%Load VEN
    [a, ~, ~] = importdata(resultVEN_Fn);
    inpVar = a.textdata(:,1);
    inpArr = a.data; 
    [~,nY] = size(inpArr);
    try
    for i=1:nY
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i,1}, i));
    end
    catch ERR
        fprintf('\nLook for problem with %s in file %s\n', a.textdata{i,1}, result);
        keyboard
    end
    pvec = find(timex>=startTime);
    if isempty(pvec)
        startTime = 0;
        pvec = find(timex>=0);
    end
    timeN = timex(pvec)-startTime;
    try
    for i=1:nY,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    catch ERR %#ok<*NASGU>
        fprintf('\nLook for problem with D.V.%s = [timeN %s(pvec)] in file %s\n', var(:), var(:), result);
        keyboard
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;


    %%Postfix
    D.tFinal        = timeN(length(timeN));
    D.DTIME         = timeN(2)-timeN(1);
    D.startTime     = startTime;
    D.V             = orderfields(D.V);
    D               = orderfields(D);
    eval(sprintf('save %s D', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('\n%s:  loaded and saved to %s...\n', mfilename, fnData);end
else
    eval(sprintf('load %s', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('%s:  re-loaded from .mat...\n', mfilename); end
end

clear fnThisFile dfnThisFile

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

function [P, D, lastFig]= plot_Fuel(bdroot, titleName, E, lastFig, swHcopy)
% function [D, lastFig} = plot_FuelSystem(ifcname, venname, titlename, lastFig, swHcopy)
% plot full      fuel system
% 16-Jun-2016   DA Gutz     Created
% Plot cdf file reading
% Inputs:
% ifcname       Name ifc.dat
% venname       Name ven.dat
% titlename     Name .titl
% lastFig       last used figure number (starts with lastFig+1)[0]
% swHcopy       hardcopy command [0]
% Outputs:
% D             The data
% lastFig   The number of the latest figure
% Sample usage:  > [D, lastFig]= plot_FuelSystem('opLine06_INS6.ifc.dat', 'opLine06_INS6.ven.dat', 'opLine06_INS6.titl', 0, 0)
% plot 0 and make hardcopies of the plots for recorP.

[P, D, lastFig]= plot_VEN_Subsystem(bdroot, titleName, E, lastFig, swHcopy, MOD);
function [P, D, lastFig]= plot_VEN_Subsystem(bdroot, titleName, E, lastFig, swHcopy, MOD, desc)
% function [D, lastFig} = plot_FuelSystem(ifcname, venname, titlename, lastFig, swHcopy, MOD)
% plot full      fuel system
% 16-Jun-2016   DA Gutz     Created
% Plot cdf file reading
% Inputs:
% ifcname       Name ifc.dat
% venname       Name ven.dat
% titlename     Name .titl
% lastFig       last used figure number (starts with lastFig+1)[0]
% swHcopy       hardcopy command [0]
% Outputs:
% D             The data
% lastFig   The number of the latest figure
% Sample usage:  > [D, lastFig]= plot_FuelSystem('opLine06_INS6.ifc.dat', 'opLine06_INS6.ven.dat', 'opLine06_INS6.titl', 0, 0)
% plot 0 and make hardcopies of the plots for recorP.


%%Initialize
warning off 'MATLAB:linkaxes:RequireDataAxes'
clear D
nax     = 0;
% naxN    = 0;

%%From GRC:  Assign log variables to workspace
% lognames = logsout.getElementNames;
% for k=1:numel(lognames)
%     logname_var = ['LOG_' regexprep(lognames{k},'(\W)','_')];
%     assignin('caller',logname_var,logsout.getElement(lognames{k}).Values);
% end

%%Read in the data
dat         = evalin('base', 'logsout.getElement(''VEN'')');
D           = dat.Values;
datf        = evalin('base', 'logsout.getElement(''FADEC'')');
DF          = datf.Values;
P.BETA      = evalin('base', 'FP.beta');
clear dat
ZRET    = evalin('base', 'Z.data.RET && Z.data.enable;');
tShort  = evalin('base', 'Z.data.tShort');
if ZRET
    DSV = evalin('base', 'DS.V;');
    PSV.time    = DSV.PFEHSV(:,1);
    PSV.pd      = DSV.PFEHSV(:,2);
    PSV.pr      = DSV.PFRTN(:,2)*0;
    PSV.ps      = DSV.PFRTN(:,2);
    PSV.prod    = DSV.PFVARD(:,2);
    PSV.phead   = DSV.PFVAA8P(:,2);
    PSV.a8pos   = DSV.A8ACV(:,2);
    PSV.x       = 4.7-PSV.a8pos/100*4.7;
    PSV.a8mad   = DSV.A8MAD(:,2);
    PSV.xn25    = DSV.QN25(:,2)*172.1;
    PSV.load    = DSV.TRSMO(:,2);
    PSV.a8ref   = DSV.TRSMO(:,2)*0;
else
    if MOD.fullUp
        PSV.time    = D.I.xn25.Time;
        P.time      = D.I.xn25.Time;
        P.rpm       = D.I.xn25.Data/E.xnmainpt*E.xnvent;
        P.xn25      = D.I.xn25.Data;
    else
        PSV.time    = D.I.xn25_rpm.Time;
        P.time      = D.I.xn25_rpm.Time;
        P.rpm       = D.I.xn25_rpm.Data/E.xnmainpt*E.xnvent;
        P.xn25      = D.I.xn25_rpm.Data;
    end
end
P.time      = D.pd.Time;
P.xn25      = D.pump.In.rpm.Data*E.xnmainpt/E.xnvent;
P.pd        = D.pd.Data;
P.ps        = D.I.ps_psia.Data;
P.pr        = D.I.pr_psia.Data;
P.px        = D.px.Data;
P.prod      = D.prod.Data;
P.phead     = D.phead.Data;
P.pa_x      = D.pumpAct.x.Data;
P.reg_x     = D.reg.Result.x.Data;
P.bias_x    = D.bias.Result.x.Data;
P.ehsv_x    = D.ehsv.SPOOL.x.Data;
P.X         = D.actSys.X.Data;
P.pump_wf   = D.pump.Result.wf.Data;
P.wfload    = D.wfload.Data;
P.rline_wf  = D.rline_wf.Data;
P.hline_wf  = D.hline_wf.Data;
P.uf_net    = D.actSys.uf.Data;
P.x_4       = D.actSys.O_4.Result.x.Data;
P.x_8       = D.actSys.O_8.Result.x.Data;
P.x_12      = D.actSys.O_12.Result.x.Data;
P.fxin_4    = D.actSys.fxin_4.Data;
P.fxin_8    = D.actSys.fxin_8.Data;
P.fxin_12   = D.actSys.fxin_12.Data;
P.fx_totaldelivered = D.actSys.fx_totaldelivered.Data;
P.uf_mod_4  = D.actSys.O_4.Result.uf_mod.Data;
P.uf_mod_8  = D.actSys.O_8.Result.uf_mod.Data;
P.uf_mod_12 = D.actSys.O_12.Result.uf_mod.Data;
P.FG_4      = D.actSys.O_4.Result.FG.Data;
P.FG_8      = D.actSys.O_8.Result.FG.Data;
P.FG_12     = D.actSys.O_12.Result.FG.Data;
P.FWSUM_4   = D.actSys.O_4.Result.FWSUM.Data;
P.FWSUM_8   = D.actSys.O_8.Result.FWSUM.Data;
P.FWSUM_12  = D.actSys.O_12.Result.FWSUM.Data;
P.mA        = D.ehsv.In.mA.Data;
P.dxdt      = D.actSys.V.Data;
P.fxven     = D.I.fxven_lbf.Data;
P.wfs       = D.wfs.Data;
P.wfr       = D.wfr.Data;
P.wfstart   = D.wfstart.Data;
P.timef     = DF.ASI040.A8_POS.Time;
P.timef020  = DF.ASI040.A8P_BIAS.Time;
P.A8_POS_REF    = DF.ASI040.A8_POS_REF.Data;
P.A8_POS    = DF.ASI040.A8_POS.Data;
P.A8_LOCK   = DF.ASI040.A8_LOCK.Data;
P.A8_TM     = DF.ASI040.A8_TM.Data;
P.VEN_LOAD_X= DF.ASI040.VEN_LOAD_X.Data;
P.A8_POS_REF_DT     = DF.ASI040.A8_POS_REF_DT.Data;
P.A8_ERR    = DF.ASI040.A8_ERR.Data;
P.A8_TM_DEM = DF.ASI040.A8_TM_DEM.Data;
P.A8_NULL   = DF.ASI040.A8_NULL.Data;
P.A8_GAIN   = DF.ASI040.A8_GAIN.Data;
P.A8_TM_DEM_LK= DF.ASL041.A8_TM_DEM_LK.Data;
P.ERROR     = DF.ASL040.ERROR.Data;
P.ERR_THRES = DF.ASL040.ERR_THRES.Data;
P.nERR_THRES= -DF.ASL040.ERR_THRES.Data;
P.A8_POS_DT =  DF.A8_POS_DT.Data;
P.RATE_THRES = DF.ASL040.RATE_THRES.Data;
P.nRATE_THRES= -DF.ASL040.RATE_THRES.Data;
P.A8_HYDRO_TRIP = DF.A8_HYDRO_TRIP.Data;
P.A8_HYDRO_FAIL = DF.A8_HYDRO_FAIL.Data;
P.A8_TM_DEM_LK= DF.ASL041.A8_TM_DEM_LK.Data;
P.A8_LK_DETECT= DF.ASL041.A8_LK_DETECT.Data;
P.A8_A_POS_RATE = DF.ASL041.A8_A_POS_RATE.Data;
P.A8_RATE_THRSH = DF.ASL041.A8_RATE_THRSH_ADJ.Data;
P.nA8_RATE_THRSH = -DF.ASL041.A8_RATE_THRSH_ADJ.Data;
P.A8P_BIAS   = DF.ASI040.A8P_BIAS.Data;


%%Titles etc
if ~exist('saves', 'dir'), mkdir('saves'), end
lastFigIn = lastFig+1;
titleStr    = sprintf('%s_%s', bdroot, desc);
fileStr    = sprintf('%s_%s', bdroot, titleName);


%%Plots
[lastFig, axTIME] = plotLocal(P, D, PSV, ZRET, lastFig, 0, titleStr, lastFigIn, fileStr);
if tShort
    [lastFig, axTIMEs] = plotLocal(P, D, PSV, ZRET, lastFig, tShort, titleStr, lastFigIn, fileStr);
end

%%Synchronize x-axes
linkaxes(axTIME,'x');
if tShort, linkaxes(axTIMEs, 'x'); end
if exist('axNGR', 'var'), linkaxes(axNGR,'x'); end %#ok<*NODEF>

if swHcopy
    T=timer('TimerFcn',@(~,~)disp('Waiting 3 sec in plot_VEN_Subsystem.m...'), 'StartDelay', 3);
    for figNum = lastFigIn:1:lastFig
        hardfigurecolor(figNum, sprintf('%s_%s', bdroot, titleName), figNum-lastFigIn+1)
        start(T)
        wait(T)
    end
    delete(T)
end

warning on 'MATLAB:linkaxes:RequireDataAxes'

return





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
held =1;
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
default('Z.A8_POS_NoisePower',      '0');   % Noise pos from electronics
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

warning('on', 'MATLAB:declareGlobalBeforeUse');
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
warning on 'Simulink:Commands:OpenSystemBlockNotFound'
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


