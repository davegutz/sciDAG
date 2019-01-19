// function sys = lti_mom_1(l, a, c)
// Building block for a momentum slice having two pressure inputs.
// Author:       D. A. Gutz
// Written:      17-Apr-92
// Revisions:    10-Dec-98    Add damping, c.
// 
// Input:
// a    Cross sectional area, sqin.
// l    Slice length, in.
// c    Damping, psi/in/sec, (OPTIONAL).
// 
// Output:
// sys  Packed system description of Input and Output.
// 
// Differential I/O:
// ps   Input # 1, supply pressure, psia.
// pd   Input # 2, discharge pressure, psia.
// wf   Output # 1, slice flow, pph.
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
// Oct 10, 2018     DA Gutz     Created
// Jan 19, 2019     DA Gutz     Damping added so no effect on dc gain
// ******************************************************************************
function [sys] = lti_mom_1(l,a,c)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Number of arguments in function call
    [%nargout,%nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Derivatives.   Damping must not be passed through to dc gain
    dw = ((3600*386)*a)/l;// Derivative, pph/sec.
    if %nargin==3 then
        dp = (c*l)*sqrt((a*4)/%pi);  // Damping, pph/sec/pph
        b = [dw*dp,-dw*dp];
    else
        dp = 0;
        b = [dw,-dw];
    end;
    a = -dp;
    c = 1;
    e = [0,0];

    // Form the system.
    sys = pack_ss(a,b,c,e);

endfunction
