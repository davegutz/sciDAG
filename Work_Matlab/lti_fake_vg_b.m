function sys    = lti_fake_vg_b(dpav1, dpav2, wfl, cd, sg, vol_rcham, beta)
% Build a fake load subsystem for a vg_b.
% The model consists of adjustable drop in series with a fixed
% drop. fx is frozen.  Equivalent to vg_b.
% Author:       D. A. Gutz
% Written:      14-Sep-92
% Revisions:    21-Sep-92    Unfroze pr & pr_sens.
%               29-Sep-92    Added vol_rcham.
%               29-Sep-92    Rewrote because non-working.
%
%Input:
% dpav1         Variable load drop, psi.
% dpav2         Fixed load drop, psi.
% wfl           Load flow, pph.
% cd            Coefficient of discharge.
% sg            Specific gravity.
% vol_rcham     Rod chamber volume.
% beta          Fuel compressibility, psi.
%
% Differential IO:
% pd            Input # 1, supply pressure, psi.
% pr            Input # 2, drain pressure, psi.
% per           Input # 3, actuator end pressure, psi.
% wfld          Input # 4, load flow demand, mA.
% fx            Input # 5, load, lbf pullin.
% wfh_sens      Input # 6, head sense flow out of ehsv, pph.
% wfr_sens      Input # 7, rod sense flow out of ehsv, pph.
% wfs           Output # 1, supply flow in, pph.
% wfr           Output # 2, drain flow out, pph.
% wfve          Output # 3, actuator end flow pulled in by rod, pph.
% ph_sens       Output # 4, head sensed pressure at ehsv, psi.
% pr_sens       Output # 5, rod sensed pressure at ehsv, psi.
% ph            Output # 6, head pressure at actuator, psi.
% pr            Output # 7, rod pressure at actuator, psi.
% v_sv          Output # 8, EHSV spool velocity toward head end, in/s.
% x_sv          Output # 9, EHSV spool displacement toward head, in.
% v_act         Output # 10, actuator velocity toward head end, in/s.
% x_act         Output # 11, actuator  displacement toward head, in.
%
% Local:
% fake_ehsv     Variable load.
% fake_act      Fixed load.
% tee_pr        Flow tee for pr.
% dummy         Dummy for null i/o.
% tee_sum_pr    Sum flow to tee_pr.
%
% Functions called:
% m_valve_a     Variable valve.
% summer        sum.
% dor_aptow     Fixed drop.

% Parameters.
% none.

fake_ehsv   = lti_m_valve_a(0, dpav1, wfl);
tee_pr      = vol_1(vol_rcham, beta, sg);
fake_act    = lti_dor_aptow(wfl, dpav2, 0, cd, sg);
tee_sum_pr  = summer(1,1,0,0);
dummy       = summer(0,0,0,0);

% Make system.
sys    = adjoin(fake_ehsv, tee_pr, fake_act, tee_sum_pr, dummy);

% Inputs.
us    = [1    7    13    3    14    15    9];

% Outputs.
ys    = [1    3    5    5    2    5    2    5    5    5    5];

% Connections.
qs    =    [    2    2;
            4    1;
            5    4;
            6    2;
            10    3];

% Form the system.
[a,b,c,e]   = unpack_ss(sys);
[a,b,c,e]   = connect_ss(a, b, c, e, qs, us, ys);
sys         = pack_ss(a, b, c, e);
