// function sys = man_n_vv(l, a, vol, n, spgr, beta, c)
// Building block for a line distributed among n equally sized
// volumes and momentum slices, with volume first & last (n = #
// of momentum slices and n+1 = # volume nodes).
// Author:       D. A. Gutz
// Written:      22-Jun-92
// Revisions:    19-Aug-92    Simplify output arguments.
//               10-Dec-98    Add damping, c.
// Input:
// a     Line cross-section, sqin.
// beta  Fluid bulk modulus, psi.
// l     Line length, in.
// n     Number of volume node / momentum slice pairs.
// spgr  Fluid specific gravity.
// vol   Line volume, cuin.
// c     Damping, psi/in/sec, (OPTIONAL).
// 
// Output:
// sys   lti in pack_ss form
// 
// Differential I/O:
// wfs   Input  # 1, supply flow, pph.
// wfd   Input  # 2, discharge flow, pph.
// ps    Output # 1, supply pressure, psia.
// pd    Output # 2, discharge pressure, psia.
// 
// Functions called:
// man_1_vm    Creates single element line of wfs, pd input and ps, wfd output.
// vol_1    Creates single volume node of wfs, wfd input and p output.
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
// Oct 13, 2018 	DA Gutz		Created
// **************************************************************************
function [sys] = lti_man_n_vv(l,a,vol,n,spgr,%beta,c)

    // Output variables initialisation (not found in input variables)
    sys=[];

    // Number of arguments in function call
    [%nargout,%nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Check size.
    if mtlb_logic(n,"<",1) then
        error("Number of nodes < 1 in man_n.")
    end;
    // Single manifold slice.
    if %nargin==7 then
        man = lti_man_1_vm(l/n, a, vol/(n+1), spgr, %beta, c);
    else
        man = lti_man_1_vm(l/n, a, vol/(n+1), spgr, %beta);
    end;

    // Single volume node.
    endvol = lti_vol_1(vol/(n+1), %beta, spgr);

    // Inputs are wfs and wfd.
    u = [1, (2*n+2)];

    // Outputs are ps and pd.
    y = [1, (2*n+1)];

    // Connections and system construction.
    temp = man;
    q = [];
    for i = 2:n
        temp = adjoin(temp,man);
        q = [q;  2*(i-1), 2*(i-1)+1;  2*(i-1)+1, 2*(i-1)];
    end;
    temp = adjoin(temp,endvol);
    q = [q;2*n, (2*n+1); (2*n+1), 2*n];

    // Form the system.
    sys = connect_ss(temp, q, u, y);

endfunction
