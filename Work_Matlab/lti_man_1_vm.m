function sys = lti_man_1_vm(l, a, vol, spgr, beta, c)
% function sys = man_1_vm(l, a, vol, spgr, beta, c);
% MAN_1_VM.	Build a one element line: volume first, momentum last.
% Author:	D. A. Gutz
% Written:	16-Apr-92
% Revisions:	22-Jun-92	Add vm subscripts.
%		19-Aug-92	Simplify output arguments.
%		10-Dec-98	Add damping, c.
% Input:
% l		Line length, in.
% a		Line cross section, sqin.
% vol		Line volume, cuin.
% spgr		Fluid specific gravity.
% beta		Fluid compressibility, psi.
% c		Damping, psi/in/sec, (OPTIONAL).
% Differential I/O:
% wfs		Input # 1, supply flow, pph.
% pd		Input # 2, discharge pressure, psia.
% ps		Output # 1, supply pressure, psia.
% wfd		Output # 2, discharge flow, pph.

% Functions called:
% lti_vol_1	Creates volume node.
% lti_mom_1	Creates momenum slice.

% Volume.
v_1	= lti_vol_1(vol, beta, spgr);

% Momentum slice.
if nargin == 6,
	m_1	= lti_mom_1(l, a, c);
else
	m_1	= lti_mom_1(l, a);
end

% Put system into block diagonal form.
temp	= adjoin(make_pack(v_1), make_pack(m_1));

% Inputs are wfs and pd.
u	= [1	4];

% Outputs are ps and wfd.
y	= [1	2];

% Connections.
q	=	[2	2;
		3	1];

% Form the system.
[a,b,c,e]	= unpack_ss(temp);
[a,b,c,e]	= connect(a,b,c,e,q,u,y);
