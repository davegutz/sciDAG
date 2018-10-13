function sys = lti_spring(s1, s2, ks)
% function sys = lti_spring(s1, s2, ks)
% Building block for spring
% Author:       D. A. Gutz
% Written:      26-Aug-92
% Revisions:    
%
% Input:
% s1    Sign of x1
% s2    Sign of x2
% ks    Spring rate, lbf/in
%
% Output:
% sys        Packed system of Input and Output
%
% Differential IO:
% x1    Input  # 1, spring end disp to compress, in
% x2    Input  # 2, spring end disp to compress, in
% f     Output # 1, spring compression, lbf
%-f     Output # 2, spring extension, lbf
%
% Local:
% none
%
% States:
% none
%
% Functions called:
% none

% Parameters:
% none

% Partials.
% none.

% Connections and system construction.
as    = []; bs=    []; cs    = [];
es    = [ks*s1    ks*s2;
       -ks*s1    -ks*s2];
sys = pack_ss(as, bs, cs, es);
