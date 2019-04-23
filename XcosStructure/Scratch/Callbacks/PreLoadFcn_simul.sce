// Copyright (C) 2019  - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// Apr 16, 2019    DA Gutz     Created
//
// Copyright (C) 2019 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// co%pies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// co%pies or substantial portions of the SoftwarG.guess.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARG.guess.
// Jan 1, 2019 DA Gutz Created
// 

global LINCOS_OVERRIDE
global loaded_scratch
global G FP

mprintf('In %s\n', sfilename()) 

//stacksize('max');

// Define valve vsv start valve geometry
d = 0.2657;
G.ven.vsv.ax1 = d^2*%pi/4;
clear d
G.ven.vsv.ax2 = G.ven.vsv.ax1;
G.ven.vsv.ax3 = 0;
G.ven.vsv.ax4 = G.ven.vsv.ax1;
G.ven.vsv.c = 0;
G.ven.vsv.clin = 0.24;
G.ven.vsv.cd = 0.7;
G.ven.vsv.cdo = 0.61;
G.ven.vsv.cp = 0.43;
d = 0.016;
G.ven.vsv.ao = d^2*%pi/4;
clear d
G.ven.vsv.fdyf = 0;
G.ven.vsv.fstf = 0;
G.ven.vsv.fs = 15.8;
G.ven.vsv.ks = 50;
G.ven.vsv.ld = 0;
G.ven.vsv.lh = 0;
mv = 8e-5*386.4;
ms = 0.15;
G.ven.vsv.m = mv + ms/2;
clear mv ms
G.ven.vsv.xmax = 0.125;
G.ven.vsv.xmin = 0;
exec('./Callbacks/vsvwin_a.sci', -1);
G.ven.vsv.ad.tb = [-1 0; 1 0];
[xh, ah, wvh] = vsvwin_a(40);
G.ven.vsv.ah.tb = [xh ah];
clear xh ah wvh


// Define trivalve reg geometry
dh = .190; dlh = 0.; dlr = 0.; dld = 0.; dr = .125; 
G.ven.reg.adl = 0;
G.ven.reg.ahd = max((sqr(dh) - sqr(dlr)) * %pi / 4., 0.);
G.ven.reg.ahs = sqr(dh) * %pi / 4.;
G.ven.reg.ald = max((sqr(dlh) - sqr(dld)) * %pi / 4., 0.);
G.ven.reg.ale = sqr(dld) * %pi / 4.;
G.ven.reg.alr = max((sqr(dlh) - sqr(dlr)) * %pi / 4., 0.);
G.ven.reg.ar = max((sqr(dh) - sqr(dr)) * %pi / 4., 0.);
G.ven.reg.asl = 0;
clear dh dlh dlr dld dr
G.ven.reg.c = 0.75;
G.ven.reg.cd = 0.61;
G.ven.reg.cp = 0;
G.ven.reg.fs = -15.9-12.;
G.ven.reg.fdyf = 2;
G.ven.reg.fstf = 2;
G.ven.reg.ks = 120.;
G.ven.reg.ld = 0;
G.ven.reg.ls = 0;
G.ven.reg.m = 0.055;
G.ven.reg.xmax = 0.125;
G.ven.reg.xmin = -0.011;
exec('./Callbacks/regwin_a.sci', -1);
[xh, as, ad] = regwin_a(40);
G.ven.reg.as.tb = [xh as];
G.ven.reg.ad.tb = [xh ad];
clear xh as ad

// Pump actuator
G.ven.pact.c_ = 100.;
G.ven.pact.cd_ = .61;
G.ven.pact.ab = 0.;
G.ven.pact.ah = (.85)^2*%pi/4;
G.ven.pact.ahl = 0.;
G.ven.pact.ar = G.ven.pact.ah;
G.ven.pact.arl = 0.;
G.ven.pact.fdyf = 10.;
G.ven.pact.fstf = 10.;
G.ven.pact.mext = .04834 * 386.4;
G.ven.pact.xmax = .287;
G.ven.pact.xmin = .00873;

// Pump actuator leakage
G.ven.pact_lk.l = 0.292;
G.ven.pact_lk.r = 0.190 / 2;
G.ven.pact_lk.ecc = 0;
G.ven.pact_lk.rad_clear = 0.0004;

G.ven.pact_lk = G.ven.pact_lk;

// Pump pos disp
G.ven.vdpp.cn = 0;
G.ven.vdpp.cs = 5.3e-10;
G.ven.vdpp.ct = 0.00096;
G.ven.vdpp.cf = -0.02;
G.ven.vdpp.cdv = 3.1024;

// VEN Unit Linkages
// Degrees pump position
yxpump = [0., .5, 1.,..
 2., 3., 4., 5., 6.,..
 7., 8., 9., 10., 11.,..
 12., 13., 14., 15., 16.,..
 17., 18., 19., 20., 21.,..
 21.7, 22., 23., 24., 25., 26.];
// Return spring force, in-lbf
ytqrs = [732.2, 723.1, 713.7,..
 694., 673.1, 651.4, 628.7, 605.3,..
 581.2, 556.4, 531.2, 505.4, 479.3,..
 452.9, 426.1, 399.1, 371.1, 344.6,..
 317.9, 289.6, 262.1, 234.5, 207.,..
 187.8, 179.6, 152.2, 124.9, 98.8, 70.9];
// Pressure force gain, in-lbf/psi
ytqa = [1.392, 1.386, 1.380,..
 1.366, 1.352, 1.336, 1.320, 1.303,..
 1.284, 1.264, 1.244, 1.222, 1.199,..
 1.176, 1.151, 1.125, 1.098, 1.070,..
 1.042, 1.012, 0.981, 0.949, 0.916,..
 0.892, 0.882, 0.847, 0.811, 0.774, 0.736};
G.ven.vlink.ctqpv = 0.4418;
G.ven.vlink.cva = 1.588;
G.ven.vlink.cftpa = 0.567*0.7;
G.ven.vlink.ytqa.tb = [yxpump' ytqa'];
G.ven.vlink.ytqrs.tb = [yxpump' ytqrs']; 
clear ytqrs yxpump ytqa

G.ven.ehsv_klk = 2.257e-6;
G.ven.ehsv_powlk = 0.8;

// Rod relief valve
G.ven.rrv.ax1 = sqr(.15) * %pi / 4.;
G.ven.rrv.ax2 = G.ven.rrv.ax1;
G.ven.rrv.ax3 = 0.;
G.ven.rrv.ax4 = 0.;
G.ven.rrv.c = 0.;
G.ven.rrv.cd = .70;
G.ven.rrv.cdo = .61;
G.ven.rrv.cp = 0.43;
d = 0.100;
G.ven.rrv.ao = d^2*%pi/4;
clear d
G.ven.rrv.fdyf = 0.0;
G.ven.rrv.fs = 0.09;
G.ven.rrv.fstf = 0.0;
G.ven.rrv.ks = 10.;
G.ven.rrv.ld = 0.;
G.ven.rrv.lh = 0.;
ms = 0.0001;
mv = .002;
G.ven.rrv.m = mv + ms/2;
clear mv ms
G.ven.rrv.xmax = .05;
G.ven.rrv.xmin = 0.;
exec('./Callbacks/rrvwin.sci', -1);
[x, a] = rrvwin(40);
G.ven.rrv.ad.tb = [x a];
clear x a
G.ven.rrv.ah.tb = [0 0;1 0];

// VEN volumes
//G.ven.vo_pcham.vol = 3.2; // Match Simulink
G.ven.vo_pcham.vol = 1.6; // Match c-code
G.ven.vo_px.vol = 0.2;

// Bias %piston
G.ven.bias.c_ = .7;
G.ven.bias.cd_ = .61;
G.ven.bias.ab = 0.;
G.ven.bias.ah = (.538)^2*%pi/4;
G.ven.bias.ahl = 0.;
G.ven.bias.ar = max(G.ven.bias.ah - (.190)^2*%pi/4, 0);
G.ven.bias.arl = 0.;
G.ven.bias.fdyf = 0.;
G.ven.bias.fstf = 0.;
G.ven.bias.mact = .0383;
G.ven.bias.mext = 0.;
G.ven.bias.xmax = .1736;
G.ven.bias.xmin = 0.;

G.ven.ksb = 650;     // Sundstrand 7/14/92
G.ven.fsb = 12.54;   // Sundstrand 7/14/92

// Start line
G.mline.ln_vs.l = 23.7;
G.mline.ln_vs.vol = 3.42;
G.mline.ln_vs.a = G.mline.ln_vs.vol/G.mline.ln_vs.l;
G.mline.ln_vs.n = 8;
G.mline.ln_vs.c = 0.001; // For no ss oscillations. Set to 0 for normal.

// Define head_b hs=mvhead geometry
G.ifc.hs.f_cn = 0.75;
G.ifc.hs.f_dn = 0.055;
G.ifc.hs.f_ln = 0.003;
G.ifc.hs.f_an = G.ifc.hs.f_dn^2*%pi/4;
G.ifc.hs.ae = 0.307;
G.ifc.hs.ao = 0.125^2*%pi/4;
G.ifc.hs.cdo = 1;
G.ifc.hs.fb = -2.4;
G.ifc.hs.fs = 12.6;
G.ifc.hs.kb = 0;
G.ifc.hs.ks = 520;
G.ifc.hs.m = 1.29e-4*386.4;
G.ifc.hs.xmax = 0.0325;
G.ifc.hs.xmin = 0;

// Define hlfvalve mv geometry
G.ifc.mv.ax1 = 1.227;
G.ifc.mv.cd = 0.69;
G.ifc.mv.m = 0.497;
G.ifc.mv.xmax = 0.536;
G.ifc.mv.xmin = -0.1;
exec('./Callbacks/mvwin_b.sci', -1);
[xt, at] = mvwin_b(40);
G.ifc.mv.at.tb = [xt at];
clear xt at

// Define valve mvtv geometry
G.ifc.mvtv.ax1 = sqr(1)*%pi/4.;
G.ifc.mvtv.ax2 = sqr(1.125)*%pi/4.;
G.ifc.mvtv.ax3 = 0;
G.ifc.mvtv.ax4 = 0;
// G.ifc.mvtv.c = 0.1; linux c-code model acts like c=0 always
G.ifc.mvtv.c = 0.;
G.ifc.mvtv.clin = 0.1;
G.ifc.mvtv.cd = 0.7;
G.ifc.mvtv.cdo = 0.7;
G.ifc.mvtv.cp = 0;
d = 0.5; // disable
G.ifc.mvtv.ao = d^2*%pi/4;
clear d
G.ifc.mvtv.fdyf = 0;
G.ifc.mvtv.fstf = 0;
G.ifc.mvtv.fs = 25.2;
G.ifc.mvtv.ks = 69;
G.ifc.mvtv.ld = 0;
G.ifc.mvtv.lh = 0;
mv = (6.87e-4) * 386.4;
ms = 0;
G.ifc.mvtv.m = mv + ms/2;
clear mv ms
G.ifc.mvtv.xmax = 0.36;
G.ifc.mvtv.xmin = -0.12;
//G.ifc.mvtv.xmin = -0.05; // was -0.12 fix init
exec('./Callbacks/mvtvwin.sci', -1);
G.ifc.mvtv.ah.tb = [-1 0; 1 0];
[xd, ad] = mvtvwin(40);
G.ifc.mvtv.ad.tb = [xd ad];
clear xd ad

G.ifc.mvtv = G.ifc.mvtv;

// IFC volumes
G.ifc.mo_p3s.area = sqr(0.0135)*%pi/4;
G.ifc.mo_p3s.length = 0.01; 
G.ifc.vo_p3s.vol = 1.5;
G.ifc.ln_p3s.l = 11.0;
G.ifc.ln_p3s.a = sqr(0.1875)*%pi/4;
G.ifc.ln_p3s.vol = G.ifc.ln_p3s.l*G.ifc.ln_p3s.a; 
G.ifc.ln_p3s.n = 1;
vo_p1c_on = 14;
vo_p1c_so = 6.6;
G.ifc.a_p3s.ao = sqr(.0135)*%pi/4;
G.ifc.a_p3s.cd = 0.73;
G.ifc.a_tvb.ao = sqr(.032)*%pi/4;
G.ifc.a_tvb.cd = 0.73;

vo_p1c_on = 14;
vo_p1c_so = 6.6;
//G.ifc.vo_p1so.vol = vo_p1c_on - vo_p1c_so;
G.ifc.vo_p1so.vol = vo_p1c_on;
G.ifc.vo_pd.vol = 9.6;
G.ifc.vo_p3.vol = 5.61;
G.ifc.vo_px.vol = 1.6;
G.ifc.a_tvb = G.ifc.a_tvb;
G.ifc.k1leak = 0.3098;
G.ifc.a1leak = 6.1783e-4;

// PRTV
G.ifc.prtv.fs = 24;
G.ifc.prtv.ks = 70;
G.ifc.prtv.ax1 = 0.076945;

// Define main line 
G.mline.main_line.l = 48;
G.mline.main_line.a = 0.363;
G.mline.main_line.vol = G.mline.main_line.l*G.mline.main_line.a; 
G.mline.main_line.n = 5;
G.mline.vo_pnozin.vol = 20;

// Nozzle pressure drop
xdpnoz = [125, 130, 154, 265, 365, 450, 510, 573, 615, 735]';
ywfnoz = [0, 540, 900, 6300, 10440, 13590, 15300, 16560, 17000, 18000]';
G.mline.noz.tb = [xdpnoz, ywfnoz];
clear ywfnoz xdpnoz

// Engine model
G.eng.N25100Pct = 17210;
G.eng.xnvent = 8108;
G.eng.spcn25 = [ 15., 40., 67., 72., 75., 80., 85., 90., 93., 95., 97.5, 100., 95., 95., 95.];
G.eng.sfxven = [ 1., 1., 0., 0., 4000., 6000., 6500, 7000., 8000., 10000., 12000., 12000., 20000., 0., 25000];
G.eng.swf = [ 430., 600., 760., 1180., 1750., 2500., 5140., 7020., 9060., 11115., 14000., 16910., 11115., 11115., 11115.];
G.eng.sawfb = [0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004, 0.0004];
G.eng.xn25p = 17210;
G.eng.xnmainpt = 27139;
G.eng.xnvent = 8108;
G.eng.N2c100Pct = 10693;
G.eng.N25c100Pct= 13420;
G.eng.N25100Pct = 17210;
// Fuel flow abscissa, pph
wf = [ 330., 805., 3669., 6515., 12598., 17400.]';
// VEN load, lbf
fxven = [-3000., 0., 27072., 30000., 32500., 34000.]';
// Simple engine steady state map. Points 0 and 5 are guesses. Points 1 
// thru 4 are F412 cycle points. 
// HPC total inlet temp, deg R
t25 = [519., 566., 708., 779., 866., 900.]';
// HPC static disch press, psia
ps3 = [15., 56., 179., 274., 441., 545.]';
// HPC static disch press derivative, psi/pph
dps3dw = [.02, .0140, .0112, .0105, .0107, .0109]';
// LPC corrected speed, 100// =10693 rpm
pcn2r = [0., 34.72, 79.67, 90.76, 100., 110.]';
// LPC corrected speed, 100// =13420 rpm
pcn25r = [13., 82.52, 91.21, 93.30, 96.31, 97.4]';
G.eng.fxvent.tb = [wf fxven];
G.eng.t25t.tb = [wf t25];
G.eng.ps3t.tb = [wf ps3];
G.eng.dps3dwt.tb = [wf dps3dw];
G.eng.pcn2rt.tb = [wf pcn2r];
G.eng.pcn25rt.tb = [wf pcn25r];
clear wf t25 ps3 dps3dw pcn2r pcn25r fxven


// Engine fuel supply
G.ebp.mfp.a = 1.395;
G.ebp.mfp.b = 11.43;
G.ebp.mfp.c = -201.8;
G.ebp.mfp.d = 0;
G.ebp.mfp.w1 = 0.16;
G.ebp.mfp.w2 = 0.16;
G.ebp.mfp.r1 = 0.7;
G.ebp.mfp.r2 = 1.55;
G.ebp.mfp.tau = 0.00127;
// FVG & non servo flowbody leakages
G.ebp.wf1leak.Ao = or_wptoa(100., 263., 0., 0.61, .74); // TODO debug only
G.ebp.wf1leak.k = la_wptok(97., 263., 0., .84); // TODO debug only
G.ebp.wf1leak.Do = sqrt(4/%pi*G.ebp.wf1leak.Ao);
fab.n = 1;
fab.vol = 6.7;
fab.l = 6;
fab.a = fab.vol/fab.l;
fab.c = 0;
aboc.n = 4;
aboc.vol = 16.8;
aboc.l = 24;
aboc.a = aboc.vol/aboc.l;
aboc.c = 0;
G.ebp.faboc.n = 3;
G.ebp.faboc.vol = aboc.vol + fab.vol;
G.ebp.faboc.l = aboc.l + fab.l;
G.ebp.faboc.a = aboc.vol/aboc.l;
G.ebp.faboc.c = 100;
clear fab aboc
G.ebp.ocm1.n = 3;
G.ebp.ocm1.vol = 8.4;
G.ebp.ocm1.l = 12;
G.ebp.ocm1.a = G.ebp.ocm1.vol/G.ebp.ocm1.l;
G.ebp.ocm1.c = 100;
G.ebp.ocm2.n = 1;
G.ebp.ocm2.vol = 4.2;
G.ebp.ocm2.l = 6;
G.ebp.ocm2.a = G.ebp.ocm2.vol/G.ebp.ocm2.l;
G.ebp.ocm2.c = 100;
G.ebp.focOr.cd = 0.61;
//G.ebp.focOr.ao = or_wptoa(17000., 60., 0., G.ebp.focOr.cd, FP.sg);
//G.ebp.focOr.Do = sqrt(4/%pi*G.ebp.focOr.Ao);
G.ebp.focOr.ao = or_wptoa(17000., 60., 0., G.ebp.focOr.cd, 0.74);
G.ebp.vo_poc.vol = 36;
G.ebp.boost.a = 0.520;
G.ebp.boost.b = 6.60;
G.ebp.boost.c = -316;
G.ebp.boost.d = 0;
G.ebp.boost.w1 = 1;
G.ebp.boost.w2 = 0.2;
G.ebp.boost.r1 = 0;
G.ebp.boost.r2 = 2.55;
G.ebp.boost.tau = 0.00127;
G.ebp.inlet.n = 3;
G.ebp.inlet.vol = 88.7;
G.ebp.inlet.l = 30;
G.ebp.inlet.a = G.ebp.inlet.vol/G.ebp.inlet.l;
G.ebp.inlet.c = 0;
G.ebp.or_filt.cd = 0.61;
G.ebp.or_filt.ao = or_wptoa(52000, 2, 0, G.ebp.or_filt.cd, FP.sg);
G.ebp.mom_filt.length = 6;
vol = 6.7;
G.ebp.mom_filt.area = vol/G.ebp.mom_filt.length;
clear vol
//G.ebp.mom_filt.c = 0;
G.ebp.vo_pb1.vol = 77.9;
G.ebp.vo_pb2.vol = 5;
G.ebp.vo_p1.vol = 1e6;

// Aircraft fuel supply
// -400
G.acsupply.ltank.l = 0.1;
G.acsupply.ltank.a = 2.805521;
G.acsupply.ltank.vol = 0.280552;
G.acsupply.ltank.n = 1;
G.acsupply.ltank.c = 100;
G.acsupply.lengine.l = 49.213;
G.acsupply.lengine.a = %pi*(1.929/2)^2;
G.acsupply.lengine.vol = G.acsupply.lengine.l * G.acsupply.lengine.a;
G.acsupply.lengine.n = 9;
G.acsupply.lengine.c = 100;
// G.acsupply.a_drop.Do = ; // see InitFcn
//G.acsupply.a_drop.cd = 0.999;
//G.acsupply.acbst.Npump = -999; // not applicable
G.acsupply.acbst.tau = 0.00127;
G.acsupply.acbst.r1 = 0;
G.acsupply.acbst.w1 = 0;
G.acsupply.acbst.r2 = 2;
G.acsupply.acbst.w2 = 1;
G.acsupply.acbst.a = 0.075;
G.acsupply.acbst.b = -1.59;
G.acsupply.acbst.c = -102;
G.acsupply.acbst.d = 0;
G.acsupply.acmbst.tau = 0.00127;
G.acsupply.acmbst.a = .116;
G.acsupply.acmbst.b = 0;
G.acsupply.acmbst.c = 0;
G.acsupply.acmbst.d = 0;
G.acsupply.acmbst.w1 = 1;
G.acsupply.acmbst.w2 = 1;
G.acsupply.acmbst.r1 = 0;
G.acsupply.acmbst.r2 = 2;
// ACsupply motor
G.acsupply.motor.cd = 0.61;
dpSize = 120;
wfSize = 4200;
sgSize = 0.75; // 80F JP5 (0.7921 to match verification)
G.acsupply.motor.ao = or_wptoa(wfSize, dpSize, 0, G.acsupply.motor.cd, sgSize);
clear dpSize wfSize sgSize

// VEN actuator
G.venload.act_c.arl = 0.000112; // B. Noyes 1/93.
G.venload.act_c.ahl = 0.0;
G.venload.act_c.ah = 9.246558;
G.venload.act_c.ar = 7.443421;
//G.venload.act_c.vol_head_mech = 38.1; // B. Noyes 6/19/1992
//G.venload.act_c.vol_rod_mech = 1; // arbitrarily small
G.venload.act_c.ab = 0.000763; // B. Noyes 8/92.
G.venload.act_c.c_ = 40.; // A little bit to quiet down.
G.venload.act_c.cd_ = .85; // B. Noyes 4/92.
G.venload.act_c.mext = 200.; // Guess.
G.venload.act_c.mact = 0;
//G.venload.act_c.m = G.venload.act_c.mext + G.venload.act_c.mact;
G.venload.act_c.xmax = 5.265;
G.venload.act_c.xmin = 0;
G.venload.act_c.fstf = 20; // Small friction.
G.venload.act_c.fdyf = G.venload.act_c.fstf;
//G.venload.act_c.eps = 1e-3; // boundary layer stiction
//G.venload.act_c.vmax = 1000;
//G.venload.act_c.vmin = -1000;
//G.venload.act_c.eps = 0.1;
sfric_c = G.venload.act_c.fstf;
dfric_c = G.venload.act_c.fdyf;
sfric_o = G.venload.act_c.fstf;
dfric_o = G.venload.act_c.fdyf;
// TODO: add friction to actuator_a_c
//G.venload.act_c.FSTF_C = [4.7*(ones(1,4) - [10 9.9 8.1 8]/100); sfric_c*ones(1,4)];
//G.venload.act_c.FDYF_C = [4.7*(ones(1,4) - [10 9.9 8.1 8]/100); dfric_c*ones(1,4)];
//G.venload.act_c.FSTF_O = [4.7*(ones(1,4) - [10 9.9 8.1 8]/100); sfric_c sfric_o sfric_o sfric_c];
//G.venload.act_c.FDYF_O = [4.7*(ones(1,4) - [10 9.9 8.1 8]/100); dfric_o*ones(1,4)];
clear sfric_c dfric_c sfric_o dfric_o

//G.venload.Km = 10000000;

G.venload.hline.n = 12;
G.venload.hline.c = 0;
G.venload.hline.vol = 13.5; // D. Patch 2/92 
G.venload.hline.l = 93.; // D. Patch 2/92 
G.venload.hline.a = G.venload.hline.vol/G.venload.hline.l;
G.venload.rline.n = 12;
G.venload.rline.c = 0;
G.venload.rline.vol = 13.5; // D. Patch 2/92 
G.venload.rline.l = 93.; // D. Patch 2/92 
G.venload.rline.a = G.venload.rline.vol/G.venload.rline.l;
G.venload.vo_hcham.vol = 60.; // B. Noyes, at nominal 2.5 in stroke
G.venload.vo_rcham.vol = 25.; // B. Noyes, at nominal 2.5 in stroke

// VEN servovalve torque motor
G.venload.ehsv.tau_s = 0.00637;             // 25 hz per Moog 6/15/92. 
G.venload.ehsv.wn_s = 25*2*%pi;             // Add 2nd order DAG 8/14/2017
G.venload.ehsv.zeta_s = 0.5;                // Add 2nd order DAG 8/14/2017
G.venload.ehsv.dp_s = 1000;                 // Moog 6/15/92. 
G.venload.ehsv.ael = or_wptoa(56, 300, 0, 0.61, 0.77);// 56 pph at 300 psi and .77 sg (JNS 9/23/92). 
G.venload.ehsv.kel = 0;                     // Disabled. Part of k1leak
G.venload.ehsv.cd_ = 0.61;                  // Arbitrary DAG 7/3/96. 
G.venload.ehsv.cdl = 0.61;                  // Arbitrary DAG 7/3/96. 
G.venload.ehsv.xmax = 0.0427;               // Moog 9/14/92 total stroke .080 inches. 
G.venload.ehsv.xmaxS = 0.085;               // Moog 9/14/92 total stroke .080 inches. 
G.venload.ehsv.xmin = -0.0373;              // " " 
G.venload.ehsv.kix = -(G.venload.ehsv.xmax - G.venload.ehsv.xmin) / 75.; // 75 mA useful range, nominal, JNS 8/25/92.
G.venload.ehsv.mAnull = 25;
dh = 0.516;                  // Moog 9/14/92. 
G.venload.ehsv.ah = dh^2*%pi/4;
dr = 0.200;                  // Guess 
G.venload.ehsv.ar = max(G.venload.ehsv.ah - dr^2*%pi/4, 0);
clear dh dr
G.venload.ehsv.vmax_s = 1.5*0.52/3/G.venload.ehsv.ah; // .52 cis per Moog 9/14/92. Divide by 3 for GE ehsv slew requirement. Multiply by 1.5 for 2-pass test 7/2/96 
G.venload.ehsv.vmin_s = -G.venload.ehsv.vmax_s;
G.venload.ehsv.underlap = -0.025*G.venload.ehsv.xmax; // 2.5% of stroke, in. 
G.venload.ehsv.amn = 1e-7;                  // Table min area, sqin 
G.venload.ehsv.wdh = 0.636;                 // 7/3/96 DAG Moog dwg.
G.venload.ehsv.wsr = 0.636;                 // 7/3/96 DAG Moog dwg.
G.venload.ehsv.wsh = 0.636;                 // 7/3/96 DAG Moog dwg.
G.venload.ehsv.wdr = 0.636;                 // 7/3/96 DAG Moog dwg.
G.venload.ehsv.xmxc_s = 0.085;              // Estimated shutoff stroke assuming 2.63x gain as for normal op. 
G.venload.ehsv.xmxc_rat = 1.4*51/40;        // Overstroke, mA 
G.venload.ehsv_klk = 2.257e-6;              // JNS 9/23/92 
G.venload.ehsv_powlk = .8;                  // JNS 9/23/92; 122.5 pph @ 1000 psi, .76sg,
G.venload.ehsv.minPressure = 10;            // DAG 3/9/2018 estimate of minimum operational pressure, psid
null = G.venload.ehsv.mAnull;
kix = G.venload.ehsv.kix;
xmaxS = G.venload.ehsv.xmaxS;
G.venload.ehsv.mA_x.tb =  [ -100     null-50  null    null+50; xmaxS   -50*kix  0        50*kix];
G.venload.ehsv.mA_x0.tb = [ null-50  null     null+50 100;     50*kix  0        -50*kix  xmaxS];
clear null kix xmaxS
// VEN servovalve windows
G.venload.ehsv.awin_dh.tb(1,1) = G.venload.ehsv.xmin;
G.venload.ehsv.awin_dh.tb(1,2) = 0;
G.venload.ehsv.awin_dh.tb(2,1) = -(G.venload.ehsv.underlap)-1e-16;
G.venload.ehsv.awin_dh.tb(2,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_dh.tb(3,1) = -(G.venload.ehsv.underlap);
G.venload.ehsv.awin_dh.tb(3,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_dh.tb(4,1) = G.venload.ehsv.xmax * G.venload.ehsv.xmxc_rat;
G.venload.ehsv.awin_dh.tb(4,2) = max(G.venload.ehsv.awin_dh.tb(3,2), G.venload.ehsv.wdh * (G.venload.ehsv.awin_dh.tb(4,1) + G.venload.ehsv.underlap));
G.venload.ehsv.awin_dh.tb(5,1) = G.venload.ehsv.xmxc_s + (G.venload.ehsv.underlap);
G.venload.ehsv.awin_dh.tb(5,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_dh.tb(6,1) = G.venload.ehsv.xmaxS;
G.venload.ehsv.awin_dh.tb(6,2) = G.venload.ehsv.amn;
// G.venload.ehsv.awin_dh.tb = G.venload.ehsv.awin_dh.tb';
G.venload.ehsv.awin_dr.tb(1,1) = -G.venload.ehsv.xmax;
G.venload.ehsv.awin_dr.tb(1,2) = 0;
G.venload.ehsv.awin_dr.tb(2,1) = -(G.venload.ehsv.underlap)-1e-16;
G.venload.ehsv.awin_dr.tb(2,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_dr.tb(3,1) = -(G.venload.ehsv.underlap);
G.venload.ehsv.awin_dr.tb(3,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_dr.tb(4,1) = -G.venload.ehsv.xmin;
G.venload.ehsv.awin_dr.tb(4,2) = max(G.venload.ehsv.awin_dr.tb(3,2), G.venload.ehsv.wdr * (G.venload.ehsv.awin_dr.tb(4,1) + G.venload.ehsv.underlap));
// G.venload.ehsv.awin_dr.tb = G.venload.ehsv.awin_dr.tb';

G.venload.ehsv.awin_sh.tb(1,1) = -(G.venload.ehsv.xmax);
G.venload.ehsv.awin_sh.tb(1,2) = 0;
G.venload.ehsv.awin_sh.tb(2,1) = -(G.venload.ehsv.underlap)-1e-16;
G.venload.ehsv.awin_sh.tb(2,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_sh.tb(3,1) = -(G.venload.ehsv.underlap);
G.venload.ehsv.awin_sh.tb(3,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_sh.tb(4,1) = -G.venload.ehsv.xmin;
G.venload.ehsv.awin_sh.tb(4,2) = max(G.venload.ehsv.awin_sh.tb(3,2), G.venload.ehsv.wsh * (G.venload.ehsv.awin_sh.tb(4,1) + G.venload.ehsv.underlap));
// G.venload.ehsv.awin_sh.tb = G.venload.ehsv.awin_sh.tb';

G.venload.ehsv.awin_sr.tb(1,1) = -(-G.venload.ehsv.xmin);
G.venload.ehsv.awin_sr.tb(1,2) = 0;
G.venload.ehsv.awin_sr.tb(2,1) = -(G.venload.ehsv.underlap)-1e-16;
G.venload.ehsv.awin_sr.tb(2,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_sr.tb(3,1) = -(G.venload.ehsv.underlap);
G.venload.ehsv.awin_sr.tb(3,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_sr.tb(4,1) = G.venload.ehsv.xmax *G.venload.ehsv.xmxc_rat; // Overstroke
G.venload.ehsv.awin_sr.tb(4,2) = max(G.venload.ehsv.awin_sr.tb(3,2), G.venload.ehsv.wsr * (G.venload.ehsv.awin_sr.tb(4,1) + G.venload.ehsv.underlap));
G.venload.ehsv.awin_sr.tb(5,1) = G.venload.ehsv.xmxc_s + (G.venload.ehsv.underlap);
G.venload.ehsv.awin_sr.tb(5,2) = G.venload.ehsv.amn;
G.venload.ehsv.awin_sr.tb(6,1) = G.venload.ehsv.xmaxS;
G.venload.ehsv.awin_sr.tb(6,2) = G.venload.ehsv.amn;

G.ven.leako.l = 0.292;              // Sundstrand 7/14/92 - KLVO=.0003126
//                                  cis/psi @ .0004 rad_clear, .095 r, 0 ecc,
//                                  .35 centistokes, .69 sg (JP4 @ 250F)
G.ven.leako.rad_clear = 0.0004;     //"  Reg. dia clearance, in
G.ven.leako.ecc = 0;                // Assumed
ven_reg_dh = .190;                  // Sundstrand 7/14/92
G.ven.leako.r = ven_reg_dh/2;
clear ven_reg_dh

// VEN initialization
xfx               = [     -8000     -3000     0         2000      8000      10000     20000     23000     27000     30000     32000]';
G.guess.xn25.tb = [xfx   [11356    11356     11356     15145     12908     17210     17210     14629     16350     17210     17210]'];
G.guess.disp.tb = [xfx   [0.081569  0.06607   0.07427   0.07095   0.1135    0.09177   0.1192    0.1494    0.1408    0.1362    0.1379]'];
G.guess.xehsv.tb = [xfx  [-0.003699 -0.001957 -0.001970 0.002523  0.003342  0.003586  0.004454  0.004661  0.005185  0.006039  0.006846]'];
G.guess.xreg.tb = [xfx   [-0.001952 -0.002000 -0.002213 -0.002433 -0.002712 -0.002777 -0.002966 -0.002998 -0.003025 -0.003025 -0.003025]'];
G.guess.xbias.tb = [xfx  [0.0       0.002358  0.01416   0.03188   0.06925   0.08248   0.1422    0.1593    0.1736    0.1736    0.1736]'];
G.guess.pd.tb = [xfx     [1500      1553      1817      2348      3101      3519      4884      5201      5576      5602      5602]'];
G.guess.prod.tb = [xfx   [387.7     577.1     842.8     1374      2129      2547      3913      4229      4722      4963      5104]'];
G.guess.px.tb = [xfx     [794.2     806.9     866.0     1086      1181      1366      1676      1693      1815      1840      1840]'];
G.guess.phead.tb = [xfx  [1180      791.8     681.2     891.8     851.2     971.8     989.8     920       884.4     753.7     650.5]'];
clear xfx

mprintf('Completed %s\n', sfilename()) 
