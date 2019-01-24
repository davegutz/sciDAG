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
global GEO INI
global start02_x        start02_v
global start02_ph       start02_prs     start02_pxr
global start02_ps       start02_wfs     start02_wfh
global start02_wfvrs    start02_wfvx    start02_uf
global start02_uf_net   start02_px start02_a
global start02_t_x      start02_t_v     start02_t_ped
global start02_t_pes    start02_t_pd    start02_t_pld
global start02_t_plr    start02_t_ps    start02_t_wfd
global start02_t_wfde   start02_t_wfld  start02_t_wfle
global start02_t_wflr   start02_t_wfs   start02_t_wfse
global start02_t_wfxd   start02_t_wfsx  start02_t_wfx
global start02_t_uf_net start02_t_uf    start02_t_fext
global start02_t_pel    start02_t_px
mprintf('In %s\n', sfilename())  


// Load c-model reference data
stacksize('max');
[M, comments] = csvRead('./Data/start02.ven.csv',',',[],"double",[],[],[],[1]);
start02_x = struct("time", M(:,1), "values", M(:,2));
start02_v = struct("time", M(:,1), "values", M(:,3));
start02_ph = struct("time", M(:,1), "values", M(:,4));
start02_prs = struct("time", M(:,1), "values", M(:,5));
start02_pxr = struct("time", M(:,1), "values", M(:,6));
start02_ps = struct("time", M(:,1), "values", M(:,7));
start02_wfs = struct("time", M(:,1), "values", M(:,8));
start02_wfh = struct("time", M(:,1), "values", M(:,9));
start02_wfvrs = struct("time", M(:,1), "values", M(:,10));
start02_wfvx = struct("time", M(:,1), "values", M(:,11));
start02_uf_net = struct("time", M(:,1), "values", M(:,12));
start02_uf = struct("time", M(:,1), "values", M(:,13));
start02_px = struct("time", M(:,1), "values", M(:,14));
start02_a = struct("time", M(:,1), "values", M(:,15));
start02_t_x = struct("time", M(:,1), "values", M(:,17));
start02_t_v = struct("time", M(:,1), "values", M(:,18));
start02_t_ped = struct("time", M(:,1), "values", M(:,19));
start02_t_pes = struct("time", M(:,1), "values", M(:,20));
start02_t_pd = struct("time", M(:,1), "values", M(:,21));
start02_t_pld = struct("time", M(:,1), "values", M(:,22));
start02_t_plr = struct("time", M(:,1), "values", M(:,23));
start02_t_ps = struct("time", M(:,1), "values", M(:,24));
start02_t_wfd = struct("time", M(:,1), "values", M(:,25));
start02_t_wfde = struct("time", M(:,1), "values", M(:,26));
start02_t_wfld = struct("time", M(:,1), "values", M(:,27));
start02_t_wfle = struct("time", M(:,1), "values", M(:,28));
start02_t_wflr = struct("time", M(:,1), "values", M(:,29));
start02_t_wfs = struct("time", M(:,1), "values", M(:,30));
start02_t_wfse = struct("time", M(:,1), "values", M(:,31));
start02_t_wfxd = struct("time", M(:,1), "values", M(:,32));
start02_t_wfsx = struct("time", M(:,1), "values", M(:,33));
start02_t_wfx = struct("time", M(:,1), "values", M(:,34));
start02_t_uf_net = struct("time", M(:,1), "values", M(:,35));
start02_t_uf = struct("time", M(:,1), "values", M(:,36));
start02_t_fext = struct("time", M(:,1), "values", M(:,38));
start02_t_pel = struct("time", M(:,1), "values", M(:,39));
start02_t_px = struct("time", M(:,1), "values", M(:,40));

clear M comments

INI.vsv.x = start02_x.values(1,:);
INI.reg.x = start02_t_x.values(1,:);

// Define valve vsv geometry
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
mv = 8e-5*386;
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
GEO.reg.fdyf = 2*0;
GEO.reg.fstf = 2*0;
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

mprintf('Completed %s\n', sfilename())  
