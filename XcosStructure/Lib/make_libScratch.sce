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
// Dec 27, 2018     DA Gutz     Created
// Jan 7, 2019      DA Gutz     Add table1_a
// 

funcprot(0);
getd('../Lib')
lib_path = get_absolute_file_path(sfilename());
chdir(lib_path);
libs = SCI + '\bin\scicos'
incs1 = SCI + '\modules\scicos_blocks\includes'
entries = ['lim_int',   'friction',     'valve_a',      'trivalve_a1',  'hlfvalve_a',..
           'table1_a',  'head_b',       'actuator_a_b', 'binsearch',    'tab1',..
           'tab2',      'hole',         'cor_aptow',    'cor_awpstopd', 'cor_awpdtops',..
           'ctab1',     'vdp',          'cla_lrecptow', 'actuator_a_c',...
           'cpmps',     'cpmpd',        'intgl'];
sources = ['lim_int_comp.c',    'friction_comp.c',  'valve.c',      'table.c',..
           'orifice.c',         'hyd_mod.c',        'device.c',     'pump.c',..
           'dyn.c'];
ilib_for_link(entries, sources, libs, 'c', '', 'LibScratchLoader.sce', 'Scratch', '','-I'+incs1, '', '');

// Have to re-init any simulations after re-make
clear
clearglobal
xdel(winsid())
mclose('all');
// Old versions clear does not clear functions
r = ver();
version = strsplit(r(1,2), '.');
version = strtod(version(1));
if version<6 then
    listf = listfunctions();
    for i = 1:size(listf,2)
        evstr('clear ' + listf(i))
    end
end
clear r version

