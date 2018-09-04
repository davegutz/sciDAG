%

function ns = issys(x)
% ISSYS		Determine whether argument is a system.
%
% Syntax: NS = ISSYS(X)
%
% Purpose:	The function ISSYS returns the state dimension of a variable,
%		which is nonzero if the argument is a packed matrix, and
%		zero if a regular matrix.
%
% Input:	X	- Variable who's state dimension is to be computed.
%
% Output:	NS	- A scalar containing the state dimension of X.  If
%			X is a regular matrix variable, then NS = 0.
%
% See Also:

% Algorithm:
%
% Calls:
%
% Called By:

%**********************************************************************
%
ns = find(all(isnan(x)));
%
if ~isempty(ns),
   ns = ns-1;
else
   ns = 0;

end
