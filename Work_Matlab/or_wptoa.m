function a = or_wptoa(wf, ps, pd, cd, sg)
% function a = or_wptoa(wf, ps, pd, cd, sg);
% Square law orifice function, flow/pressure to area.
% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	17-Oct-96	Trap divide by cd=0.
%
% Input:
% cd    Coefficient of discharge.
% pd    Discharge pressure, psia.
% ps    Supply pressure, psia.
% sg    Specific gravity.
% wf    Flow, pph.
%
% Output:
% a		Calculated orifice area, sqin.

% Functions called:
% ssqrt	Signed square root.

% Perform:
psmpd	= sgn(ps - pd) * max(abs(ps - pd), 1e-16);
a = wf / ssqrt(psmpd*sg) / cd / 19020.;

return
