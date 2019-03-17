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
// Feb 24, 2019    DA Gutz        Created
// 
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
// INI.pr

// Initialized locally with guess
// INI.p1so
// INI.p2
// INI.px
// INI.p3
// INI.mv.x

global verbose
global INI GEO FP
//clearglobal bl_start  bl_mv bl_mvtv bl_hs bl_a_tvb
global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb
verbose = 1;
mprintf('In %s\n', sfilename())  

// Find the blocks
[bl_start, sim_start] = find_block(scs_m, 'start');
if typeof(bl_start)~="scicos_block" then
    error('start not found');
end
[bl_mv, sim_mv] = find_block(scs_m, 'mv');
if typeof(bl_mv)~="scicos_block" then
    error('mv not found');
end
[bl_mvtv, sim_mvtv] = find_block(scs_m, 'mvtv');
if typeof(bl_mvtv)~="scicos_block" then
    error('mvtv not found');
end
[bl_hs, sim_hs] = find_block(scs_m, 'hs');
if typeof(bl_hs)~="scicos_block" then
    error('hs not found');
end
[bl_a_tvb, sim_a_tvb] = find_block(scs_m, 'a_tvb');
if typeof(bl_a_tvb)~="scicos_block" then
    error('a_tvb not found');
end

// Init guess TODO:  need better logic
INI.p1so = 442.72465;
INI.p2 = 388.48432;
INI.px = 310.97791;

// solve using relaxation method
INI.x_hs = 0.007; // Todo:  need better guess logic here?
INI.x_mv = 0.0133; // Todo:  need better guess logic here
INI.wf3 = INI.wf36;
e_p1so = 0;
e_p2 = 0;
e_px = 0;
e_hs = 0;
e_mv = 0;
INI.count = 0;
while ( INI.count== 0 |..
      ((abs(e_p1so)>1e-5 |..
        abs(e_p2)>1e-5 |..
        abs(e_px)>1e-5 |..
        abs(e_hs)>1e-7 |..
        abs(e_mv)>1e-7) ..
        & INI.count<200 ))
        INI.count   = INI.count + 1;

        INI.p1so = INI.p1so + max(min(e_p1so*0.01, 2), -2);
        INI.prt = INI.p1so - 315;
        INI.p2 = INI.p2 + max(min(e_p2*0.01, 2), -2);
        INI.px = INI.px + max(min(-e_px*0.01, 2), -2);
        INI.x_hs = min(max(INI.x_hs + max(min(e_hs*0.002, 0.0004), -0.0004), GEO.hs.xmin), GEO.hs.xmax);
        INI.x_mv = min(max(INI.x_mv + max(min(e_mv*0.0002, 0.004), -0.004), GEO.mv.xmin), GEO.mv.xmax);
        
        INI.pnozin = min(130*(INI.wf3/540)^2, interp1(GEO.noz.tb(:,2), GEO.noz.tb(:,1), INI.wf3, 'linear', 'extrap'))+INI.ps3;
        INI.p3 = max(171.5*(INI.wf3/17000)^2, 40) + INI.pnozin;

        bl_start_call = callblk_valve_a(bl_start, sim_start, INI.ven_pd, 0, INI.p1so, INI.p1so, 0, INI.ven_ps, 0);
        INI.wf1v = -(bl_start_call.wfh+bl_start_call.wfvrs);              

        bl_mv_call = callblk_halfvalve_a(bl_mv, sim_mv, INI.p1so, INI.pr, INI.pr, INI.ven_ps, INI.pamb, INI.p1so, INI.p2    , INI.x_mv);
        INI.wf1mv = bl_mv_call.wfs;
        INI.wfmv = bl_mv_call.wfd;

        bl_mvtv_call = callblk_valve_a(bl_mvtv, sim_mvtv, INI.p2    , INI.p3, 0, 0, INI.prt, INI.px, 0);
        INI.wfvx = bl_mvtv_call.wfvx;
        INI.wf3 = bl_mvtv_call.wfd;

        bl_hs_call = callblk_head_b(bl_hs, sim_hs, INI.px, INI.p1so, INI.p2, INI.x_hs);
        INI.wf1s = bl_hs_call.wfh;
        INI.wfx = bl_hs_call.wff;
        INI.wf3s = bl_hs_call.wfl;
        INI.wf2s = INI.wf3s;

        bl_a_tvb_call = callblk_cor_aptow(bl_a_tvb, sim_a_tvb, GEO.a_tvb.ao, GEO.a_tvb.cd, INI.prt, INI.px);
        INI.wftvb = bl_a_tvb_call.wf;

        e_p1so = INI.wf1v - INI.wf1bias - INI.wf1mv - INI.wf1s;
        e_p2 = INI.wfmv + INI.wf2s - bl_mvtv_call.wfs;
        e_px = INI.wfx + INI.wfvx - INI.wftvb;
        e_hs = bl_hs_call.uf;
        e_mv = INI.wf36 - INI.wfmv;

        INI.x = [INI.p1so, INI.p2, INI.px, INI.x_hs, INI.x_mv];
        INI.e = [e_p1so, e_p2, e_px, e_hs, e_mv]
        mprintf('x= [%7.3f %7.3f %7.3f %9.7f %9.7f ]  ', INI.x);
        mprintf('e= [%9.7f %9.7f %9.7f %9.7f %9.7f ]\n', INI.e);
end
INI.p3s = INI.p2;
INI.wfmd = INI.wf3;
INI.vsv.x = bl_start_call.x;
INI.x_vsv = INI.vsv.x;
INI.hs.x = INI.x_hs;
INI.mv.x = INI.x_mv;
INI.mvtv.x = bl_mvtv_call.x;
INI.x_mvtv = INI.mvtv.x;
clear e_p1so e_p2 e_px e_hs e_mv
mprintf('Completed %s.   INI.count = %ld\n', sfilename(), INI.count)  
