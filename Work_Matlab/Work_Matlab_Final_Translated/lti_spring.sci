// function sys = lti_spring(s1, s2, ks)
// Building block for spring
// Author:       D. A. Gutz
// Written:      26-Aug-92
// Revisions:    
// 
// Input:
// s1    Sign of x1
// s2    Sign of x2
// ks    Spring rate, lbf/in
// 
// Output:
// sys        Packed system of Input and Output
// 
// Differential IO:
// x1    Input  # 1, spring end disp to compress, in
// x2    Input  # 2, spring end disp to compress, in
// f     Output # 1, spring compression, lbf
//-f     Output # 2, spring extension, lbf
// 
// Local:
// none
// 
// States:
// none
// 
// Functions called:
// none
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
// Oct 13, 2018    DA Gutz    Created
// **************************************************************************
function [sys] = lti_spring(s1, s2, ks)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Parameters:
    // none

    // Partials.
    // none.

    // Connections and system construction.
    as = [];bs = [];cs = [];
    es = [ks*s1, ks*s2;  (-ks)*s1, (-ks)*s2];
    sys = pack_ss(as, bs, cs, es);

endfunction
