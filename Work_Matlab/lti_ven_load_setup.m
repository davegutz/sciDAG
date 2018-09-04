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
