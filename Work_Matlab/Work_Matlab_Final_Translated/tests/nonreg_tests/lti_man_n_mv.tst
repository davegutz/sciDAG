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
// Sep 26, 2018 	DA Gutz		Created
// 

//mfile2sci('./<mfile>.m', 'C:/Users/Dave/Documents/GitHub/sciDAG/Work_Matlab/Work_Matlab_Initial_Translated/')

// Copy ./Work_Matlab_Initial_Translated/<mfile>.sci to Work_Matlab_Final_Translated/pack_ss.sci and edit it

// run this in Work_Matlab_Final_Translated
clear
funcprot(0);
getd('../Work_Matlab_Final_Translated')
man_n_mv = lti_man_n_mv(24, 0.1, 2.4, 4, 0.8, 150000, 1)
man_n_mv = lti_man_n_mv(24, 0.1, 2.4, 4, 0.8, 150000, 0)

man_n_mv = lti_man_n_mv(24, 0.1, 2.4, 4, 0.8, 150000, 1);
sys_siso = connect_ss(man_n_mv, [], [1], [2]);
[a,b,c,d]=unpack_ss(sys_siso); man_n_mv_lti = syslin('c',a,b,c,d);
spec(a)
epsa = 1e-32; epsr = 1e-32;
man_n_mv_ltitf = clean(ss2tf(man_n_mv_lti), epsa, epsr);
bode(man_n_mv_ltitf, 1, 100000)


