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

stacksize('max');

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

// Start line
GEO.ln_vs.l = 23.7;
GEO.ln_vs.vol = 3.42;
GEO.ln_vs.a = GEO.ln_vs.vol/GEO.ln_vs.l;

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
GEO.mv.xmin = 0;
exec('./Callbacks/mvwin_a.sci', -1);
[xt, at] = mvwin_a(40);
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
xwfnoz = [0.,     540.,   900.,   6300., 10440., 13590., 15300., 16560., 17000., 18000.]';
ydpnoz = [125.,   130.,   154.,   265.,   365.,  450.,   510.,   573.,   615.,   735]';
GEO.noz.tb = [xwfnoz, ydpnoz];
clear xwfnoz ydpnoz

mprintf('Completed %s\n', sfilename())  
