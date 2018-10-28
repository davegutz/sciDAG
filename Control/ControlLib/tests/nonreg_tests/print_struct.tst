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
clear
funcprot(0);
mclose('all');
getd('../ControlLib')

A = struct('d',%t, 'b',1, 'e',%nan, 'a',2, 'f', 'myF', 'c',3, 'd',int8(4), 'e', int16(5), 'f', int32(6));
B = struct('second', A, 'third', A, 'first', A, 'fourth', %t);
D = struct('primary', A, 'secondary', B);

[fdo, err] = mopen('tests/nonreg_tests/print_struct_tst.csv', 'wt');
print_struct(D, 'D', fdo, ',');
mclose(fdo);
mgetl('tests/nonreg_tests/print_struct_tst.csv')

print_struct(D, 'D', 6, ',');

[fdo, err] = mopen('tests/nonreg_tests/print_struct_tst.csv', 'wt');
print_struct(D, 'D', fdo, ',');
mclose(fdo);
mgetl('tests/nonreg_tests/print_struct_tst.csv')
