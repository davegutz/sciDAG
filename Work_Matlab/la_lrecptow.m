function wf = la_lrecptow(l, r, e, c, ps, pd, kvis)
%%la_lrecptow
% Purpose:    Calculate laminar flow
% Author:     Dave Gutz   22-Jul-92   Created
%
% Inputs:
% l         Length, in
% r         Radius, in
% e         Eccentricity, in
% c         Radial clearance, in
% ps        Supply pressure, psia
% pd        Discharge pressure, psia
% kvis      Kinematic viscosity, centistokes
%
% Output:
% wf        Flow, pph
%#define la_lrecptow(L, R, E, C, PS, PD, KVIS)\
%                    (4.698e8 * (R) *((C)*(C)*(C)) / (KVIS) /\
%		     (L) * (1. + 1.5 * sqr((E)/(C))) * ((PS) - (PD)))


%#codegen

wf = 4.698e8*r*(c*c*c)/kvis/l*(1.+1.5*(e/c)^2)*(ps-pd);





