function [sys] = lti_vol_1(vol, %beta, spgr)
    // VOL1.  Building block for a volume having two flow inputs.
    //  Author:     D. A. Gutz
    //  Written:    16-Apr-92
    //  Revisions:  None.
    //
    //  Input:
    //  beta        Fluid bulk modulus, psi.
    //  spgr        Fluid specific gravity.
    //  vol         Volume, cuin.
    //  wfs         Input # 1, supply flow, pph.
    //  wfd         Input # 2, discharge flow, pph.
    //
    //  Output:
    //  sys         Packed system of Input and Output
    //  p           Output # 1, volume pressure, psia.
    //
    // 
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

    //  Derivative
    dp = ((%beta/129.93948)/vol)/spgr;  // Derivative, psi/sec.
    a = 0;
    b = [dp, -dp];
    c = 1;
    e = [0, 0];

    //  Form the system.
    sys = pack_ss(a, b, c, e);

endfunction
