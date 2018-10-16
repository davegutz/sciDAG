function sys = splitter(s1, s2, s3, s4)
% function sys = splitter(s1, s2, s3, s4)
% Differential splitter
% Author:      D. A. Gutz
% Written:     26-Jun-92
% Revisions:   19-Aug-92    Simplify return arguments.
%
% Input:
% s        Sensitivity, dOut/dIn.
%
% Differential IO.
% x            Input  # 1, to be split
% o1           Output # 1, first
% o2           Output # 2, second
% o3           Output # 3, third
% o4           Output # 4, fourth
%
% Output:
% sys          Packed system definition.
%
% Local:
% None.
%
% States:
% none.
%
% Functions called:
% none.

% Parameters.
% none.

% Partials.
% none.

% Connections and system construction.
a    = [];
b    = [];
c    = [];
e    = [s1  s2  s3  s4]';
sys = pack_ss(a, b, c, e);
