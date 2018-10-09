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
a = 1;
b = -0.1;
c = 0;
f = 0;
r1 = 0.5;
b1 = 0.5;
r2 = 2.0;
b2 = 0.5;
rpm = 10000;
wf = 10000;
sg = 1;
tau = 0.007;
pmp = lti_ip_wpstopd(a, b, c, f, r1, b1, r2, b2, rpm, wf, sg, tau);
[a, b, c, d] = unpack_ss(pmp)
