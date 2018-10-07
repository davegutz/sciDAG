function [wf] = la_kptow(k, ps, pd, kvis)
    // function wf = la_kptow(k, ps, pd, kvis)
    // Laminar orifice function, area/pressure to flow.
    // Author:    D. A. Gutz
    // Written:   22-Jun-92
    // Revisions: None.
    // 
    // Input:
    // k    Laminar coefficient
    // pd   Discharge pressure, psia.
    // ps   Supply pressure, psia.
    // kvis Kinematic viscosity, centistokes
    // 
    // Output:
    // wfFlow, pph.
    // Functions called:
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
    wf=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Perform
    wf = k*(ps-pd)/max(kvis, 1e-24);
    
endfunction
