function sysol = lti_valve_a_1_ol(ax1, ax2, ax4, bdamp, cd, ks, ms, mv, pd, ph, ps, sg, wd, wfd, wfh, wh, stops, cp)
% VALVE_A_1.	Building block for a valve.  Transient and jet forces
%		neglected.  Friction is neglected.  The orifice is neglected.
%		Damping is an input.
% Author:	D. A. Gutz
% Written:	22-Jan-93
% Revisions:	03-Feb-93	Add jet forces.

% Input:
% ax1		Supply to reference cross-section, sqin.
% ax2		Damping cross-section, sqin.
% ax3		Supply cross-section, sqin.
% ax4		Supply to opposite spring end cross-seciton, sqin.
% bdamp		Damping, lbf/(in/sec).
% cd		Coefficient of discharge.
% cp		Jet coefficient.
% ks		Spring rate, lbf/in.
% ms		Spring mass, lbm.
% mv		Valve mass, lbm.
% pd		Discharge pressure, psia.
% ph		High discharge pressure, psia.
% ps		Supply pressure, psia.
% sg		Fluid specific gravity.
% wd		Discharge area gradient, sqin/in.
% wfd		Discharge flow out, pph.
% wfh		High discharge flow in, pph.
% wh		High discharge area gradient, sqin/in.
% stops		0=go.

% Output:
% sys		Packed system.
% sysol		Packed system for open loop.

% Differential IO:
% ps		I # 1, supply pressure, psia.
% pd		I # 2, discharge pressure, psia.
% ph		I # 3, high discharge pressure, psia.
% prs		I # 4, Reference opposite spring eng pressure, psia.
% pr		I # 5, Regulated pressure, psia.
% pxr		I # 6, Reference pressure, psia.
% x             I # 7, spool displacement toward drain, in.(open loop)
% wfs		O # 1, supply flow in, pph.
% wfd		O # 2, discharge flow out, pph.
% wfh		O # 3, high discharge flow in, pph.
% wfvrs		O # 4, reference opposite spring end flow in, pph.
% wfvr		O # 5, reference flow out, pph.
% wfvx		O # 6, damping flow out, pph.
% dxdt		O # 7, spool velocity toward drain, in/sec.
% x		O # 8, spool displacement toward drain, in.

% Local:
% ad		Discharge window area, sqin.
% ah		High discharge window area, sqin.
% dwdc		Flow conversion, pph/cis.
% dwfdda	Partial wfd with area, pph/sqin.
% dwfddp	Partial wfd with pressure, pph/psi.
% dwfhda	Partial wfh with area, pph/sqin.
% dwfhdp	Partial wfh with pressure, pph/psi.
% m		Total mass, lbm.


% States:
% dxdt		Spool velocity toward drain, in/sec.
% x		Spool displacement toward drain, in.

% Functions called:
% or_wptoa	Orifice area.
% ssqrt	Signed square root.

% Parameters.
m	= ms / 2. + mv;
dwdc	= 129.93948 * sg;
if abs(ps-pd)<1e-16, ps = pd + sgn(ps-pd)*1e-8; end
if abs(ps-ph)<1e-16, ps = ph + sgn(ps-ph)*1e-8; end
ad	= or_wptoa(wfd, ps, pd, cd, sg);
ah	= or_wptoa(wfh, ph, ps, cd, sg);

% Partials.
dwfdda	= wfd / max(ad, 1e-16);
dwfddp	= wfd / (2. * (ps - pd));
dwfhda	= wfh / max(ah, 1e-16);
dwfhdp	= wfh / (2. * (ph - ps));
dfjhdp	= -sign(ps - ph) * cp * ah;
dfjddp	= sign(ps - pd) * cp * ad;
dfjhda	= -cp * abs(ps - ph);
dfjhdx	= dfjhda * wh;
dfjdda	= cp * abs(ps - pd);
dfjddx	= dfjdda * wd;

% Connections and system construction.
a	= [-bdamp	-(ks+dfjhdx+dfjddx)] * 386. / m;
a	= [a;
	    1	  0];
b	= [(ax1-ax4-dfjhdp-dfjddp) dfjddp dfjhdp ax4 -(ax1-ax2) -ax2 0];
b	= b * 386. / m;
b	= [b;
	   0		0	0	0		0	0	0];
if stops ~= 0,	% Freeze states if on stops.
	b	= 0*b;
end
col	= [dwdc*(ax1-ax4)		0;
	   0				0;
	   0				0;
	   ax4*dwdc			0;
	   (ax1-ax2)*dwdc		0;
	   ax2*dwdc			0;
	   1				0;
	   0				1];
eol	= [(dwfddp+dwfhdp)	-dwfddp	-dwfhdp	0 0 0 (dwfdda*wd + dwfhda*wh);
	   dwfddp	-dwfddp		0	0 0 0 dwfdda*wd;
	  -dwfhdp	0		dwfhdp	0 0 0 -dwfhda*wh;
	   0		0		0	0 0 0 0;
	   0		0		0	0 0 0 0;
	   0		0		0	0 0 0 0;
	   0		0		0	0 0 0 0;
	   0		0		0	0 0 0 0];

% Form the system.