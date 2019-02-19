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

function [blkcall] = callblk_valve_a(blk, ps, pd, ph, prs, pr, pxr, xol)
    // Call compiled funcion VALVE_A that is scicos_block blk
    blk.inptr(1) = ps;
    blk.inptr(2) = pd;
    blk.inptr(3) = ph;
    blk.inptr(4) = prs;
    blk.inptr(5) = pr;
    blk.inptr(6) = pxr;
    blk.inptr(7) = xol;
    blkcall.ps = ps;
    blkcall.pd = pd;
    blkcall.ph = ph;
    blkcall.prs = prs;
    blkcall.pr = pr;
    blkcall.pxr = pxr;
    blkcall.xol = xol;
    blkcall.sg = blk.rpar(1);
    blkcall.LINCOS_OVERRIDE = blk.rpar(2);
    blk = callblk(blk, 0, 0);
    blk = callblk(blk, 1, 0);
    blk = callblk(blk, 9, 0);
    blkcall.wfs = blk.outptr(1);
    blkcall.wfd = blk.outptr(2);
    blkcall.wfh = blk.outptr(3);
    blkcall.wfvrs = blk.outptr(4);
    blkcall.wfvr = blk.outptr(5);
    blkcall.wfvx = blk.outptr(6);
    blkcall.v = blk.outptr(7);
    blkcall.x = blk.outptr(8);
    blkcall.uf = blk.outptr(9);
//    blkcall.mode = blk.outptr(10);
    blkcall.V = blk.xd(1);
    blkcall.A = blk.xd(2);
    blkcall.mode = blk.mode;
    blkcall.surf0 = blk.g(1);
    blkcall.surf1 = blk.g(2);
    blkcall.surf2 = blk.g(3);
    blkcall.surf3 = blk.g(4);
    blkcall.surf4 = blk.g(5);
endfunction

function [blkcall] = callblk_halfvalve_a(blk, ps, px, pr, pc, pa, pw, pd, xol)
    // Call compiled funcion HALFVALVE_A that is scicos_block blk
    blk.inptr(1) = ps;
    blk.inptr(2) = px;
    blk.inptr(3) = pr;
    blk.inptr(4) = pc;
    blk.inptr(5) = pa;
    blk.inptr(6) = pw;
    blk.inptr(7) = pd;
    blk.inptr(8) = xol;
    blkcall.ps = ps;
    blkcall.px = px;
    blkcall.pr = pr;
    blkcall.pc = pc;
    blkcall.pa = pa;
    blkcall.pw = pw;
    blkcall.pd = pd;
    blkcall.xol = xol;
    blkcall.sg = blk.rpar(1);
    blkcall.LINCOS_OVERRIDE = blk.rpar(2);
    blk = callblk(blk, 0, 0);
    blk = callblk(blk, 1, 0);
    blk = callblk(blk, 9, 0);
    blkcall.wfs = blk.outptr(1);
    blkcall.wfd = blk.outptr(2);
    blkcall.wfsr = blk.outptr(3);
    blkcall.wfwd = blk.outptr(4);
    blkcall.wfw = blk.outptr(5);
    blkcall.wfwx = blk.outptr(6);
    blkcall.wfxa = blk.outptr(7);
    blkcall.wfrc = blk.outptr(8);
    blkcall.wfx = blk.outptr(9);
    blkcall.wfa = blk.outptr(10);
    blkcall.wfc = blk.outptr(11);
    blkcall.wfr = blk.outptr(12);
    blkcall.v = blk.outptr(13);
    blkcall.x = blk.outptr(14);
    blkcall.uf = blk.outptr(15);
//    blkcall.mode = blk.outptr(16);
    blkcall.V = blk.xd(1);
    blkcall.A = blk.xd(2);
    blkcall.mode = blk.mode;
    blkcall.surf0 = blk.g(1);
    blkcall.surf1 = blk.g(2);
    blkcall.surf2 = blk.g(3);
    blkcall.surf3 = blk.g(4);
    blkcall.surf4 = blk.g(5);
endfunction

function [blkcall] = callblk_head_b(blk, pf, ph, pl, xol)
    // Call compiled funcion HEAD_B that is scicos_block blk
    blk.inptr(1) = pf;
    blk.inptr(2) = ph;
    blk.inptr(3) = pl;
    blk.inptr(4) = xol;
    blkcall.pf = pf;
    blkcall.ph = ph;
    blkcall.pl = pl;
    blkcall.xol = xol;
    blkcall.sg = blk.rpar(1);
    blkcall.LINCOS_OVERRIDE = blk.rpar(2);
    blk = callblk(blk, 0, 0);
    blk = callblk(blk, 1, 0);
    blk = callblk(blk, 9, 0);
    blkcall.wff = blk.outptr(1);
    blkcall.wfh = blk.outptr(2);
    blkcall.wfl = blk.outptr(3);
    blkcall.plx = blk.outptr(4);
    blkcall.v = blk.outptr(5);
    blkcall.x = blk.outptr(6);
    blkcall.uf = blk.outptr(7);
//    blkcall.mode = blk.outptr(8);
    blkcall.V = blk.xd(1);
    blkcall.A = blk.xd(2);
    blkcall.mode = blk.mode;
    blkcall.surf0 = blk.g(1);
    blkcall.surf1 = blk.g(2);
    blkcall.surf2 = blk.g(3);
    blkcall.surf3 = blk.g(4);
    blkcall.surf4 = blk.g(5);
endfunction

function [blkcall] = callblk_cor_aptow(blk, a, %cd, ps, pd)
    // Call compiled funcion HEAD_B that is scicos_block blk
    blk.inptr(1) = a;
    blk.inptr(2) = ps;
    blk.inptr(3) = pd;
    blkcall.a = a;
    blkcall.ps = ps;
    blkcall.pd = pd;
    blk.rpar(1) = %cd;
    blkcall.cd = %cd;
    blkcall.sg = blk.rpar(2);
    blk = callblk(blk, 0, 0);
    blkcall.wf = blk.outptr(1);
endfunction

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

INI.x = [INI.vsv.x; INI.p1so; INI.p2; INI.mvtv.x; INI.px; INI.hs.x; INI.mv.x];

INI.vsv.x = INI.x(1);
INI.p1so = INI.x(2);
INI.p2 = INI.x(3);
INI.mvtv.x = INI.x(4);
INI.px = INI.x(5);
INI.hs.x = INI.x(6);
INI.mv.x = INI.x(7);
bl_start_call = callblk_valve_a(bl_start, INI.ven_pd, 0, INI.p1so,..
                    INI.p1so, 0, INI.ven_ps, INI.vsv.x);
INI.wf1v = -(bl_start_call.wfh+bl_start_call.wfvrs);              
                    
bl_mv_call = callblk_halfvalve_a(bl_mv, INI.p1so, INI.pr, INI.pr, ..
                    INI.ven_ps, INI.pamb, INI.p1so, INI.p2, INI.mv.x);
INI.wf1mv = bl_mv_call.wfs;
INI.wfmv = bl_mv_call.wfd;

bl_mvtv_call = callblk_valve_a(bl_mvtv, INI.p2, INI.p3, 0,..
                    0, INI.prt, INI.px, INI.mvtv.x);
INI.wfvx = bl_mvtv_call.wfvx;
INI.wf3 = bl_mvtv_call.wfd;

bl_hs_call = callblk_head_b(bl_hs, INI.px, INI.p1so, INI.p2, INI.hs.x);
INI.wf1s = bl_hs_call.wfh;
INI.wfx = bl_hs_call.wff;
INI.wf3s = bl_hs_call.wfl;
INI.wf2s = INI.wf3s;

bl_a_tvb_call = callblk_cor_aptow(bl_a_tvb, GEO.a_tvb.ao, GEO.a_tvb.cd, INI.prt, INI.px);
INI.wftvb = bl_a_tvb_call.wf;

e_start = bl_start_call.uf/10;
e_p1so = (INI.wf1v - INI.wf1bias - INI.wf1mv - INI.wf1s)/INI.wf36;
e_p2 = (INI.wfmv + INI.wf2s - bl_mvtv_call.wfs)/INI.wf36;
e_mvtv = bl_mvtv_call.uf/10;
e_px = (INI.wfx + INI.wfvx - INI.wftvb)/100;
e_hs = bl_hs_call.uf/10;
e_p3 = (INI.wf3 - INI.wf36)/INI.wf36;
INI.e = [e_start; e_p1so; e_p2; e_mvtv; e_px; e_hs; e_p3];
