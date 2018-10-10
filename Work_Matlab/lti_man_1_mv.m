function sys = lti_man_1_mv(l, a, vol, spgr, beta, c)
% function sys = lti_man_1_mv(l, a, vol, spgr, beta, c);
% Build a one element line: momentum first, volume last.
% Author:       D. A. Gutz
% Written:      22-Jun-92
% Revisions:    19-Aug-92    Simplify output arguments.
%               10-Dec-98    Add damping, c.
% Input:
% l     Line length, in.
% a     Line cross section, sqin.
% vol   Line volume, cuin.
% spgr  Fluid specific gravity.
% beta  Fluid compressibility, psi.
% c     Damping, psi/in/sec, (OPTIONAL).
%
% Output:
% sys   Packed system of Input and Output
%
% Differential I/O:
% ps    Input  # 1, supply pressure, psia.
% wfd   Input  # 2, discharge flow, pph.
% wfs   Output # 1, supply flow, pph.
% pd    Output # 2, discharge pressure, psia.
%
% Functions called:
% vol_1 Creates volume node.
% mom_1 Creates momenum slice.

% Momentum slice.
if nargin == 6,
    m_1 = lti_mom_1(l, a, c);
else
    m_1 = lti_mom_1(l, a);
end

% Volume.
v_1 = lti_vol_1(vol, beta, spgr);

% Put system into block diagonal form.
temp = adjoin(m_1, v_1);

% Inputs are ps and wfd.
u = [1 4];

% Outputs are wfs and pd.
y = [1 2];

% Connections.
q = [2 2; 3 1];

% Form the system.
sys = connect_ss(temp, q, u, y);
