// function sys = dor_aptow(wf, ps, pd, cd, sg);
// Differential area/pressure to flow for a square law orifice.
// Author:      D. A. Gutz
// Written:     22-Jun-92
// Revisions:   19-Aug-92   Simplify return arguments.
//              26-Nov-2012 add divide by zero protection%
// Input:
// cd       Coefficient of discharge.
// pd       Discharge pressure, psia.
// ps       Supply pressure, psia.
// sg       Specific gravity.
// wf       Flow, pph.
// 
// Differential IO.
// ps       Input # 1, supply pressure, psia.
// pd       Input # 2, discharge pressure, psia.
// a        Input # 3, area perturbation, sqin.
// wf       Output # 1, flow, pph.
// 
// Output:
// sys      Differential orifice model.
//
// Local:
// ao       Orifice area, sqin.
// dwfda    Partial flow to area, pph/sqin.
// dwfdp    Partial flow to pressure, pph/psi.
//
// States:
// none.
//
// Functions called:
// or_wptoa Orifice area.
// ssqrt    Signed square root.
// Copyright(C) 2018 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
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
// Oct 4, 2018  DA Gutz Created
function [sys] = lti_dor_aptow(wf, ps, pd, %cd, sg)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Parameters.
    ao = or_wptoa(wf, ps, pd, %cd, sg);

    // Partials.
    dwfda = wf/ao;
    psmpd = sign(ps-pd) * max(abs(ps-pd), 1.0D-16); // 11/26/2012 add divide by zero protection
    dwfdp = wf/(2*psmpd);

    // Connections and system construction.
    a = [];
    b = [];
    c = [];
    // ! L.48: mtlb(dwfdpdwfda) can be replaced by dwfdpdwfda() or dwfdpdwfda whether dwfdpdwfda is an M-file or not.
    e = [dwfdp, -dwfdp,  dwfda];

    // Form the system.
    sys = pack_ss(a, b, c, e);
    
endfunction
