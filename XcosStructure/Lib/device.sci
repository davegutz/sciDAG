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
// Jan 27, 2019    DA Gutz        Created


//// Default valve_a prototype **************************************
head_b_default = tlist(["hd_b", "ae", "ao", "c", "cdo", "fb", "fdyf", "fs", "fstf",..
        "kb", "ks", "m", "xmax", "xmin"],..
         0, 0, 0, 0, 0, 0, 0, 0,..
         0, 0, 0, 1, -1);

function [hs] = %head_b_string(h)
    // Cast head type to string
    hs = msprintf('list(');

    // Scalars
    hs = hs + msprintf('%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,',..
             h.ae, h.ao, h.c, h.cdo, h.fb, h.fdyf, h.fs, h.fstf,..
             h.kb, h.ks, h.m, h.xmax, h.xmin);

    // Tables
    
    // end
    hs = hs + msprintf(')');
endfunction

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx(h)
    lis = list(h.ae, h.ao, h.c, h.cdo, h.fb, h.fdyf, h.fs, h.fstf,..
             h.kb, h.ks, h.m, h.xmax, h.xmin);
endfunction

function str = %hd_b_p(h)
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
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set prototype valve parameters',..
            ['lsx(head_b)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
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
        model.in = [1;1;1;1;1]
        model.out = [1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx(GEO.hs)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.hs.x"]
        gr_i = [];
        x = standard_define([12 18],model,exprs,gr_i)  // size icon, etc..
    end
endfunction
