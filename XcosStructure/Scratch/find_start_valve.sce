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
// Feb 17, 2019    DA Gutz        Created
// 



clear bl_start
bl_start = find_block(scs_m, 'start');
if typeof(bl_start)~="scicos_block" then
    error('start not found');
end
clear bl_mv
bl_mv = find_block(scs_m, 'mv');
if typeof(bl_mv)~="scicos_block" then
    error('mv not found');
end
clear bl_mvtv
bl_mvtv = find_block(scs_m, 'mvtv');
if typeof(bl_mvtv)~="scicos_block" then
    error('mvtv not found');
end
clear bl_hs
bl_hs = find_block(scs_m, 'hs');
if typeof(bl_hs)~="scicos_block" then
    error('hs not found');
end
clear bl_a_tvb
bl_a_tvb = find_block(scs_m, 'a_tvb');
if typeof(bl_a_tvb)~="scicos_block" then
    error('a_tvb not found');
end

// First guess use init file
INI.x = [INI.vsv.x; INI.p1so; INI.p2; INI.mvtv.x; INI.px; INI.hs.x; INI.mv.x];


obj_score = ObjFcn_start04selfinit(INI.x)


//bl_start_call = callblk_valve_a(bl_start, INI.ven_pd, 0, INI.p1so,..
//                    INI.p1so, 0, INI.ven_ps, INI.vsv.x);
//INI.wf1v = -(bl_start_call.wfh+bl_start_call.wfvrs);              
//                    
//bl_mv_call = callblk_halfvalve_a(bl_mv, INI.p1so, INI.pr, INI.pr, ..
//                    INI.ven_ps, INI.pamb, INI.p1so, INI.p2, INI.mv.x);
//INI.wf1mv = bl_mv_call.wfs;
//INI.wfmv = bl_mv_call.wfd;
//
//bl_mvtv_call = callblk_valve_a(bl_mvtv, INI.p2, INI.p3, 0,..
//                    0, INI.prt, INI.px, INI.mvtv.x);
//INI.wfvx = bl_mvtv_call.wfvx;
//INI.wf3 = bl_mvtv_call.wfd;
//
//bl_hs_call = callblk_head_b(bl_hs, INI.px, INI.p1so, INI.p2, INI.hs.x);
//INI.wf1s = bl_hs_call.wfh;
//INI.wfx = bl_hs_call.wff;
//INI.wf3s = bl_hs_call.wfl;
//INI.wf2s = INI.wf3s;
//
//bl_a_tvb_call = callblk_cor_aptow(bl_a_tvb, GEO.a_tvb.ao, GEO.a_tvb.cd, INI.prt, INI.px);
//INI.wftvb = bl_a_tvb_call.wf;
//
//e_start = bl_start_call.uf/10;
//e_p1so = (INI.wf1v - INI.wf1bias - INI.wf1mv - INI.wf1s)/INI.wf36;
//e_p2 = (INI.wfmv + INI.wf2s - bl_mvtv_call.wfs)/INI.wf36;
//e_mvtv = bl_mvtv_call.uf/10;
//e_px = (INI.wfx + INI.wfvx - INI.wftvb)/100;
//e_hs = bl_hs_call.uf/10;
//e_p3 = (INI.wf3 - INI.wf36)/INI.wf36;
//INI.e = [e_start; e_p1so; e_p2; e_mvtv; e_px; e_hs; e_p3];
//
