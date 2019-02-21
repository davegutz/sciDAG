// Copyright (C) 2019 - Dave Gutz
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
// Feb 21, 2019    DA Gutz        Created
// 
function ice = iterateInit(xmax, xmin, eInit, str)
    // function ice = iterateInit(xmax, xmin, eInit)
    // Generic iteration initializer
    // Inputs: 
    //   xmax    Maximum value of x
    //   min     Minimum value of x
    //   eInit   Initial error
    // Outputs:
    //   ice     Initialized structure

    ice.xmax    = xmax;
    ice.xmin    = xmin;
    ice.e       = eInit;
    ice.ep      = eInit;
    ice.xp      = ice.xmax;
    ice.x       = ice.xmin;   // Do min and max first
    ice.dx      = ice.x - ice.xp;
    ice.de      = ice.e - ice.ep;
    ice.count   = 0;
    ice.str     = str;

endfunction
