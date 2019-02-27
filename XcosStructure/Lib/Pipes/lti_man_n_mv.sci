// function obj = lti_man_n_mv(obj, spgr, %beta)
// Building block for a line distributed among n equally sized
// volumes and momentum slices, with momentum first & volume last.
// Author:     D. A. Gutz
// Written:    22-Jun-92
// Revisions:  19-Aug-92    Simplify output arguments.
//             10-Dec-98    Add damping, c.
//             19-Jan-19    Port to xcos
// 
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
// lti   LTI in packed form
// A,B,C,D  LTI in unpacked form
// 
// Differential I/O:
// ps    Input  # 1, supply pressure, psia.
// wfd   Input  # 2, discharge flow, pph.
// wfs   Output # 1, supply flow, pph.
// pd    Output # 2, discharge pressure, psia.
// 
// Functions called:
// man_1_mv    Creates single element line of ps, wfd input and wfs, pd output.
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
// Oct 11, 2018     DA Gutz    Created
// ******************************************************************
function obj = lti_man_n_mv(obj, spgr, %beta)
    if typeof(obj) ~= 'pipeMV' then
        mprintf('ERROR:   wrong type %s\n', typeof(obj));
        error('wrong type')
    end

    l = obj.l; a = obj.a; vol =  obj.vol; n = obj.n; %c = obj.c;

    // Output variables initialisation (not found in input variables)
    obj.lti = [];  obj.A = []; obj.B = []; obj.C = []; obj.D = [];

    // Number of arguments in function call
    [%nargout,%nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Check size.
    if mtlb_logic(n,"<",1) then
        error("Number of nodes < 1 in man_n_mv.")
    end;

    // Single manifold slice.
    man = lti_man_1_mv(l/n, a, vol/n, spgr, %beta, %c, %c);

    // Inputs are ps and wfd.
    u = [1, n*2];

    // Outputs are wfs and pd.
    y = [1, n*2];

    // Connections and system construction.
    temp = man;
    q = [];
    for i = 2:n
        temp = adjoin(temp, man);
        q = [q;  2*(i-1), 2*(i-1)+1;  2*(i-1)+1, 2*(i-1)];
    end;

    // Form the system.
    obj.lti = connect_ss(temp, q, u, y);
   [a, b, c, d] = unpack_ss(obj.lti);
    obj.A = a; obj.B = b; obj.C = c; obj.D = d;
    obj.ltis = syslin('c', a, b, c, d); 
endfunction

function vec =ini_man_n_mv(obj, pi, wfi)
    if typeof(obj) ~= 'pipeMV' then
        mprintf('ERROR:   wrong type %s\n', typeof(obj));
        error('wrong type')
    end
    len = 2*obj.n;
    vec = zeros(1, len);
    for i=1:2:len
        vec(i) = wfi;
    end
    for i=2:2:len
        vec(i) = pi;
    end
endfunction
