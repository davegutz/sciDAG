function sys = lti_pos_pump(cs, ct, cn, ps, pd, rpm, disp, kvis, sg)
% POS_PUMP.	Positive displacement pump model.
% Author:	D. A. Gutz
% Written:	19-Aug-92
% Revisions:	None.
%
% Input:
% cs		Laminar slip flow coefficient.
% ct		Turbulent slip flow coefficient. 
% cn		Speed slip flow coefficient.
% disp		Displacement, cuin/rev.
% ps		Supply, psia.
% pd		Discharge, psia.
% kvis		Kinematic viscosity, centistokes.
% sg		Specific gravity.

% Differential IO:
% ps		Input # 1, supply pressure, psi.
% pd		Input # 2, discharge pressure, psi.
% rpm		Input # 3, speed, rpm.
% disp		Input # 4, displacement, cuin/rev.
% wf		Output # 1, flow, pph.

% Output:
% sys		Packed system of Input and Output.

% Local:
% q		Connection matrix.
% u		Input matrix.
% y		Output matrix.

% States:
% none.

% Functions called:
% None.

% Parameters.
% avis		Absolute viscosity, lbf-sec/sqin.
% cis		Flow, cis.
% dwdc		Conversion cis to pph.
% eff_vol	Volumetric efficiency.
% mtdqp		avis * rad/sec / pl, dimensionless speed factor.
% pl		Load, psi.
% wf		Flow, pph.

avis	= 9.312e-5 * .00155 * sg * kvis;
dwdc	= 129.93948 * sg;
pl	= pd - ps;
mtdqp	= avis * .10471976 * rpm / pl;
eff_vol	= 1 - cs / mtdqp - ct * 1825 * ssqrt(pl / sg) / rpm / disp^.3333 - cn;
cis	= eff_vol * disp * rpm / 60;
wf	= cis * dwdc; %#ok<NASGU>

% Partials.
dwfdcis		= dwdc;
dcisdeff_vol	= disp * rpm / 60;
deff_voldpl	= -ct * 1825 / sqrt(sg) / (2 * sqrt(abs(pl))) / rpm / disp^.333;
dpldps		= -1;
dpldpd		= 1;
deff_voldmtdqp	= cs / mtdqp^2;
deff_volddisp	= .33333 * ct * 1825 * ssqrt(pl / sg) / rpm / disp^1.333;
dmtdqpdpl	= -mtdqp / pl;
dmtdqpdrpm	= mtdqp / rpm;
dcisdrpm	= cis / rpm;
dcisddisp	= cis / disp;
dwfdps		= dwfdcis * dcisdeff_vol * (deff_voldpl * dpldps +...
		   deff_voldmtdqp * dmtdqpdpl * dpldps);
dwfdpd		= dwfdcis * dcisdeff_vol * (deff_voldpl * dpldpd +...
		   deff_voldmtdqp * dmtdqpdpl * dpldpd);
dwfdrpm		= dwfdcis * (dcisdrpm +...
		   dcisdeff_vol * deff_voldmtdqp * dmtdqpdrpm);
dwfddisp	= dwfdcis * (dcisddisp +...
		   dcisdeff_vol * deff_volddisp);

% Connections and system construction.
asys	= [];
bsys	= [];
csys	= [];
esys	= [dwfdps	dwfdpd	dwfdrpm		dwfddisp];
