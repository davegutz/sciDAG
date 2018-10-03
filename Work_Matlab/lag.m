function sys = lag(tau)
% LAG.		Building block for simple first order lag.
%  Author:	D. A. Gutz
%  Written:	26-Jun-92
%  Revisions:	19-Aug-92	Simplify return arguments.
%
%  Input:
%  tau		Time constant, sec.

%  Differential IO:
%  x		Input # 1.
%  y		Output # 1, lagged by tau.

%  Output:
%  sys		Packed system of Input and Output.

%  Local:
%  q		Connection matrix.
%  u		Input matrix.
%  y		Output matrix.


%  States:
%  y		Output.

%  Functions called:
%  None.

%  Parameters.
%  None.

%  Partials.
%  None.

%  Connections and system construction.
a	= -1/tau;
b	= 1/tau;
c	= 1;
e	= 0;
sys = pack_ss(a,b,c,e);
