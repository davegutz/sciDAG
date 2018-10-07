function [ns] = issys(x)
    // ISSYSDetermine whether argument is a system.
    // 
    // Syntax: NS = ISSYS(X)
    // 
    // Purpose:The function ISSYS returns the state dimension of a variable,
    //which is nonzero if the argument is a packed matrix, and
    //zero if a regular matrix.
    // 
    // Input:X- Variable who''s state dimension is to be computed.
    // 
    // Output:NS- A scalar containing the state dimension of X.  If
    //X is a regular matrix variable, then NS = 0.
    // 
    // See Also:

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
    //**********************************************************************

    // Output variables initialisation (not found in input variables)
    ns=[];

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // 
    ns = mtlb_find(mtlb_all(isnan(x)));

    // 
    if ~isempty(ns) then
        ns = mtlb_s(ns,1);
    else
        ns = 0;
    end;
endfunction
