function sys = summer(s1, s2, s3, s4)
% function sys = summer(s1, s2, s3, s4)
% Differential addition
% Author:      D. A. Gutz
% Written:     26-Jun-92
% Revisions:   19-Aug-92    Simplify return arguments.
%
% Input:
% s        Sensitivity, dOut/dIn.
%
% Differential IO.
% x1           Input # 1, first
% x2           Input # 2, second
% x3           Input # 3, third
% x4           Input # 4, fourth
% sum          Output # 1, sum of inputs .* sensitivity
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
e    = [s1  s2  s3  s4];
sys = pack_ss(a, b, c, e);
