time_run= 'Output from $Id: start02.c,v 1.2 2007/01/25 22:44:22 davegutz Exp davegutz $ on Sat Jan 12 18:09:30 2019.';
time_stamp= 'Last compilation of $Id: start02.c,v 1.2 2007/01/25 22:44:22 davegutz Exp davegutz $ on Jan 12 2019 18:09:23'; 
titl = '23.7 in start tube, 135 JP5 135k/.75/0.46 100pph';
pars = [];labels



%**************timex        = -2.000e-06.***************************
% Metering valve throttle valve (mvtv):
mvtv_ax1     =     0.7854; mvtv_ax2     =     0.9940; mvtv_cd     =     0.7000;
mvtv_ks      =      69.00; mvtv_mv      =     0.2652; mvtv_bdamp  =  0.0001000;

% Throttle valve head sensor (tvhead):
tvhead_ae    =     0.3070; tvhead_ks    =      520.0; tvhead_dn   =    0.05500;
tvhead_bdamp =  0.0005000; tvhead_m     =    0.04985;

% Main pipe (pipe):
l_main       =      48.00; a_main       =     0.3630; vol_main    =      17.42;
n_main       =          5;

% Manifold volume (vol_pnozin):
vol_pnozin   =      20.00;

% AC lines:
l_engine     =      7.000; a_engine     =      2.960; vol_engine  =      20.80;
n_engine     =          1;
motivepull   =          1;

wfacmbst =      794.4; wfacbst =      0.000;
l_ltank  =      186.0; a_ltank =      4.909; vol_ltank =      913.0;
n_ltank  =         25;
l_li     =      20.00; a_li    =     0.1520; vol_li    =      3.100;
n_li     =          3;
l_lm     =      15.00; a_lm    =     0.1520; vol_lm    =      2.300;
n_lm     =          2;
l_lmp    =      4.000; a_lmp   =      2.960; vol_lmp   =      11.90;
n_lmp    =          2;

l_lla    =      71.00; a_lla   =     0.1520; vol_lla   =      11.00;
n_lla    =          7;
l_lah    =      67.00; a_lah   =     0.1520; vol_lah   =      10.20;
n_lah    =          7;
l_checka =      7.000; a_checka=      2.960;
l_wfsi   =      7.000; a_wfsi  =     0.1520;

vol_pl   =      200.0; vol_pah   =      234.0;
dpl      =      1.431; dpaa      =      1.431;
dpah     =      1.431;

a_acbst      =    0.07500; b_acbst      =     -1.590; c_acbst      =     -102.0;
r1_acbst     =      0.000; b1_acbst     =      1.000; r2_acbst     =      2.000;
b2_acbst     =      1.000; tau_acbst    =   0.001270;
a_acmbst     =     0.1160; b_acmbst     =      0.000; c_acmbst     =      0.000;
r1_acmbst    =      0.000; b1_acmbst    =      1.000; r2_acmbst    =      2.000;
b2_acmbst    =      1.000; tau_acmbst   =   0.001270;

% Check valve:
check_ax1    =     0.9940; check_ax2    =     0.2124; check_ks    =      40.70;
check_mv     =    0.03860;
% prt regulating valve (prtv):
prtv_ax1     =    0.07694; prtv_ax4     =    0.07694; prtv_cd     =     0.6800;
prtv_ks      =      70.00; prtv_mv      =     0.2810; prtv_bdamp  =      1.700;

% P3 sense line:
vol_p3s      =      1.500; dp3sdwf3s    =      1.000; lmo_p3s     =    0.01000;
amo_p3s      =  0.0001431;
l_p3sl       =      11.00; a_p3sl       =    0.02761; vol_p3sl    =     0.3037;
n_p3sl       =          1;

% Pump to check valve:
vol_p1       =      5.300;

% prt volume:
vol_prt      =     0.4000;

% VEN start to ifc:
l_vs         =      23.70; a_vs         =     0.1443; vol_vs      =      3.420;
n_vs         =          8;

% p1c:
vol_p1c      =      14.00;

% Throttle valve to discharge:
vol_p3       =      9.600;

% VG lines:
l_vghi       =      18.00; a_vghi       =     0.1444; vol_vghi    =      2.600;
n_vghi       =          3;
l_cvghi      =      6.000; a_cvghi      =    0.06667; vol_cvghi   =     0.4000;
n_cvghi      =          1;
l_fvghi      =      14.00; a_fvghi      =     0.1429; vol_fvghi   =      2.000;
n_fvghi      =          2;
l_vglo       =      32.00; a_vglo       =     0.1437; vol_vglo    =      4.600;
n_vglo       =          5;
l_cvglo      =      6.000; a_cvglo      =    0.06667; vol_cvglo   =     0.4000;
n_cvglo      =          1;
l_fvglo      =      12.00; a_fvglo      =     0.1417; vol_fvglo   =      1.700;
n_fvglo      =          2;

% Oil cooler to main pump:
l_ocm1       =      12.00; a_ocm1       =     0.7000; vol_ocm1     =      8.400;
n_ocm1       =          3;
l_ocm2       =      6.000; a_ocm2       =     0.7000; vol_ocm2     =      4.200;
n_ocm2       =          1;

% Oil cooler:
vol_poc      =      36.00; dp_oc        =      40.00;

% AB tee to oil cooler:
l_aboc       =      24.00; a_aboc       =     0.7000; vol_aboc     =      16.80;
n_aboc       =          4;

% Filter to AB tee:
l_fab        =      6.000; a_fab        =      1.120; vol_fab      =      6.700;
n_fab        =          1;

% Filter:
vol_pb2      =      77.90; l_wffilt     =      6.000; a_wffilt     =      1.120;
dp_filt      =  0.000466819; wffilt       =      794.4;

% Engine inlet line:
l_in         =      30.00; a_in         =      2.968; vol_in       =      88.70;
n_in         =          3;

% VEN supply volume:
vol_psven    =      5.000;

% Piping select, =0 for engine, =1 for Bendix:
sw_pipe      =          0;

% Main pump:
a_mainp      =      1.395; b_mainp      =      11.43; c_mainp      =     -201.8;
r1_mainp     =     0.7000; b1_mainp     =     0.1600; r2_mainp     =      1.550;
b2_mainp     =     0.1600; tau_mainp    =   0.001270;

% Boost pump:
a_boost      =     0.5200; b_boost      =      6.600; c_boost      =     -316.0;
r1_boost     =      0.000; b1_boost     =      1.000; r2_boost     =      2.550;
b2_boost     =     0.2000; tau_boost    =   0.001270;
%VEN pump and pump actuator:
ks_reg_ven   =      120.0; m_reg_ven    =    0.05500; ahs_reg_ven  =    0.02835;
ahd_reg_ven  =    0.02835; alr_reg_ven  =      0.000; ald_reg_ven  =      0.000;
ale_reg_ven  =      0.000;
cd_reg_ven   =     0.6100; bdamp_reg_ven=     0.7500;
cs_pump_ven  =  5.300e-10; ct_pump_ven  =  0.0009600;
cn_pump_ven  =      0.000; m_pump_ven   =      18.68; bdamp_pump_ven  =      100.0;
vol_pd_ven   =      3.200;
ks_bias_ven  =      650.0; m_bias_ven    =    0.03830; bdamp_bias_ven=     0.7000;
ah_bias_ven  =     0.2273; ar_bias_ven  =     0.1990;
l_rline_ven  =      93.00; a_rline_ven   =     0.1452; vol_rline_ven =      13.50;
n_rline_ven  =         12;
l_hline_ven  =      93.00;  a_hline_ven  =     0.1452; vol_hline_ven  =      13.50;
n_hline_ven  =         12;
x_act_ven    =      0.000;
vol_rcham_ven=      1.000;  vol_hcham_ven=      86.78;
vol_rchamr_ven=     14.50;
ah_ehsv_ven  =     0.2091;  cd_ehsv_ven  =     0.6100; cause_ehsv_ven =          0;
kix_ehsv_ven =  -0.001067; tau_ehsv_ven   =   0.006370;
dp_s_ehsv_ven=      1000.;ah_act_ven   =      9.247; ar_act_ven    =      7.443;  bdamp_act_ven  =      40.00;
mact_act_ven =      0.000; mext_act_ven  =      200.0;
ax1_start_ven=    0.05545; ax2_start_ven =    0.05545; ax4_start_ven   =    0.05545;
cd_start_ven    =     0.7000; cp_start_ven=     0.4300; fs_start_ven =       15.8;
ks_start_ven =      50.00; mv_start_ven  =    0.03281; bdamp_start_ven =      0.000;
ao_start_ven =  0.0002011;



%Parameters:
wfdem        =      100.0; sg           =     0.7500; beta        =  1.350e+05;
cd           =     0.6900; pamb         =      14.70; wfx         =     -126.7;
px           =      312.1; p1           =      334.7; p1c         =      443.2;
pc           =      73.60; p2           =      389.5; wf36         = wfdem;
p3           =      59.46; ps3c         =      15.00;  prt         =      129.0;
mvtv_wd      =    0.04000; tvhead_cdf   =     0.6100;  dwf36dpnozin=      11.93;
dpcddwf      =  0.0001187; wf1p         =      117.7;  xnmainp     =  1.086e+04;
wfb2         =      794.4; xnven        =      3243.;  mvtv_stops  =          0;
tau_ps3      =   0.002500; dps3dw       =    0.02000;  check_stops =         -1;
mvtv_ad      =  0.000477631; mvtv_x       =   -0.03806;wfrt        =     -130.8; prtv_wh       =     0.1179; prtv_stops   =          0;
prtv_bdamp  =      1.700; wftvb       =     -130.9; wfoc      =     -15.07;
dp_oc       = -4.717e-05; xn25        =      6884.;
wf1c        =     -1.168; check_wd      =      2.375;  dps3dw_ss   =      0.000;
kvis        =     0.4600; wf1leak_o     =      119.3;  wf1leak_l   =      248.9;
vol_p2      =      5.610; vol_px        =      1.600;
wfb         =      118.9; precx         =      17.70;
wfcvgleak_o =      126.5; wfcvgleak_l   =      69.02;
wffvgleak_o =      60.74; wffvgleak_l   =      131.9;
dpacbdw      =   -0.01081;
l_acin  =      0.000; a_acin  =      0.000; vol_acin =      0.000;
n_acin  =          0;
ctqpv_ven    =     0.4418; ftpa_ven    =      1.865;
dwfdv_ven    =      107.4;  ddispdx_ven =      3.086;
kspump_ven   =      1341.; kvis_ven     =     0.4600;  ps_ven      =      73.60;
pd_ven       =      1451.; pr_ven       =      73.60;  px_ven      =      725.6;
wfsx_reg_ven =      114.1; wfxd_reg_ven =      100.2;  wfl_ven     =      530.8;
wfstart      =      900.9;dpav1_ven    =      0.000; dpav2_ven    =      0.000;  disp_ven    =     0.3190;
xn_ven       =      3243.; beta_ven     =  1.350e+05; sg_ven      =     0.7500;
wd_reg_ven   =    0.07288; ws_reg_ven   =    0.07838; stops_bias_ven=        -1;
stops_reg_ven=          0; stops_pump_ven=         0;  swmodel_ven   =          0;
wh_start_ven =     0.3226; stops_start_ven=         0;phead_ven    =      73.60; prod_ven     =      73.60;
wfhd_ehsv_ven=      0.000; wfrd_ehsv_ven=      0.000; wfsh_ehsv_ven=      0.000;
wfsr_ehsv_ven=    0.03729; wfj_ehsv_ven =      148.1; stops_ehsv_ven=         1;
wfb_act_ven  =      0.000; wfrl_act_ven =      0.000; wfhl_act_ven =      0.000;
stops_act_ven=         0; fx_ven       =     -1.000;
wdh_ehsv_ven =      0.000;  wdr_ehsv_ven =      0.000;
wsh_ehsv_ven =      0.000;  wsr_ehsv_ven =      0.000;
v_act_ven    =      0.000;
swstore = 1;
store;



%**************timex        =     0.2000.***************************
% Metering valve throttle valve (mvtv):
mvtv_ax1     =     0.7854; mvtv_ax2     =     0.9940; mvtv_cd     =     0.7000;
mvtv_ks      =      69.00; mvtv_mv      =     0.2652; mvtv_bdamp  =  0.0001000;

% Throttle valve head sensor (tvhead):
tvhead_ae    =     0.3070; tvhead_ks    =      520.0; tvhead_dn   =    0.05500;
tvhead_bdamp =  0.0005000; tvhead_m     =    0.04985;

% Main pipe (pipe):
l_main       =      48.00; a_main       =     0.3630; vol_main    =      17.42;
n_main       =          5;

% Manifold volume (vol_pnozin):
vol_pnozin   =      20.00;

% AC lines:
l_engine     =      7.000; a_engine     =      2.960; vol_engine  =      20.80;
n_engine     =          1;
motivepull   =          1;

wfacmbst =      230.6; wfacbst =      0.000;
l_ltank  =      186.0; a_ltank =      4.909; vol_ltank =      913.0;
n_ltank  =         25;
l_li     =      20.00; a_li    =     0.1520; vol_li    =      3.100;
n_li     =          3;
l_lm     =      15.00; a_lm    =     0.1520; vol_lm    =      2.300;
n_lm     =          2;
l_lmp    =      4.000; a_lmp   =      2.960; vol_lmp   =      11.90;
n_lmp    =          2;

l_lla    =      71.00; a_lla   =     0.1520; vol_lla   =      11.00;
n_lla    =          7;
l_lah    =      67.00; a_lah   =     0.1520; vol_lah   =      10.20;
n_lah    =          7;
l_checka =      7.000; a_checka=      2.960;
l_wfsi   =      7.000; a_wfsi  =     0.1520;

vol_pl   =      200.0; vol_pah   =      234.0;
dpl      =     0.1206; dpaa      =     0.1206;
dpah     =     0.1206;

a_acbst      =    0.07500; b_acbst      =     -1.590; c_acbst      =     -102.0;
r1_acbst     =      0.000; b1_acbst     =      1.000; r2_acbst     =      2.000;
b2_acbst     =      1.000; tau_acbst    =   0.001270;
a_acmbst     =     0.1160; b_acmbst     =      0.000; c_acmbst     =      0.000;
r1_acmbst    =      0.000; b1_acmbst    =      1.000; r2_acmbst    =      2.000;
b2_acmbst    =      1.000; tau_acmbst   =   0.001270;

% Check valve:
check_ax1    =     0.9940; check_ax2    =     0.2124; check_ks    =      40.70;
check_mv     =    0.03860;
% prt regulating valve (prtv):
prtv_ax1     =    0.07694; prtv_ax4     =    0.07694; prtv_cd     =     0.6800;
prtv_ks      =      70.00; prtv_mv      =     0.2810; prtv_bdamp  =      1.700;

% P3 sense line:
vol_p3s      =      1.500; dp3sdwf3s    =      1.000; lmo_p3s     =    0.01000;
amo_p3s      =  0.0001431;
l_p3sl       =      11.00; a_p3sl       =    0.02761; vol_p3sl    =     0.3037;
n_p3sl       =          1;

% Pump to check valve:
vol_p1       =      5.300;

% prt volume:
vol_prt      =     0.4000;

% VEN start to ifc:
l_vs         =      23.70; a_vs         =     0.1443; vol_vs      =      3.420;
n_vs         =          8;

% p1c:
vol_p1c      =      14.00;

% Throttle valve to discharge:
vol_p3       =      9.600;

% VG lines:
l_vghi       =      18.00; a_vghi       =     0.1444; vol_vghi    =      2.600;
n_vghi       =          3;
l_cvghi      =      6.000; a_cvghi      =    0.06667; vol_cvghi   =     0.4000;
n_cvghi      =          1;
l_fvghi      =      14.00; a_fvghi      =     0.1429; vol_fvghi   =      2.000;
n_fvghi      =          2;
l_vglo       =      32.00; a_vglo       =     0.1437; vol_vglo    =      4.600;
n_vglo       =          5;
l_cvglo      =      6.000; a_cvglo      =    0.06667; vol_cvglo   =     0.4000;
n_cvglo      =          1;
l_fvglo      =      12.00; a_fvglo      =     0.1417; vol_fvglo   =      1.700;
n_fvglo      =          2;

% Oil cooler to main pump:
l_ocm1       =      12.00; a_ocm1       =     0.7000; vol_ocm1     =      8.400;
n_ocm1       =          3;
l_ocm2       =      6.000; a_ocm2       =     0.7000; vol_ocm2     =      4.200;
n_ocm2       =          1;

% Oil cooler:
vol_poc      =      36.00; dp_oc        =      40.00;

% AB tee to oil cooler:
l_aboc       =      24.00; a_aboc       =     0.7000; vol_aboc     =      16.80;
n_aboc       =          4;

% Filter to AB tee:
l_fab        =      6.000; a_fab        =      1.120; vol_fab      =      6.700;
n_fab        =          1;

% Filter:
vol_pb2      =      77.90; l_wffilt     =      6.000; a_wffilt     =      1.120;
dp_filt      =  0.000466819; wffilt       =      796.7;

% Engine inlet line:
l_in         =      30.00; a_in         =      2.968; vol_in       =      88.70;
n_in         =          3;

% VEN supply volume:
vol_psven    =      5.000;

% Piping select, =0 for engine, =1 for Bendix:
sw_pipe      =          0;

% Main pump:
a_mainp      =      1.395; b_mainp      =      11.43; c_mainp      =     -201.8;
r1_mainp     =     0.7000; b1_mainp     =     0.1600; r2_mainp     =      1.550;
b2_mainp     =     0.1600; tau_mainp    =   0.001270;

% Boost pump:
a_boost      =     0.5200; b_boost      =      6.600; c_boost      =     -316.0;
r1_boost     =      0.000; b1_boost     =      1.000; r2_boost     =      2.550;
b2_boost     =     0.2000; tau_boost    =   0.001270;
%VEN pump and pump actuator:
ks_reg_ven   =      120.0; m_reg_ven    =    0.05500; ahs_reg_ven  =    0.02835;
ahd_reg_ven  =    0.02835; alr_reg_ven  =      0.000; ald_reg_ven  =      0.000;
ale_reg_ven  =      0.000;
cd_reg_ven   =     0.6100; bdamp_reg_ven=     0.7500;
cs_pump_ven  =  5.300e-10; ct_pump_ven  =  0.0009600;
cn_pump_ven  =      0.000; m_pump_ven   =      18.68; bdamp_pump_ven  =      100.0;
vol_pd_ven   =      3.200;
ks_bias_ven  =      650.0; m_bias_ven    =    0.03830; bdamp_bias_ven=     0.7000;
ah_bias_ven  =     0.2273; ar_bias_ven  =     0.1990;
l_rline_ven  =      93.00; a_rline_ven   =     0.1452; vol_rline_ven =      13.50;
n_rline_ven  =         12;
l_hline_ven  =      93.00;  a_hline_ven  =     0.1452; vol_hline_ven  =      13.50;
n_hline_ven  =         12;
x_act_ven    =      0.000;
vol_rcham_ven=      1.000;  vol_hcham_ven=      86.78;
vol_rchamr_ven=     14.50;
ah_ehsv_ven  =     0.2091;  cd_ehsv_ven  =     0.6100; cause_ehsv_ven =          0;
kix_ehsv_ven =  -0.001067; tau_ehsv_ven   =   0.006370;
dp_s_ehsv_ven=      1000.;ah_act_ven   =      9.247; ar_act_ven    =      7.443;  bdamp_act_ven  =      40.00;
mact_act_ven =      0.000; mext_act_ven  =      200.0;
ax1_start_ven=    0.05545; ax2_start_ven =    0.05545; ax4_start_ven   =    0.05545;
cd_start_ven    =     0.7000; cp_start_ven=     0.4300; fs_start_ven =       15.8;
ks_start_ven =      50.00; mv_start_ven  =    0.03281; bdamp_start_ven =      0.000;
ao_start_ven =  0.0002011;



%Parameters:
wfdem        =      107.3; sg           =     0.7500; beta        =  1.350e+05;
cd           =     0.6900; pamb         =      14.70; wfx         =     -134.1;
px           =      315.1; p1           =      340.1; p1c         =      448.5;
pc           =      78.77; p2           =      392.4; wf36         = wfdem;
p3           =      60.26; ps3c         =      15.15;  prt         =      133.4;
mvtv_wd      =    0.04000; tvhead_cdf   =     0.6100;  dwf36dpnozin=      11.93;
dpcddwf      =  0.0001187; wf1p         =      132.6;  xnmainp     =  1.086e+04;
wfb2         =      226.3; xnven        =      3243.;  mvtv_stops  =          0;
tau_ps3      =   0.002500; dps3dw       =    0.02000;  check_stops =         -1;
mvtv_ad      =  0.000511231; mvtv_x       =   -0.03722;wfrt        =     -128.8; prtv_wh       =     0.1180; prtv_stops   =          0;
prtv_bdamp  =      1.700; wftvb       =     -130.3; wfoc      =     -739.9;
dp_oc       = -4.717e-05; xn25        =      6884.;
wf1c        =     -1.170; check_wd      =      2.375;  dps3dw_ss   =      0.000;
kvis        =     0.4600; wf1leak_o     =      119.4;  wf1leak_l   =      249.0;
vol_p2      =      5.610; vol_px        =      1.600;
wfb         =      119.9; precx         =      17.70;
wfcvgleak_o =      126.6; wfcvgleak_l   =      69.08;
wffvgleak_o =      60.39; wffvgleak_l   =      130.4;
dpacbdw      =   -0.01081;
l_acin  =      0.000; a_acin  =      0.000; vol_acin =      0.000;
n_acin  =          0;
ctqpv_ven    =     0.4418; ftpa_ven    =      1.854;
dwfdv_ven    =      106.7;  ddispdx_ven =      3.084;
kspump_ven   =      1341.; kvis_ven     =     0.4600;  ps_ven      =      77.01;
pd_ven       =      1521.; pr_ven       =      77.39;  px_ven      =      723.0;
wfsx_reg_ven =      112.5; wfxd_reg_ven =      105.8;  wfl_ven     =      546.1;
wfstart      =      1121.;dpav1_ven    =      0.000; dpav2_ven    =      0.000;  disp_ven    =     0.3417;
xn_ven       =      3243.; beta_ven     =  1.350e+05; sg_ven      =     0.7500;
wd_reg_ven   =    0.07288; ws_reg_ven   =    0.07838; stops_bias_ven=        -1;
stops_reg_ven=          0; stops_pump_ven=         0;  swmodel_ven   =          0;
wh_start_ven =     0.3402; stops_start_ven=         0;phead_ven    =      77.34; prod_ven     =      77.34;
wfhd_ehsv_ven= -0.0002147; wfrd_ehsv_ven=     -0.000; wfsh_ehsv_ven=      0.000;
wfsr_ehsv_ven=    0.03804; wfj_ehsv_ven =      151.0; stops_ehsv_ven=         1;
wfb_act_ven  =     0.3590; wfrl_act_ven =    -0.3669; wfhl_act_ven =     -0.000;
stops_act_ven=        -1; fx_ven       =     -1.000;
wdh_ehsv_ven =      0.000;  wdr_ehsv_ven =      0.000;
wsh_ehsv_ven =      0.000;  wsr_ehsv_ven =      0.000;
v_act_ven    =      0.000;
swstore = 1;
store;
