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
global GEO INI FP LIN mv_x mv_xa mv_xin Tf
global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb

// Auto data overplot load
[D, N, time] = load_csv_data('./Data/start04ss.ven.csv', 1);
exec('./Data/load_decode_csv_data.sce', -1);
[D, N, time] = load_csv_data('./Data/start04ss.ifc.csv', 1);
exec('./Data/load_decode_csv_data.sce', -1);

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
FP.sg = fp_sg.values(1,:);
FP.beta = fp_beta.values(1,:);
FP.kvis = fp_kvis.values(1,:);
FP.dwdc = DWDC(FP.sg);
FP.avis = AVIS(FP.sg, FP.kvis);
FP.tvp = 7;

// Objects
vlink_default = tlist(["vlk", "ctqpv", "cva", "cdv", "cftpa", "ytqa", "ytqrs",..
                       "cdabdamp", "fsb", "ksb"],..
                       0, 0, 0, 0, ctab1_default, ctab1_default,..
                       0, 0, 0);
function str = %vlk_string(v)
    // Display head_b type
    str = msprintf('''%s'' type:  ctqpv=%f, cva=%f, cdv=%f, cftpa=%f,',..
             typeof(v), v.ctqpv, v.cva, v.cdv, v.cftpa);
    str = str + 'ytqa: ' + string(v.ytqa) + ',';
    str = str + 'ytqrs: '+ string(v.ytqrs);
endfunction
function str = %vlk_p(v)
    // Display vlink type
    str = string(v);
    disp(str)
endfunction

GEO = tlist(["sys_geo", "vdpp", "vsv", "reg", "pact", "pact_lk", "vlink", "ehsv_klk", "ehsv_powlk", "rrv", "vo_pcham", "vo_px", "bias", "mv", "mvtv", "hs", "noz", "mo_p3s", "vo_p2", "vo_p3", "vo_p1so", "vo_px", "vo_p3s", "vo_pnozin", "ln_p3s", "ln_vs", "main_line", "a_p3s", "a_tvb", "mvwin"], vdp_default, vlv_a_default, tv_a1_default,  actuator_a_b_default, la_default, vlink_default, 0, 0, vlv_a_default, vol_default, vol_default, actuator_a_b_default, hlfvlv_a_default, vlv_a_default, head_b_default, ctab1_default, mom_default, vol_default, vol_default, vol_default, vol_default, vol_default, vol_default, pipeVM_default, pipeVM_default, pipeMM_default, or_default, or_default, ctab1_default);
VEN = tlist(["sys_ven", "vdpp", "vsv", "reg", "pact", "pact_lk", "vlink", "vleak", "rrv", "vo_pcham", "vo_px", "bias"], vdp_default, vlv_a_default, tv_a1_default, actuator_a_b_default, la_default, vlink_default, la_default, vlv_a_default, vol_default, vol_default, actuator_a_b_default);
IFC = tlist(["sys_ifc", "mv", "mvtv", "hs", "mo_p3s", "vo_p2",  "vo_p3", "vo_p1so", "vo_px", "vo_p3s", "ln_p3s", "a_p3s", "a_tvb", "mvwin", "check"], hlfvlv_a_default, vlv_a_default, head_b_default, mom_default, vol_default, vol_default, vol_default, vol_default, vol_default, pipeVM_default, or_default, or_default, ctab1_default, vlv_a_default);
G = tlist(['geo', 'ifc'], IFC);
IFC_mvtv = vlv_a_default;

function gstr = %sys_geo_string(g)
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
    gstr = gstr + msprintf('vo_px = %s;\n', string(g.vo_px));
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

function %sys_geo_p(g)
    // Display system geometry (sys_geo) type
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

try
    importXcosDiagram("./"+this_xcos_file);
    xcos('./'+this_xcos_file);
catch
    importXcosDiagram("./"+this_zcos_file);
    xcos('./'+this_zcos_file);
end
//scicos_simulate(scs_m);
//scs_m.props.context


