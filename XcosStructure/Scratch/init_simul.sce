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
// Mar 24, 2019    DA Gutz     Created
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
// Jan 1, 2019      DA Gutz     Created
// 
funcprot(0);
getd('../Lib')
this = sfilename();
base = strsplit(this, '.');
base = base(1);
root = strsplit(base, 'init_');
root = root(2);
this_xcos_file = root + '.xcos';
this_zcos_file = root + '.zcos';
this_path = get_absolute_file_path(this);
chdir(this_path);
n_fig = -1;
xdel(winsid())
//mclose('all');   This cannot be scripted, has to be called at command line

global m k c
global loaded_scratch root sys_f scs_m cpr
global GEO G INI FP LIN mv_x mv_xa mv_xin Tf
global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb
global INIx

// Auto data overplot load
stack_size = stacksize('max');
[D, N, time] = load_csv_data('./Data/start04ss.ven.csv', 1);
exec('./Data/load_decode_csv_data.sce', -1);
[D, N, time] = load_csv_data('./Data/start04ss.ifc.csv', 1);
exec('./Data/load_decode_csv_data.sce', -1);
[D, N, time] = load_csv_data_row('./Data/FP_IRP.csv', 1);
[n_names, m_names] = size(N);
for i = 1:m_names
    execstr(N(i) + "=D(" + string(i) + ",1);")
end
[D, N, time] = load_csv_data('./Data/DV_IRP.csv', 1);
exec('./Data/load_decode_csv_data.sce', -1);
[D, N, time] = load_csv_data('./Data/DI_IRP.csv', 1);
exec('./Data/load_decode_csv_data.sce', -1);
clear D N n_names m_names

// Length of simulation
Tf = time($);
Tf = 0.01;

// Real time plot buffer
Tb = Tf;

// Data storage setup
TBUF = 0.0001;
NBUF = ceil(Tf/TBUF);
clear D N time

// Memory of setup
INI.initialized = %f;
INI.skip_init = %t;
INI.batch = %f;
INI.tPumpFail = %inf;
LIN.open_tv = 0;

// Fuel properties
FP.dwdc = DWDC(FP.sg);
FP.avis = AVIS(FP.sg, FP.kvis);
FP.tvp = 7;
FP.tvp_margin = -1e6;

// Structures
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

// Temporary.  TODO:  remove this line and use zcos diagram + pre_xcos...
exec('./Callbacks/PreLoadFcn_simul.sce', -1);



function gstr = %geo_string(g)
    // string geo overload
    gstr = '';
    gstr = msprintf('''%s'' type:  \n', typeof(g));
    gstr = gstr + msprintf('vdpp = %s;\n', string(g.vdpp));
    gstr = gstr + msprintf('vsv = %s;\n', string(g.vsv));
    gstr = gstr + msprintf('reg = %s;\n', string(g.reg));
    gstr = gstr + msprintf('pact = %s;\n', string(g.pact));
    gstr = gstr + msprintf('pact_lk = %s;\n', string(g.pact_lk));
    gstr = gstr + msprintf('vlink = %s;\n', string(g.vlink));
    gstr = gstr + msprintf('ehsv_klk = %s;\n', string(g.ehsv_klk));
    gstr = gstr + msprintf('ehsv_powlk = %s;\n', string(g.ehsv_powlk));
    gstr = gstr + msprintf('rrv = %s;\n', string(g.rrv));
    gstr = gstr + msprintf('vo_pcham = %s;\n', string(g.vo_pcham));
    gstr = gstr + msprintf('vo_vpx = %s;\n', string(g.vo_vpx));
    gstr = gstr + msprintf('bias = %s;\n', string(g.bias));
    gstr = gstr + msprintf('mv = %s;\n', string(g.mv));
    gstr = gstr + msprintf('mvtv = %s;\n', string(g.mvtv));
    gstr = gstr + msprintf('hs = %s;\n', string(g.hs));
    gstr = gstr + msprintf('noz = %s;\n', string(g.noz));
    gstr = gstr + msprintf('mo_p3s = %s;\n', string(g.mo_p3s));
    gstr = gstr + msprintf('vo_p2 = %s;\n', string(g.vo_p2));
    gstr = gstr + msprintf('vo_p3 = %s;\n', string(g.vo_p3));
    gstr = gstr + msprintf('vo_p1so = %s;\n', string(g.vo_p1so));
    gstr = gstr + msprintf('vo_px = %s;\n', string(g.vo_px));
    gstr = gstr + msprintf('vo_p3s = %s;\n', string(g.vo_p3s));
    gstr = gstr + msprintf('vo_pnozin = %s;\n', string(g.vo_pnozin));
    gstr = gstr + msprintf('ln_p3s = %s;\n', string(g.ln_p3s));
    gstr = gstr + msprintf('ln_vs = %s;\n', string(g.ln_vs));
    gstr = gstr + msprintf('main_line = %s;\n', string(g.main_line));
    gstr = gstr + msprintf('a_p3s = %s;\n', string(g.a_p3s));
    gstr = gstr + msprintf('a_tvb = %s;\n', string(g.a_tvb));
    gstr = gstr + msprintf('mvwin = %s;\n', string(g.mvwin));
endfunction

function %geo_p(g)
    disp(string(g));
endfunction


loaded_scratch = %f;
LINCOS_OVERRIDE = 0;
LINCOS_OPEN_LOOP = 0;
exec('Callbacks\pre_xcos_simulate_default.sci');
exec('Callbacks\post_xcos_simulate_default.sci');
loadXcosLibs(); loadScicos();


if ~win64() then
  warning(_("This module requires a Windows x64 platform."));
  return
end

// Load library
exec('../Lib/init_libScratch.sce', -1);
chdir(this_path);

mprintf('Executed ' + this + ' up to importXcosDiagram*********\n');
mprintf('Ready to play...press the right arrow icon on %s diagram at top.\n', root);

try
    importXcosDiagram("./"+this_xcos_file);
    xcos('./'+this_xcos_file);
catch
    importXcosDiagram("./"+this_zcos_file);
    xcos('./'+this_zcos_file);
end
//scicos_simulate(scs_m);
//scs_m.props.context


