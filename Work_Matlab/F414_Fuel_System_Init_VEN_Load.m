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
