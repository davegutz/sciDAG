function sys = lti_pump_act_ven(ctqpv, ftpa, m, bdamp, ks, ddispdx, dwfdv, stops)
% PUMP_ACT_VEN.	Building block for F414 VEN pump actuator. Friction is neglected
%		(damping input).
% Author:	D. A. Gutz
% Written:	21-Aug-92.
% Revisions:	11-Sep-92	Add stops.



% Input:
% ctqpv		Piston load coefficient, in-lbf/psi.
% ftpa		Control pressure coefficient, in-lbf/psi.
% bdamp		Damping, in-lbf/(rad/sec).
% m		Total effective pump/actuator mass, rad/s/s/in-lbf.
% ks		Total effective pump return spring rate, in-lbf/rad.
% ddispdx	Effective gain pump, cuin/rev/rad.
% dwfdv		Effective flow output, pph/rad/s.
% stops		-1=min stop, 0=go, 1=max stop.

% Output:
% sys		Packed system of Input and Output.

% Differential IO:
% ps		Input # 1, rod-end pressure, psia.
% pd		Input # 2, pump discharge pressure, psia.
% px		Input # 3, head-end control pressure, psia.
% wfr		Output # 1, rod-end flow in, pph.
% wfh		Output # 2, head-end flow in, pph.
% disp		Output # 3, pump disp, cuin/rev.
% dxdt		Output # 4, actuator velocity toward head end, rad/sec.
% x		Output # 5, actuator displacement toward head end, rad.

% Local:
% none.

% States:
% dxdt		Spool velocity toward head end, rad/sec.
% x		Spool displacement toward head end, rad.

% Functions called:
% none.

% Parameters.
% none.

% Partials.
% none.

% Connections and system construction.
as	= [-bdamp*386.4/m	-ks*386.4/m;
	    1	 		0];
bs	= [ftpa-ctqpv	ctqpv	-ftpa];
bs	= bs * 386.4 / m;
bs	= [bs;
	   0			0	0];
if stops ~=0,	% Lock states if on stops~=0.
	bs	= 0*bs;
end
cs	= [dwfdv		0;
	   -dwfdv		0;
	   0			ddispdx;
	   1			0;
	   0			1];
es	= [0	0	0;
	   0	0	0;
	   0	0	0;
	   0	0	0;
	   0	0	0];
% Form the system.
