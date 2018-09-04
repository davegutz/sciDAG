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

