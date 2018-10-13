function sys = lti_man_n_vm(l, a, vol, n, spgr, beta, c)
% function sys = man_n_vm(l, a, vol, n, spgr, beta, c)
% Building block for a line distributed among n equally sized
% volumes and momentum slices, with volume first & momentum last.
% Author:       D. A. Gutz
% Written:      16-Apr-92
% Revisions:    22-Jun-92    Added vm subscripts.
%               19-Aug-92    Simplify output arguments.
%               10-Dec-98    Add damping, c.
% Input:
% a     Line cross-section, sqin.
% beta  Fluid bulk modulus, psi.
% l     Line length, in.
% n     Number of momentum slice / volume node pairs.
% spgr  Fluid specific gravity.
% vol   Line volume, cuin.
% c     Damping, psi/in/sec, (OPTIONAL).
%
% Output:
% sys   LTI in packed form
%
% Differential I/O:
% wfs   Input  # 1, supply flow, pph.
% pd    Input  # 2, discharge pressure, psia.
% ps    Output # 1, supply pressure, psia.
% wfd   Output # 2, discharge flow, pph.
%
% Functions called:
% man_1_vm  Creates single element line of wfs, pd input and ps, wfd output.

% Check size.
if n<1
    error('Number of nodes < 1 in man_n_vm.')
end

% Single manifold slice.
if nargin == 7,
    man    = lti_man_1_vm(l/n, a, vol/n, spgr, beta, c);
else
    man    = lti_man_1_vm(l/n, a, vol/n, spgr, beta);
end

% Inputs are wfs and pd.
u    = [1    n*2];

% Outputs are ps and wfd.
y    = [1    n*2];

% Connections and system construction.
temp    = man;
q = [];
for i=2:n
    temp    = adjoin(temp, man);
    q    = [q;
           2*(i-1)    2*(i-1)+1;
           2*(i-1)+1    2*(i-1)];
end

% Form the system.
sys = connect_ss(temp,q,u,y);
