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

