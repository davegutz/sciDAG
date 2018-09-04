function sys = lti_dor_aptow(wf, ps, pd, cd, sg)
% function sys = dor_aptow(wf, ps, pd, cd, sg);
% Differential area/pressure to flow for a square law orifice.
% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	19-Aug-92	Simplify return arguments.
%               26-Nov-2012 add divide by zero protection%
% Input:
% cd		Coefficient of discharge.
% pd		Discharge pressure, psia.
% ps		Supply pressure, psia.
% sg		Specific gravity.
% wf		Flow, pph.
%
% Differential IO.
% ps		Input # 1, supply pressure, psia.
% pd		Input # 2, discharge pressure, psia.
% a         Input # 3, area perturbation, sqin.
% wf		Output # 1, flow, pph.
%
% Output:
% sys		Differential orifice model.

% Local:
% ao		Orifice area, sqin.
% dwfda	Partial flow to area, pph/sqin.
% dwfdp	Partial flow to pressure, pph/psi.

% States:
% none.

% Functions called:
% or_wptoa	Orifice area.
% ssqrt	Signed square root.

% Parameters.
ao	= or_wptoa(wf, ps, pd, cd, sg);

% Partials.
dwfda	= wf / ao;
psmpd	= sgn(ps - pd) * max(abs(ps - pd), 1e-16);  % 11/26/2012 add divide by zero protection
dwfdp	= wf / (2. * psmpd);

% Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dwfdp 	-dwfdp		dwfda];

% Form the system.
