function [p,m,n] = size_ss(g)
% SIZE_SS	Compute system output, input and state dimensions.
%
% Syntax: [P,M,N] = SIZE_SS(G)
%
% Purpose: The SIZE_SS command returns three important dimensions for a
%		state-space system, namely, the number of outputs, the
%		number of inputs, and the state-dimension.
%
% Input:	G - input system, either a regular or packed-matrix
%		    variable.
%
% Output:	P, M, N - integers containing the output, input and
%	             state dimensions respectively of the input system
%		     G. If G is a regular matrix, then M and P default
%		     to the row and column dimensions of G and P is set
%		     equal to zero.  When used with only 1 output
%		     argument, SIZE_SS returns the vector [P M N].
%
% See Also:	ISSYS, ISTITO, SIZE

% Algorithm:
%
% Calls:
%
% Called By:


%**********************************************************************
% 

%
narginchk(1,1);
[p,m] = size(g); n = issys(g);
%
if n,
   if istito(g),
 	p = p - n - 2; m = m - n - 2;
   else 
	p = p - n - 1; m = m - n - 1;
   end
end
%
if nargout <= 1,
   p = [p m n];
end
