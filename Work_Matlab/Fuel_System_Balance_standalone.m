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
