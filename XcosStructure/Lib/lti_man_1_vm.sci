// function sys = man_1_vm(l, a, vol, spgr, beta, c);
// Build a one element line: volume first, momentum last.
// Author:       D. A. Gutz
// Written:      16-Apr-92
// Revisions:    22-Jun-92    Add vm subscripts.
//               19-Aug-92    Simplify output arguments.
//               10-Dec-98    Add damping, c.
// Input:
// l     Line length, in.
// a     Line cross section, sqin.
// vol   Line volume, cuin.
// spgr  Fluid specific gravity.
// beta  Fluid compressibility, psi.
// c     Damping, psi/in/sec, (OPTIONAL).
// 
// Output:
// sys   Packed system of Input and Output
// 
// Differential I/O:
// wfs   Input #  1, supply flow, pph.
// pd    Input #  2, discharge pressure, psia.
// ps    Output # 1, supply pressure, psia.
// wfd   Output # 2, discharge flow, pph.
// 
// Functions called:
// lti_vol_1    Creates volume node.
// lti_mom_1    Creates momenum slice.
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
// Oct 10, 2018 	DA Gutz		Created
// ******************************************************************************
function [sys] = lti_man_1_vm(l, a, vol, spgr, %beta,c)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Number of arguments in function call
    [%nargout, %nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Volume.
    v_1 = lti_vol_1(vol, %beta, spgr);

    // Momentum slice.
    if %nargin==6 then
        m_1 = lti_mom_1(l, a, c);
    else
        m_1 = lti_mom_1(l, a);
    end;

    // Put system into block diagonal form.
    temp = adjoin(v_1, m_1);

    // Inputs are wfs and pd.
    u = [1, 4];

    // Outputs are ps and wfd.
    y = [1, 2];

    // Connections.
    q = [2,2; 3,1];

    // Form the system.
    sys = connect_ss(temp,q,u,y);

endfunction
