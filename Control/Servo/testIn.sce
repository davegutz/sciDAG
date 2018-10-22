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
commentDelim = '/\/\//';
M = csvRead(testInFile,[],[],'string',[],commentDelim);
// TODO:  use csvTextScan instead so don't load the file three times
// could use size() to get number of lines and read csvTextScan first
// row to get number of columns.
[nrow, ncol] = size(M);
Mnames = M(:, 1);
// Assume data lines have trailing comma at end of line e.g. 'input=2,2,3,'
// Trailing comma requires '-1' in next line.
Mvals =  M(:, 2:ncol-1);
mcol = size(Mvals, 'c');
testOutFile = 'testOut.csv';
[fdo, err] = mopen(testOutFile, 'wt');
if err<>0 then
    mprintf('testIn.sce: error %d opening %s...', err, testOutFile);
end
for j = 1:mcol
    for i=1:nrow
        execstr(Mnames(i)+'='+Mvals(i, j))
    end
    p_struct(P, 'P');
    disp(Config)
    disp(Desc)
    disp(PSO.speedf)
    disp(PSO.boundsmax)
    // Write to file
    p_struct(Config, 'Config', fdo);
    p_struct(Desc, 'Desc', fdo);
    p_struct(dT, 'dT', fdo);
    p_struct(verbose, 'verbose', fdo);
    p_struct(f_min, 'f_min', fdo);
    p_struct(f_max, 'f_max', fdo);
    p_struct(P, 'P', fdo);
    p_struct(C, 'C', fdo);
    p_struct(MU, 'MU', fdo);
    p_struct(R, 'R', fdo);
    p_struct(WC, 'WC', fdo);
    p_struct(PSO, 'PSO', fdo);
end

mclose(fdo);

