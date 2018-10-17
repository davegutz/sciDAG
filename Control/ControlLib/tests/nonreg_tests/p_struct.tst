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
getd('../ControlLib')

// Read from file
testInFile = 'tests/nonreg_tests/p_struct.csv';
M = csvRead(testInFile,[],[],'string');
[nrow, ncol] = size(M);
Mnames = csvRead(testInFile,[],[],'string',[],[],[2 1 nrow 1]);
Mvals =  csvRead(testInFile,[],[],'string',[],[],[2 2 nrow ncol]);
j = 2;
for i=1:nrow-1
    execstr(Mnames(i)+'='+Mvals(i,j))
end

// Recursive extraction experiment
// exec('p_struct.sci', -1)
p_struct(sys, 'sys');
p_struct(sys, 'sys', 6, ';');

testOutFile = 'tests/nonreg_tests/p_struct.txt';
fd = mopen(testOutFile, 'wt');
p_struct(sys, 'sys', fd, ';');
mclose(fd);
mgetl(testOutFile)
