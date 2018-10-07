function [sys,dp] = ip_wtodp(a,b,c,d,r1,b1,r2,b2,rpm,wf,sg,tau)
    // function [sys, dp] = ip_wtodp(a, b, c, d, r1, b1, r2, b2, rpm, wf, sg, tau)
    // Impeller model, flow and discharge pressure to supply.
    // Author:   D. A. Gutz
    // Written:  08-Jul-92
    // Revisions: 19-Aug-92 Simplify return arguments.
    // 
    // Input:
    // a     Pump head coefficients.
    // b              """"
    // c              """"
    // d              """"
    // r1    Inner radius, in.
    // b1    Inner disk width, in.
    // r2    Outer radius, in.
    // b2    Outer disk width, in.
    // rpm   Speed.
    // wf    Flow, pph.
    // sg    Specific gravity.
    // tau   Time constant, sec.
    // 
    // Differential IO:
    // wf  Input #  1, flow, pph.
    // ps  Input #  2, supply pressure, psi.
    // rpm Input #  3, speed, rpm.
    // pd  Output # 1, discharge pressure, psi.
    // 
    // Output:
    // sys   Packed system of Input and Output.
    // pd-ps Pressure rise, psid
    //
    // Local:
    // q  Connection matrix.
    // u  Input matrix.
    // y  Output matrix.
    //
    // States:
    // none.
    //
    // Functions called:
    // None.
    //
    // Parameters.
    // fc    Flow coefficient.
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
    dp=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // dwdc  Conversion cis to pph.
    dwdc = 129.93948*sg;
    fc = ((5.851*wf)/dwdc)/(((3.85*b2)*(r2^2))*rpm);
    hc = a + (b + (c + d*fc)*fc)*fc;
    dp = (((0.000001022*hc)*sg)*(r2^2 - r1^2))*(rpm^2);

    // Partials.
    // dfcdwf  Flow coefficient due to flow, 1/pph.
    // dhcdfc  Head coefficient due to flow coefficient.
    // dpdhc   Pressure due to head coefficient, psi.
    // dfcdrpm Flow coefficient due to speed, 1/rpm.
    dfcdwf = fc/wf;
    dhcdfc = b + 2*c*fc;
    dpdhc = ((0.000001022*sg)*(r2^2-r1^2))*(rpm^2);
    dfcdrpm = -fc/rpm;

    // Connections and system construction.
    as = -1/tau;
    bs = [((dfcdwf*dhcdfc)*dpdhc)/tau, 0, ((dfcdrpm*dhcdfc)*dpdhc)/tau];
    cs = -1;
    es = [0,1,0];
    sys = pack_ss(as, bs, cs, es);
endfunction
