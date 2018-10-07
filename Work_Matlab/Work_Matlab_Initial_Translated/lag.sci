function [sys] = lag(tau)
    //  sys = lag(tau)
    //  Building block for simple first order lag.
    //  Author:     D. A. Gutz
    //  Written:    26-Jun-92
    //  Revisions:  19-Aug-92 Simplify return arguments.
    // 
    //  Input:
    //  tauTime constant, sec.
    //  Differential IO:
    //  xInput # 1.
    //  yOutput # 1, lagged by tau.
    //  Output:
    //  sysPacked system of Input and Output.
    //  Local:
    //  qConnection matrix.
    //  uInput matrix.
    //  yOutput matrix.
    //  States:
    //  yOutput.
    //  Functions called:
    //  None.
    //  Parameters.
    //  None.
    //  Partials.
    //  None.
    //  Connections and system construction.
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


    // Output variables initialisation (not found in input variables)
    sys=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Perform
    a = -1/tau;
    b = 1/tau;
    c = 1;
    e = 0;
    sys = pack_ss(a, b, c, e);
    
endfunction
