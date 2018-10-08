// function sys = lti_m_valve_a(pd, ps, wf)
// Building block for a metering valve.  Square law orifice.
// Version with ps and pd inputs.
// Author:       D. A. Gutz
// Written:      19-Aug-92
// Revisions:    none.
// Input:
// pd        Discharge pressure, psia.
// ps        Supply pressure, psia.
// wf        Discharge flow out, pph.
// Output:
// sys       Packed system of Input and Output.
// Differential IO:
// ps        Input # 1, supply pressure, psia.
// pd        Input # 2, discharge pressure, psia.
// wfdem     Input # 3, metering valve area in flow units, pph.
// wf        Output # 1, discharge flow out, pph.
// 
// Local:
// dwdp        Sensitivity pressure to flow, pph/psi.
// 
// States:
// none.
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
// 
//**********************************************************************
function [sys] = lti_m_valve_a(pd, ps, wf)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Parameters.
    // none.

    // Partials.
    dwdp = wf/(2*(ps-pd));

    // Connections and system construction.
    a = [];
    b = [];
    c = [];
    e = [dwdp, -dwdp, 1];
    sys = pack_ss(a, b, c, e);
    
endfunction
