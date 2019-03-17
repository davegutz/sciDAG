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
[D, N, time] = load_csv_data('./Data/start04.ven.csv', 1);
exec('./Data/load_decode_csv_data.sce', -1);
[D, N, time] = load_csv_data('./Data/start04.ifc.csv', 1);
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
LIN.open_tv = 0;

// Fuel properties
FP.sg = fp_sg.values(1,:);
FP.beta = fp_beta.values(1,:);
FP.kvis = fp_kvis.values(1,:);
FP.dwdc = DWDC(FP.sg);
FP.avis = AVIS(FP.sg, FP.kvis);
FP.tvp = 7;

// Objects
vlink_default = tlist(["ven_link", "ctqpv", "cva", "cdv", "cftpa", "ytqa", "ytqrs"],..
                            0, 0, 0, 0, ctab1_default, ctab1_default);
GEO = tlist(["sys_geo", "vdpp", "vsv", "reg", "pact", "pact_lk", "vlink", "mv", "mvtv", "hs", "noz", "mo_p3s", "vo_p2", "vo_p3", "vo_p1so", "vo_px", "vo_p3s", "vo_pnozin", "ln_p3s", "ln_vs", "main_line", "a_p3s", "a_tvb", "mvwin"], vdp_default, vlv_a_default, tv_a1_default,  actuator_a_b_default, la_default, vlink_default, hlfvlv_a_default, vlv_a_default, head_b_default, ctab1_default, mom_default, vol_default, vol_default, vol_default, vol_default, vol_default, vol_default, pipeVM_default, pipeVM_default, pipeMM_default, or_default, or_default, ctab1_default);
VEN = tlist(["sys_ven", "vdpp", "vsv", "reg"], vdp_default, vlv_a_default, tv_a1_default);
IFC = tlist(["sys_ifc", "mvtv", "hs"], vlv_a_default, head_b_default);
IFC_mvtv = vlv_a_default;

function %sys_geo_p(g)
    // Display geo overload
    mprintf('sys_geo:  \n');
    disp(g.vsv)
    disp(g.reg)
    disp(g.mv)
    disp(g.hs)
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


