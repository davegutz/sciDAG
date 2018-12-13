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
clearglobal
funcprot(0);
//mclose('all');
getd('../ControlLib')
n_fig = -1;
//xdel(winsid())

myBodePlot();
xs2pdf(0, 'tests\nonreg_tests\myBodePlotTest')
winopen('tests\nonreg_tests\myBodePlotTestRef.pdf')
copyfile('tests\nonreg_tests\myBodePlotTest.pdf', 'tests\nonreg_tests\myBodePlotTestNow.pdf')
winopen('tests\nonreg_tests\myBodePlotTestNow.pdf')
xs2png(0, 'tests\nonreg_tests\myBodePlotTest')
winopen('tests\nonreg_tests\myBodePlotTestRef.png')
copyfile('tests\nonreg_tests\myBodePlotTest.png', 'tests\nonreg_tests\myBodePlotTestNow.png')
winopen('tests\nonreg_tests\myBodePlotTestNow.png')
assert_checkfilesequal ('tests\nonreg_tests\myBodePlotTest.png' , 'tests\nonreg_tests\myBodePlotTestRef.png')
