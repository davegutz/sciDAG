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
getd('../ControlLib')

A = struct('d',%t, 'b',1, 'e',%nan, 'a',2, 'f', 'myF', 'c',3);
B = struct('second', A, 'third', A, 'first', A, 'fourth', %t);
C(1) = A; C(2) = B;

As = order_all_fields(A);
Bs = order_all_fields(B);
errmsg = msprintf('**** Just plain struct, not array*****');
assert_checkerror("Cs = order_all_fields(C);", errmsg);

D(1)=As; D(2) = As;

[fdo, err] = mopen('tests/nonreg_tests/order_all_fields_tst.csv', 'wt');
print_struct(D, 'D', fdo, ',');
mclose(fdo);

mgetl('tests/nonreg_tests/order_all_fields_tst.csv')

