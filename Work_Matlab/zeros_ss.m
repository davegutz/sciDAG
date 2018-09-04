function sys = zeros_ss(n,m);
%function sys = zeros_ss(n,m);
% Wrapper for isicles functions to avoid error return for 0 index.
% D. Gutz 1/27/04
% Inputs:
% same as matlab zeros function.
% Outputs:
% same as matlab zeros function.

if ( n == 0 & m ~=0 ) | ( n~=0 & m == 0 ),
  sys = [];
else
  sys = zeros(n, m);
end

