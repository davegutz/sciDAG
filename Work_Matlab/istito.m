%
function [flag,na] = istito(sys)
% ISTITO	Determine whether argument is a TITO system.
%
% Syntax: FLAG = ISTITO(SYS) or
%         [FLAG,NA] = ISTITO(SYS)
%
% Purpose:	The function ISTITO determines whether the packed matrix
%		is in SISO or TITO form.  It may also be asked to return
%		the state dimension of the system.
%
% Input:	SYS  - a packed matrix system
%
% Output:	FLAG - one of two values:
%			  0 - SYS is SISO
%			  1 - SYS is TITO
%		NA   - state dimension of SYS
%
% See Also:

% Called By: STAR_SS



%**********************************************************************

% 
% Calculations
%
num = length(find(all(~isfinite(sys))));
if num == 2,				% dynamic TITO case
  flag = 1;
  na = find(all(isnan(sys))) - 1;
elseif num == 1					
  if isempty(find(all(isnan(sys)))),	% static TITO case
     flag = 1;
     na = 0;
  else					% dynamic SISO case
    flag = 0;
    na = find(all(isnan(sys))) - 1;
  end
else					% static SISO case
  flag = 0;
  na = 0;
end

