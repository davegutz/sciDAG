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


