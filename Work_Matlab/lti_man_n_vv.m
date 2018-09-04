function sys = lti_man_n_vv(l, a, vol, n, spgr, beta, c)
% function sys = man_n_vv(l, a, vol, n, spgr, beta, c)
% MAN_N_VV.	Building block for a line distributed among n equally sized
%		volumes and momentum slices, with volume first & last (n = #
%		of momentum slices and n+1 = # volume nodes).
% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	19-Aug-92	Simplify output arguments.
%		10-Dec-98	Add damping, c.
% Input:
% a		Line cross-section, sqin.
% beta		Fluid bulk modulus, psi.
% l		Line length, in.
% n		Number of volume node / momentum slice pairs.
% spgr		Fluid specific gravity.
% vol		Line volume, cuin.
% c		Damping, psi/in/sec, (OPTIONAL).
% Differential I/O:
% wfs		Input # 1, supply flow, pph.
% wfd		Input # 2, discharge flow, pph.
% ps		Output # 1, supply pressure, psia.
% pd		Output # 2, discharge pressure, psia.

% Functions called:
% man_1_vm	Creates single element line of wfs, pd input and ps, wfd output.
% vol_1	Creates single volume node of wfs, wfd input and p output.

% Check size.
if n<1
	error('Number of nodes < 1 in man_n.')
end

% Single manifold slice.
if nargin == 7,
	man	= lti_man_1_vm(l/n, a, vol/(n+1), spgr, beta, c);
else
	man	= lti_man_1_vm(l/n, a, vol/(n+1), spgr, beta);
end

% Single volume node.
endvol	= lti_vol_1(vol/(n+1), beta, spgr);

% Inputs are wfs and wfd.
u	= [1	2*n+2];

% Outputs are ps and pd.
y	= [1	2*n+1];

% Connections and system construction.
temp	= make_pack(man);
q = [];
for i=2:n
	temp	= adjoin(temp, make_pack(man));
	q	= [q;
		   2*(i-1)	2*(i-1)+1;
		   2*(i-1)+1	2*(i-1)];
end
temp	= adjoin(temp, make_pack(endvol));
q	= [q;
	   2*n		2*n+1;
	   2*n+1	2*n];

% Form the system.
[a,b,c,e]	= unpack_ss(temp);
[a,b,c,e]	= connect(a,b,c,e,q,u,y);
