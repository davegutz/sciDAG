function area = hole(x, d);
% @(#)hole.m 1.2 93/06/22
% HOLE.		Calculate hole area as a function of uncovered length.
% Author:     Dave Gutz 09-Jun-90.
% Revisions:  None.

% Inputs:
% x		Spool edge relative to start of hole.
% d		Hole diameter.

% Local:
% r		Hole radius.
% frac		Fraction of hole uncovered.
% frac		Fraction of hole uncovered.

r	= d / 2.;
x	= max((min(x, d - 1e-16)), 1e-16);
frac	= 1. - x / r;

if(frac > 1e-16),
	area	= atan( sqrt(1. - frac * frac) / frac);
elseif(frac < -1e-16),
	area	= pi + atan( sqrt(1. - frac * frac) / frac);
else
	area	= pi / 2.;
end
area	= r * r * area   -   (r - x) * sqrt(x * (2.*r - x));
area	= max(area, 1e-16);
