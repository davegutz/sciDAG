function y = ssqrt(x);
% SSQRT.	Signed square root.
%  Author:	D. A. Gutz
%  Written:	22-Jun-92
%  Revisions:	None.

%  Input:
%  x		Real number.

%  Output:
%  y		sign(x) * sqrt(abs(x))

%  Perform:
y	= sign(x) * sqrt(abs(x));
