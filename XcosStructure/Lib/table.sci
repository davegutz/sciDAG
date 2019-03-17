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
// Jan 7, 2019     DA Gutz     Created
//
// interfacing function for 1-D linear interpolation block with clipping

// Default table prototype ****************************************
function [ts] = xz_string(t)
    ts = msprintf('[');
    [nad, %mad] = size(t);
    for i = 1:nad,
        ts = ts + msprintf('%f, %f', t(i,1:2));
        if i<nad,
            ts = ts + msprintf(';');
        end
    end
    ts = ts + msprintf(']');
endfunction

tbl1_b_default = tlist(["tbl1_b", "tb"], [-1, -10; 1, 10; 2, 20;]);
ctab1_default = tlist(["ctab1", "tb", "sx", "dx", "sz", "dz"], [-1, -10; 1, 10; 2, 20;], 1, 0, 1, 0);


function [ts] = %tbl1_b_string(t)
    // Start
    ts = msprintf('list(');
    // Table
    ts = ts + xz_string(t.tb);
    // Scalars
    // End
    ts = ts + msprintf(')');
endfunction

function [ts] = %ctab1_string(t)
    // Table string overload
    ts = msprintf('''%s'' type:  ', typeof(t));
    ts = ts + 'tb=' + xz_string(t.tb);
    ts = ts + msprintf(', sx=%f, dx=%f, sz=%f, dz=%f', t.sx, t.dx, t.sz, t.dz);
endfunction


function lis = lsx_ctab1(t)
    tbx = (t.tb(:,1)-t.dx)/t.sx;
    tbz = t.tb(:,2)*t.sz+t.dz;
    lis = list(t.tb, t.sx, t.dx, t.sz, t.dz);
endfunction

function vec = vec_ctab1(t)
    tbx = (t.tb(:,1)-t.dx)/t.sx;
    tbz = t.tb(:,2)*t.sz+t.dz;
    vec = [tbx tbz];
endfunction

function str = %tbl1_b_p(t)
    // Display table1 type
    str = string(t);
    disp(str)
endfunction

function str = %ctab1_p(t)
    // Display ctab1 type
    str = string(t);
    disp(str)
endfunction

// Callbacks ******************************************** 
function [x,y,typ] = CTAB1(job, arg1, arg2)
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
            [ok,TB,exprs] = getvalue('Set prototype table1 parameters',..
            ['lsx_ctab1(ctab1_default)'],..
            list('lis',-1),..
            exprs)
            if ~ok then break,end 
            model.opar = TB
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end
    case 'define' then
//        message('in define')
        model.opar=list(ctab1_default);
        model = scicos_model()
        model.sim = list('ctab1', 4)
        model.in = [1]
        model.out = [1]
        model.state = [0]
        model.dstate = [0]
        model.blocktype = 'c'
        model.nmode = 0
        model.nzcross = 0
        model.dep_ut = [%t %f] // [direct feedthrough,   time dependence]
        exprs = ["lsx_ctab1(ctab1_default)"]
        gr_i = [];
        x = standard_define([4 2],model,exprs,gr_i)  // size icon wxh, etc..
    end
endfunction

