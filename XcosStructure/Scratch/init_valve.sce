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
exec('../Lib/init_libScratch.sce', -1);
chdir(this_path);
n_fig = -1;
xdel(winsid())
//mclose('all');   This cannot be scripted, has to be called at command line


global m k c
global loaded_scratch
global GEO INI
global start02_x start02_v
global start02_ph start02_prs start02_pxr start02_ps
global start02_wfs start02_wfh start02_wfvr start02_wfvx
Tf = 0.01;

//valve_scratch = tlist(["valve_a", "m", "c", "fstf", "fdyf", "xmin", "xmax"], 0,0,0,0,0,0);
//GEO = tlist(["sys_geo", "valve_scratch"], valve_scratch);
GEO = tlist(["sys_geo", "vsv"], vlv_a_default);
ady = tlist(["tbl1_b", "tb"], [-1, 0; 0, 0; 2, 20;]);
ahy = tlist(["tbl1_b", "tb"], [-1, 0; 0, 0; 2, 2;]);
valve_scratchy = tlist(["vlv_a", "m", "c", "fstf", "fdyf", "xmin", "xmax", "ad", "ah"],..
    7000, 0, 0, 0, -%inf, %inf, ady, ahy);
valve_scratchx = list(4000, 0, 0, 0, -%inf, %inf, [-1, 0; 0, 0; 2, 20;], [-1, 0; 0, 0; 2, 20;]);
GEOx = tlist(["sys_geox", "valve_scratchx"], valve_scratchx);
function %sys_geo_p(g)
    // Display geo overload
    mprintf('sys_geo:  \n');
    disp(g.vsv)
endfunction
function %valve_a_p(v)
    // Display valve overload
    mprintf('valve_a:  m=%f, c=%f, fstf=%f, fdyf=%f, xmin=%f, xmax=%f\n',..
         v.m, v.c, v.fstf, v.fdyf, v.xmin, v.xmax);
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
//
lib_path = get_absolute_file_path(this)+'..\Lib\';
//
// ulink previous function with same name
[bOK, ilib] = c_link('lim_int');
if bOK then
  ulink(ilib);
end
//
link(SCI + '\bin\scicos' + getdynlibext());
link(lib_path + 'libScratch' + getdynlibext(), ['valve_a'], 'c');
link(lib_path + 'libScratch' + getdynlibext(), ['friction'], 'c');
link(lib_path + 'libScratch' + getdynlibext(), ['lim_int'], 'c');
// remove temp. variables on stack
//clear lib_path;
clear bOK;
clear ilib;
// ----------------------------------------------------------------------------
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


