// function a = or_wptoa(wf, ps, pd, cd, sg);
// Square law orifice function, flow/pressure to area.
// Author:      D. A. Gutz
// Written:     22-Jun-92
// Revisions:   17-Oct-96   Trap divide by cd=0.
// 
// Input:
// cd       Coefficient of discharge.
// pd       Discharge pressure, psia.
// ps       Supply pressure, psia.
// sg       Specific gravity.
// wf       Flow, pph.
// 
// Output:
// a        Calculated orifice area, sqin.
//
// Functions called:
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
function [a] = or_wptoa(wf, ps, pd, %cd, sg)

    // Output variables initialisation (not found in input variables)
    a=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Perform:
    psmpd = sign(ps-pd)*max(abs(ps-pd), 1.0D-16);
    a = wf / ssqrt(psmpd*sg) / %cd / 19020.;
    if a<0 then
        error('Inputs cause area < 0; not physically possible.')
    end
endfunction
