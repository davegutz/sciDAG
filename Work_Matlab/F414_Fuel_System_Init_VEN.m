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
