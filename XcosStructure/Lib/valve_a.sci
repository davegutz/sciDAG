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
exec('../Lib/table1_a.sci');

//// Default valve_a prototype **************************************
vlv_a_default = tlist(["vlv_a", "ao", "ax1", "ax2", "ax3", "ax4",..
        "c", "clin", "cd", "cdo", "cp", "fdyf", "fs", "fstf", "ks",..
        "ld", "lh", "m", "xmax", "xmin",..
         "ad", "ah"],..
         1, 0, 0, 0, 0,..
         0, 0, 0.61, 0.61, 0.69, 0, 15.8, 0, 24.4,..
         0, 0, 5, 1, -1, tbl1_a_default, tbl1_a_default);

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
             vec_tbl1_a(v.ad),  vec_tbl1_a(v.ah));
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
        model.in = [1]
        model.out = [1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx(GEO.vsv)"; string(SG); string(LINCOS_OVERRIDE); "INI.vsv.x"]
        gr_i = [];
        x = standard_define([4 2],model,exprs,gr_i)

    end
endfunction

