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
// Feb 20, 2019    DA Gutz        Created
// 
// Be sure to install PSO toolbox using Applications - Module Manager - Optimization

// Inputs:
// INI.p1so
// INI.p2
// INI.px
// INI.p3
// INI.mv.x
// INI.ven_ps
// INI.ven_pd
// INI.pamb
// INI.wf1bias
// INI.prt
// INI.pr
global verbose
global INI GEO FP
clearglobal W E X PSO
global W E X PSO
clearglobal bl_start  bl_mv bl_mvtv bl_hs bl_a_tvb
global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb
verbose = 1;

// Explicitly calculated parameters
//INI.pnozin = min(130*(INI.wf36/540)^2, interp1(GEO.noz.tb(:,2), GEO.noz.tb(:,1), INI.wf36, 'linear', 'extrap'))+INI.ps3;
////INI.p3 = 59.4582;
//INI.p3 = max(171.5*(INI.wf36/17000)^2, 40) + INI.pnozin;
INI.wfmd = INI.wf36;
INI.wf3s = 0;
W.start = 0.1;
W.p1so = 1/INI.wf36;
W.p2 = 1/INI.wf36;
W.mvtv = 0.1;
W.px = 1/100;
W.hs = 0.1;
W.p3 = 1/INI.wf36;


// Find the blocks
bl_start = find_block(scs_m, 'start');
if typeof(bl_start)~="scicos_block" then
    error('start not found');
end
bl_mv = find_block(scs_m, 'mv');
if typeof(bl_mv)~="scicos_block" then
    error('mv not found');
end
bl_mvtv = find_block(scs_m, 'mvtv');
if typeof(bl_mvtv)~="scicos_block" then
    error('mvtv not found');
end
bl_hs = find_block(scs_m, 'hs');
if typeof(bl_hs)~="scicos_block" then
    error('hs not found');
end
bl_a_tvb = find_block(scs_m, 'a_tvb');
if typeof(bl_a_tvb)~="scicos_block" then
    error('a_tvb not found');
end

if 1,  // solve using relaxation method
//p2 = INI.p2;
//p3 = INI.p3;
//px = INI.px;
INI.x_hs = INI.hs.x;
INI.x_mv = INI.mv.x;
//INI.x_mv = 0;
e_p1so = 0;
e_p2 = 0;
e_px = 0;
e_hs = 0;
e_mv = 0;
count = 0;
INI.wfmd = INI.wf36;
while ( count== 0 |..
      ((abs(e_p1so)>1e-16 |..
        abs(e_p2)>1e-20 |..
        abs(e_px)>1e-20 |..
        abs(e_hs)>1e-20 |..
        abs(e_mv)>1e-20) ..
        & count<1 ))
        count   = count + 1;

        INI.pnozin = min(130*(INI.wfmd/540)^2, interp1(GEO.noz.tb(:,2), GEO.noz.tb(:,1), INI.wfmd, 'linear', 'extrap'))+INI.ps3;
        INI.p3 = max(171.5*(INI.wfmd/17000)^2, 40) + INI.pnozin;


        INI.p1so = INI.p1so + max(min(e_p1so*0.1, 10), -10);
        INI.p2 = INI.p2     + max(min(e_p2*0.1, 10), -10);
        INI.px = INI.px + max(min(-e_px*0.1, 10), -10);
        INI.x_hs = min(max(INI.x_hs + max(min(e_hs/1000, 0.0002), -0.0002), GEO.hs.xmin), GEO.hs.xmax);
        INI.x_mv = INI.x_mv + max(min(e_mv/10000, 0.002), -0.002);
        
        bl_start_call = callblk_valve_a(bl_start, INI.ven_pd, 0, INI.p1so, INI.p1so, 0, INI.ven_ps, 0); // last arg ignored
        INI.vsv.x = bl_start_call.x;
        x_vsv = INI.vsv.x;
        INI.wf1v = -(bl_start_call.wfh+bl_start_call.wfvrs);              

        bl_mv_call = callblk_halfvalve_a(bl_mv, INI.p1so, INI.pr, INI.pr, INI.ven_ps, INI.pamb, INI.p1so, INI.p2    , INI.x_mv);
        wf1mv = bl_mv_call.wfs;
        INI.wfmv = bl_mv_call.wfd;

        bl_mvtv_call = callblk_valve_a(bl_mvtv, INI.p2    , INI.p3, 0, 0, INI.prt, INI.px, 0); // last arg ignored
        INI.x_mvtv = bl_mvtv_call.x;
        INI.wfvx = bl_mvtv_call.wfvx;
        wf3 = bl_mvtv_call.wfd;

        bl_hs_call = callblk_head_b(bl_hs, INI.px, INI.p1so, INI.p2    , INI.x_hs);
        INI.wf1s = bl_hs_call.wfh;
        INI.wfx = bl_hs_call.wff;
        INI.wf3s = bl_hs_call.wfl;
        INI.wf2s = INI.wf3s;

        bl_a_tvb_call = callblk_cor_aptow(bl_a_tvb, GEO.a_tvb.ao,..
        GEO.a_tvb.cd, INI.prt, INI.px);
        INI.wftvb = bl_a_tvb_call.wf;

        e_p1so = INI.wf1v - INI.wf1bias - wf1mv - INI.wf1s;
        e_p2 = INI.wfmv + INI.wf2s - bl_mvtv_call.wfs;
        e_px = INI.wfx + INI.wfvx - INI.wftvb;
        e_hs = bl_hs_call.uf;
        e_mv = INI.wf36 - INI.wfmv;

        INI.x = [INI.p1so, INI.p2    , INI.px, INI.x_hs, INI.x_mv];
        INI.e = [e_p1so, e_p2, e_px, e_hs, e_mv]
        mprintf('x= [%5.1f %5.1f %5.1f %6.4f %6.4f ]  ', INI.x);
        mprintf('e= [%6.4f %6.4f %6.4f %6.4f %6.4f ]\n', INI.e);
end
//INI.wf1s = wf1s;
//INI.wfx = wfx;
//INI.wfvx = wfvx;
//INI.wftvb = wftvb;
//INI.wf3s = wf3s;
//INI.wf2s = wf2s;
//INI.wfmv = wfmv;
INI.wf1mv = INI.wfmv;
INI.x_vsv = INI.vsv.x;
INI.wf3 = bl_mvtv_call.wfd;
//INI.wf1v = wf1v;
//INI.hs.x = x_hs;
//INI.mv.x = x_mv;
//INI.mvtv.x = x_mvtv;
//INI.p1so = p1so;
//INI.p2 = p2;
//INI.px = px;

// solve using PSO
else
exec('./Callbacks/ObjFcn_start04selfinit.sci', -1);
exec('./Callbacks/OutFcn_start04selfinit.sci', -1);
outputfun_str = 'OutFcn_start04selfinit';
// First guess use init file
INI.x = [INI.vsv.x, INI.p1so, INI.p2, INI.mvtv.x, INI.px, INI.hs.x, INI.mv.x];
obj_score = ObjFcn_start04selfinit(INI.x);
X.obj_function = 'ObjFcn_start04selfinit';
PSO.iters = 0;
evstr(outputfun_str + '(PSO.iters, obj_score, INI.x)')
 
PSO.wmax = 0.9; PSO.wmin = 0.4;
PSO.itmax = 200;
PSO.c1 = 2; PSO.c2 = 2;
PSO.N = 20; PSO.D = 7;
PSO.launchp = 0.9;
//PSO.speedf = 2*ones(1, PSO.D); 
PSO.speedf = [.01 1 1 .01 1 .01 .01];
PSO.verbose = 1;
PSO.x0 = INI.x;
dx = 0.05; dp = 100;
PSO.boundsmax = [GEO.vsv.xmax INI.ven_pd INI.ven_pd GEO.mvtv.xmax INI.ven_pd GEO.hs.xmax INI.mv.x+dx]';
PSO.boundsmin = [GEO.vsv.xmin INI.ven_ps INI.ven_ps GEO.mvtv.xmin INI.ven_ps GEO.hs.xmin INI.mv.x-dx]';
PSO.weights = [0.9; 0.4];
PSO.c = [0.7; 1.47];

// PSO inputs
//speed_min = 0.1*PSO.boundsmin;
speed_max = 1*(PSO.boundsmax-PSO.boundsmin);
speed_min = -speed_max;
X.speed = [speed_min, speed_max];
grand('setsd', 0); // must initialize random generator.  Want same result on repeated runs.

//[fopt, xopt, iopt] = myPSO_bsg_starcraft_rad(evstr(X.obj_function),.. 
//           [PSO.boundsmin, PSO.boundsmax],..
//            X.speed, PSO.itmax, PSO.N,..
//            PSO.weights, PSO.c, PSO.launchp, PSO.speedf,..
//            PSO.N,.. 
//            PSO.radius, PSO.n_radius,..
//            OutFcn_start04selfinit, PSO.x0,..
//            PSO.n_stuck);
[fopt, xopt] = myPSO_bsg_starcraft(evstr(X.obj_function),.. 
           [PSO.boundsmin, PSO.boundsmax],..
            X.speed, PSO.itmax, PSO.N,..
            PSO.weights, PSO.c, PSO.launchp, PSO.speedf,..
            PSO.N, OutFcn_start04selfinit,.. 
            PSO.x0);
            
PSO.iters = PSO.iters + 1;
evstr(outputfun_str + '(PSO.iters, fopt, xopt)');
end
