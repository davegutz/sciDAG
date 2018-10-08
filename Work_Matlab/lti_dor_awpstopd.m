function sys = lti_dor_awpstopd(wf, ps, pd, cd, sg)
% DOR_AWPSTOPD.	Differential area/flow/supply pressure to discharge pressure.
%  Author:      D. A. Gutz
%  Written:     22-Jun-92
%  Revisions:   19-Aug-92   Simplify return arguments.
%
%  Input:
%  cd       Coefficient of discharge.
%  pd       Discharge pressure, psia.
%  ps       Supply pressure, psia.
%  sg       Specific gravity.
%  wf       Flow, pph.
%
%  Output:
%  sys  Packed system definition.
%
%  Differential IO.
%  ao       Input # 1, area perturbation, sqin.
%  wf       Input # 2, differential flow, pph.
%  ps       Input # 3, differential supply pressure, psi.
%  pd       Output # 1, differential discharge pressure, psi.
%
%  Local:
%  ao       Orifice area, sqin.
%  dpda     Partial pressure to area, psi/sqin.
%  dpdw     Partial pressure to flow, psi/pph.
%
%  States:
%  none.
%
%  Functions called:
%  or_wptoa	Orifice area.

%  Parameters.
ao	= or_wptoa(wf, ps, pd, cd, sg);

%  Partials.
dpda	=  2. * (ps - pd) / ao;
dpdw	= -2. * (ps - pd) / wf;

%  Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dpda   dpdw    1];

%  Form the system.
sys = pack_ss(a, b, c, e);
