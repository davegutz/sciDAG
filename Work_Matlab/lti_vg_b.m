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
