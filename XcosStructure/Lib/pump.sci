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


//// Default vdp prototype *****************************************
vdp_default = tlist(["vdp", "cf", "cn", "cs", "ct", "cdv"],..
         0, 0, 0, 0, 0);
         
function [ps] = %vdp_string(p)
    // Cast head type to string
    ps = msprintf('list(');

    // Scalars
    ps = ps + msprintf('%f,%f,%f,%f,',..
             p.cf, p.cn, p.cs, p.ct);

    // Tables
    
    // end
    ps = ps + msprintf(')');
endfunction

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx_vdp(p)
    lis = list(p.cf, p.cn, p.cs, p.ct);
endfunction

function str = %vdp_p(p)
    // Display valve type
    str = string(p);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = VDP(job, arg1, arg2)
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
            [ok,GEO,SG,AVIS,exprs] = getvalue('Set vdp parameters',..
            ['lsx_vdp(vdp)';'SG';'AVIS'],..
            list('lis',-1,'vec',1,'vec',1),..
            exprs)
            if ~ok then break,end 
            model.state = [0]
            model.rpar = [SG;AVIS]
            model.opar = GEO
            graphics.exprs = exprs
            x.graphics = graphics
            x.model = model
            break
        end
    case 'define' then
//        message('in define')
        model.opar=list(vdp_default);
        SG = 0.8
        AVIS = 5e-8;
        model = scicos_model()
        model.sim = list('vdp', 4)
        model.in = [1;1;1;1]
        model.out = [1;1;1;1]
        model.state = [0]
        model.dstate = [0]
        model.rpar = [SG; AVIS]
        model.blocktype = 'c'
        model.nmode = 0
        model.nzcross = 0
        model.dep_ut = [%t %f] // [direct feedthrough,   time dependence]
        exprs = ["lsx_vdp(GEO.vdpp)"; 'FP.sg'; 'FP.avis']
        gr_i = [];
        x = standard_define([8 8],model,exprs,gr_i) // size icon, etc..
    end
endfunction

function [blkcall] = callblk_vdp(blk, rpm, disp_, pd, ps)
    // Call compiled funcion vdp that is scicos_block blk
    blk.inptr(1) = rpm;
    blk.inptr(2) = disp_;
    blk.inptr(3) = pd;
    blk.inptr(4) = ps;
    blkcall.rpm = rpm;
    blkcall.disp_ = disp_;
    blkcall.pd = pd;
    blkcall.ps = ps;
    blkcall.sg = blk.rpar(1);
    blkcall.avis = blk.rpar(2);
//    blk = callblk(blk, 0, 0);
//    blk = callblk(blk, 1, 0);
//    blk = callblk(blk, 9, 0);
    blk = callblk(blk, -1, 0);
    blkcall.wf = blk.outptr(1);
    blkcall.mtdqp = blk.outptr(2);
    blkcall.eff_vol = blk.outptr(3);
    blkcall.pl = blk.outptr(4);
endfunction
//////////********** end vdp ***************************************
