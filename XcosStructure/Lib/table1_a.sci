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
//xz_a_default = tlist(["xz_a", "xz"], [-1, 0, 10; 0, 0, 10]);
//function [ts] = %xz_a_string(t)
//    ts = msprintf('[');
//    [nad, %mad] = size(t.xz);
//    for i = 1:nad,
//        for j = 1:%mad,
//            ts = ts + msprintf('%f', t.xz(i,j));
//            if j<%mad,
//                ts = ts + msprintf(',');
//            elseif i<nad,
//                ts = ts + msprintf(';');
//            end
//        end
//    end
//    ts = ts + msprintf(']');
//endfunction
//function lis = lsx_xz(t)
//    lis = list(t.xz);
//endfunction

function [ts] = xz_string(t)
    ts = msprintf('[');
    [nad, %mad] = size(t);
    for i = 1:nad,
        for j = 1:%mad,
            ts = ts + msprintf('%f', t(i,j));
            if j<%mad,
                ts = ts + msprintf(',');
            elseif i<nad,
                ts = ts + msprintf(';');
            end
        end
    end
    ts = ts + msprintf(']');
endfunction

tbl1_a_default = tlist(["tbl1_a", "tb", "sx", "dx", "sz", "dz"], [-1, 0, 10; 0, 0, 10], 1, 0, 1, 0);
function [ts] = %tbl1_a_string(t)
    // Start
    ts = msprintf('list(');

    // Table
    ts = ts + xz_string(t.tb);

    // Scalars
    ts = ts + msprintf(',%f,%f,%f,%f,', t.sx, t.dx, t.sz, t.dz);
    
    // End
    ts = ts + msprintf(')');
endfunction


function lis = lsx_tbl1_a(t)
    lis = list(t.tb, t.sx, t.dx, t.sz, t.dz);
endfunction

function str = %tbl1_a_p(t)
    // Display table1 type
    str = string(t);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = TABLE1_A(job, arg1, arg2)

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
            ['lsx_tbl1_a(tbl1_a_default)'],..
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
        model.opar=list(tbl1_a_default);
        model = scicos_model()
        model.sim = list('table1_a', 4)
        model.in = [1]
        model.out = [1]
        model.state = [0]
        model.dstate = [0]
        model.blocktype = 'c'
        model.nmode = 0
        model.nzcross = 0
        model.dep_ut = [%t %f] // [direct feedthrough,   time dependence]
        exprs = ["lsx_tbl1_a(tbl1_a_default)"]
        gr_i = ['x=orig(1),y=orig(2),w=sz(1),h=sz(2)';
        'txt=[''Prototype'';''Table1'']';
        'xstringb(x+0.25*w, y+0.20*h, txt, 0.50*w, 0.60*h, ''fill'')';
        'txt=[''DF'';'''';''STOPS'';]';
        'xstringb(x+0.02*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
        'txt=['''';''V'';'''';''DFmod'';'''']';
        'xstringb(x+0.73*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
        ]
        x = standard_define([4 2],model,exprs,gr_i)

    end
endfunction

