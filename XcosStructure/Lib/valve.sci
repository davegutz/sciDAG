// Copyright (C) 2018 - Dave Gutz
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
// Jan 2, 2019    DA Gutz        Created
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
// Jan 1, 2019     DA Gutz     Created
//
// interfacing function for friction block

// Default table1_a 
exec('../Lib/table.sci');

//// Default valve_a prototype **************************************
vlv_a_default = tlist(["vlv_a", "ao", "ax1", "ax2", "ax3", "ax4",..
        "c", "clin", "cd", "cdo", "cp", "fdyf", "fs", "fstf", "ks",..
        "ld", "lh", "m", "xmax", "xmin",..
         "ad", "ah"],..
         1, 0, 0, 0, 0,..
         0, 0, 0.61, 0.61, 0.69, 0, 15.8, 0, 24.4,..
         0, 0, 5, 1, -1,..
         ctab1_default, ctab1_default);

function [vs] = %vlv_a_string(v)
    // Cast valve type to string
    vs = msprintf('list(');

    // Scalars
    vs = vs + msprintf('%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,',..
             v.ao, v.ax1, v.ax2, v.ax3, v.ax4,..
             v.c, v.clin, v.cd, v.cdo, v.cp, v.fdyf, v.fs, v.fstf, v.ks,..
             v.ld, v.lh, v.m, v.xmax, v.xmin);

    // Tables
    vs = vs + string(v.ad) + ',';
    vs = vs + string(v.ah);
    
    // end
    vs = vs + msprintf(')');
endfunction

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx(v)
    lis = list(v.ao, v.ax1, v.ax2, v.ax3, v.ax4,..
             v.c, v.clin, v.cd, v.cdo, v.cp, v.fdyf, v.fs, v.fstf, v.ks,..
             v.ld, v.lh, v.m, v.xmax, v.xmin,..
             vec_ctab1(v.ad),  vec_ctab1(v.ah));
endfunction

function str = %vlv_a_p(v)
    // Display valve type
    str = string(v);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = VALVE_A(job, arg1, arg2)
    x = [];
    y = [];
    typ = [];
    //disp(job)
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then
        [x,y,typ] = standard_inputs(arg1)
        //disp(sci2exp(x))
    case 'getoutputs' then
        [x,y,typ] = standard_outputs(arg1)
        //disp(sci2exp(x))
    case 'getorigin' then
        [x,y] = standard_origin(arg1)
        //disp(sci2exp(x))
    case 'set' then
        //message(sci2exp(arg1))
        x = arg1
        graphics = arg1.graphics
        exprs = graphics.exprs
        model = arg1.model
        while %t do
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set prototype valve parameters',..
            ['lsx(vlv_a)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
            list('lis',-1,'vec',1,'vec',1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [Xinit; 0]
            model.rpar = [SG;LINCOS_OVERRIDE]
            model.opar = GEO
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end
    case 'define' then
//        message('in define')
        model.opar=list(vlv_a_default);
        SG = 0.8
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('valve_a', 4)
        model.in = [1;1;1;1;1;1;1]
        model.out = [1;1;1;1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx(GEO.vsv)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.vsv.x"]
        gr_i = [];
        x = standard_define([12 18],model,exprs,gr_i)  // size icon, etc..
    end
endfunction

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

//// Default three-way valve_a prototype **************************************
tv_a1_default = tlist(["tv_a1", "adl", "ahd", "ahs", "ald", "ale",..
        "alr", "ar", "asl", "c", "cd", "cp", "fdyf", "fs", "fstf", "ks",..
        "ld", "ls", "m", "xmax", "xmin",..
         "ad", "as"],..
         1, 0, 0, 0, 0,..
         0, 0, 0, 0, 0.61, 0.69, 0, 15.8, 0, 24.4,..
         0, 0, 5, 1, -1,..
         ctab1_default, ctab1_default);

function [vs] = %tv_a1_string(v)
    // Cast trivalve type to string
    vs = msprintf('list(');

    // Scalars
    vs = vs + msprintf('%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,',..
             v.adl, v.ahd, v.ahs, v.ald, v.ale,..
             v.alr, v.ar, v.asl, v.c, v.cd, v.cp, v.fdyf, v.fs, v.fstf, v.ks,..
             v.ld, v.ls, v.m, v.xmax, v.xmin);

    // Tables
    vs = vs + string(v.ad) + ',';
    vs = vs + string(v.as);
    
    // end
    vs = vs + msprintf(')');
endfunction

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx_tva1(v)
    lis = list(v.adl, v.ahd, v.ahs, v.ald, v.ale,..
             v.alr, v.ar, v.asl, v.c, v.cd, v.cp, v.fdyf, v.fs, v.fstf, v.ks,..
             v.ld, v.ls, v.m, v.xmax, v.xmin,..
             vec_ctab1(v.ad),  vec_ctab1(v.as));
endfunction

function str = %tv_a1_p(v)
    // Display valve type
    str = string(v);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = TRIVALVE_A1(job, arg1, arg2)
    x = [];
    y = [];
    typ = [];
    //disp(job)
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then
        [x,y,typ] = standard_inputs(arg1)
        //disp(sci2exp(x))
    case 'getoutputs' then
        [x,y,typ] = standard_outputs(arg1)
        //disp(sci2exp(x))
    case 'getorigin' then
        [x,y] = standard_origin(arg1)
        //disp(sci2exp(x))
    case 'set' then
        //message(sci2exp(arg1))
        x = arg1
        graphics = arg1.graphics
        exprs = graphics.exprs
        model = arg1.model
        while %t do
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set prototype trivalve parameters',..
            ['lsx_tva1(tv_a1)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
            list('lis',-1,'vec',1,'vec',1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [Xinit; 0]
            model.rpar = [SG;LINCOS_OVERRIDE]
            model.opar = GEO
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end
    case 'define' then
//        message('in define')
        model.opar=list(tv_a1_default);
        SG = 0.8
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('trivalve_a1', 4)
        model.in  = [1;1;1;1;1;1;1;1;1;1]
        model.out = [1;1;1;1;1;1;1;1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx_tva1(GEO.reg)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.reg.x"]
        gr_i = [];
        x = standard_define([16 22],model,exprs,gr_i)  // size icon [h v], etc..
    end
endfunction

//// Default half-area valve_a prototype **************************************
hlfvlv_a_default = tlist(["hlfvlv_a", "arc", "arx", "asr", "awd", "awx",..
        "ax1", "ax2", "ax3", "axa", "c", "cd", "cp", "fdyf", "fstf",..
        "m", "xmax", "xmin",..
         "at"],..
         0, 0, 0, 0, 0,..
         0, 0, 0, 0, 0, 0.61, 0, 0, 0,..
         0, 1, -1,..
         ctab1_default);

function [vs] = %hlfvlv_a_string(v)
    // Cast half-area valve type to string
    vs = msprintf('list(');

    // Scalars
    vs = vs + msprintf('%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,',..
             v.arc, v.arx, v.asr, v.awd, v.awx,..
             v.ax1, v.ax2, v.ax3, v.axa, v.c, v.cd, v.cp, v.fdyf, v.fstf,..
             v.m, v.xmax, v.xmin);

    // Tables
    vs = vs + string(v.at);
    
    // end
    vs = vs + msprintf(')');
endfunction

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx_hva1(v)
    lis = list(v.arc, v.arx, v.asr, v.awd, v.awx,..
             v.ax1, v.ax2, v.ax3, v.axa, v.c, v.cd, v.cp, v.fdyf, v.fstf,..
             v.m, v.xmax, v.xmin,..
             vec_ctab1(v.at));
endfunction

function str = %hlfvlv_a_p(v)
    // Display half-area valve type
    str = string(v);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = HLFVALVE_A(job, arg1, arg2)
    x = [];
    y = [];
    typ = [];
    //disp(job)
    select job
    case 'plot' then
        standard_draw(arg1)
    case 'getinputs' then
        [x,y,typ] = standard_inputs(arg1)
        //disp(sci2exp(x))
    case 'getoutputs' then
        [x,y,typ] = standard_outputs(arg1)
        //disp(sci2exp(x))
    case 'getorigin' then
        [x,y] = standard_origin(arg1)
        //disp(sci2exp(x))
    case 'set' then
        //message(sci2exp(arg1))
        x = arg1
        graphics = arg1.graphics
        exprs = graphics.exprs
        model = arg1.model
        while %t do
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set prototype hlfvalve parameters',..
            ['lsx_hva1(hlfvlv_a)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
            list('lis',-1,'vec',1,'vec',1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [Xinit; 0]
            model.rpar = [SG;LINCOS_OVERRIDE]
            model.opar = GEO
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end
    case 'define' then
//        message('in define')
        model.opar=list(hlfvlv_a_default);
        SG = 0.8
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('hlfvalve_a', 4)
        model.in  = [1;1;1;1;1;1;1;1]
        model.out = [1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx_hva1(GEO.mv)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.mv.x"]
        gr_i = [];
        x = standard_define([16 26],model,exprs,gr_i)  // size icon [h v], etc..
    end
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
