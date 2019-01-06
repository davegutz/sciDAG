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

// Default table prototype ****************************************
tbl_a_default = tlist(["tbl_a", "xy"], [-1, 0, 10; 0, 0, 10]);
function [ts] = %tbl_a_string(t)
        ts = msprintf('[');
    [nad, %mad] = size(t.xy);
    for i = 1:nad,
        for j = 1:%mad,
            ts = ts + msprintf('%f', t.xy(i,j));
            if j<%mad,
                ts = ts + msprintf(',');
            elseif i<nad,
                ts = ts + msprintf(';');
            end
        end
    end
    ts = ts + msprintf(']');
endfunction

// Default valve_a prototype **************************************
//vlv_a_default = tlist(["vlv_a", "m", "c", "ad"], 5000, 0, [-1, 0, 3;0, 0, 5]);
vlv_a_default = tlist(["vlv_a", "m", "c", "ad", "aw"],..
                     5000, 0, tbl_a_default, tbl_a_default);
function [vs] = %vlv_a_string(v)
    // Cast valve type to string
    //    vs = '';
        vs = "list(5000, 0, [-2,0,4;0,0,6])";
//    vs = "list(vlv_a)";
    // Scalars
    vs = msprintf('list(%f,%f,', v.m, v.c);
    // Tables
    vs = vs + string(v.ad) + ',';
    vs = vs + string(v.aw);
    vs = vs + msprintf(')');
endfunction
function lis = lsx(v)
    lis = list(v.m, v.c, v.ad, v.aw);
endfunction
function str = %vlv_a_p(v)
    // Display valve type
//    str = msprintf('list(%f, %f)\n', v.m, v.c);
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
            [ok,GEO,FSTF,FDYF,C,EPS,M,Xmin,Xmax,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set prototype valve parameters',..
            ['lsx(vlv_a)';'FSTF';'FDYF';'C';'EPS';'M';'Xmin';'Xmax';'LINCOS_OVERRIDE';'Xinit'],..
            list('lis',-1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [Xinit; 0]
            model.rpar = [FSTF; FDYF; C; EPS; M; Xmin; Xmax; LINCOS_OVERRIDE]
            model.opar = GEO
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end

    case 'define' then
//        message('in define')
        model.opar=list(vlv_a);
        FSTF = 0
        FDYF = 0
        C = 0
        EPS = 0
        M = 5000
        Xmin = -1
        Xmax = 1
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('valve_a', 4)
        model.in = [1]
        model.out = [1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [FSTF; FDYF; C; EPS; M; Xmin; Xmax; LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
//        exprs = ["list(5000, 0, [-2,0,4;0,0,6])";..
//        exprs = [string(vlv_a);..
        exprs = ["lsx(vlv_a_default)";..
                string(FSTF); string(FDYF); string(C); string(EPS);..
                 string(M); string(Xmin); string(Xmax);..
                 string(LINCOS_OVERRIDE);..
                 string(Xinit)]
        gr_i = ['x=orig(1),y=orig(2),w=sz(1),h=sz(2)';
        'txt=[''Prototype'';''Valve'']';
        'xstringb(x+0.25*w, y+0.20*h, txt, 0.50*w, 0.60*h, ''fill'')';
        'txt=[''DF'';'''';''STOPS'';]';
        'xstringb(x+0.02*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
        'txt=['''';''V'';'''';''DFmod'';'''']';
        'xstringb(x+0.73*w, y+0.08*h, txt, 0.25*w, 0.80*h, ''fill'')';
        ]
        x = standard_define([4 2],model,exprs,gr_i)

    end
endfunction

