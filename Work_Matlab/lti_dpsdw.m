function sys = lti_dpsdw(dpsdwf)
% function sys = lti_dpsdw(dpsdwf);
% Differential flow/discharge pressure to supply pressure.
% Version with input sensitivity.
% Author:    D. A. Gutz
% Written:   22-Jun-92
% Revisions: 19-Aug-92 Simplify return arguments.
%
% Input:
% dpsdwf Sensitivity, psi/pph.
%
% Output:
% a,b,c,e System state space matrices.
% sys Packed system definition.
%
% Differential IO.
% wf Input  # 1, differential flow, pph.
% pd Input  # 2, differential discharge pressure, psi.
% ps Output # 1, differential supply pressure, psi.

% Connections and system construction.
a = [];
b = [];
c = [];
e = [dpsdwf 1];

% Form the system.
sys = pack_ss(a, b, c, e);
