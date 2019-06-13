// Copyright (C) 2019  - Dave Gutz
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
// Mar 31, 2019    DA Gutz     Created
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

// Sharp edge to reattached flow characteristic of flapper nozzle
f_lqx = [1.2, 2.5, 4.5, 7.5; .61, .65, .88, .95];

//// Default head_b prototype *****************************************
head_b_default = tlist(["hdb", "f_an", "f_cn", "f_dn", "f_ln",..
        "ae", "ao", "c", "cdo", "fb", "fdyf", "fs", "fstf",..
        "kb", "ks", "m", "xmax", "xmin"],..
         0, 0, 0, 0, 0,..
         0, 0, 0, 0, 0, 0, 0, 0,..
         0, 0, 0, 1, -1);

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx_hdb(h)
    lis = list(h.f_an, h.f_cn, h.f_dn, h.f_ln,..
             h.ae, h.ao, h.c, h.cdo, h.fb, h.fdyf, h.fs, h.fstf,..
             h.kb, h.ks, h.m, h.xmax, h.xmin);
endfunction

function str = %hdb_string(h)
    str = msprintf('''%s'' type:  f_an=%f,\nf_cn=%f,\nf_dn=%f,\nf_ln=%f,\nae=%f,\nao=%f,\nc=%f,\ncdo=%f,\nfb=%f,\nfdyf=%f,\nfs=%f,\nfstf=%f,\nkb=%f,\nks=%f,\nm=%f,\nxmax=%f,\nxmin=%f;',..
             typeof(h), h.f_an, h.f_cn, h.f_dn, h.f_ln,..
             h.ae, h.ao, h.c, h.cdo, h.fb, h.fdyf, h.fs, h.fstf,..
             h.kb, h.ks, h.m, h.xmax, h.xmin);
endfunction

function str = hdb_fstring(h)
    str = msprintf('type,''%s'',\nf_an,%f,\nf_cn,%f,\nf_dn,%f,\nf_ln,%f,\nae,%f,\nao,%f,\nc,%f,\ncdo,%f,\nfb,%f,\nfdyf,%f,\nfs,%f,\nfstf,%f,\nkb,%f,\nks,%f,\nm,%f,\nxmax,%f,\nxmin,%f,\n',..
             typeof(h), h.f_an, h.f_cn, h.f_dn, h.f_ln,..
             h.ae, h.ao, h.c, h.cdo, h.fb, h.fdyf, h.fs, h.fstf,..
             h.kb, h.ks, h.m, h.xmax, h.xmin);
endfunction

function str = %hdb_p(h)
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
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set head_b parameters',..
            ['lsx_hdb(head_b)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
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
        model.in = [1;1;1;1]
        model.out = [1;1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx_hdb(GEO.hs)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.hs.x"]
        gr_i = [];
       x = standard_define([12 18],model,exprs,gr_i)  // size icon, etc..
    end
endfunction

function [blkcall] = callblk_head_b(blk, sim, pf, ph, pl, xol)
    if sim~='head_b' then
        mprintf('ERROR:  %s is not head_b', sim);
        error('wrong block type')
    end
    // Call compiled funcion HEAD_B that is scicos_block blk
    blk.inptr(1) = pf;
    blk.inptr(2) = ph;
    blk.inptr(3) = pl;
    blk.inptr(4) = xol;
    blkcall.pf = pf;
    blkcall.ph = ph;
    blkcall.pl = pl;
    blkcall.xol = xol;
    blkcall.sg = blk.rpar(1);
    blkcall.LINCOS_OVERRIDE = blk.rpar(2);
//    blk = callblk(blk, 0, 0);
//    blk = callblk(blk, 1, 0);
//    blk = callblk(blk, 9, 0);
    blk = callblk(blk, -1, 0);
    blkcall.wff = blk.outptr(1);
    blkcall.wfh = blk.outptr(2);
    blkcall.wfl = blk.outptr(3);
    blkcall.plx = blk.outptr(4);
    blkcall.v = blk.outptr(5);
    blkcall.x = blk.outptr(6);
    blkcall.uf = blk.outptr(7);
//    blkcall.mode = blk.outptr(8);
    blkcall.V = blk.xd(1);
    blkcall.A = blk.xd(2);
    blkcall.mode = blk.mode;
    blkcall.surf0 = blk.g(1);
    blkcall.surf1 = blk.g(2);
    blkcall.surf2 = blk.g(3);
    blkcall.surf3 = blk.g(4);
    blkcall.surf4 = blk.g(5);
endfunction
//////////********** end head_b ***************************************

//// Default actuator_a_b prototype ***********************************
actuator_a_b_default = tlist(["aab", "ab", "ah", "ahl", "ar", "arl",..
        "c_", "cd_", "fdyf", "fstf",..
       "mact", "mext", "xmax", "xmin"],..
         0, 0, 0, 0, 0,..
         0, 0, 0, 0,..
         0, 0, 1, -1);

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx_aab(a)
    lis = list(a.ab, a.ah, a.ahl, a.ar, a.arl,..
             a.c_, a.cd_, a.fdyf, a.fstf,..
             a.mact, a.mext, a.xmax, a.xmin);
endfunction

function str = %aab_string(a)
    str = msprintf('''%s'' type:  ab=%f,\nah=%f,\nahl=%f,\nar=%f,\narl=%f,\nc_=%f,\ncd_=%f,\nfdyf=%f,\nfstf=%f;mact=%f,\nmext=%f,\nxmax=%f,\nxmin=%f;\n',..
             typeof(a), a.ab, a.ah, a.ahl, a.ar, a.arl,..
             a.c_, a.cd_, a.fdyf, a.fstf,..
             a.mact, a.mext, a.xmax, a.xmin);
endfunction

function str = aab_fstring(a)
    str = msprintf('type,''%s'',\nab,%f,\nah,%f,\nahl,%f,\nar,%f,\narl,%f,\nc_,%f,\ncd_,%f,\nfdyf,%f,\nfstf,%f,\nmact,%f,\nmext,%f,\nxmax,%f,\nxmin,%f,\n',..
             typeof(a), a.ab, a.ah, a.ahl, a.ar, a.arl,..
             a.c_, a.cd_, a.fdyf, a.fstf,..
             a.mact, a.mext, a.xmax, a.xmin);
endfunction

function str = %aab_p(a)
    str = string(a);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = ACTUATOR_A_B(job, arg1, arg2)
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
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set actuator_a_b parameters',..
            ['lsx_aab(actuator_a_b)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
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
        model.opar=list(actuator_a_b_default);
        SG = 0.8
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('actuator_a_b', 4)
        model.in = [1;1;1;1;1;1]
        model.out = [1;1;1;1;1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 5
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx_aab(GEO.pact)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.pact.x"]
        gr_i = [];
        x = standard_define([12 18],model,exprs,gr_i)  // size icon, etc..
    end
endfunction

function [blkcall] = callblk_actuator_a_b(blk, sim, ph, pl, pr, per, fext, xol)
    if sim~='aab' then
        mprintf('ERROR:  %s is not aab', sim);
        error('wrong block type')
    end
    // Call compiled funcion ACTUATOR_A_B that is scicos_block blk
    blk.inptr(1) = ph;
    blk.inptr(2) = pl;
    blk.inptr(3) = pr;
    blk.inptr(4) = per;
    blk.inptr(5) = fext;
    blk.inptr(6) = xol;
    blkcall.ph = ph;
    blkcall.pl = pl;
    blkcall.pr = pr;
    blkcall.per = per;
    blkcall.fext = fext;
    blkcall.xol = xol;
    blkcall.sg = blk.rpar(1);
    blkcall.LINCOS_OVERRIDE = blk.rpar(2);
//    blk = callblk(blk, 0, 0);
//    blk = callblk(blk, 1, 0);
//    blk = callblk(blk, 9, 0);
    blk = callblk(blk, -1, 0);
    blkcall.wfb = blk.outptr(1);
    blkcall.wfh = blk.outptr(2);
    blkcall.wfhl = blk.outptr(3);
    blkcall.wfr = blk.outptr(4);
    blkcall.wfrl = blk.outptr(5);
    blkcall.wfve = blk.outptr(6);
    blkcall.v = blk.outptr(7);
    blkcall.x = blk.outptr(8);
    blkcall.uf = blk.outptr(9);
    blkcall.uf_net = blk.outptr(10);
//    blkcall.mode = blk.outptr(11);
    blkcall.V = blk.xd(1);
    blkcall.A = blk.xd(2);
    blkcall.mode = blk.mode;
    blkcall.surf0 = blk.g(1);
    blkcall.surf1 = blk.g(2);
    blkcall.surf2 = blk.g(3);
    blkcall.surf3 = blk.g(4);
    blkcall.surf4 = blk.g(5);
endfunction
//////////********** end actuator_a_b ***************************************

//// Default actuator_a_c prototype ***********************************
actuator_a_c_default = tlist(["aac", "ab", "ah", "ahl", "ar", "arl",..
        "c_", "cd_", "fdyf", "fstf",..
        "mact", "mext", "xmax", "xmin"],..
         0, 0, 0, 0, 0,..
         0, 0, 0, 0,..
         0, 0, 1, -1);

// Arguments of C_Code cannot have nested lists; use vector (vec_) instead.
function lis = lsx_aac(a)
    lis = list(a.ab, a.ah, a.ahl, a.ar, a.arl,..
             a.c_, a.cd_, a.fdyf, a.fstf,..
             a.mact, a.mext, a.xmax, a.xmin);
endfunction

function str = %aac_string(a)
    str = msprintf('''%s'' type:  ab=%f,\nah=%f,\nahl=%f,\nar=%f,\narl=%f,\nc_=%f,\ncd_=%f,\nfdyf=%f,\nfstf=%f,\nmact=%f,\nmext=%f,\nxmax=%f,\nxmin=%f;\n',..
             typeof(a), a.ab, a.ah, a.ahl, a.ar, a.arl,..
             a.c_, a.cd_, a.fdyf, a.fstf,..
             a.mact, a.mext, a.xmax, a.xmin);
endfunction

function str = aac_fstring(a)
    str = msprintf('type,''%s'',\nab,%f,\nah,%f,\nahl,%f,\nar,%f,\narl,%f,\nc_,%f,\ncd_,%f,\nfdyf,%f,\nfstf,%f,\nmact,%f,\nmext,%f,\nxmax,%f,\nxmin,%f,\n',..
             typeof(a), a.ab, a.ah, a.ahl, a.ar, a.arl,..
             a.c_, a.cd_, a.fdyf, a.fstf,..
             a.mact, a.mext, a.xmax, a.xmin);
endfunction

function str = %aac_p(a)
    str = string(a);
    disp(str)
endfunction

// Callback ******************************************** 
function [x,y,typ] = ACTUATOR_A_C(job, arg1, arg2)
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
            [ok,GEO,SG,LINCOS_OVERRIDE,Xinit,exprs] = getvalue('Set actuator_a_c parameters',..
            ['lsx_aac(actuator_a_c)';'SG';'LINCOS_OVERRIDE';'Xinit'],..
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
        model.opar=list(actuator_a_c_default);
        SG = 0.8
        LINCOS_OVERRIDE = 0
        Xinit = 0
        model = scicos_model()
        model.sim = list('actuator_a_c', 4)
        model.in = [1;1;1;1;1;1]
        model.out = [1;1;1;1;1;1;1;1;1;1;1]
        model.state = [Xinit; 0]
        model.dstate = [0]
        model.rpar = [SG;LINCOS_OVERRIDE]
        model.blocktype = 'c'
        model.nmode = 1
        model.nzcross = 7
        model.dep_ut = [%f %t] // [direct feedthrough,   time dependence]
        exprs = ["lsx_aab(G.venload.act_c)"; "FP.sg"; string(LINCOS_OVERRIDE); "INI.venload.act_c.x"]
        gr_i = [];
        x = standard_define([12 18],model,exprs,gr_i)  // size icon, etc..
    end
endfunction

function [blkcall] = callblk_actuator_a_c(blk, sim, ph, pl, pr, per, fext, xol)
    if sim~='aac' then
        mprintf('ERROR:  %s is not aac', sim);
        error('wrong block type')
    end
    // Call compiled funcion ACTUATOR_A_C that is scicos_block blk
    blk.inptr(1) = ph;
    blk.inptr(2) = pl;
    blk.inptr(3) = pr;
    blk.inptr(4) = per;
    blk.inptr(5) = fext;
    blk.inptr(6) = xol;
    blkcall.ph = ph;
    blkcall.pl = pl;
    blkcall.pr = pr;
    blkcall.per = per;
    blkcall.fext = fext;
    blkcall.xol = xol;
    blkcall.sg = blk.rpar(1);
    blkcall.LINCOS_OVERRIDE = blk.rpar(2);
//    blk = callblk(blk, 0, 0);
//    blk = callblk(blk, 1, 0);
//    blk = callblk(blk, 9, 0);
    blk = callblk(blk, -1, 0);
    blkcall.wfb = blk.outptr(1);
    blkcall.wfh = blk.outptr(2);
    blkcall.wfhl = blk.outptr(3);
    blkcall.wfr = blk.outptr(4);
    blkcall.wfrl = blk.outptr(5);
    blkcall.wfve = blk.outptr(6);
    blkcall.v = blk.outptr(7);
    blkcall.x = blk.outptr(8);
    blkcall.uf = blk.outptr(9);
    blkcall.uf_net = blk.outptr(10);
//    blkcall.mode = blk.outptr(11);
    blkcall.V = blk.xd(1);
    blkcall.A = blk.xd(2);
    blkcall.mode = blk.mode;
    blkcall.surf0 = blk.g(1);
    blkcall.surf1 = blk.g(2);
    blkcall.surf2 = blk.g(3);
    blkcall.surf3 = blk.g(4);
    blkcall.surf4 = blk.g(5);
    blkcall.surf5 = blk.g(6);
    blkcall.surf6 = blk.g(7);
endfunction
//////////********** end actuator_a_c ***************************************

//// Default four-way ehsv 2nd order (fehsv2) prototype ***********************************
fehsv2_default = tlist(["fehsv2", "tau_s", "wn_s", "zeta_s", "dp_s",..
        "ael", "kel", "cd_", "cdl", "kix", "mAnull",..
        "ah", "ar", "vmax_s", "vmin_s",..
        "underlap", "amn", "wdh", "wsr", "wsh", "wdr", "xmxc_s", "xmxc_rat",..
        "minPressure", "xmax", "xmaxS", "xmin",..
        "mA_x", "mA_x0", "awin_dh", "awin_dr", "awin_sh", "awin_sr"],..
         0.00637, 157.07963, 0.5, 1000,..
         0.0003176, 0, 0.61, 0.61, -0.0010667, 25,..
         0.2091170, 0.1777010, 1.2433233, -1.2433233,..
         -0.0010675, 1e-7, 0.636, 0.636, 0.636, 0.636, 0.085, 1.785,.. 
         10, 0.0427, 0.085, -0.0373,..
         ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default);

function str = %fehsv2_string(e)
    str = msprintf('''%s'' type:  tau_s=%f,\nwn_s=%f,\nzeta_s=%f,\ndp_s=%f,\nael=%f,\nkel=%f,\ncd_=%f,\ncdl=%f,\nkix=%f,\nmAnull=%f,\nah=%f,\nar=%f,\nvmax_s=%f,\nvmin_s=%f,\nunderlap=%f,\namn=%f,\nwdh=%f,\nwsr=%f,\nwsh=%f,\nwdr=%f,\nxmxc_s=%f,\nxmxc_rat=%f,\nminPressure=%f,\nxmax=%f,\nxmaxS=%f,\nxmin=%f\nmA_x=%s\nmA_x0=%s\nawin_dh=%s\nawin_dr=%s\nawin_sh=%s\nawin_sr=%s\n',..
        typeof(e), e.tau_s, e.wn_s, e.zeta_s, e.dp_s,..
        e.ael, e.kel, e.cd_, e.cdl, e.kix, e.mAnull,..
        e.ah, e.ar, e.vmax_s, e.vmin_s,..
        e.underlap, e.amn, e.wdh, e.wsr, e.wsh, e.wdr, e.xmxc_s, e.xmxc_rat,..
        e.minPressure, e.xmax, e.xmaxS, e.xmin,..
        ctab1_fstring(e.mA_x), ctab1_fstring(e.mA_x0),..
        ctab1_fstring(e.awin_dh), ctab1_fstring(e.awin_dr),..
        ctab1_fstring(e.awin_sh), ctab1_fstring(e.awin_sr));
endfunction

function str = fehsv2_fstring(e)
    str = msprintf('type,''%s'',\ntau_s,%f,\nwn_s,%f,\nzeta_s,%f,\ndp_s,%f,\nael,%f,\nkel,%f,\ncd_,%f,\ncdl,%f,\nkix,%f,\nmAnull,%f,\nah,%f,\nar,%f,\nvmax_s,%f,\nvmin_s,%f,\nunderlap,%f,\namn,%f,\nwdh,%f,\nwsr,%f,\nwsh,%f,\nwdr,%f,\nxmxc_s,%f,\nxmxc_rat,%f,\nminPressure,%f,\nxmax,%f,\nxmaxS,%f,\nxmin,%f,\nmA_x,%s\nmA_x0,%s\nawin_dh,%s\nawin_dr,%s\nawin_sh,%s\nawin_sr,%s\n',..
        typeof(e), e.tau_s, e.wn_s, e.zeta_s, e.dp_s,..
        e.ael, e.kel, e.cd_, e.cdl, e.kix, e.mAnull,..
        e.ah, e.ar, e.vmax_s, e.vmin_s,..
        e.underlap, e.amn, e.wdh, e.wsr, e.wsh, e.wdr, e.xmxc_s, e.xmxc_rat,..
        e.minPressure, e.xmax, e.xmaxS, e.xmin,..
        ctab1_fstring(e.mA_x), ctab1_fstring(e.mA_x0), ctab1_fstring(e.awin_dh), ctab1_fstring(e.awin_dr),..
        ctab1_fstring(e.awin_sh), ctab1_fstring(e.awin_sr));
endfunction

function str = %fehsv2_p(e)
    str = string(e);
    disp(str)
endfunction

//////////********** end fehsv2 ***************************************
