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

function [x,y,typ] = VALVE_A(job, arg1, arg2)

    x = [];
    y = [];
    typ = [];

    function str = %valve_a_string(v)
        // Display valve type
        str = msprintf("tlist([''valve_a'', ''m'', ''c''], 0, 0)");
    endfunction

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
            [ok,FSTF,FDYF,C,EPS,M,Xmin,Xmax,GEO,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set prototype valve parameters',..
            ['FSTF';'FDYF';'C';'EPS';'M';'Xmin';'Xmax';'GEO';'LINCOS_OVERRIDE';'Xinit'],..
            list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'lis',-1,'vec',1,'vec',1),..
            exprs)
//            [ok,FSTF,FDYF,C,EPS,M,Xmin,Xmax,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set prototype valve parameters',..
//            ['FSTF';'FDYF';'C';'EPS';'M';'Xmin';'Xmax';'LINCOS_OVERRIDE';'Xinit'],..
//            list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),..
//            exprs)
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
        FSTF = 0
        FDYF = 0
        C = 0
        EPS = 0
        M = 5000
        Xmin = -1
        Xmax = 1
        GEO = list(0, 5000)
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('valve_a',4)
        model.in = [1]
        model.out = [1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [FSTF; FDYF; C; EPS; M; Xmin; Xmax; LINCOS_OVERRIDE]
//        model.opar = [GEO]
//        model.opar = [tlist(["valve_a", "m", "c"], 0, 0)]
        //model.opar = [0,0]
//        model.opar = tlist(["valve_a", "m", "c"], 0, 0);
        model.opar=list(int32([1,2;3,4]),[1+%i %i -5000]);
//        model.opar = list(0, 5000);
//        model.opar=GEO;
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = [string(FSTF); string(FDYF); string(C); string(EPS);..
                 string(M); string(Xmin); string(Xmax);..
//                 string(GEO);..
                 "list(int32([1,2;3,4]),[1+%i %i -5000])";..
//                 "[0; 5000]";..
//                "list(0, 5000)";..
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

