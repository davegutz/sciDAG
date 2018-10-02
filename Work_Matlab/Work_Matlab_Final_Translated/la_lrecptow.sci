function [wf] = la_lrecptow(l, r, e, c, ps, pd, kvis)
    // la_lrecptow
    // Purpose:    Calculate laminar flow
    // Author:     Dave Gutz   22-Jul-92   Created
    // 
    // Inputs:
    // l         Length, in
    // r         Radius, in
    // e         Eccentricity, in
    // c         Radial clearance, in
    // ps        Supply pressure, psia
    // pd        Discharge pressure, psia
    // kvis      Kinematic viscosity, centistokes
    // 
    // Output:
    // wf        Flow, pph
    //#define la_lrecptow(L, R, E, C, PS, PD, KVIS)\
    //                    (4.698e8 * (R) *((C)*(C)*(C)) / (KVIS) /\
    //     (L) * (1. + 1.5 * sqr((E)/(C))) * ((PS) - (PD)))
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
    wf = (((((469800000*r)*((c*c)*c))/kvis)/l)*(1+1.5*((e/c)^2)))*(ps-pd);

endfunction
