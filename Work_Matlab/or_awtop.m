function ps = or_awtop(a, wf, pd, cd, sg)
% function ps = or_awtop(a, wf, pd, cd, sg);
% Square law orifice function, area/flow to pressure.
% 22-Jun-1992 DA Gutz   Written
% 20-May-2016 DA Gutz   Fixed bug sg was inside parenthesis
%
% Input:
% a    Orifice area, sqin.
% cd   Coefficient of discharge.
% pd   Discharge pressure, psia.
% sg   Specific gravity.
% wf   Flow, pph.
%
% Output:
% ps   Supply pressure, psia.

% Functions called:
% ssqr		Signed square.

% Perform:
ps = pd + ssqr(wf/a/cd/19020.)/sg;
