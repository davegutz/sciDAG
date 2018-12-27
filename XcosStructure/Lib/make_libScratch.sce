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
// Dec 27, 2018    DA Gutz        Created
// 
try
    this_saved = this;
end
this = 'make_libScratch.sce';
lib_path = get_absolute_file_path(this);
chdir(lib_path);
libs = 'C:\PROGRA~1\SCILAB~1.2\bin\scicos'
incs = 'C:\PROGRA~1\SCILAB~1.2\modules\scicos_blocks\includes'
entries = ['lim_int', 'friction'];
sources = ['lim_int_comp.c', 'friction_comp.c'];
ilib_for_link(entries, sources, libs, 'c', '', 'LibScratchLoader.sce', 'Scratch', '','-I'+incs, '', '');
try
    this = this_saved;
end
