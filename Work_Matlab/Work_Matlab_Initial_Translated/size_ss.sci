function [p,m,n] = size_ss(g)
    // SIZE_SSCompute system output, input and state dimensions.
    // 
    // Syntax: [P,M,N] = SIZE_SS(G)
    // 
    // Purpose: The SIZE_SS command returns three important dimensions for a
    //state-space system, namely, the number of outputs, the
    //number of inputs, and the state-dimension.
    // 
    // Input:G - input system, either a regular or packed-matrix
    //    variable.
    // 
    // Output:P, M, N - integers containing the output, input and
    //             state dimensions respectively of the input system
    //     G. If G is a regular matrix, then M and P default
    //     to the row and column dimensions of G and P is set
    //     equal to zero.  When used with only 1 output
    //     argument, SIZE_SS returns the vector [P M N].
    // 
    // See Also:ISSYS, ISTITO, SIZE

    // Algorithm:
    // 
    // Calls:
    // 
    // Called By:
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
    p=[];
    m=[];
    n=[];

    // Number of arguments in function call
    [%nargout,%nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // 

    // 
    narginchk(%nargin, 1,1);
    [p,m] = size(g);// !! L.34: Unknown function issys not converted, original calling sequence used.
    n = issys(g);
    // 
    if n then
        // !! L.37: Matlab toolbox(es) function istito not converted, original calling sequence used

        if istito(g) then
            p = mtlb_s(mtlb_s(p,n),2);  m = mtlb_s(mtlb_s(m,n),2);
        else
            p = mtlb_s(mtlb_s(p,n),1);  m = mtlb_s(mtlb_s(m,n),1);
        end;
    end;
    // 
    if %nargout<=1 then
        p = [p,m,n];
    end;
endfunction
