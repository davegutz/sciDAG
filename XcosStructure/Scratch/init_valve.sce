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
global loaded_scratch
global GEO INI FP
global start02_x        start02_v
global start02_ph       start02_prs     start02_pxr
global start02_ps       start02_wfs     start02_wfh
global start02_wfvrs    start02_wfvx    start02_uf
global start02_uf_net   start02_px start02_a
global start02_t_x      start02_t_v     start02_t_ped
global start02_t_pes    start02_t_pd    start02_t_pld
global start02_t_plr    start02_t_ps    start02_t_wfd
global start02_t_wfde   start02_t_wfld  start02_t_wfle
global start02_t_wflr   start02_t_wfs   start02_t_wfse
global start02_t_wfxd   start02_t_wfsx  start02_t_wfx
global start02_t_uf_net start02_t_uf    start02_t_fext
global start02_t_pel    start02_t_px
global start02_h_x      start02_h_v     start02_h_ps
global start02_h_x      start02_h_v     start02_h_ps
global start02_h_px     start02_h_pr    start02_h_pc
global start02_h_pa     start02_h_pw    start02_h_pd
global start02_h_wfs    start02_h_wfd   start02_h_wfsr
global start02_h_wfwd   start02_h_wfx   start02_h_wfwx
global start02_h_wfxa   start02_h_wfrc  start02_h_wfx
global start02_h_wfa    start02_h_wfc   start02_h_wfr
global start02_h_uf_net start02_h_uf    start02_h_wfw
global start02_b_x      start02_b_v     start02_b_pf 
global start02_b_ph     start02_b_pl    start02_b_plx
global start02_b_wff    start02_b_wfh   start02_b_wfl
global start02_b_uf_net start02_b_uf    start02_b_f_f
global start02_b_f_cf

Tf = 0.001;

GEO = tlist(["sys_geo", "vsv", "reg", "mv", "hs"], vlv_a_default, tv_a1_default, hlfvlv_a_default, head_b_default);

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
exec('Callbacks\pre_xcos_simulate_' + root + '.sci');
exec('Callbacks\post_xcos_simulate_' + root + '.sci');
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


