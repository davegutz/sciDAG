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
