function sys = lti_dor_awpdtops(wf, ps, pd, cd, sg)
% function sys = dor_awpdtops(wf, ps, pd, cd, sg);
% Differential area/flow/discharge pressure to supply pressure.
% Author:   D. A. Gutz
% Written:  22-Jun-92
% Revisions:  19-Aug-92 Simplify return arguments.
%
% Input:
% cd    Coefficient of discharge.
% pd    Discharge pressure, psia.
% ps    Supply pressure, psia.
% sg    Specific gravity.
% wf    Flow, pph.
%
% Differential IO:
% a     Input  # 1, area perturbation, sqin.
% wf    Input  # 2, differential flow, pph.
% pd    Input  # 3, differential discharge pressure, psi.
% ps    Output # 1, differential supply pressure, psi.

% Local:
% ao     Orifice area, sqin.
% dpda   Partial pressure to area, psi/sqin.
% dpdw   Partial pressure to flow, psi/pph.

% States:
% none.

% Functions called:
% or_wptoa Orifice area.

% Parameters.
ao = or_wptoa(wf, ps, pd, cd, sg);

% Partials.
dpda = -2. * (ps - pd) / ao;
dpdw =  2. * (ps - pd) / wf;

% Connections and system construction.
a = [];
b = [];
c = [];
e = [dpda  dpdw  1];

% Form the system.