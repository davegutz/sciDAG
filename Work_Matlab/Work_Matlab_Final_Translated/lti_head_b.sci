// function sys = lti_head_b(ae, bdamp, cdf, dn, ks, kb, pf, ph, sg, wff, m);
// Building block for a bellows head sensor.  Version with ph,
// pl, & pf input and wfh, wfl, & wff output, mass.
// Author:       D. A. Gutz
// Written:      02-Dec-92    Add mass to head_a.
// Revisions:
// 
// Input:
// ae     Sense bellows area, sqin.
// bdamp  Damping, lbf/(in/sec).
// cdf    Flapper coefficient of discharge.
// dn     Flapper nozzle diameter, in.
// ks     Spring rate, lbf/in.
// kb     Bellows spring rate, lbf/in.
// pf     Flapper supply pressure, psia.
// ph     High sensed pressure, psia.
// sg     Fluid specific gravity.
// wff    Flapper flow from pf into ph cavity, pph.
// m      Equivalent mass, lbm.
// 
// Differential IO:
// ph     Input  # 1, high sensed differential pressure, psi.
// pl     Input  # 2, low sensed differential pressure, psi.
// pf     Input  # 3, flapper supply differential pressure, psi.
// wfh    Output # 1, high sensed differential flow in, pph.
// wfl    Output # 2, low sensed differential flow out, pph.
// wff    Output # 3, flapper differential flow in, pph.
// x      Output # 4, flapper differential position, in.
// 
// Output:
// sys        Packed system of Input and Output.
// 
// Local:
// af        Flapper discharge window area, sqin.
// dafdx     Partial area with flapper position, sqin/in.
// dwfda     Partial flow with flapper area, pph/sqin.
// dwdc      Volumetric to mass flow conversion, pph/cis.
// dwfdp     Partial flow with flapper delta pressure, pph/psi.
// q         Connection matrix.
// u         Input matrix.
// y         Output matrix.
// 
// States:
// x        Flapper differential position, in.
// 
// Functions called:
// or_wptoa    Orifice calculation.
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
// *****************************************************************************
function [sys] = lti_head_b(ae,bdamp,cdf,dn,ks,kb,pf,ph,sg,wff,m)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);


    // Parameters.
    af = or_wptoa(wff, pf, ph, cdf, sg);
    dwdc = 129.93948 * sg;

    // Partials.
    dafdx = %pi * dn;
    dwfda = wff / af;
    dwfdp = wff / (2 * (pf-ph));

    // Connections and system construction.
    a = ([-bdamp, -(ks+kb)]*386.4)/m;
    a = [a; 1, 0];
    b = ([ae, -ae, 0] * 386.4) / m;
    b = [b; 0, 0, 0];
    c = [ae * dwdc,  (-dafdx)*dwfda;  ae*dwdc,  0;  0, dafdx*dwfda;  0, 1];
    e = [dwfdp, 0, -dwfdp;  0,0,0;  -dwfdp, 0, dwfdp;  0,0,0];
    sys = pack_ss(a, b, c, e);

endfunction
