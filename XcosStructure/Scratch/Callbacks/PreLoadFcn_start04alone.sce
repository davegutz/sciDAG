// Copyright (C) 2019 - Dave Gutz
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
// Jan 1, 2019  DA Gutz     Created
// 

global LINCOS_OVERRIDE
global loaded_scratch
global GEO INI FP

mprintf('In %s\n', sfilename())  

//stacksize('max');

// Define valve vsv start valve geometry
d = 0.2657;
GEO.vsv.ax1 = d^2*%pi/4;
clear d
GEO.vsv.ax2 = GEO.vsv.ax1;
GEO.vsv.ax3 = 0;
GEO.vsv.ax4 = GEO.vsv.ax1;
GEO.vsv.c = 0;
GEO.vsv.clin = 0.24;
GEO.vsv.cd = 0.7;
GEO.vsv.cdo = 0.61;
GEO.vsv.cp = 0.43;
d = 0.016;
GEO.vsv.ao = d^2*%pi/4;
clear d
GEO.vsv.fdyf = 0;
GEO.vsv.fstf = 0;
GEO.vsv.fs = 15.8;
GEO.vsv.ks = 50;
GEO.vsv.ld = 0;
GEO.vsv.lh = 0;
mv = 8e-5*386.4;
ms = 0.15;
GEO.vsv.m = mv + ms/2;
clear mv ms
GEO.vsv.xmax = 0.125;
GEO.vsv.xmin = 0;
exec('./Callbacks/vsvwin_a.sci', -1);
GEO.vsv.ad.tb = [-1 0; 1 0];
[xh, ah, wvh] = vsvwin_a(40);
GEO.vsv.ah.tb = [xh ah];
clear xh ah wvh

// Define trivalve reg geometry
dh = .190; dlh = 0.; dlr = 0.; dld = 0.; dr = .125; 
GEO.reg.adl = 0;
GEO.reg.ahd = max((sqr(dh)  - sqr(dlr)) * %pi / 4., 0.);
GEO.reg.ahs = sqr(dh)  * %pi / 4.;
GEO.reg.ald = max((sqr(dlh) - sqr(dld)) * %pi / 4., 0.);
GEO.reg.ale = sqr(dld) * %pi / 4.;
GEO.reg.alr = max((sqr(dlh) - sqr(dlr)) * %pi / 4., 0.);
GEO.reg.ar = max((sqr(dh)  - sqr(dr))  * %pi / 4., 0.);
GEO.reg.asl = 0;
clear dh dlh dlr dld dr
GEO.reg.c = 0.75;
GEO.reg.cd = 0.61;
GEO.reg.cp = 0;
GEO.reg.fs = -15.9-12.;
GEO.reg.fdyf = 2;
GEO.reg.fstf = 2;
GEO.reg.ks = 120.;
GEO.reg.ld = 0;
GEO.reg.ls = 0;
GEO.reg.m = 0.055;
GEO.reg.xmax = 0.125;
GEO.reg.xmin = -0.011;
exec('./Callbacks/regwin_a.sci', -1);
[xh, as, ad] = regwin_a(40);
GEO.reg.as.tb = [xh as];
GEO.reg.ad.tb = [xh ad];
clear xh as ad

// Pump actuator
GEO.pact.c_     = 100.;
GEO.pact.cd_    = .61;
GEO.pact.ab    = 0.;
GEO.pact.ah    = (.85)^2*%pi/4;
GEO.pact.ahl   = 0.;
GEO.pact.ar    = GEO.pact.ah;
GEO.pact.arl   = 0.;
GEO.pact.fdyf  = 10.;
GEO.pact.fstf  = 10.;
GEO.pact.mext  = .04834 * 386.4;
GEO.pact.xmax  = .287;
GEO.pact.xmin  = .00873;

// Pump actuator leakage
GEO.pact_lk.l = 0.292;
GEO.pact_lk.r = 0.190 / 2;
GEO.pact_lk.ecc = 0;
GEO.pact_lk.rad_clear = 0.0004;

// Pump pos disp
GEO.vdpp.cn = 0;
GEO.vdpp.cs = 5.3e-10;
GEO.vdpp.ct = 0.00096;
GEO.vdpp.cf = -0.02;
GEO.vdpp.cdv = 3.1024;

// VEN Unit Linkages
// Degrees pump position
yxpump = [0.,     .5,     1.,..
          2.,     3.,     4.,     5.,     6.,..
          7.,     8.,     9.,     10.,    11.,..
          12.,    13.,    14.,    15.,    16.,..
          17.,    18.,    19.,    20.,    21.,..
          21.7,   22.,    23.,    24.,    25.,    26.];
// Return spring force, in-lbf
ytqrs = [732.2,  723.1,  713.7,..
         694.,   673.1,  651.4,  628.7,  605.3,..
         581.2,  556.4,  531.2,  505.4,  479.3,..
         452.9,  426.1,  399.1,  371.1,  344.6,..
         317.9,  289.6,  262.1,  234.5,  207.,..
         187.8,  179.6,  152.2,  124.9,  98.8, 70.9];
// Pressure force gain, in-lbf/psi
ytqa = [1.392,  1.386,  1.380,..
        1.366,  1.352,  1.336,  1.320,  1.303,..
        1.284,  1.264,  1.244,  1.222,  1.199,..
        1.176,  1.151,  1.125,  1.098,  1.070,..
        1.042,  1.012,  0.981,  0.949,  0.916,..
        0.892,  0.882,  0.847,  0.811,  0.774,  0.736};
GEO.vlink.ctqpv = 0.4418;
GEO.vlink.cva = 1.588;
GEO.vlink.cftpa = 0.567*0.7;
GEO.vlink.ytqa.tb = [yxpump' ytqa'];
GEO.vlink.ytqrs.tb = [yxpump' ytqrs']; 
clear ytqrs yxpump ytqa

GEO.ehsv_klk = 2.257e-6;
GEO.ehsv_powlk = 0.8;

// Rod relief valve
GEO.rrv.ax1 = sqr(.15) * %pi / 4.;
GEO.rrv.ax2 = GEO.rrv.ax1;
GEO.rrv.ax3 = 0.;
GEO.rrv.ax4 = 0.;
GEO.rrv.c = 0.;
GEO.rrv.cd = .70;
GEO.rrv.cdo = .61;
GEO.rrv.cp = 0.43;
d = 0.100;
GEO.rrv.ao = d^2*%pi/4;
clear d
GEO.rrv.fdyf = 0.0;
GEO.rrv.fs = 0.09;
GEO.rrv.fstf = 0.0;
GEO.rrv.ks = 10.;
GEO.rrv.ld = 0.;
GEO.rrv.lh = 0.;
ms = 0.0001;
mv = .002;
GEO.rrv.m = mv + ms/2;
clear mv ms
GEO.rrv.xmax = .05;
GEO.rrv.xmin = 0.;
exec('./Callbacks/rrvwin.sci', -1);
[x, a] = rrvwin(40);
GEO.rrv.ad.tb = [x a];
clear x a
GEO.rrv.ah.tb = [0 0;1 0];

// VEN volumes
GEO.vo_pcham.vol = 1.6;
GEO.vo_px.vol = 1000000;

// Bias piston
GEO.bias.c_ = .7;
GEO.bias.cd_ = .61;
GEO.bias.ab = 0.;
GEO.bias.ah = (.538)^2*%pi/4;
GEO.bias.ahl = 0.;
GEO.bias.ar = (.190)^2*%pi/4;
GEO.bias.arl = 0.;
GEO.bias.fdyf = 0.;
GEO.bias.fstf = 0.;
GEO.bias.mact = .0383;
GEO.bias.mext = 0.;
GEO.bias.xmax = .1736;
GEO.bias.xmin = 0.;

// Start line
GEO.ln_vs.l = 23.7;
GEO.ln_vs.vol = 3.42;
GEO.ln_vs.a = GEO.ln_vs.vol/GEO.ln_vs.l;
GEO.ln_vs.n = 8;
GEO.ln_vs.c = 0.001;  // For no ss oscillations.   Set to 0 for normal.

// Define head_b hs=mvhead geometry
GEO.hs.f_cn = 0.75;
GEO.hs.f_dn = 0.055;
GEO.hs.f_ln = 0.003;
GEO.hs.f_an = GEO.hs.f_dn^2*%pi/4;
GEO.hs.ae = 0.307;
GEO.hs.ao = 0.125^2*%pi/4;
GEO.hs.cdo = 1;
GEO.hs.fb = 0;
GEO.hs.fs = 12.6;
GEO.hs.kb = 0;
GEO.hs.ks = 520;
GEO.hs.m = 1.29e-4*386.4;
GEO.hs.xmax = 0.0325;
GEO.hs.xmin = 0;

// Define hlfvalve mv geometry
GEO.mv.ax1 = 1.227;
GEO.mv.cd = 0.69;
GEO.mv.m = 0.497;
GEO.mv.xmax = 0.536;
GEO.mv.xmin = -0.1;
exec('./Callbacks/mvwin_b.sci', -1);
[xt, at] = mvwin_b(40);
GEO.mv.at.tb = [xt at];
clear xt at

// Define valve mvtv geometry
GEO.mvtv.ax1 = sqr(1)*%pi/4.;
GEO.mvtv.ax2 = sqr(1.125)*%pi/4.;
GEO.mvtv.ax3 = 0;
GEO.mvtv.ax4 = 0;
// GEO.mvtv.c = 0.1;  linux c-code model acts like c=0 always
GEO.mvtv.c = 0.;
GEO.mvtv.clin = 0.1;
GEO.mvtv.cd = 0.7;
GEO.mvtv.cdo = 0.7;
GEO.mvtv.cp = 0.43;
d = 0.5;
GEO.mvtv.ao = d^2*%pi/4;
clear d
GEO.mvtv.fdyf = 0;
GEO.mvtv.fstf = 0;
GEO.mvtv.fs = 25.2;
GEO.mvtv.ks = 69;
GEO.mvtv.ld = 0;
GEO.mvtv.lh = 0;
mv = (6.87e-4) * 386.4;
ms = 0;
GEO.mvtv.m = mv + ms/2;
clear mv ms
GEO.mvtv.xmax = 0.36;
GEO.mvtv.xmin = -0.12;
//GEO.mvtv.xmin = -0.05;  // was -0.12 fix init
exec('./Callbacks/mvtvwin.sci', -1);
GEO.mvtv.ah.tb = [-1 0; 1 0];
[xd, ad] = mvtvwin(40);
GEO.mvtv.ad.tb = [xd ad];
clear xd ad

// IFC volumes
GEO.mo_p3s.area = sqr(0.0135)*%pi/4;
GEO.mo_p3s.length = 0.01; 
GEO.vo_p3s.vol = 1.5;
GEO.ln_p3s.l = 11.0;
GEO.ln_p3s.a = sqr(0.1875)*%pi/4;
GEO.ln_p3s.vol = GEO.ln_p3s.l*GEO.ln_p3s.a; 
GEO.ln_p3s.n = 1;
vo_p1c_on = 14;
vo_p1c_so = 6.6;
//GEO.vo_p1so.vol = vo_p1c_on - vo_p1c_so;
GEO.vo_p1so.vol = vo_p1c_on;
GEO.vo_p2.vol = 5.61;
GEO.vo_p3.vol = 9.6;
GEO.vo_px.vol = 1.6;
GEO.a_p3s.ao =  sqr(.0135)*%pi/4;
GEO.a_p3s.cd = 0.73;
GEO.a_tvb.ao = sqr(.032)*%pi/4;
GEO.a_tvb.cd = 0.73;

// Define main line 
GEO.main_line.l = 48;
GEO.main_line.a = 0.363;
GEO.main_line.vol = GEO.main_line.l*GEO.main_line.a; 
GEO.main_line.n = 5;
GEO.vo_pnozin.vol = 20;

// Nozzle pressure drop
xdpnoz = [125,  130,  154, 265,  365,   450,   510,   573,   615,   735]';
ywfnoz = [0,    540,  900, 6300, 10440, 13590, 15300, 16560, 17000, 18000]';
GEO.noz.tb = [xdpnoz, ywfnoz];
clear ywfnoz xdpnoz

// Engine model
E.N25100Pct = 17210;
E.xnvent = 8108;

mprintf('Completed %s\n', sfilename())  
