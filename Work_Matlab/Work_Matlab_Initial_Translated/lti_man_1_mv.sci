function [sys] = lti_man_1_mv(l, a, vol, spgr, %beta, c)
    // function sys = man_1_mv(l, a, vol, spgr, beta, c);
    // MAN_1_MV.  Build a one element line: momentum first, volume last.
    // Author:      D. A. Gutz
    // Written:     22-Jun-92
    // Revisions:   19-Aug-92Simplify output arguments.
    //10-Dec-98     Add damping, c.
    // Input:
    // l            Line length, in.
    // a            Line cross section, sqin.
    // vol          Line volume, cuin.
    // spgr         Fluid specific gravity.
    // beta         Fluid compressibility, psi.
    // c            Damping, psi/in/sec, (OPTIONAL).
    // Differential I/O:
    // ps           Input # 1, supply pressure, psia.
    // wfd          Input # 2, discharge flow, pph.
    // wfs          Output # 1, supply flow, pph.
    // pd           Output # 2, discharge pressure, psia.
    //
    // Functions called:
    // vol_1        Creates volume node.
    // mom_1        Creates momenum slice.
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

    // Number of arguments in function call
    [%nargout,%nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Momentum slice.
    if %nargin==6 then
        m_1 = lti_mom_1(l, a, c);
    else
        m_1 = lti_mom_1(l, a);
    end;

    // Volume.
    // !! L.33: Unknown function lti_vol_1 not converted, original calling sequence used.
    v_1 = lti_vol_1(vol, %beta, spgr);

    // Put system into block diagonal form.
    temp = adjoin(make_pack(m_1), make_pack(v_1));

    // Inputs are ps and wfd.
    u = 14;

    // Outputs are wfs and pd.
    y = 12;

    // Connections.
    q = [22;31];

    // Form the system.
    [a, b, c, e] = unpack_ss(temp);
    // !! L.49: Matlab toolbox(es) function connect not converted, original calling sequence used
    [a, b, c, e] = connect(a, b, c, e, q, u, y);
    sys = pack_ss(a, b, c, e);
    
endfunction
