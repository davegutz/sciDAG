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





bl_start_call = callblk_valve_a(bl_start, INI.ven_pd, 0, INI.p1so,..
                    INI.p1so, 0, INI.ven_ps, INI.vsv.x);
                    
bl_mv_call = callblk_halfvalve_a(bl_mv, INI.p1so, INI.pr, INI.pr, ..
                    INI.ven_ps, INI.pamb, INI.p1so, INI.p2, INI.mv.x);

bl_mvtv_call = callblk_valve_a(bl_mvtv, INI.p2, INI.p3, 0,..
                    0, INI.prt, INI.px, INI.mvtv.x);

bl_hs_call = callblk_head_b(bl_hs, INI.px, INI.p1so, INI.p3s, INI.hs.x);


if 0 then
bl_start.inptr(1) = INI.ven_pd;
bl_start.inptr(2) = 0;
bl_start.inptr(3) = INI.p1so;
bl_start.inptr(4) = INI.p1so;
bl_start.inptr(5) = 0;
bl_start.inptr(6) = INI.ven_ps;
bl_start.inptr(7) = 0;

bl_start.rpar(1) = FP.sg;
bl_start.rpar(2) = 1;  // LINCOS_OVERRIDE doesn't seem to do anything this mode

bl_start.x(1) = x;
bl_start.x(2) = 0;

t = 0;
bl_start = callblk(bl_start, 0, t);
bl_start = callblk(bl_start, 1, t);
bl_start = callblk(bl_start, 9, t);

blstart.sg = bl_start.rpar(1);
blstart.LINCOS_OVERRIDE = bl_start.rpar(2);
blstart.wfs = bl_start.outptr(1);
blstart.wfd = bl_start.outptr(2);
blstart.wfh = bl_start.outptr(3);
blstart.wfvrs = bl_start.outptr(4);
blstart.wfvr = bl_start.outptr(5);
blstart.wfvx = bl_start.outptr(6);
blstart.v = bl_start.outptr(7);
blstart.x = bl_start.outptr(8);
blstart.uf = bl_start.outptr(9);
blstart.mode = bl_start.outptr(10);

blstart.V = bl_start.xd(1);
blstart.A = bl_start.xd(2);

blstart.mode = bl_start.mode;

blstart.surf0 = bl_start.g(1);
blstart.surf1 = bl_start.g(2);
blstart.surf2 = bl_start.g(3);
blstart.surf3 = bl_start.g(4);
blstart.surf4 = bl_start.g(5);
end


