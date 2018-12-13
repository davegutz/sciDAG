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
// Dec 3, 2018 	DA Gutz		Created
// 
funcprot(0);
//getd('../../Control/ControlLib')
n_fig = -1;
xdel(winsid())
//mclose('all');
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
importXcosDiagram("./scratch552.xcos");
xcos('./scratch552.xcos');
scicos_simulate(scs_m);
scs_m.props.context


