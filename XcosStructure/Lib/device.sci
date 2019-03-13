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
// Mar 10, 2019    DA Gutz        Created
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
// Jan 27, 2019     DA Gutz     Created
// Mar 10, 2019     DA Gutz     Add actuator_a_b


//// Default head_b prototype *****************************************
head_b_default = tlist(["hdb", "f_an", "f_cn", "f_dn", "f_ln",..
        "ae", "ao", "c", "cdo", "fb", "fdyf", "fs", "fstf",..
        "kb", "ks", "m", "xmax", "xmin"],..
         0, 0, 0, 0, 0,..
         0, 0, 0, 0, 0, 0, 0, 0,..
         0, 0, 0, 1, -1);

function [hs] = %hdb_string(h)
    // Cast head type to string
    hs = msprintf('list(');

    // Scalars
    hs = hs + msprintf('%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,',..
             h.f_an, h.f_cn, h.f_dn, h.f_ln,..
             h.ae, h.ao, h.c, h.cdo, h.fb, h.fdyf, h.fs, h.fstf,..
             h.kb, h.ks, h.m, h.xmax, h.xmin);

    // Tables
    
    // end
    hs = hs + msprintf(')');
endfunction

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx_hdb(h)
    lis = list(h.f_an, h.f_cn, h.f_dn, h.f_ln,..
             h.ae, h.ao, h.c, h.cdo, h.fb, h.fdyf, h.fs, h.fstf,..
             h.kb, h.ks, h.m, h.xmax, h.xmin);
endfunction

function str = %hdb_p(h)
    // Display valve type
    str = string(h);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = HEAD_B(job, arg1, arg2)
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
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set head_b parameters',..
            ['lsx_hdb(head_b)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
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
        model.opar=list(head_b_default);
        SG = 0.8
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('head_b', 4)
        model.in = [1;1;1;1]
        model.out = [1;1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx_hdb(GEO.hs)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.hs.x"]
        gr_i = [];
        x = standard_define([12 18],model,exprs,gr_i)  // size icon, etc..
    end
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
//    blk = callblk(blk, 0, 0);
//    blk = callblk(blk, 1, 0);
//    blk = callblk(blk, 9, 0);
    blk = callblk(blk, -1, 0);
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
//////////********** end head_b ***************************************






//// Default actuator_a_b prototype ***********************************
actuator_a_b_default = tlist(["aab", "ab", "ah", "ahl", "ar", "arl",..
        "c_", "cd_", "fdyf", "fstf",..
        "mact", "mext", "xmax", "xmin"],..
         0, 0, 0, 0, 0,..
         0, 0, 0, 0,..
         0, 0, 1, -1);

function [act] = %aab_string(a)
    // Cast head type to string
    act = msprintf('list(');

    // Scalars
    act = act + msprintf('%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f',..
             a.ab, a.ah, a.ahl, a.ar, a.arl,..
             a.c_, a.cd_, a.fdyf, a.fstf,..
             a.mact, a.mext, a.xmax, a.xmin);

    // Tables
    
    // end
    act = act + msprintf(')');
endfunction

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx_aab(a)
    lis = list(a.ab, a.ah, a.ahl, a.ar, a.arl,..
             a.c_, a.cd_, a.fdyf, a.fstf,..
             a.mact, a.mext, a.xmax, a.xmin);
endfunction

function str = %aab_p(a)
    // Display valve type
    str = string(a);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = ACTUATOR_A_B(job, arg1, arg2)
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
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set actuator_a_b parameters',..
            ['lsx_aab(actuator_a_b)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
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
        model.opar=list(actuator_a_b_default);
        SG = 0.8
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('actuator_a_b', 4)
        model.in = [1;1;1;1;1;1]
        model.out = [1;1;1;1;1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx_aab(GEO.pact)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.pact.x"]
        gr_i = [];
        x = standard_define([12 18],model,exprs,gr_i)  // size icon, etc..
    end
endfunction

function [blkcall] = callblk_actuator_a_b(blk, ph, pl, pr, per, fext, xol)
    // Call compiled funcion ACTUATOR_A_B that is scicos_block blk
    blk.inptr(1) = ph;
    blk.inptr(2) = pl;
    blk.inptr(3) = pr;
    blk.inptr(4) = per;
    blk.inptr(5) = fext;
    blk.inptr(6) = xol;
    blkcall.ph = ph;
    blkcall.pl = pl;
    blkcall.pr = pr;
    blkcall.per = per;
    blkcall.fextr = fext;
    blkcall.xol = xol;
    blkcall.sg = blk.rpar(1);
    blkcall.LINCOS_OVERRIDE = blk.rpar(2);
//    blk = callblk(blk, 0, 0);
//    blk = callblk(blk, 1, 0);
//    blk = callblk(blk, 9, 0);
    blk = callblk(blk, -1, 0);
    blkcall.wfb = blk.outptr(1);
    blkcall.wfh = blk.outptr(2);
    blkcall.wfhl = blk.outptr(3);
    blkcall.wfr = blk.outptr(4);
    blkcall.wfrl = blk.outptr(5);
    blkcall.wfve = blk.outptr(6);
    blkcall.v = blk.outptr(7);
    blkcall.x = blk.outptr(8);
    blkcall.uf = blk.outptr(9);
    blkcall.uf_net = blk.outptr(10);
//    blkcall.mode = blk.outptr(11);
    blkcall.V = blk.xd(1);
    blkcall.A = blk.xd(2);
    blkcall.mode = blk.mode;
    blkcall.surf0 = blk.g(1);
    blkcall.surf1 = blk.g(2);
    blkcall.surf2 = blk.g(3);
    blkcall.surf3 = blk.g(4);
    blkcall.surf4 = blk.g(5);
endfunction
