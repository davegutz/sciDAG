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
// INI.wf36
// INI.ps3
// INI.ven_ps
// INI.ven_pd
// INI.pamb
// INI.wf1bias
// INI.prt
// INI.pr

global verbose
global INI GEO FP
global W E X PSO
clearglobal bl_start  bl_mv bl_mvtv bl_hs bl_a_tvb
global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb
verbose = 1;

// Explicitly calculated parameters
INI.pnozin = min(130*(INI.wf36/540)^2, interp1(GEO.noz.tb(:,2), GEO.noz.tb(:,1), INI.wf36, 'linear', 'extrap'))+INI.ps3;
//INI.p3 = 59.4582;
INI.p3 = max(171.5*(INI.wf36/17000)^2, 40) + INI.pnozin;
INI.wfmd = INI.wf36;
INI.wf3s = 0;
W.start = 0.1;
W.p1so = 1/INI.wf36;
W.p2 = 1/INI.wf36;
W.mvtv = 0.1;
W.px = 1/100;
W.hs = 0.1;
W.p3 = 1/INI.wf36;

exec('./Callbacks/ObjFcn_start04selfinit.sci', -1);
exec('./Callbacks/OutFcn_start04selfinit.sci', -1);
exec('./Callbacks/OutFcn_start04selfinit.sci', -1);

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

// First guess use init file
INI.x = [INI.vsv.x, INI.p1so, INI.p2, INI.mvtv.x, INI.px, INI.hs.x, INI.mv.x];

obj_score = ObjFcn_start04selfinit(INI.x);

PSO.wmax = 0.9; PSO.wmin = 0.4;
PSO.itmax = 10;
PSO.c1 = 0.7; PSO.c2 = 1.47;
PSO.N = 50; PSO.D = 7;
PSO.launchp = 0.9;
PSO.speedf = [2.0000000000000000 2.0000000000000000 2.0000000000000000 2.0000000000000000 2.0000000000000000 2.0000000000000000 2.0000000000000000];
PSO.verbose = 1;
PSO.boundsmax = [50.000000000000000;0.25000000000000000;0.050000000000000010;0.25000000000000000;0.050000000000000010;0.25000000000000000;0.25000000000000000];
PSO.boundsmin = [25.000000000000000;0.00000000000000000;0.0080000000000000002;0.00000000000000000;0.0080000000000000002;0.00000000000000000;0.12500000000000000];
PSO.radius = [32.000000000000000 0.010000000000000000 0.010000000000000000 0.010000000000000000 0.010000000000000000 0.010000000000000000 0.010000000000000000];
PSO.n_radius = 8; PSO.n_stuck = 10;
PSO.weights = [0.90000000000000002;0.40000000000000002];
PSO.c = [0.69999999999999996;1.4700000000000000];
PSO.x0 = INI.x;

        // PSO inputs
        speed_max = 0.1*PSO.boundsmax;
        speed_min = 0.1*PSO.boundsmin;
        X.speed = [speed_min, speed_max];
        grand('setsd', 0); // must initialize random generator.  Want same result on repeated runs.

X.obj_function = 'ObjFcn_start04selfinit';
        [fopt, xopt, iopt] = myPSO_bsg_starcraft_rad(evstr(X.obj_function),.. 
           [PSO.boundsmin, PSO.boundsmax],..
            X.speed, PSO.itmax, PSO.N,..
            PSO.weights, PSO.c, PSO.launchp, PSO.speedf,..
            PSO.N,.. 
            PSO.radius, PSO.n_radius,..
            OutFcn_start04selfinit, PSO.x0,..
            PSO.n_stuck);
            PSO.iters = PSO.iters + 1;
            evstr(outputfun_str + '(PSO.iters, fopt, xopt)');
