function sys = lti_dwdp(dwfdp)
% DPSDW.	Differential pressure to flow.
%		Version with input sensitivity.
%  Author:	D. A. Gutz
%  Written:	26-Jun-92
%  Revisions:	19-Aug-92	Simplify return arguments.
%
%  Input:
%  dwfdp	Sensitivity, psi/pph.
%
%  Differential IO.
%  ps		Input # 1, differential supply pressure, psi.
%  pd		Input # 2, differential discharge pressure, psi.
%  wf		Output # 1, differential flow, pph.
%
%  Output:
%  sys		Packed system definition.

%  Local:
%  None.

%  States:
%  none.

%  Functions called:
%  none.

%  Parameters.
%  none.

%  Partials.
%  none.

%  Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dwfdp	-dwfdp];
