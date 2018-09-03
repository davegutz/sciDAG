function so = adjoin(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15) %#ok<INUSD>
% ADJOIN	Form composite system interconnection.
%
% Syntax: So = ADJOIN(S1, ... Sn), or So = ADJOIN(S1, ... Sn-1, FLAG)
%
% Purpose:	The ADJOIN function forms a composite system from
%		the state-space realizations of distinct systems.
%		The different forms possible include
%
%			[ S1   0  ]  	              [  S1  ]
%			[    \    ],  [S1 --- Sn-1],  [   |  ]
%			[  0   Sn ]                   [ Sn-1 ]
%
%		where the latter two are horizontally and vertically
%		adjoined systems, obtained with FLAG = 'h', or FLAG = 'v'
%		respectively.
%
% Input:	S1 ,... Sn  - Input systems, in packed matrix form. Currently
%			      n is limited to a maximum of 15.
%		FLAG	- Optional string, either 'h' indicating the
%			horizontal adjoin operation, or 'v' for vertical.
%
% Output:	So	- the composite system, in packed matrix form.
%
% See Also:	ADD_SS, MULT_SS, SUB_SS, INV_SS

% Algorithm:
%
% Calls:	UNPACK_SS, PACK_SS
%
% Called By:

% SCCS information: %W% %G%


%**********************************************************************
narginchk(2,15);
%
s_f = eval(['s',int2str(nargin)]);
% if isstr(s_f)
if ischar(s_f)
    if s_f == 'v'			% Vertical stacking operation
        [ao,bo,co,eo] = unpack_ss(s1); [a1,b1,~,~] = unpack_ss(s1);
        [~,p1,~] = size_ss(s1);
        for i = 2:nargin-1
            si = eval(['s',int2str(i)]);
            [ai,bi,ci,ei] = unpack_ss(si); [mi,pi,ni] = size_ss(si);
            [mo,~] = size(eo); [~,no] = size(ao);
            if pi ~= p1
                error('Incompatible dimensions for adjoin operation');
            end
            if no == ni
                if ( ~any(any(a1-ai)) && ~any(any(b1-bi)) )
                    co = [co; [ci zeros_ss(pi,no-ni)]];
                else
                    ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
                    bo = [bo; bi];
                    co = [co zeros_ss(mo,ni); zeros_ss(mi,no) ci];
                end
            else
                ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
                bo = [bo; bi];
                co = [co zeros_ss(mo,ni); zeros_ss(mi,no) ci];
            end
            eo = [eo; ei];
        end
    elseif s_f == 'h'			% Horizontal stacking operation
        [ao,bo,co,eo] = unpack_ss(s1); [a1,~,c1,~] = unpack_ss(s1);
        [m1,~,~] = size_ss(s1);
        for i = 2:nargin-1
            si = eval(['s',int2str(i)]);
            [ai,bi,ci,ei] = unpack_ss(si); [mi,pi,ni] = size_ss(si);
            [~,po] = size(eo); [~,no] = size(ao);
            if mi ~= m1
                error('Incompatible dimensions for adjoin operation');
            end
            if no == ni
                if ( ~any(any(a1-ai)) && ~any(any(c1-ci)) )
                    bo = [bo [bi; zeros_ss(no-ni,mi)]];
                else
                    ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
                    bo = [bo zeros_ss(no,pi); zeros_ss(ni,po) bi];
                    co = [co ci];
                end
            else
                ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
                bo = [bo zeros_ss(no,pi); zeros_ss(ni,po) bi];
                co = [co ci];
            end
            eo = [eo ei];
        end
    else
        errmsg = ['Unrecognized input argument: s',int2str(nargin), ...
            ' = " ', s_f, ' "'];
        error(errmsg);
    end
else
    [ao,bo,co,eo] = unpack_ss(s1);		% Block-diagonal adjoin
    for i = 2:nargin
        si = eval(['s',int2str(i)]);
        [ai,bi,ci,ei] = unpack_ss(si); [mi,pi,ni] = size_ss(si);
        [mo,po] = size(eo); [~,no] = size(ao);
        ao = [ao zeros_ss(no,ni); zeros_ss(ni,no) ai];
        bo = [bo zeros_ss(no,pi); zeros_ss(ni,po) bi];
        co = [co zeros_ss(mo,ni); zeros_ss(mi,no) ci];
        eo = [eo zeros_ss(mo,pi); zeros_ss(mi,po) ei];
    end
end
so = pack_ss(ao,bo,co,eo);
%

function ns = issys(x)
% ISSYS		Determine whether argument is a system.
%
% Syntax: NS = ISSYS(X)
%
% Purpose:	The function ISSYS returns the state dimension of a variable,
%		which is nonzero if the argument is a packed matrix, and
%		zero if a regular matrix.
%
% Input:	X	- Variable who's state dimension is to be computed.
%
% Output:	NS	- A scalar containing the state dimension of X.  If
%			X is a regular matrix variable, then NS = 0.
%
% See Also:

% Algorithm:
%
% Calls:
%
% Called By:

%**********************************************************************
%
ns = find(all(isnan(x)));
%
if ~isempty(ns),
   ns = ns-1;
else
   ns = 0;

end
%
function [flag,na] = istito(sys)
% ISTITO	Determine whether argument is a TITO system.
%
% Syntax: FLAG = ISTITO(SYS) or
%         [FLAG,NA] = ISTITO(SYS)
%
% Purpose:	The function ISTITO determines whether the packed matrix
%		is in SISO or TITO form.  It may also be asked to return
%		the state dimension of the system.
%
% Input:	SYS  - a packed matrix system
%
% Output:	FLAG - one of two values:
%			  0 - SYS is SISO
%			  1 - SYS is TITO
%		NA   - state dimension of SYS
%
% See Also:

% Called By: STAR_SS



%**********************************************************************

% 
% Calculations
%
num = length(find(all(~isfinite(sys))));
if num == 2,				% dynamic TITO case
  flag = 1;
  na = find(all(isnan(sys))) - 1;
elseif num == 1					
  if isempty(find(all(isnan(sys)))),	% static TITO case
     flag = 1;
     na = 0;
  else					% dynamic SISO case
    flag = 0;
    na = find(all(isnan(sys))) - 1;
  end
else					% static SISO case
  flag = 0;
  na = 0;
end


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
sys	= ss(as, bs, cs, es);
function sys = lti_dla_kptow(wf, ps, pd, kvis)
% DLA_KPTOW.	Differential area/pressure to flow for a laminar leakage.
% Author:	D. A. Gutz
% Written:	22-Dec-92
% Revisions:

% Input:
% pd		Discharge pressure, psia.
% ps		Supply pressure, psia.
% kvis		Viscocity, centistokes.
% wf		Flow, pph.

% Differential IO.
% ps		Input # 1, supply pressure, psia.
% pd		Input # 2, discharge pressure, psia.
% k         Input # 3, area perturbation, pph-centistokes/psi.
% wf		Output # 1, flow, pph.

% Output:
% sys		Differential orifice model.

% Local:
% dwfdk	Partial flow to area.
% dwfdp	Partial flow to pressure, pph/psi.

% States:
% none.

% Functions called:
% none.

% Parameters.
% none.

% Partials.
dwfdk	= (ps - pd) / kvis;
dwfdp	= wf / (ps - pd);

% Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dwfdp 	-dwfdp		dwfdk];

% Form the system.
sys	= ss(a,b,c,e);
function sys = lti_dor_aptow(wf, ps, pd, cd, sg)
% function sys = dor_aptow(wf, ps, pd, cd, sg);
% Differential area/pressure to flow for a square law orifice.
% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	19-Aug-92	Simplify return arguments.
%               26-Nov-2012 add divide by zero protection%
% Input:
% cd		Coefficient of discharge.
% pd		Discharge pressure, psia.
% ps		Supply pressure, psia.
% sg		Specific gravity.
% wf		Flow, pph.
%
% Differential IO.
% ps		Input # 1, supply pressure, psia.
% pd		Input # 2, discharge pressure, psia.
% a         Input # 3, area perturbation, sqin.
% wf		Output # 1, flow, pph.
%
% Output:
% sys		Differential orifice model.

% Local:
% ao		Orifice area, sqin.
% dwfda	Partial flow to area, pph/sqin.
% dwfdp	Partial flow to pressure, pph/psi.

% States:
% none.

% Functions called:
% or_wptoa	Orifice area.
% ssqrt	Signed square root.

% Parameters.
ao	= or_wptoa(wf, ps, pd, cd, sg);

% Partials.
dwfda	= wf / ao;
psmpd	= sgn(ps - pd) * max(abs(ps - pd), 1e-16);  % 11/26/2012 add divide by zero protection
dwfdp	= wf / (2. * psmpd);

% Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dwfdp 	-dwfdp		dwfda];

% Form the system.
sys	= ss(a,b,c,e);
function sys = lti_dor_awpdtops(wf, ps, pd, cd, sg)
% function sys = dor_awpdtops(wf, ps, pd, cd, sg);
% Differential area/flow/discharge pressure to supply pressure.
% Author:   D. A. Gutz
% Written:  22-Jun-92
% Revisions:  19-Aug-92 Simplify return arguments.
%
% Input:
% cd    Coefficient of discharge.
% pd    Discharge pressure, psia.
% ps    Supply pressure, psia.
% sg    Specific gravity.
% wf    Flow, pph.
%
% Differential IO:
% a     Input  # 1, area perturbation, sqin.
% wf    Input  # 2, differential flow, pph.
% pd    Input  # 3, differential discharge pressure, psi.
% ps    Output # 1, differential supply pressure, psi.

% Local:
% ao     Orifice area, sqin.
% dpda   Partial pressure to area, psi/sqin.
% dpdw   Partial pressure to flow, psi/pph.

% States:
% none.

% Functions called:
% or_wptoa Orifice area.

% Parameters.
ao = or_wptoa(wf, ps, pd, cd, sg);

% Partials.
dpda = -2. * (ps - pd) / ao;
dpdw =  2. * (ps - pd) / wf;

% Connections and system construction.
a = [];
b = [];
c = [];
e = [dpda  dpdw  1];

% Form the system.
sys = ss(a,b,c,e);
function sys = lti_dor_awpstopd(wf, ps, pd, cd, sg)
% DOR_AWPSTOPD.	Differential area/flow/supply pressure to discharge pressure.
%  Author:	D. A. Gutz
%  Written:	22-Jun-92
%  Revisions:	19-Aug-92	Simplify return arguments.

%  Input:
%  cd		Coefficient of discharge.
%  pd		Discharge pressure, psia.
%  ps		Supply pressure, psia.
%  sg		Specific gravity.
%  wf		Flow, pph.

%  Output:
%  a,b,c,e	System state space matrices.
%  sys		Packed system definition.

%  Differential IO.
%  ao		Input # 1, area perturbation, sqin.
%  wf		Input # 2, differential flow, pph.
%  ps		Input # 3, differential supply pressure, psi.
%  pd		Output # 1, differential discharge pressure, psi.

%  Local:
%  ao		Orifice area, sqin.
%  dpda		Partial pressure to area, psi/sqin.
%  dpdw		Partial pressure to flow, psi/pph.

%  States:
%  none.

%  Functions called:
%  or_wptoa	Orifice area.

%  Parameters.
ao	= or_wptoa(wf, ps, pd, cd, sg);

%  Partials.
dpda	=  2. * (ps - pd) / ao;
dpdw	= -2. * (ps - pd) / wf;

%  Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dpda 	dpdw		1];

%  Form the system.
sys	= ss(a,b,c,e);
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
sys = ss(a,b,c,e);
function sys = lti_dwdp(dwfdp)
% DPSDW.	Differential pressure to flow.
%		Version with input sensitivity.
%  Author:	D. A. Gutz
%  Written:	26-Jun-92
%  Revisions:	19-Aug-92	Simplify return arguments.
%
%  Input:
%  dwfdp	Sensitivity, psi/pph.
%
%  Differential IO.
%  ps		Input # 1, differential supply pressure, psi.
%  pd		Input # 2, differential discharge pressure, psi.
%  wf		Output # 1, differential flow, pph.
%
%  Output:
%  sys		Packed system definition.

%  Local:
%  None.

%  States:
%  none.

%  Functions called:
%  none.

%  Parameters.
%  none.

%  Partials.
%  none.

%  Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dwfdp	-dwfdp];
sys	= ss(a,b,c,e);
function sys	= lti_fake_vg_b(dpav1, dpav2, wfl, cd, sg, vol_rcham, beta)


% FAKE_VG_B.	Build a fake load subsystem for a vg_b.
%		The model consists of adjustable drop in series with a fixed
%		drop. fx is frozen.  Equivalent to vg_b.
% Author:	D. A. Gutz
% Written:	14-Sep-92
% Revisions:	21-Sep-92	Unfroze pr & pr_sens.
%		29-Sep-92	Added vol_rcham.
%		29-Sep-92	Rewrote because non-working.


%%Input:
% dpav1		Variable load drop, psi.
% dpav2		Fixed load drop, psi.
% wfl		Load flow, pph.
% cd		Coefficient of discharge.
% sg		Specific gravity.
% vol_rcham	Rod chamber volume.
% beta		Fuel compressibility, psi.

% Differential IO:
% pd		Input # 1, supply pressure, psi.
% pr		Input # 2, drain pressure, psi.
% per		Input # 3, actuator end pressure, psi.
% wfld		Input # 4, load flow demand, mA.
% fx		Input # 5, load, lbf pullin.
% wfh_sens	Input # 6, head sense flow out of ehsv, pph.
% wfr_sens	Input # 7, rod sense flow out of ehsv, pph.
% wfs		Output # 1, supply flow in, pph.
% wfr		Output # 2, drain flow out, pph.
% wfve		Output # 3, actuator end flow pulled in by rod, pph.
% ph_sens	Output # 4, head sensed pressure at ehsv, psi.
% pr_sens	Output # 5, rod sensed pressure at ehsv, psi.
% ph		Output # 6, head pressure at actuator, psi.
% pr		Output # 7, rod pressure at actuator, psi.
% v_sv		Output # 8, EHSV spool velocity toward head end, in/s.
% x_sv		Output # 9, EHSV spool displacement toward head, in.
% v_act		Output # 10, actuator velocity toward head end, in/s.
% x_act		Output # 11, actuator  displacement toward head, in.

% Local:
% fake_ehsv	Variable load.
% fake_act	Fixed load.
% tee_pr	Flow tee for pr.
% dummy		Dummy for null i/o.
% tee_sum_pr	Sum flow to tee_pr.

% Functions called:
% m_valve_a	Variable valve.
% summer	sum.
% dor_aptow	Fixed drop.

% Parameters.
% none.

fake_ehsv	= m_valve_a(0, dpav1, wfl);
tee_pr		= vol_1(vol_rcham, beta, sg);
fake_act	= dor_aptow(wfl, dpav2, 0, cd, sg);
tee_sum_pr	= summer(1,1,0,0);
dummy		= summer(0,0,0,0);

% Make system.
sys	= adjoin(fake_ehsv, tee_pr, fake_act, tee_sum_pr, dummy);

% Inputs.
us	= [1	7	13	3	14	15	9];

% Outputs.
ys	= [1	3	5	5	2	5	2	5	5	5	5];

% Connections.
qs	=	[	2	2;
			4	1;
			5	4;
			6	2;
			10	3];

% Form the system.
[a,b,c,e]	= unpack_ss(sys);
[a,b,c,e]	= connect(a,b,c,e,qs,us,ys);
sys		= ss(a,b,c,e);
function sys = lti_head_b(ae, bdamp, cdf, dn, ks, kb, pf, ph, sg, wff, m)
% function sys = head_a(ae, bdamp, cdf, dn, ks, kb, pf, ph, sg, wff, m);
% Building block for a bellows head sensor.  Version with ph,
%		pl, & pf input and wfh, wfl, & wff output, mass.
% Author:	D. A. Gutz
% Written:	02-Dec-92	Add mass to head_a.
% Revisions:
%
% Input:
% ae     Sense bellows area, sqin.
% bdamp  Damping, lbf/(in/sec).
% cdf    Flapper coefficient of discharge.
% dn     Flapper nozzle diameter, in.
% ks     Spring rate, lbf/in.
% kb     Bellows spring rate, lbf/in.
% pf     Flapper supply pressure, psia.
% ph     High sensed pressure, psia.
% sg     Fluid specific gravity.
% wff    Flapper flow from pf into ph cavity, pph.
% m      Equivalent mass, lbm.
%
% Differential IO:
% ph     Input  # 1, high sensed differential pressure, psi.
% pl     Input  # 2, low sensed differential pressure, psi.
% pf     Input  # 3, flapper supply differential pressure, psi.
% wfh    Output # 1, high sensed differential flow in, pph.
% wfl    Output # 2, low sensed differential flow out, pph.
% wff    Output # 3, flapper differential flow in, pph.
% x      Output # 4, flapper differential position, in.
%
% Output:
% sys		Packed system of Input and Output.

% Local:
% af		Flapper discharge window area, sqin.
% dafdx	Partial area with flapper position, sqin/in.
% dwfda	Partial flow with flapper area, pph/sqin.
% dwdc		Volumetric to mass flow conversion, pph/cis.
% dwfdp	Partial flow with flapper delta pressure, pph/psi.
% q		Connection matrix.
% u		Input matrix.
% y		Output matrix.


% States:
% x	    Flapper differential position, in.

% Functions called:
% or_wptoa	Orifice calculation.

% Parameters.
af	= or_wptoa(wff, pf, ph, cdf, sg);
dwdc	= 129.93948 * sg;

% Partials.
dafdx	= pi * dn;
dwfda	= wff / af;
dwfdp	= wff / (2. * (pf - ph));

% Connections and system construction.
a	= [-bdamp	-(ks+kb)] * 386.4 / m;
a	= [a;
	  1	0];
b	= [ae	-ae	0] * 386.4 / m;
b	= [b;
	  0	0	0];
c	= [ae*dwdc	-dafdx*dwfda;
	  ae*dwdc	0;
	  0		dafdx*dwfda;
	  0		1];
e	= [dwfdp	0	-dwfdp;
	   0		0	0;
	   -dwfdp	0	dwfdp;
	   0		0	0];

sys	= ss(a, b, c, e);
function sys = lti_ip_wpdtops(~, b, c, f, r1, ~, r2, b2, rpm, wf, sg, tau)
% function sys = ip_wpdtops(a, b, c, f, r1, b1, r2, b2, rpm, wf, sg, tau)
% Impeller model, flow and discharge pressure to supply.
% Author:   D. A. Gutz
% Written:  08-Jul-92
% Revisions:
%  19-Aug-92    DA Gutz     Simplify return arguments.
%  11-Apr-2014  DA Gutz     Add f coefficient
%
% Input:
% a     Pump head coefficients.
% b              "
% c              "
% f              "
% r1    Inner radius, in.
% b1    Inner disk width, in.
% r2    Outer radius, in.
% b2    Outer disk width, in.
% rpm   Speed.
% wf    Flow, pph.
% sg    Specific gravity.
% tau   Time constant, sec.
%
% Differential IO:
% wf  Input #  1, flow, pph.
% pd  Input #  2, discharge pressure, psi.
% rpm Input #  3, speed, rpm.
% ps  Output # 1, supply pressure, psi.
%
% Output:
% sys   Packed system of Input and Output.

% Local:
% q  Connection matrix.
% u  Input matrix.
% y  Output matrix.


% States:
% none.

% Functions called:
% None.

% Parameters.
% fc    Flow coefficient.
% dwdc  Conversion cis to pph.
dwdc = 129.93948 * sg;
fc   = 5.851 * wf / (dwdc * 3.85 * b2 * r2^2 * rpm);
% hc   = a + (b + (c + f*fc)*fc)*fc;
% dp   = 1.022e-6 * hc * sg * (r2^2 - r1^2) * rpm^2;

% Partials.
% dfcdwf  Flow coefficient due to flow, 1/pph.
% dhcdfc  Head coefficient due to flow coefficient.
% dpdhc   Pressure due to head coefficient, psi.
% dfcdrpm Flow coefficient due to speed, 1/rpm.
dfcdwf  = fc / wf;
dhcdfc  = b + 2*c*fc + 3*f*fc^2;
dpdhc   = 1.022e-6 * sg * (r2^2 - r1^2) * rpm^2;
dfcdrpm = -fc / rpm;

% Connections and system construction.
as  = -1/tau;
bs  = [dfcdwf*dhcdfc*dpdhc/tau 0 dfcdrpm*dhcdfc*dpdhc/tau];
cs  = -1;
es  = [0 1 0];
sys = ss(as, bs, cs, es);
function sys = lti_ip_wpstopd(~, b, c, f, r1, ~, r2, b2, rpm, wf, sg, tau)
% function sys = ip_wpstopd(a, b, c, f, r1, b1, r2, b2, rpm, wf, sg, tau)
% Impeller model, flow and supply pressure to discharge.
% Author:   D. A. Gutz
% Written:  20-Sep-2013
% Revisions: 
%  11-Apr-2014  DA Gutz    Add f coefficient
%
% Input:
% a     Pump head coefficients.
% b              "
% c              "
% f              "
% r1    Inner radius, in.
% b1    Inner disk width, in.
% r2    Outer radius, in.
% b2    Outer disk width, in.
% rpm   Speed.
% wf    Flow, pph.
% sg    Specific gravity.
% tau   Time constant, sec.
%
% Differential IO:
% wf  Input #  1, flow, pph.
% ps  Input#   2, supply pressure, psi.
% rpm Input #  3, speed, rpm.
% pd  Output # 1, discharge pressure, psi.
%
% Output:
% sys   Packed system of Input and Output.
% pd-ps Pressure rise, psid

% Local:
% q  Connection matrix.
% u  Input matrix.
% y  Output matrix.


% States:
% none.

% Functions called:
% None.

% Parameters.
% fc    Flow coefficient.
% dwdc  Conversion cis to pph.
dwdc = 129.93948 * sg;
fc   = 5.851 * wf / (dwdc * 3.85 * b2 * r2^2 * rpm);
% hc   = a + (b + (c + f*fc)*fc)*fc;
% dp   = 1.022e-6 * hc * sg * (r2^2 - r1^2) * rpm^2;

% Partials.
% dfcdwf  Flow coefficient due to flow, 1/pph.
% dhcdfc  Head coefficient due to flow coefficient.
% dpdhc   Pressure due to head coefficient, psi.
% dfcdrpm Flow coefficient due to speed, 1/rpm.
dfcdwf  = fc / wf;
dhcdfc  = b + 2*c*fc + 3*f*fc^2;
dpdhc   = 1.022e-6 * sg * (r2^2 - r1^2) * rpm^2;
dfcdrpm = -fc / rpm;

% Connections and system construction.
as  = -1/tau;
bs  = [dfcdwf*dhcdfc*dpdhc/tau 0 dfcdrpm*dhcdfc*dpdhc/tau];
cs  = 1;
es  = [0 1 0];
sys = ss(as, bs, cs, es);
function sys = lag(tau)
% LAG.		Building block for simple first order lag.
%  Author:	D. A. Gutz
%  Written:	26-Jun-92
%  Revisions:	19-Aug-92	Simplify return arguments.
%
%  Input:
%  tau		Time constant, sec.

%  Differential IO:
%  x		Input # 1.
%  y		Output # 1, lagged by tau.

%  Output:
%  sys		Packed system of Input and Output.

%  Local:
%  q		Connection matrix.
%  u		Input matrix.
%  y		Output matrix.


%  States:
%  y		Output.

%  Functions called:
%  None.

%  Parameters.
%  None.

%  Partials.
%  None.

%  Connections and system construction.
a	= -1/tau;
b	= 1/tau;
c	= 1;
e	= 0;
sys	= ss(a, b, c, e);
function sys = lti_m_valve_a(pd, ps, wf)
% function sys = m_valve_a(pd, ps, wf)
% M_VALVE_A.	Building block for a metering valve.  Square law orifice.
%		Version with ps and pd inputs.
%  Author:	D. A. Gutz
%  Written:	19-Aug-92
%  Revisions:	none.
%  Input:
%  pd		Discharge pressure, psia.
%  ps		Supply pressure, psia.
%  wf		Discharge flow out, pph.
%  Output:
%  sys		Packed system of Input and Output.
%  Differential IO:
%  ps		Input # 1, supply pressure, psia.
%  pd		Input # 2, discharge pressure, psia.
%  wfdem	Input # 3, metering valve area in flow units, pph.
%  wf		Output # 1, discharge flow out, pph.

%  Local:
%  dwdp		Sensitivity pressure to flow, pph/psi.

%  States:
%  none.

%  Functions called:
%  or_wptoa	Orifice calculation.

%  Parameters.
%  none.

%  Partials.
dwdp	= wf / (2. * (ps - pd));


%  Connections and system construction.
a	= [];
b	= [];
c	= [];
e	= [dwdp	-dwdp	1];
sys	= ss(a, b, c, e);
function sys = lti_man_1_mv(l, a, vol, spgr, beta, c)
% function sys = man_1_mv(l, a, vol, spgr, beta, c);
% MAN_1_MV.	Build a one element line: momentum first, volume last.
% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	19-Aug-92	Simplify output arguments.
%		10-Dec-98	Add damping, c.
% Input:
% l		Line length, in.
% a		Line cross section, sqin.
% vol		Line volume, cuin.
% spgr		Fluid specific gravity.
% beta		Fluid compressibility, psi.
% c		Damping, psi/in/sec, (OPTIONAL).
% Differential I/O:
% ps		Input # 1, supply pressure, psia.
% wfd		Input # 2, discharge flow, pph.
% wfs		Output # 1, supply flow, pph.
% pd		Output # 2, discharge pressure, psia.

% Functions called:
% vol_1	Creates volume node.
% mom_1	Creates momenum slice.

% Momentum slice.
if nargin == 6,
	m_1	= lti_mom_1(l, a, c);
else
	m_1	= lti_mom_1(l, a);
end

% Volume.
v_1	= lti_vol_1(vol, beta, spgr);

% Put system into block diagonal form.
temp	= adjoin(make_pack(m_1), make_pack(v_1));

% Inputs are ps and wfd.
u	= [1	4];

% Outputs are wfs and pd.
y	= [1	2];

% Connections.
q	=	[2	2;
		3	1];

% Form the system.
[a,b,c,e]	= unpack_ss(temp);
[a,b,c,e]	= connect(a,b,c,e,q,u,y);
sys	= ss(a,b,c,e);
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
sys	= ss(a,b,c,e);
function sys = lti_man_n_mm(l, a, vol, n, spgr, beta, c)
% function sys = lti_man_n_mm(l, a, vol, n, spgr, beta, c)
% MAN_N_MM.	Building block for a line distributed among equally sized
%		volumes and momentum slices, with momentum first & last (n = #
%		of volume nodes and n+1 = # momentum slices).
% Author:	D. A. Gutz
% Written:	22-Oct-2012
% Input:
% a		Line cross-section, sqin.
% beta  Fluid bulk modulus, psi.
% l		Line length, in.
% n		Number of momentum slices.
% spgr	Fluid specific gravity.
% vol	Line volume, cuin.
% c		Damping, psi/in/sec, (OPTIONAL).
% Differential I/O:
% ps	Input # 1, supply pressure, psia.
% pd	Input # 2, discharge pressure, psia.
% wfs	Output # 1, supply flow, pph.
% wfd	Output # 2, discharge flow, pph.

% Functions called:
% man_1_mv	Create single element line of ps, wfd input and wfs, pd output.
% mom_1		Create single momentum slice of ps, pd input and wf output.

% Check size.
if n<1
	error('Number of nodes < 1 in man_n_mm.')
end

% Single manifold slice.
if nargin == 7,
	man	= lti_man_1_mv(l/(n+1), a, vol/n, spgr, beta, c);
else
	man	= lti_man_1_mv(l/(n+1), a, vol/n, spgr, beta);
end

% Single momentum slice.
endmom	= lti_mom_1(l/(n+1), a);

% Inputs are ps and pd.
u	= [1	2*n+2];

% Outputs are wfs and wfd.
y	= [1	2*n+1];

% Connections and system construction.
temp	= make_pack(man);
q   = [];
for i=2:n
	temp	= adjoin(temp, make_pack(man));
	q	= [q;
		   2*(i-1)	2*(i-1)+1;
		   2*(i-1)+1	2*(i-1)];
end
temp	= adjoin(temp, make_pack(endmom));
q	= [q;
	   2*n		2*n+1;
	   2*n+1	2*n];

% Form the system.
[a,b,c,e]	= unpack_ss(temp);
[a,b,c,e]	= connect(a,b,c,e,q,u,y);
sys	= ss(a,b,c,e);
function sys = lti_man_n_mv(l, a, vol, n, spgr, beta, c)
% function sys = man_n_mv(l, a, vol, n, spgr, beta, c)
% MAN_N_MV.	Building block for a line distributed among n equally sized
%		volumes and momentum slices, with momentum first & volume last.
% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	19-Aug-92	Simplify output arguments.
%               10-Dec-98	Add damping, c.
% Input:
% a		Line cross-section, sqin.
% beta	Fluid bulk modulus, psi.
% l		Line length, in.
% n		Number of volume node / momentum slice pairs.
% spgr	Fluid specific gravity.
% vol	Line volume, cuin.
% c		Damping, psi/in/sec, (OPTIONAL).
% Differential I/O:
% ps	Input # 1, supply pressure, psia.
% wfd	Input # 2, discharge flow, pph.
% wfs	Output # 1, supply flow, pph.
% pd	Output # 2, discharge pressure, psia.

% Functions called:
% man_1_mv	Creates single element line of ps, wfd input and wfs, pd output.

% Check size.
if n<1
	error('Number of nodes < 1 in man_n_mv.')
end

% Single manifold slice.
if nargin == 7
	man	= man_1_mv(l/n, a, vol/n, spgr, beta, c);
else
	man	= man_1_mv(l/n, a, vol/n, spgr, beta);
end

% Inputs are ps and wfd.
u	= [1	n*2];

% Outputs are wfs and pd.
y	= [1	n*2];

% Connections and system construction.
temp	= man;
q = [];
for i=2:n
	temp	= adjoin(temp, man);
	q	= [q;
		   2*(i-1)	2*(i-1)+1;
		   2*(i-1)+1	2*(i-1)];
end

% Form the system.
[a,b,c,e]	= unpack_ss(temp);
[a,b,c,e]	= connect(a,b,c,e,q,u,y);
sys	= ss(a,b,c,e);
function sys = lti_man_n_vm(l, a, vol, n, spgr, beta, c)
% function sys = man_n_vm(l, a, vol, n, spgr, beta, c)
% MAN_N_VM.	Building block for a line distributed among n equally sized
%		volumes and momentum slices, with volume first & momentum last.
% Author:	D. A. Gutz
% Written:	16-Apr-92
% Revisions:	22-Jun-92	Added vm subscripts.
%		        19-Aug-92	Simplify output arguments.
%		        10-Dec-98	Add damping, c.
% Input:
% a		Line cross-section, sqin.
% beta	Fluid bulk modulus, psi.
% l		Line length, in.
% n		Number of momentum slice / volume node pairs.
% spgr	Fluid specific gravity.
% vol	Line volume, cuin.
% c		Damping, psi/in/sec, (OPTIONAL).
% Differential I/O:
% wfs	Input # 1, supply flow, pph.
% pd	Input # 2, discharge pressure, psia.
% ps	Output # 1, supply pressure, psia.
% wfd	Output # 2, discharge flow, pph.

% Functions called:
% man_1_vm	Creates single element line of wfs, pd input and ps, wfd output.

% Check size.
if n<1
	error('Number of nodes < 1 in man_n_vm.')
end

% Single manifold slice.
if nargin == 7,
	man	= lti_man_1_vm(l/n, a, vol/n, spgr, beta, c);
else
	man	= lti_man_1_vm(l/n, a, vol/n, spgr, beta);
end

% Inputs are wfs and pd.
u	= [1	n*2];

% Outputs are ps and wfd.
y	= [1	n*2];

% Connections and system construction.
temp	= make_pack(man);
q = [];
for i=2:n
	temp	= adjoin(temp, make_pack(man));
	q	= [q;
		   2*(i-1)	2*(i-1)+1;
		   2*(i-1)+1	2*(i-1)];
end

% Form the system.
[a,b,c,e]	= unpack_ss(temp);
[a,b,c,e]	= connect(a,b,c,e,q,u,y);
sys	= ss(a,b,c,e);
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
sys	= ss(a,b,c,e);
function sys = lti_mom_1(l, a, c)
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

a	= -dp;
b	= [dw	-dw];
c	= 1;
e	= [0	0];

% Form the system.
sys	= ss(a,b,c,e);
function sys = lti_pos_pump(cs, ct, cn, ps, pd, rpm, disp, kvis, sg)
% POS_PUMP.	Positive displacement pump model.
% Author:	D. A. Gutz
% Written:	19-Aug-92
% Revisions:	None.
%
% Input:
% cs		Laminar slip flow coefficient.
% ct		Turbulent slip flow coefficient. 
% cn		Speed slip flow coefficient.
% disp		Displacement, cuin/rev.
% ps		Supply, psia.
% pd		Discharge, psia.
% kvis		Kinematic viscosity, centistokes.
% sg		Specific gravity.

% Differential IO:
% ps		Input # 1, supply pressure, psi.
% pd		Input # 2, discharge pressure, psi.
% rpm		Input # 3, speed, rpm.
% disp		Input # 4, displacement, cuin/rev.
% wf		Output # 1, flow, pph.

% Output:
% sys		Packed system of Input and Output.

% Local:
% q		Connection matrix.
% u		Input matrix.
% y		Output matrix.

% States:
% none.

% Functions called:
% None.

% Parameters.
% avis		Absolute viscosity, lbf-sec/sqin.
% cis		Flow, cis.
% dwdc		Conversion cis to pph.
% eff_vol	Volumetric efficiency.
% mtdqp		avis * rad/sec / pl, dimensionless speed factor.
% pl		Load, psi.
% wf		Flow, pph.

avis	= 9.312e-5 * .00155 * sg * kvis;
dwdc	= 129.93948 * sg;
pl	= pd - ps;
mtdqp	= avis * .10471976 * rpm / pl;
eff_vol	= 1 - cs / mtdqp - ct * 1825 * ssqrt(pl / sg) / rpm / disp^.3333 - cn;
cis	= eff_vol * disp * rpm / 60;
wf	= cis * dwdc; %#ok<NASGU>

% Partials.
dwfdcis		= dwdc;
dcisdeff_vol	= disp * rpm / 60;
deff_voldpl	= -ct * 1825 / sqrt(sg) / (2 * sqrt(abs(pl))) / rpm / disp^.333;
dpldps		= -1;
dpldpd		= 1;
deff_voldmtdqp	= cs / mtdqp^2;
deff_volddisp	= .33333 * ct * 1825 * ssqrt(pl / sg) / rpm / disp^1.333;
dmtdqpdpl	= -mtdqp / pl;
dmtdqpdrpm	= mtdqp / rpm;
dcisdrpm	= cis / rpm;
dcisddisp	= cis / disp;
dwfdps		= dwfdcis * dcisdeff_vol * (deff_voldpl * dpldps +...
		   deff_voldmtdqp * dmtdqpdpl * dpldps);
dwfdpd		= dwfdcis * dcisdeff_vol * (deff_voldpl * dpldpd +...
		   deff_voldmtdqp * dmtdqpdpl * dpldpd);
dwfdrpm		= dwfdcis * (dcisdrpm +...
		   dcisdeff_vol * deff_voldmtdqp * dmtdqpdrpm);
dwfddisp	= dwfdcis * (dcisddisp +...
		   dcisdeff_vol * deff_volddisp);

% Connections and system construction.
asys	= [];
bsys	= [];
csys	= [];
esys	= [dwfdps	dwfdpd	dwfdrpm		dwfddisp];
sys	= ss(asys, bsys, csys, esys);
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
sys	= ss(as, bs, cs, es);
function sys = lti_spring(s1, s2, ks)
% SPRING.	Building block for spring.
% Author:	D. A. Gutz
% Written:	26-Aug-92.
% Revisions:	



% Input:
% s1		Sign of x1.
% s2		Sign of x2.
% ks		Spring rate, lbf/in.

% Output:
% sys		Packed system of Input and Output.

% Differential IO:
% x1		Input # 1, spring end disp to compress, in.
% x2		Input # 2, spring end disp to compress, in.
% f		Output # 1, spring compression, lbf.
%-f		Output # 2, spring extension, lbf.

% Local:
% none.

% States:
% none.

% Functions called:
% none.

% Parameters.
% none.

% Partials.
% none.

% Connections and system construction.
as	= []; bs=	[]; cs	= [];
es	= [ks*s1	ks*s2;
	   -ks*s1	-ks*s2];
sys	= ss(as, bs, cs, es);
function sys = lti_trivalve_a(ahs, ahd, alr, ald, ale, bdamp, cd, ks, m, ki,...
		cause, ps, pd, px, sg, ws, wd, wfsx, wfxd,...
		stops)
% TRIVALVE_A.	Building block for a trivalve.  Transient and jet forces
%		neglected.  Friction is neglected (damping input).  Transient
%		leakages neglected.
% Author:	D. A. Gutz
% Written:	17-Aug-92.
% Revisions:	19-Aug-92	Simplify output arguments.
%		26-Aug-92	Reconfigure.
%		11-Sep-92	Added stops.
%		14-Sep-92	Change pressure cause to 0.

% Input:
% ahs		Spool supply end head area, sqin.
% ahd		Spool drain end head area, sqin.
% alr		Load land rod end head area, sqin.
% ald		Load land drain end head area, sqin.
% ale		Load land bitter end area, sqin.
% bdamp		Damping, lbf/(in/sec).
% cause		Causality, 0=pressure, 1=flow.
% cd		Coefficient of discharge.
% ks		Spring rate, lbf/in.
% m		Total mass, lbm.
% ki		Torque motor gain, lbf/mA.
% ps		Supply pressure, psia.
% pd		Drain pressure, psia.
% px		Control pressure, psia.
% sg		Fluid specific gravity.
% ws		Supply area gradient, sqin/in.
% wd		Discharge area gradient, sqin/in.
% wfxd		Discharge flow out, pph.
% wfsx		Supply flow in, pph.
% stops		0=go.

% Output:
% sys		Packed system of Input and Output.

% Differential IO:
% ps		Input # 1, supply pressure, psia.
% pd		Input # 2, drain pressure, psia.
% px		Input # 3, control pressure, psia.	(cause=0)
% wfx		Input # 3, control flow out, pph.	(cause=1)
% pes		Input # 4, supply end pressure, psia.
% ped		Input # 5, drain end pressure, psia.
% pel		Input # 6, load land bitter end pressure, psia.
% plr		Input # 7, inside external land pressure, psia.
% pld		Input # 8, outside external land pressure, psia.
% mA		Input # 9, torque motor current, mA.
% fext		Input # 10, external load toward drain, lbf.
% wfs		Output # 1, supply flow in, pph.
% wfd		Output # 2, drain flow out, pph.
% wfx		Output # 3, control flow out, pph.	(cause=0)
% px		Output # 3, control pressure, psia 	(cause=1)
% wfse		Output # 4, supply end flow out, pph.
% wfde		Output # 5, drain end flow out, pph.
% wfle		Output # 6, load land bitter end flow out, pph.
% wflr		Output # 7, external land flow into rod side, pph.
% wfld		Output # 8, external land flow out drain side, pph.
% dxdt		Output # 9, spool velocity toward drain, in/sec.
% x         Output # 10, spool displacement toward drain, in.

% Local:
% ad		Drain window area, sqin.
% as		Supply discharge window area, sqin.
% dwdc		Flow conversion, pph/cis.

% States:
% dxdt		Spool velocity toward drain, in/sec.
% x		Spool displacement toward drain, in.

% Functions called:
% or_wptoa	Orifice area.
% ssqrt		Signed square root.

% Parameters.
dwdc	= 129.93948 * sg;
ad	= or_wptoa(wfxd, px, pd, cd, sg);
as	= or_wptoa(wfsx, ps, px, cd, sg);

% Partials.
dwfsda	= wfsx / max(as, 1e-16);
dwfsdp	= wfsx / (2. * (ps - px));
dasdx	= ws;
dwfdda	= wfxd / max(ad, 1e-16);
dwfddp	= wfxd / (2. * (px - pd));
daddx	= -wd;
dwfxdx	= dwfsda * dasdx - dwfdda * daddx;
dwfxdpx	= dwfsdp + dwfddp;

% Connections and system construction.
as	= [-bdamp	-ks] * 386. / m;
as	= [as;
	    1	  0];
bs	= [0	0	0	ahs	-ahd	-ale	alr -ald ki 1];
bs	= bs * 386. / m;
bs	= [bs;
	   0	0	0	0	0	0	0    0   0 0];
if stops~=0,	% Freeze states if on stops.
	bs	= 0 * bs;
end
% Pressure causality:
if cause == 0,
cs	= [0		dwfsda*dasdx;
	   0		dwfdda*daddx;
	   0		dwfxdx;
	   -dwdc*ahs	0;
	   dwdc*ahd	0;
	   dwdc*ale	0;
	   dwdc*alr	0;
	   dwdc*ald	0;
	   1		0;
	   0		1];
es	= [dwfsdp	0	-dwfsdp	0	0	0	0 0 0 0;
	   0		-dwfddp	dwfddp	0	0	0	0 0 0 0;
	   dwfsdp	dwfddp	-dwfxdpx 0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0];
% Flow causality:
elseif cause == 1,
cs	= [0		(dwfsda*dasdx - dwfxdx*dwfsdp/dwfxdpx);
	   0		(dwfdda*daddx + dwfxdx*dwfddp/dwfxdpx);
	   0		(dwfxdx/dwfxdpx);
	   -dwdc*ahs	0;
	   dwdc*ahd	0;
	   dwdc*ale	0;
	   dwdc*alr	0;
	   dwdc*ald	0;
	   1		0;
	   0		1];
es	= [(dwfsdp - dwfsdp*dwfsdp/dwfxdpx)	-dwfddp*dwfsdp/dwfxdpx	...
			dwfsdp/dwfxdpx	0	0	0	0 0 0 0;
	   dwfsdp*dwfddp/dwfxdpx	(dwfddp*dwfddp/dwfxdpx -dwfddp) ...
			-dwfddp/dwfxdpx	0	0	0	0 0 0 0;
	   dwfsdp/dwfxdpx			dwfddp/dwfxdpx ...
			-1/dwfxdpx	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0;
	   0		0	0	0	0	0	0 0 0 0];
else
	error('Improper cause input to trivalve_a.')
	return; %#ok<UNRCH>
end;
% Form the system.
sys	= ss(as, bs, cs, es);
function sys = lti_valve_a(ax1, ax2, ax4, bdamp, cd, ks, ms, mv,...
		pd, ph, ps, sg, wd, wfd, wfh, wh, stops, cp)
% function sys = valve_a(ax1, ax2, ax4, bdamp, cd, ks, ms, mv,...
% 		pd, ph, ps, sg, wd, wfd, wfh, wh, stops, cp)
% VALVE_A.	Building block for a valve.  Transient and jet forces
%		neglected.  Friction is neglected.  The orifice is neglected.
%		Damping is an input.


% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	26-Jun-92	Fixed sign e(1,3).
%		29-Jun-92	Added states to output.
%		19-Aug-92	Simplify output arguments.
%		19-Nov-92	stops added.
%		03-Feb-93	Jet forces added.
%		09-Apr-93	Error trap on divide by zero.
%		17-Oct-96	Error trap on divide by zero.
% Input:
% ax1		Supply to reference cross-section, sqin.
% ax2		Damping cross-section, sqin.
% ax3		Supply cross-section, sqin.
% ax4		Supply to opposite spring end cross-seciton, sqin.
% bdamp	Damping, lbf/(in/sec).
% cd		Coefficient of discharge.
% cp            Jet force coefficient.
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
% sys		Packed system of Input and Output.

% Differential IO:
% ps		Input # 1, supply pressure, psia.
% pd		Input # 2, discharge pressure, psia.
% ph		Input # 3, high discharge pressure, psia.
% prs		Input # 4, Reference opposite spring eng pressure, psia.
% pr		Input # 5, Regulated pressure, psia.
% pxr		Input # 6, Reference pressure, psia.
% wfs		Output # 1, supply flow in, pph.
% wfd		Output # 2, discharge flow out, pph.
% wfh		Output # 3, high discharge flow in, pph.
% wfvrs     Output # 4, reference opposite spring end flow in, pph.
% wfvr		Output # 5, reference flow out, pph.
% wfvx		Output # 6, damping flow out, pph.
% dxdt		Output # 7, spool velocity toward drain, in/sec.
% x         Output # 8, spool displacement toward drain, in.

% Local:
% ad		Discharge window area, sqin.
% ah		High discharge window area, sqin.
% dwdc		Flow conversion, pph/cis.
% dwfdda	Partial wfd with area, pph/sqin.
% dwfddp	Partial wfd with pressure, pph/psi.
% dwfhda	Partial wfh with area, pph/sqin.
% dwfhdp	Partial wfh with pressure, pph/psi.
% m         Total mass, lbm.


% States:
% dxdt		Spool velocity toward drain, in/sec.
% x         Spool displacement toward drain, in.

% Functions called:
% or_wptoa	Orifice area.
% ssqrt	Signed square root.

% Parameters.
m	= ms / 2. + mv;
dwdc	= 129.93948 * sg;
ad	= or_wptoa(wfd, ps, pd, cd, sg);
ah	= or_wptoa(wfh, ph, ps, cd, sg);

% Partials.
dwfdda	= wfd / max(ad, 1e-16);
dwfddp	= wfd / (2. * sgn(ps - pd) * max(abs(ps - pd),1e-16));
dwfhda	= wfh / max(ah, 1e-16);
dwfhdp	= wfh / (2. * sgn(ph - ps) * max(abs(ph - ps), 1e-16));
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
b	= [(ax1-ax4-dfjhdp-dfjddp) dfjddp dfjhdp ax4 -(ax1-ax2) -ax2];
b	= b * 386. / m;
b	= [b;
	   0		0	0	0		0	0];
if stops ~= 0,	% Freeze states if on stops.
	b	= 0*b;
end
c	= [dwdc*(ax1-ax4)	(dwfdda*wd + dwfhda*wh);
	   0			dwfdda*wd;
	   0			-dwfhda*wh;
	   ax4*dwdc			0;
	   (ax1-ax2)*dwdc		0;
	   ax2*dwdc			0;
	   1				0;
	   0				1];
e	= [(dwfddp+dwfhdp)	-dwfddp	-dwfhdp		0	0	0;
	   dwfddp	-dwfddp		0		0	0	0;
	  -dwfhdp	0		dwfhdp		0	0	0;
	   0		0		0		0	0	0;
	   0		0		0		0	0	0;
	   0		0		0		0	0	0;
	   0		0		0		0	0	0;
	   0		0		0		0	0	0];

% Form the system.
sys	= ss(a,b,c,e);
function sys = lti_valve_a_1(ax1, ax2, ax4, bdamp, cd, ks, ms, mv, pd, ph, ps, sg, wd, wfd, wfh, wh, stops, cp, openLoop)
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
% x         O # 8, spool displacement toward drain, in.

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
if openLoop,
    c	= [dwdc*(ax1-ax4)		0;
        0				0;
        0				0;
        ax4*dwdc			0;
        (ax1-ax2)*dwdc		0;
        ax2*dwdc			0;
        1				0;
        0				1];
    e	= [(dwfddp+dwfhdp)	-dwfddp	-dwfhdp	0 0 0 (dwfdda*wd + dwfhda*wh);
        dwfddp	-dwfddp		0	0 0 0 dwfdda*wd;
        -dwfhdp	0		dwfhdp	0 0 0 -dwfhda*wh;
        0		0		0	0 0 0 0;
        0		0		0	0 0 0 0;
        0		0		0	0 0 0 0;
        0		0		0	0 0 0 0;
        0		0		0	0 0 0 0];
else
    c	= [dwdc*(ax1-ax4)	(dwfdda*wd + dwfhda*wh);
        0			dwfdda*wd;
        0			-dwfhda*wh;
        ax4*dwdc			0;
        (ax1-ax2)*dwdc		0;
        ax2*dwdc			0;
        1				0;
        0				1];
    e	= [(dwfddp+dwfhdp)	-dwfddp	-dwfhdp	0 0 0 0;
        dwfddp	-dwfddp		0	0 0 0 0;
        -dwfhdp	0		dwfhdp	0 0 0 0;
        0		0		0	0 0 0 0;
        0		0		0	0 0 0 0;
        0		0		0	0 0 0 0;
        0		0		0	0 0 0 0;
        0		0		0	0 0 0 0];
end
% Form the system.
sys	= ss(a,b,c,e);
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
sysol	= ss(a,b,col,eol);
function ven_load = lti_ven_load_setup(D, FP, pd_ven, pr_ven, phead_ven, prod_ven, wfhl_act_ven, wfrl_act_ven, wfb_act_ven, wfhd_ehsv_ven, wfrd_ehsv_ven, wfsh_ehsv_ven, wfsr_ehsv_ven, wfj_ehsv_ven)
% VEN_LOAD_SETUP.	Build a VEN load subsystem for the F414 VEN system.
%		The model consists of EHSV and actuator; alternatively
%		a resistive load is used.
% Written:	D. Gutz		24-Oct-96
% Revisions:

beta_ven = FP.beta;
sg_ven  = FP.sg;

% Input:
% beta_ven	Fuel compressibility, psi.
% pd_ven	VEN pump discharge pressure, psia.
% pr_ven	VEN servo return pressure, psia.
% prod_ven	VEN rod pressure, psia.
% phead_ven	VEN head pressure, psia.
% wfl_ven	Load flow, pph.
% ah_act_ven	Actuator area, sqin.
% sg_ven	Fluid specific gravity.
% stops_act_ven	Actuator stops, 0=go.
% ah_ehsv_ven		EHSV spool end head area, sqin.
% cause_ehsv_ven	EHSV causality, 1=flow, 2=pressure.
% cd_ehsv_ven		EHSV coefficient of discharge.
% wdh_ehsv_ven	EHSV head drain area gradient, sqin/in.
% wdr_ehsv_ven	EHSV rod drain area gradient, sqin/in.
% wsh_ehsv_ven	EHSV head supply area gradient, sqin/in.
% wsr_ehsv_ven	EHSV rod supply  area gradient, sqin/in.
% wfhd_ehsv_ven	EHSV head to drain flow, pph.
% wfrd_ehsv_ven	EHSV rod to drain flow, pph.
% wfsh_ehsv_ven	EHSV supply to head flow, pph.
% wfsr_ehsv_ven	EHSV supply to rod flow, pph.
% wfj_ehsv_ven	EHSV first stage flow, pph.
% stops_ehsv_ven	EHSV: 0=go.
% kix_ehsv_ven	EHSV servovalve gain, inches/mA.
% tau_ehsv_ven	EHSV time constant, sec.
% dp_s_ehsv_ven	EHSV (ps-pd) at time constant sizing, psi.
% l_rl_ven	Rod line length, in.
% a_rl_ven	Rod line section, sqin.
% vol_rl_ven	Rod line volume, cuin.
% n_rl_ven	Rod line number of vol nodes.
% l_hl_ven	Head line length, in.
% a_hl_ven	Head line section, sqin.
% vol_hl_ven	Head line volume, cuin.
% n_hl_ven		Head line number of vol nodes.
% vol_rc_ven	Rod chamber volume, cuin.
% vol_hc_ven	Head chamber volume, cuin.
% ah_act_ven	Actuator head end section, sqin.
% ar_act_ven	Actuator rod end section, sqin.
% bdamp_act_ven	Actuator damping, lbf/in/s.
% mact_act_ven	Actuator mass, lbm.
% mext_act_ven	Actuator external mass, lbm.
% wfb_act_ven	Actuator cross piston bleed rod to head, pph.
% wfrl_act_ven	Actuator rod leakage out, pph.
% wfhl_act_ven	Actuator head leakage out, pph.
% vol_rchamr_ven	Resistive load rod chamber volume, cuin.

% Differential IO:
% pdload	Input # 1, VEN pump disch, psi.
% prload	Input # 2, VEN return pressure, psi.
% perload	Input # 3.
% wfldload	Input # 4, VEN load flow demand, pph.
% fxload	Input # 5, VEN load, lbf.
% wfh_sens_load	Input # 6, Head sense, pph.
% wfr_sens_load	Input # 7, Rod sense, pph.
% wfsload	Output # 1, VEN supply flow, pph.
% wfrload	Output # 2, VEN load flow, pph.
% wfveload	Output # 3.

% Local:
% dpav1_ven	Variable load drop, psi.
% dpav2_ven	Fixed load drop, psi.
% psven		ps_ven splitter.
% pump_ven	VEN pump.
% tsum_pd_ven	pd_ven tee flow sum.
% tee_pd_ven	pd_ven volume.
% bias		bias piston.
% bias_spring	Bias piston spring.
% reg_ven	VEN pump pressure regulator.
% tee_pd_reg_ven	pd_ven to regulator flow sum.
% piston_ven	VEN pump actuator.
% disp_pump_ven	Gain actuator to pump displacement.
% force_pump_ven_1	Ven pump force balance.
% force_pump_ven_2	VEN pump force balance.
% tee_ps_ven	ps_ven flow sum.
% disp_piston_ven	VEN pump actuator flow robbing.
% ven_load	VEN load.

% Functions called:
% trivalve_b	Trivalve setup.
% summer	Tee.
% splitter	Tee.
% pump_act_ven	Actuator.
% fake_load_ven	Load.
% spring	Spring.

% Parameters.
% none.
if stops_ehsv_ven == 1,
	ven_load	= lti_fake_vg_b((pd_ven - pr_ven) / 2., (pd_ven - pr_ven) / 2., D.wfl_ven, D.cd_ehsv_ven, sg_ven, D.vol_rchamr_ven, beta_ven);
elseif swmodel_ven == 1,
	ven_load	= lti_fake_vg_b(D.dpav1_ven, D.dpav2_ven, D.wfl_ven, D.cd_ehsv_ven, sg_ven, D.vol_rchamr_ven, beta_ven);
elseif swmodel_ven == 0,
	ven_load	= lti_vg_b(D.ah_ehsv_ven, D.cd_ehsv_ven,...
	D.cause_ehsv_ven, D.pd_ven, D.pr_ven, D.phead_ven, D.prod_ven, sg_ven,...
	D.wdh_ehsv_ven, D.wdr_ehsv_ven, D.wsh_ehsv_ven, D.wsr_ehsv_ven,...
	D.wfhd_ehsv_ven, D.wfrd_ehsv_ven, D.wfsh_ehsv_ven, D.wfsr_ehsv_ven,...
	D.wfj_ehsv_ven, D.stops_ehsv_ven, D.kix_ehsv_ven, D.tau_ehsv_ven,...
	D.dp_s_ehsv_ven, D.l_rline_ven, D.a_rline_ven, D.vol_rline_ven, D.n_rline_ven,...
	D.l_hline_ven, D.a_hline_ven, D.vol_hline_ven, D.n_hline_ven,...
	beta_ven, D.vol_rcham_ven, D.vol_hcham_ven, D.ah_act_ven, D.ar_act_ven,...
	D.bdamp_act_ven, D.mact_act_ven, D.mext_act_ven, D.wfb_act_ven,...
	D.wfrl_act_ven, D.wfhl_act_ven, D.stops_act_ven);

else
	error('VEN load model not selected')
end
function sys = lti_vg_b(ah_sv, cd_sv, cause_sv, ps, pd, ph, pr, sg,...
    wdh_sv, wdr_sv, wsh_sv, wsr_sv, wfhd_sv, wfrd_sv,...
    wfsh_sv, wfsr_sv, wfj_sv, stops_sv, kix_sv,...
    tau_sv, dp_s_sv, l_rl, a_rl, vol_rl, n_rl, l_hl,...
    a_hl, vol_hl, n_hl, beta, vol_rc, vol_hc,...
    ah_act, ar_act, bdamp_act, mact_act, mext_act,...
    wfb_act, wfrl_act, wfhl_act, stops_act)


% VG_B.		Building block for variable geometry with four-way ehsv
%		and actuator with bleeds.
% Author:	D. A. Gutz
% Written:	14-Sep-92.
% Revisions:


% Input:
% ah_sv		EHSV spool end head area, sqin.
% cause_sv	EHSV causality, 1=flow, 2=pressure.
% cd_sv		EHSV coefficient of discharge.
% ps		Supply pressure, psia.
% pd		Drain pressure, psia.
% ph		Head control pressure, psia.
% pr		Rod control pressure, psia.
% sg		Fluid specific gravity.
% wdh_sv	EHSV head drain area gradient, sqin/in.
% wdr_sv	EHSV rod drain area gradient, sqin/in.
% wsh_sv	EHSV head supply area gradient, sqin/in.
% wsr_sv	EHSV rod supply  area gradient, sqin/in.
% wfhd_sv	EHSV head to drain flow, pph.
% wfrd_sv	EHSV rod to drain flow, pph.
% wfsh_sv	EHSV supply to head flow, pph.
% wfsr_sv	EHSV supply to rod flow, pph.
% wfj_sv	EHSV first stage flow, pph.
% stops_sv	EHSV: 0=go.
% kix_sv	EHSV servovalve gain, inches/mA.
% tau_sv	EHSV time constant, sec.
% dp_s_sv	EHSV (ps-pd) at time constant sizing, psi.
% l_rl		Rod line length, in.
% a_rl		Rod line section, sqin.
% vol_rl	Rod line volume, cuin.
% n_rl		Rod line number of vol nodes.
% l_hl		Head line length, in.
% a_hl		Head line section, sqin.
% vol_hl	Head line volume, cuin.
% n_hl		Head line number of vol nodes.
% beta		Fluid compressibility, psi.
% vol_rc	Rod chamber volume, cuin.
% vol_hc	Head chamber volume, cuin.
% ah_act	Actuator head end section, sqin.
% ar_act	Actuator rod end section, sqin.
% bdamp_act	Actuator damping, lbf/in/s.
% mact_act	Actuator mass, lbm.
% mext_act	Actuator external mass, lbm.
% wfb_act	Actuator cross piston bleed rod to head, pph.
% wfrl_act	Actuator rod leakage out, pph.
% wfhl_act	Actuator head leakage out, pph.
% stops_act	0=go.

% Output:
% sys		Packed system of Input and Output.

% Differential IO:
% pd		Input # 1, supply pressure, psi.
% pr		Input # 2, drain pressure, psi.
% per		Input # 3, actuator end pressure, psi.
% wfld		Input # 4, load flow demand, mA.
% fx		Input # 5, load, lbf pullin.
% wfh_sens	Input # 6, head sense flow out of ehsv, pph.
% wfr_sens	Input # 7, rod sense flow out of ehsv, pph.
% wfs		Output # 1, supply flow in, pph.
% wfr		Output # 2, drain flow out, pph.
% wfve		Output # 3, actuator end flow pulled in by rod, pph.
% ph_sens	Output # 4, head sensed pressure at ehsv, psi.
% pr_sens	Output # 5, rod sensed pressure at ehsv, psi.
% ph		Output # 6, head pressure at actuator, psi.
% pr		Output # 7, rod pressure at actuator, psi.
% v_sv		Output # 8, EHSV spool velocity toward head end, in/s.
% x_sv		Output # 9, EHSV spool displacement toward head, in.
% v_act		Output # 10, actuator velocity toward head end, in/s.
% x_act		Output # 11, actuator  displacement toward head, in.

% Local:
% tee_wfrod	rod sense tee.
% tee_wfhead	head sense tee.
% tee_wfr	wfr tee.
% sv		ehsv.
% act		actuator.
% rl		rod line.
% hl		head line
% rc		rod chamber.
% hc		head chamber.
% tee_pr	pr tee.
% tee_wfs	wfs tee.

% States:
% x_sv		Spool displacement toward head end, in.
% v_act		Actuator velocity toward head, in/s.
% x_act		Actuator disp toward head, in.


% Functions called:
% fourehsv_b	four-way ehsv.
% actuator_b	actuator.
% man_n_vm	line volume to momentum.
% vol_1		single volume node.
% summer	sum.
% splitter	split.


% Parameters.
% none

% Partials.
% none.

% Components:
if stops_sv == 1,
    dp		= max((pd - pr) / 2., 1e-6);
    wfl     = wfsh_sv+wfsr_sv;
    sys = lti_fake_vg_b(dp, dp, wfl, cd_sv, sg, vol_rc, beta);
    return
else
    sv	= fourehsv_b(ah_sv, cd_sv, cause_sv, ps, pd, ph, pr, sg,...
        wdh_sv, wdr_sv, wsh_sv, wsr_sv, wfhd_sv, wfrd_sv,...
        wfsh_sv, wfsr_sv, wfj_sv, stops_sv, kix_sv, tau_sv,...
        dp_s_sv);
    act	= actuator_b(ah_act, ar_act, bdamp_act, mact_act, mext_act,...
        pr, ph, pd, wfb_act, wfrl_act, wfhl_act, stops_act, sg);
    tee_wfrod	= summer(-1,1,0,0);
    rl	= man_n_vm(l_rl, a_rl, vol_rl, n_rl, sg, beta);
    rc	= vol_1(vol_rc, beta, sg);
    tee_wfhead	= summer(-1,1,0,0);
    hl	= man_n_vm(l_hl, a_hl, vol_hl, n_hl, sg, beta);
    hc	= vol_1(vol_hc, beta, sg);
    tee_wfr	= summer(1,1,1,0);
    tee_pr	= splitter(1,1,0,0);
    tee_wfs	= summer(1,1,0,0);
    
    % Connections and system construction.
    sys	= adjoin(sv, act, tee_wfrod, rl, rc, tee_wfhead, hl, hc,...
        tee_wfr, tee_pr, tee_wfs);
    
    % Inputs:
    us	= [1	31	9	5	10	19	11];
    
    % Outputs:
    ys	= [29	24	11	21	17	23	19	6	7	14	15];
    %ys	= [1	2	10	12	13];
    
    % Connections:
    qs	= [	2	25;
        3	21;	%break prod & phead feedback to ehsv.
        4	17;	%break prod & phead feedback to ehsv.
        6	19;
        7	23;
        8	26;
        12	4;
        15	16;
        16	19;
        17	18;
        18	8;
        20	3;
        23	20;
        24	23;
        25	22;
        26	9;
        27	12;
        28	13;
        29	2;
        32	1;
        33	5	];
    
    % Form the system.
    [a, b, c, e]	= unpack_ss(sys);
    [a, b, c, e]	= connect(a, b, c, e, qs, us, ys);
    sys		= ss(a, b, c, e);
endfunction sys = lti_vol_1(vol, beta, spgr)
% VOL1.		Building block for a volume having two flow inputs.
%  Author:	D. A. Gutz
%  Written:	16-Apr-92
%  Revisions:	None.

%  Input:
%  beta		Fluid bulk modulus, psi.
%  spgr		Fluid specific gravity.
%  vol		Volume, cuin.
%  wfs		Input # 1, supply flow, pph.
%  wfd		Input # 2, discharge flow, pph.

%  Output:
%  sys		Packed system of Input and Output
%  p		Output # 1, volume pressure, psia.

%  Derivative
dp	= beta / 129.93948 / vol / spgr;	% Derivative, psi/sec.
a	= 0;
b	= [dp	-dp];
c	= 1;
e	= [0	0];

%  Form the system.
sys	= ss(a,b,c,e);
function out_pss = make_pack(in_ss)
% make_pack
% make old fashioned pack_ss format
% 22-Oct-2012   DA Gutz     Created

out_pss   = pack_ss(in_ss.a, in_ss.b, in_ss.c, in_ss.d);
function out_ss = make_ss(in_pss)
% make_pack
% make old fashioned pack_ss format
% 22-Oct-2012   DA Gutz     Created
[a,b,c,d]   = unpack_ss(in_pss);
out_ss   = ss(a,b,c,d);
function sys = man_1_mv(l, a, vol, spgr, beta, c)
% function sys = man_1_mv(l, a, vol, spgr, beta, c);
% MAN_1_MV.	Build a one element line: momentum first, volume last.
% Author:	D. A. Gutz
% Written:	22-Jun-92
% Revisions:	19-Aug-92	Simplify output arguments.
%		10-Dec-98	Add damping, c.
% Input:
% l		Line length, in.
% a		Line cross section, sqin.
% vol		Line volume, cuin.
% spgr		Fluid specific gravity.
% beta		Fluid compressibility, psi.
% c		Damping, psi/in/sec, (OPTIONAL).
% Differential I/O:
% ps		Input # 1, supply pressure, psia.
% wfd		Input # 2, discharge flow, pph.
% wfs		Output # 1, supply flow, pph.
% pd		Output # 2, discharge pressure, psia.

% Functions called:
% vol_1	Creates volume node.
% mom_1	Creates momenum slice.

% Momentum slice.
if nargin == 6,
	m_1	= mom_1(l, a, c);
else
	m_1	= mom_1(l, a);
end

% Volume.
v_1	= vol_1(vol, beta, spgr);

% Put system into block diagonal form.
temp	= adjoin(m_1, v_1);

% Inputs are ps and wfd.
u	= [1	4];

% Outputs are wfs and pd.
y	= [1	2];

% Connections.
q	=	[2	2;
		3	1];

% Form the system.
[a,b,c,e]	= unpack_ss(temp);
[a,b,c,e]	= connect(a,b,c,e,q,u,y);
sys	=pack_ss(a,b,c,e);
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
sys	= pack_ss(a,b,c,e);
function [p,m,n] = size_ss(g)
% SIZE_SS	Compute system output, input and state dimensions.
%
% Syntax: [P,M,N] = SIZE_SS(G)
%
% Purpose: The SIZE_SS command returns three important dimensions for a
%		state-space system, namely, the number of outputs, the
%		number of inputs, and the state-dimension.
%
% Input:	G - input system, either a regular or packed-matrix
%		    variable.
%
% Output:	P, M, N - integers containing the output, input and
%	             state dimensions respectively of the input system
%		     G. If G is a regular matrix, then M and P default
%		     to the row and column dimensions of G and P is set
%		     equal to zero.  When used with only 1 output
%		     argument, SIZE_SS returns the vector [P M N].
%
% See Also:	ISSYS, ISTITO, SIZE

% Algorithm:
%
% Calls:
%
% Called By:


%**********************************************************************
% 

%
narginchk(1,1);
[p,m] = size(g); n = issys(g);
%
if n,
   if istito(g),
 	p = p - n - 2; m = m - n - 2;
   else 
	p = p - n - 1; m = m - n - 1;
   end
end
%
if nargout <= 1,
   p = [p m n];
end
%
function [a,b1,b2,c1,c2,d11,d12,d21,d22] = unpack_ss(sys,flag)
% UNPACK_SS	Unpacks a system into component matrices.
%
% Syntax: [A,B1,B2,C1,C2,D11,D12,D21,D22] = UNPACK_SS(SYS), or ...
%         [A,B,C,D] = UNPACK_SS(SYS) or ...
%         X = UNPACK_SS(SYS,FLAG)
%
% Purpose:	The first version 'unpacks' the nine constituent matrices
%		of a TITO state-space representation.
%               
%		The second version 'unpacks' the four constituent matrices 
%		of a SISO state-space representation.
%
%		The third version allows selection of only a single
%		element from the SISO state-space quartet or from the
%		TITO nantet.
%
% Input:	SYS - Input system, in packed matrix format.
%		FLAG - Optional character used to select only a single
%		       matrix or section for unpacking.  Hence FLAG 
%		       may be either 'a', 'b', 'c', 'd', 'b1', 'b2', 
%		       'c1', 'c2', 'd11', 'd12', 'd21', or 'd22', in
%		       which case the corresponding matrix is unpacked
%		       from SYS.
%
% Output:	A, B1, B2, C1, C2, D11, D12, D21, D22  or ...
%		A, B, C, D 
%			- Regular matrices unpacked from SYS.
%
% See Also:	PACK_SS


%**********************************************************************


%
% Check Arguments
% 
narginchk(1,2);
%
if nargin == 1 && nargout == 1,
   error('Must specify FLAG when unpacking a single matrix')
end
%
%**********************************************************************

% 
% Calculations
%
[ms,ns] = size(sys);
na = find(all(isnan(sys)));
%
% if there are no NaN's we have the static system case
%
if isempty(na),			
   a = []; b1 = []; b2 = []; c1 = []; c2 = [];
   d = sys;
   ne = find(all(~isfinite(sys)));	
   if isempty(ne),
      d11 = sys;
      d12 = []; d21 = []; d22 = [];
   else
      me = find(all(~isfinite(sys')));
      d11 = sys(1:me-1,1:ne-1);
      d12 = sys(1:me-1,ne+1:ns);
      d21 = sys(me+1:ms,1:ne-1);
      d22 = sys(me+1:ms,ne+1:ns);
   end
%
% if there are NaN's we have either the static or dynamic case
%
else
   %
   % Unpack A, B, C, and E sections first
   %
   a = sys(1:na-1,1:na-1); b = sys(1:na-1,na+1:ns); 
   c = sys(na+1:ms,1:na-1); d = sys(na+1:ms,na+1:ns);
   % 
   % Now get B1, B2, C1, C2, D11, D12, D21, and D22
   %
   nb1 = find(~isfinite(b(1,:)));
   if isempty(nb1),
	b1 = b; b2 = []; d1 = d; d2 = [];
   else
        b1 = b(1:na-1,1:nb1-1); b2 = b(1:na-1,nb1+1:ns-na);
	d1 = d(:,1:nb1-1); d2 = d(:,nb1+1:ns-na);
   end
   mc1 = find(~isfinite(c(:,1)));
   if isempty(mc1),
	c1 = c; c2 = [];
	d11 = d1; d12 = d2; d21 = []; d22 = [];
   else
        c1 = c(1:mc1-1,1:na-1); c2 = c(mc1+1:ms-na,1:na-1);
	if isempty(d1),
	   d11 = []; d21 = [];
	else
	   d11 = d1(1:mc1-1,:); d21 = d1(mc1+1:ms-na,:);
	end
	if isempty(d2),
	   d12 = []; d22 = [];
	else
	   d12 = d2(1:mc1-1,:); d22 = d2(mc1+1:ms-na,:);
	end
   end
end
err = 0;
if nargout == 1,
   if length(flag) == 1,
      if flag == 'b',
         a = b;
      elseif flag == 'c',
         a = c;
      elseif flag == 'd',
         a = d;
      elseif flag == 'e',
	 a = d;
      elseif flag ~= 'a',
         err = 1;
      end
   elseif length(flag) == 2,
      if flag == 'b1', %#ok<*STCMP>
         a = b1;
      elseif flag == 'b2',
         a = b2;
      elseif flag == 'c1',
         a = c1;
      elseif flag == 'c2',
         a = c2;
      else
         err = 1;
      end
   elseif length(flag) == 3,
      if flag == 'd11',
         a = d11;
      elseif flag == 'd12',
         a = d12;
      elseif flag == 'd21',
         a = d21;
      elseif flag == 'd22',
         a = d22;
      else
         err = 1;
      end
   end
   if err,
      error('Improper choice for FLAG')
   end
elseif nargout == 4,
   b1 = [b1 b2]; b2 = [c1;c2]; c1 = [d11 d12;d21 d22];
elseif nargout ~= 9,
   disp('Warning: Not the proper number of output arguments for UNPACK_SS');
end

function sys = vol_1(vol, beta, spgr)
% VOL1.		Building block for a volume having two flow inputs.
%  Author:	D. A. Gutz
%  Written:	16-Apr-92
%  Revisions:	None.

%  Input:
%  beta		Fluid bulk modulus, psi.
%  spgr		Fluid specific gravity.
%  vol		Volume, cuin.
%  wfs		Input # 1, supply flow, pph.
%  wfd		Input # 2, discharge flow, pph.

%  Output:
%  sys		Packed system of Input and Output
%  p		Output # 1, volume pressure, psia.

%

%  Derivative
dp	= beta / 129.93948 / vol / spgr;	% Derivative, psi/sec.
a	= [0];
b	= [dp	-dp];
c	= [1];
e	= [0	0];

%  Form the system.
sys	= pack_ss(a,b,c,e);
function sys = zeros(n,m);
%function sys = zeros_ss(n,m);
% Wrapper for isicles functions to avoid error return for 0 index.
% D. Gutz 1/27/04
% Inputs:
% same as matlab zeros function.
% Outputs:
% same as matlab zeros function.

if ( n == 0 & m ~=0 ) | ( n~=0 & m == 0 ),
  sys = [];
else
  sys = zeros(n, m);
end

