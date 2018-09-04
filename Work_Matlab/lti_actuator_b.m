function sys = lti_actuator_b(ah, ar, bdamp, mact, mext, pr, ph, pl, wfb, wfrl, wfhl, stops, sg)
% ACTUATOR_B.	Building block for actuator.  Friction is neglected
%		(damping input).
% Author:	D. A. Gutz
% Written:	19-Aug-92.
% Revisions:	20-Aug-92	Fix sign of states.
%		26-Aug-92	Prevent  / 0.
%		11-Sep-92	Added stops.
%		14-Sep-92	Added sg so flow calculation correct.

% Input:
% ah		Head area, sqin.
% ar		Rod-end area, sqin.
% bdamp		Damping, lbf/(in/sec).
% mact		Actuator mass, lbm.
% mext		External mass, lbm.
% pr		Rod end pressure, psia.
% ph		Head end pressure, psia.
% pl		Head and rod leakage drain, psia.
% wfb		Flow through cross-piston bleed, head to rod, pph.
% wfrl		Leakage out rod end, pph.
% wfhl		Leakage out head end, pph.
% stops		Stops, 0=go.
% sg		Specific gravity of fluid.

% Output:
% sys		Packed system of Input and Output.

% Differential IO:
% pr		Input # 1, rod-end pressure, psia.
% ph		Input # 2, head-end pressure, psia.
% pl		Input # 3, leakage drain pressure, psi.
% per		Input # 4, rod pressure, psi.
% fext		Input # 5, supply end pressure, psi.
% wfr		Output # 1, rod-end flow in, pph.
% wfh		Output # 2, head-end flow in, pph.
% wfb		Output # 3, cross-piston rod to head, pph.
% wfve		Output # 4, rod displacement flow into body, pph.
% wfrl		Output # 5, rod drain end flow out, pph.
% wfhl		Output # 6, head drain end flow out, pph.
% dxdt		Output # 7, actuator velocity toward head end, in/sec.
% x         Output # 8, actuator displacement toward head end, in.

% Local:
% m		Total mass, lbm.

% States:
% dxdt		Spool velocity toward drain, in/sec.
% x		Spool displacement toward drain, in.

% Functions called:
% none.

% Parameters.
m	= mact + mext;
dwdc	= 129.93948 * sg;

% Partials.
if abs(pr - ph) < 1e-16,
	dwfbdp	= 0;
else
	dwfbdp	= wfb / (2. * (pr - ph));
end
if abs(pr - pl) < 1e-16,
	dwfrldp	= 0;
else
	dwfrldp	= wfrl / (2. * sign(pr - pl) * max(abs(pr - pl), 1e-16));
end
if abs(ph - pl) < 1e-16,
	dwfhldp	= 0;
else
	dwfhldp	= wfhl / (2. * sign(ph - pl) * max(abs(ph - pl), 1e-16));
end

% Connections and system construction.
as	= [-bdamp*386./m	0;
	    1	 		0];
bs	= [ar	-ah	0	ah-ar		-1];
bs	= bs * 386. / m;
bs	= [bs;
	   0	0	0	0		0];
if stops~=0,	% Freeze states if on stops.
	bs	= 0 * bs;
end
cs	= [ar*dwdc	0;
	   -ah*dwdc	0;
	   0		0;
	  (ah-ar)*dwdc	0;
	   0		0;
	   0		0;
	   1		0;
	   0		1];
es	= [(dwfbdp+dwfrldp)	-dwfbdp		-dwfrldp	0	0;
	   -dwfbdp	(dwfbdp+dwfhldp)	-dwfhldp	0	0;
	   dwfbdp		-dwfbdp		0		0	0;
	   0			0		0		0	0;
	   dwfrldp		0		-dwfrldp	0	0;
	   0			dwfhldp		-dwfhldp	0	0;
	   0			0		0		0	0;
	   0			0		0		0	0];
% Form the system.
