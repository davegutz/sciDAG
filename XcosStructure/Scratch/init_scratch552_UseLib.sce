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
// Dec 3, 2018      DA Gutz     Created
// 
funcprot(0);
getd('../Lib')
this = 'init_scratch552_UseLib.sce';
this_xcos_file = 'scratch552_UseLib.xcos';
this_path = get_absolute_file_path(this);
chdir(this_path);
exec('../Lib/init_libScratch.sce', -1);
chdir(this_path);
n_fig = -1;
xdel(winsid())
//mclose('all');   This cannot be scripted, has to be called at command line
global plant A B C D
global loaded_scratch
A=0;B=1;C=1;D=0;
loaded_scratch = %f;
plant.a = A;
plant.b = B;
plant.c = C;
plant.d = D;
exec('Callbacks\pre_xcos_simulate.sci');
exec('Callbacks\post_xcos_simulate.sci');
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
link('C:\PROGRA~1\SCILAB~1.2\bin\scicos' + getdynlibext());
link(lib_path + 'libScratch' + getdynlibext(), ['friction'], 'c');
link(lib_path + 'libScratch' + getdynlibext(), ['lim_int'], 'c');
// remove temp. variables on stack
//clear lib_path;
clear bOK;
clear ilib;
// ----------------------------------------------------------------------------
mprintf('Executed ' + this + ' up to importXcosDiagram*********\n');


importXcosDiagram("./"+this_xcos_file);
xcos('./'+this_xcos_file);
//scicos_simulate(scs_m);
//scs_m.props.context


