function sys = mom_1(l, a, c)
% function sys = mom_1(l, a, c)
% MOM_11.	Building block for a momentum slice having two pressure inputs.
% Author:	D. A. Gutz
% Written:	17-Apr-92
% Revisions:	10-Dec-98	Add damping, c.
% Input:
% a	Cross sectional area, sqin.
% l	Slice length, in.
% c	Damping, psi/in/sec, (OPTIONAL).
% Output:
% sys	Packed system description of Input and Output.
% Differential I/O:
% ps	Input # 1, supply pressure, psia.
% pd	Input # 2, discharge pressure, psia.
% wf	Output # 1, slice flow, pph.

% Derivatives
dw	= 3600*386*a/l;		% Derivative, pph/sec.
if nargin == 3,
	dp = c*l*sqrt(a*4/pi);	% Damping, pph/sec/pph
else
	dp = 0;
end

a	= [-dp];
b	= [dw	-dw];
c	= [1];
e	= [0	0];

% Form the system.
