function y = sgn(x);
% SGN.		Safe sign.
%  Author:	D. A. Gutz
%  Written:	09-Apr-93
%  Revisions:	None.

%  Input:
%  x		Real number.

%  Output:
%  y		sign(x)

%  Perform:
if x ~= 0,
	y	= sign(x);
else
	y	= 1;
