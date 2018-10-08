// Differential addition
// Author:      D. A. Gutz
// Written:     26-Jun-92
// Revisions:   19-Aug-92    Simplify return arguments.
// 
// Input:
// s        Sensitivity, dOut/dIn.
// 
// Differential IO.
// x1           Input # 1, first
// x2           Input # 2, second
// x3           Input # 3, third
// x4           Input # 4, fourth
// sum          Output # 1, sum of inputs .* sensitivity
// 
// Output:
// sys          Packed system definition.
// 
// Local:
// None.
// 
// States:
// none.
// 
// Functions called:
// none.

// Parameters.
// none.

// Partials.
// none.
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
//**********************************************************************

function [sys] = summer(s1, s2, s3, s4)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Connections and system construction.
    a = [];
    b = [];
    c = [];
    e = [s1,s2,s3,s4];
    sys = pack_ss(a,b,c,e);

endfunction
