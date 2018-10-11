function sys = lti_man_n_mv(l, a, vol, n, spgr, beta, c)
% function sys = man_n_mv(l, a, vol, n, spgr, beta, c)
% Building block for a line distributed among n equally sized
% volumes and momentum slices, with momentum first & volume last.
% Author:     D. A. Gutz
% Written:    22-Jun-92
% Revisions:  19-Aug-92    Simplify output arguments.
%             10-Dec-98    Add damping, c.
%
% Input:
% a     Line cross-section, sqin.
% beta  Fluid bulk modulus, psi.
% l     Line length, in.
% n     Number of volume node / momentum slice pairs.
% spgr  Fluid specific gravity.
% vol   Line volume, cuin.
% c     Damping, psi/in/sec, (OPTIONAL).
%
%Output:
% sys   Packed lti
%
% Differential I/O:
% ps    Input  # 1, supply pressure, psia.
% wfd   Input  # 2, discharge flow, pph.
% wfs   Output # 1, supply flow, pph.
% pd    Output # 2, discharge pressure, psia.
%
% Functions called:
% man_1_mv    Creates single element line of ps, wfd input and wfs, pd output.

% Check size.
if n<1
    error('Number of nodes < 1 in man_n_mv.')
end

% Single manifold slice.
if nargin == 7
    man    = lti_man_1_mv(l/n, a, vol/n, spgr, beta, c);
else
    man    = lti_man_1_mv(l/n, a, vol/n, spgr, beta);
end

% Inputs are ps and wfd.
u    = [1    n*2];

% Outputs are wfs and pd.
y    = [1    n*2];

% Connections and system construction.
temp    = man;
q = [];
for i=2:n
    temp    = adjoin(temp, man);
    q    = [q;
           2*(i-1)    2*(i-1)+1;
           2*(i-1)+1   2*(i-1)];
end

% Form the system.
sys = connect_ss(temp, q, u, y);
