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
// Oct 18, 2018 	DA Gutz		Created
// 

clear
getd('../ControlLib')
exec('myServo.sci', -1)
n_fig = -1;
xdel(winsid())

// Read from file
testInFile = 'testIn.csv';
M = csvRead(testInFile,[],[],'string',[],'/\/\//');
//M = csvRead(testInFile,[],[],'string',[],"/^\s*$/");

[nrow, ncol] = size(M);
Mnames = csvRead(testInFile,[],[],'string',[],[],[1 1 nrow 1]);
Mvals =  csvRead(testInFile,[],[],'string',[],[],[1 2 nrow ncol]);
j = 1;
for i=1:nrow-1
    execstr(Mnames(i)+'='+Mvals(i,j))
end

p_struct(P, 'P');
p_struct(C, 'C');
p_struct(MU, 'MU');
p_struct(R, 'R');
p_struct(WC, 'WC');
disp(speedf)
disp(boundsmax)
