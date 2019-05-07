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
// Dec 17, 2018 	DA Gutz		Created
//
// interfacing function for lim_int block

function [x,y,typ] = INTGL(job, arg1, arg2)

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
            [ok,ymax,ymin,Xinitial,exprs] = getvalue('Set integrator parameters',..
            ['high limit';'low limit';'Xinitial'],..
            list('vec',1,'vec',1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [Xinitial]
            model.rpar = [ymax;ymin]
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end

    case 'define' then
        //message('in define')
        ymax = 1.0
        ymin = -1.0
        Xinitial = 0
        model = scicos_model()
        model.sim = list('intgl',4)
        model.in = [1]
        model.out = [1]
        model.state = [Xinitial]
        model.dstate = [0]  // Initial discrete state, cannot be empty
        model.rpar = [ymax; ymin]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 3
        model.dep_ut = [%t %t]

        exprs = [string([ymax;ymin;Xinitial])]
        gr_i = [];
        x = standard_define([4 2],model,exprs,gr_i)
    end
endfunction

