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

//mfile2sci('./pack_ss.m', 'C:/Users/Dave/Documents/GitHub/sciDAG/Work_Matlab/Work_Matlab_Initial_Translated/')

// Copy ./Work_Matlab_Initial_Translated/pack_ss.sci to Work_Matlab_Final_Translated/pack_ss.sci and edit it

// run this in Work_Matlab_Final_Translated
clear
funcprot(0)
getd('../Work_Matlab_Final_Translated')
a = [1 2
     3 4];
b = [5
     6];
c = [7 8
     9 10];
e = [11
    12];
sys = pack_ss(a, b, c, e);
mprintf('\nsys=\n');
disp(sys)


sysadjoined = adjoin(sys, sys);
mprintf('\nsysadjoined=\n');
disp(sysadjoined)

// Expected result
//sys=
//
//   1.    2.    Nan   5. 
//   3.    4.    Nan   6. 
//   Nan   Nan   Nan   Nan
//   7.    8.    Nan   11.
//   9.    10.   Nan   12.
//
//sysadjoined=
//
//   1.    2.    0.    0.    Nan   5.    0. 
//   3.    4.    0.    0.    Nan   6.    0. 
//   0.    0.    1.    2.    Nan   0.    5. 
//   0.    0.    3.    4.    Nan   0.    6. 
//   Nan   Nan   Nan   Nan   Nan   Nan   Nan
//   7.    8.    0.    0.    Nan   11.   0. 
//   9.    10.   0.    0.    Nan   12.   0. 
//   0.    0.    7.    8.    Nan   0.    11.
//   0.    0.    9.    10.   Nan   0.    12.
//
