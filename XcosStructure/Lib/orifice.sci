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
// Mar 17, 2019    DA Gutz        Created
// 
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
// interfacing functions for sharp-edged orifice
or_default = tlist(["or", "ao", "cd"], 0, 0.61);
la_default = tlist(["la", "l", "r", "ecc", "rad_clear"], 0, 0, 0, 0);
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

function [blkcall] = callblk_cor_aptow(blk, a, %cd, ps, pd)
    // Call compiled funcion HEAD_B that is scicos_block blk
    blk.inptr(1) = a;
    blk.inptr(2) = ps;
    blk.inptr(3) = pd;
    blkcall.a = a;
    blkcall.ps = ps;
    blkcall.pd = pd;
    blk.rpar(1) = %cd;
    blkcall.cd = %cd;
    blkcall.sg = blk.rpar(2);
    blk = callblk(blk, 0, 0);
    blkcall.wf = blk.outptr(1);
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

function [x,y,typ] = CLA_LRECPTOW(job, arg1, arg2)

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
            [ok,L,R,ECC,RAD_CLEAR,KVIS,exprs] = getvalue('Set cla_lrecptow parameters',..
            ['L';'R';'ECC';'RAD_CLEAR';'KVIS'],..
            list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [0]
            model.rpar = [L,R,ECC,RAD_CLEAR,KVIS]
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end

    case 'define' then
//        message('in define')
        L = 0;
        R = 0;
        ECC = 0;
        RAD_CLEAR = 0;
        KVIS = 0;
        model = scicos_model()
        model.sim = list('cla_lrecptow', 4)
        model.in = [1;1]
        model.out = [1]
        model.state = [0]
        model.dstate = [0]
        model.rpar = [L;R;ECC;RAD_CLEAR;KVIS]
        model.blocktype = 'c'
        model.nmode = 0
        model.nzcross = 0
        model.dep_ut = [%t %f] // [direct feedthrough,   time dependence]
        exprs = ['GEO.pact_lk.l'; 'GEO.pact_lk.r'; 'GEO.pact_lk.ecc';..
                 'GEO.pact_lk.rad_clear'; 'FP.kvis']
        gr_i = [];
        x = standard_define([4 6],model,exprs,gr_i) // size icon, etc..

    end
endfunction

function [blkcall] = callblk_cla_lrecptow(blk, l, r, ecc, rad_clear, kvis, ps, pd)
    // Call compiled funcion HEAD_B that is scicos_block blk
    blk.inptr(1) = ps;
    blk.inptr(2) = pd;
    blkcall.ps = ps;
    blkcall.pd = pd;
    blk.rpar(1) = l;
    blk.rpar(2) = r;
    blk.rpar(3) = ecc;
    blk.rpar(4) = rad_clear;
    blkcall.l = l;
    blkcall.r = r;
    blkcall.ecc = ecc;
    blkcall.rad_clear = rad_clear;
    blkcall.kvis = blk.rpar(5);
    blk = callblk(blk, 0, 0);
    blkcall.wf = blk.outptr(1);
endfunction
