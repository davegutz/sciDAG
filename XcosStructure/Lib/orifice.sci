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
// interfacing function for sharp-edged orifice
function d = dwdc(sg)
    d = 129.93948*sg;
endfunction
function y = sqr(x)
    y = x*x;
endfunction
function y = ssqr(x)
    y = sign(x)*x*x;
endfunction
function y = ssqrt(x)
    y = sign(x)*sqrt(abs(x));
endfunction
function wf = or_aptow(a, ps, pd, %cd, sg)
    wf = a * 19020. * %cd * ssqrt(sg * (ps - pd))
endfunction
function a = or_wptoa(wf, ps, pd, %cd, sg)
    a = (wf / sign(ps-pd) / max(sqrt(abs(sg*(ps-pd))), 1e-16) / %cd / 19020.);
endfunction
function ps = or_awpdtops(a, wf, pd, %cd, sg)
    ps = (pd + ssqr(wf / 19020. / max(a, 1e-12) / %cd) / sg);
endfunction
function pd = or_awpstopd(a, wf, ps, %cd, sg)
    pd = (ps - ssqr(wf / 19020. / max(a, 1e-12) / %cd) / sg);
endfunction
function wf = la_kptow(k, ps, pd, kvis)
    wf = k / kvis * (ps - pd);
endfunction
function k = la_wptok(wf, ps, pd, kvis)
    k = kvis * wf / (ps - pd);
endfunction
function wf = la_lrecptow(l, r, e, c, ps, pd, kvis)
    wf = (4.698e8 * r *(c*c*c) / kvis / l * (1. + 1.5 * sqr(e/c)) * (ps-pd));
endfunction

// Callback ******************************************** 
function [x,y,typ] = COR_APTOW(job, arg1, arg2)

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
            [ok,CD,SG,exprs] = getvalue('Set prototype valve parameters',..
            ['CD';'SG'],..
            list('vec',-1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [0]
            model.rpar = [CD;SG]
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end

    case 'define' then
//        message('in define')
        CD = 0.61
        SG = 0.8
        model = scicos_model()
        model.sim = list('cor_aptow', 4)
        model.in = [1;1;1]
        model.out = [1]
        model.state = [0]
        model.dstate = [0]
        model.rpar = [CD;SG]
        model.blocktype = 'c'
        model.nmode = 0
        model.nzcross = 0
        model.dep_ut = [%t %f] // [direct feedthrough,   time dependence]
        exprs = [string(CD); string(SG)]
        gr_i = [];
        x = standard_define([4 6],model,exprs,gr_i) // size icon, etc..

    end
endfunction

function [x,y,typ] = COR_AWPSTOPD(job, arg1, arg2)

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
            [ok,CD,SG,exprs] = getvalue('Set prototype valve parameters',..
            ['CD';'SG'],..
            list('vec',-1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [0]
            model.rpar = [CD;SG]
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end

    case 'define' then
//        message('in define')
        CD = 0.61
        SG = 0.8
        model = scicos_model()
        model.sim = list('cor_awpstopd', 4)
        model.in = [1;1;1]
        model.out = [1]
        model.state = [0]
        model.dstate = [0]
        model.rpar = [CD;SG]
        model.blocktype = 'c'
        model.nmode = 0
        model.nzcross = 0
        model.dep_ut = [%t %f] // [direct feedthrough,   time dependence]
        exprs = [string(CD); string(SG)]
        gr_i = [];
        x = standard_define([4 6],model,exprs,gr_i) // size icon, etc..

    end
endfunction

function [x,y,typ] = COR_AWPDTOPS(job, arg1, arg2)

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
            [ok,CD,SG,exprs] = getvalue('Set prototype valve parameters',..
            ['CD';'SG'],..
            list('vec',-1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [0]
            model.rpar = [CD;SG]
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end

    case 'define' then
//        message('in define')
        CD = 0.61
        SG = 0.8
        model = scicos_model()
        model.sim = list('cor_awpdtops', 4)
        model.in = [1;1;1]
        model.out = [1]
        model.state = [0]
        model.dstate = [0]
        model.rpar = [CD;SG]
        model.blocktype = 'c'
        model.nmode = 0
        model.nzcross = 0
        model.dep_ut = [%t %f] // [direct feedthrough,   time dependence]
        exprs = [string(CD); string(SG)]
        gr_i = [];
        x = standard_define([4 6],model,exprs,gr_i) // size icon, etc..

    end
endfunction
