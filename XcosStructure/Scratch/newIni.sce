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
// Mar 23, 2019    DA Gutz     Created
//
funcprot(0);
getd('../Lib')
global m k c
global loaded_scratch root sys_f scs_m cpr
global GEO G INI FP LIN mv_x mv_xa mv_xin Tf
global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb
// VEN linkage object
vlink_default = tlist(["vlk", "ctqpv", "cva", "cdv", "cftpa", "ytqa", "ytqrs",..
                       "cdabdamp", "fsb", "ksb"],..
                       0, 0, 0, 0, ctab1_default, ctab1_default,..
                       0, 0, 0);
function str = %vlk_string(v)
    str = msprintf('''%s'' type:  ctqpv=%f, cva=%f, cdv=%f, cftpa=%f,',..
             typeof(v), v.ctqpv, v.cva, v.cdv, v.cftpa);
    str = str + 'ytqa: ' + string(v.ytqa) + ',';
    str = str + 'ytqrs: '+ string(v.ytqrs);
endfunction
function str = %vlk_p(v)
    str = string(v);
    disp(str)
endfunction

// wf1leak object
wf1leak_default = tlist(["wf1leak", "Ao", "k", "Do"], 0, 0, 0);
function str = %wf1l_string(v)
    str = msprintf('''%s'' type:  Ao=%f, k=%f, Do=%f',..
             typeof(v), v.Ao, v.k, v.Do);
endfunction
function str = %wf1l_p(v)
    str = string(v);
    disp(str)
endfunction


GEO = tlist(["sys_geo", "vdpp", "vsv", "reg", "pact", "pact_lk", "vlink", "ehsv_klk", "ehsv_powlk", "rrv", "vo_pcham", "vo_vpx", "bias", "mv", "mvtv", "hs", "noz", "mo_p3s", "vo_p2", "vo_p3", "vo_p1so", "vo_px", "vo_p3s", "vo_pnozin", "ln_p3s", "ln_vs", "main_line", "a_p3s", "a_tvb", "mvwin"], vdp_default, vlv_a_default, tv_a1_default,  actuator_a_b_default, la_default, vlink_default, 0, 0, vlv_a_default, vol_default, vol_default, actuator_a_b_default, hlfvlv_a_default, vlv_a_default, head_b_default, ctab1_default, mom_default, vol_default, vol_default, vol_default, vol_default, vol_default, vol_default, pipeVM_default, pipeVM_default, pipeMM_default, or_default, or_default, ctab1_default);

// Work in progress   TODO:  replace GEO with G elsewhere
MLINE = tlist(["sys_mline", "vo_pnozin", "ln_vs", "main_line", "noz"],vol_default, pipeVM_default, pipeMM_default, ctab1_default);
IFC = tlist(["sys_ifc", "mv", "mvtv", "hs", "mo_p3s", "vo_p2",  "vo_p3", "vo_p1so", "vo_px", "vo_p3s", "ln_p3s", "a_p3s", "a_tvb", "mvwin", "check", "k1leak", "a1leak", "prtv"], hlfvlv_a_default, vlv_a_default, head_b_default, mom_default, vol_default, vol_default, vol_default, vol_default, vol_default, pipeVM_default, or_default, or_default, ctab1_default, vlv_a_default, 0, 0, vlv_a_default);
EPMP = tlist(["sys_ebp", "mfp", "wf1leak", "faboc", "ocm1", "ocm2", "focOr", "vo_poc", "boost", "inlet", "or_filt", "mom_filt", "vo_pb1", "vo_pb2"], cpmp_default, wf1leak_default, pipeMM_default, pipeMM_default, pipeVM_default, or_default, vol_default, cpmp_default, pipeMM_default, or_default, mom_default, vol_default, vol_default)
VEN = tlist(["sys_ven", "vdpp", "vsv", "reg", "pact", "pact_lk", "vlink", "vleak", "rrv", "vo_pcham", "vo_px", "bias", "ehsv_klk", "ehsv_powlk", "ksb", "fsb", "leako"], vdp_default, vlv_a_default, tv_a1_default, actuator_a_b_default, la_default, vlink_default, la_default, vlv_a_default, vol_default, vol_default, actuator_a_b_default, 0, 0, 0, 0, la_default);
ENG = tlist(["sys_eng", "pcn25r", "N25c100Pct", "N25100Pct", "N2c100Pct", "xn25p", "xnvent", "xnmainpt", "ctstd", "spcn25", "sfxven", "swf", "sawfb", "fxvent", "t25t", "ps3t", "dps3dwt", "pcn2rt", "pcn25rt"], ctab1_default, 0, 0, 0, 0, 0, 0, 0, [0 1], [0 1], [0 1], [0 1], [0 1], ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default);
MOTOR = tlist(["sys_motor", "dp", "wf"], 0, 0);
ACSUPPLY = tlist(["sys_acsup", "ltank", "lengine", "acbst", "acmbst", "motor"], pipeMV_default, pipeMV_default, cpmp_default, cpmp_default, MOTOR);
VENLOAD = tlist(["sys_venload", "act_c", "ehsv", "ehsv_klk", "ehsv_powlk", "rline", "hline", "vo_rcham", "vo_hcham"], actuator_a_c_default, fehsv2_default, 0, 0, pipeVM_default, pipeVM_default, vol_default, vol_default);
GUESS = tlist(["v_guess", "xn25", "disp", "xehsv", "xreg", "xbias", "pd", "prod", "px", "phead"], ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default);

G = tlist(['geo', 'ifc', 'ebp', 'ven', 'venload', 'eng', 'mline', 'acsupply', 'guess'], IFC, EPMP, VEN, VENLOAD, ENG, MLINE, ACSUPPLY, GUESS);



// To match matlab case
FP.sg = 0.79;
FP.kvis = 1.3;
FP.beta = 159200;
FP.dwdc = 102.6522;
FP.avis = 1.4823e-7;
FP.tvp_margin = -1e6;
FP.tvp = 5;

exec('./Callbacks/PreLoadFcn_simul.sce', -1);
exec('./Callbacks/solve_VEN.sci', -1);
exec('./Callbacks/solve_MAIN.sci', -1);
exec('./Callbacks/solve_IFC.sci', -1);
exec('./Callbacks/regwin_a.sci', -1);

clear INI

INI.wf36 = 9060;
INI.pamb = 14.7;
//INI.p1so = 1978.3;
INI.awfb = 1e-5;


INI.ven.pamb =INI.pamb;
INI.ven.fxven = 8000;
INI.ven.guess.fxven = INI.ven.fxven;
INI.ven.guess.xn25 = lookup(INI.ven.fxven, G.guess.xn25);
INI.ven.guess.x1_xehsv = lookup(INI.ven.fxven, G.guess.xehsv);
INI.ven.guess.x2_prod = lookup(INI.ven.fxven, G.guess.prod);
INI.ven.guess.x3_xbi  = lookup(INI.ven.fxven, G.guess.xbias);
INI.ven.guess.x4_pd = lookup(INI.ven.fxven, G.guess.pd);
INI.ven.guess.x5_disp = lookup(INI.ven.fxven, G.guess.disp);
INI.ven.guess.x_xreg = lookup(INI.ven.fxven, G.guess.xreg);
INI.ven.x1_xehsv = INI.ven.guess.x1_xehsv;
INI.ven.x2_prod = INI.ven.guess.x2_prod;
INI.ven.x3_xbi  = INI.ven.guess.x3_xbi;
INI.ven.x4_pd = INI.ven.guess.x4_pd;
INI.ven.x5_disp = INI.ven.guess.x5_disp;
INI.ven.x_xreg = INI.ven.guess.x_xreg;
 
INI.ven.pr = 241.1401;
INI.ven.ps = 241.0706;
INI.xn25 = INI.ven.guess.xn25;
INI.xn25 = 16005;
INI.ven.N = INI.xn25/G.eng.xn25p*G.eng.xnvent;


// Eng Boost
INI.sAC = 1;
INI.wfr = 0;
INI.wfs = 0;
INI.wf1cvg = 0;
INI.wf1fvg = 0;
INI.wf1v = 0;
INI.precx = INI.pamb;
INI.eng.wf36 = INI.wf36;
INI.verbose = 3;
INI.linearizing = 0;
INI.single_pass = 0;

//INI = solve_MAIN(INI, G, FP);
//
//INI.pr = INI.pc;
//

[INI, G] = solve_VEN(INI, G, FP);
INI = order_all_fields(INI); 
