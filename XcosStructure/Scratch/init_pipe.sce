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
// Jan 7, 2019      DA Gutz     Created
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


global loaded_scratch root
global pipe_vv pipe_mv INI FP ori Press 
FP = tlist(["fuel", "sg", "beta"], 0.8, 135000);
pipe_vv = tlist(["pipeVV", "l", "a", "vol", "n", "spgr", "beta", "c", "lti", "A", "B", "C", "D"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 3, FP.sg, FP.beta, 0, [], [], [], [], []);
pipe_mv = tlist(["pipeMV", "l", "a", "vol", "n", "spgr", "beta", "c", "lti", "A", "B", "C", "D"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 3, FP.sg, FP.beta, 0, [], [], [], [], []);
Press = 1;
Tf = 0.02;
ori = tlist(["orifice", "a", "cd"], 0.001, 0.61);
function [ps] = %pipe_string(p)
    // Start
    ps = msprintf('list(');
    // Scalars
    ps = ps + msprintf('%f,%f,%f,%d,%f,%f,%f', p.l, p.a, p.vol, p.n, p.spgr, p.beta, p.c);
    // End
    ps = ps + msprintf(')');
endfunction
function lis = lsx_pipe(p)
    lis = list(p.l, p.a, p.vol, p.n, p.spgr, p.beta, p.c);
endfunction
function str = %pipe_p(p)
    // Display pipe type
    str = string(p);
    disp(str)
endfunction

loaded_scratch = %f;

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
link(SCI + '\bin\scicos' + getdynlibext());
link(lib_path + 'libScratch' + getdynlibext(), ['cor_awpdtops'], 'c');
link(lib_path + 'libScratch' + getdynlibext(), ['cor_awpstopd'], 'c');
link(lib_path + 'libScratch' + getdynlibext(), ['cor_aptow'], 'c');
// remove temp. variables on stack
//clear lib_path;
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


