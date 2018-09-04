function wf = or_aptow(a, ps, pd, cd, sg)
% function wf = or_aptow(a, ps, pd, cd, sg);
% Square law orifice function, area/pressure to flow.
% Author:    D. A. Gutz
% Written:   22-Jun-92
% Revisions: None.
%
% Input:
% a    Orifice area, sqin.
% cd   Coefficient of discharge.
% pd   Discharge pressure, psia.
% ps   Supply pressure, psia.
% sg   Specific gravity.
%
% Output:
% wf		Flow, pph.

% Functions called:
% ssqrt		Signed square root.

% Perform:
