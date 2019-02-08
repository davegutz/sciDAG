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
// Jan 22, 2019    DA Gutz        Created
// 

function s = sqr(x)
    s = x*x;
endfunction

function [x, a] = mvwin_a(n)
    x = zeros(n);
    a = zeros(n);
    AMVMIN = (.00453 - .09*.036); //Min flow window area, sqin. */
    LMV1 = 0.;                 //Contour point, in. */
    LMV2 = (0.025 + .036) ;    //Contour point, in. */
    LMV3 = (0.225 + .036);     //Contour point, in. */
    LMV4 = (0.500 + .036);     //Contour point, in. */
    WMV1 = .09;                //Contour width all windows, in. */
    WMV2 = .09;                //Contour width all windows, in. */
    WMV3 = .304;               //Contour width all windows, in. */
    WMV4 = 1.152;              //Contour width all windows, in. */

    //Calculate evenly spaced position interval. */
    dx  = sqrt(LMV4) / (n -1);

    //Calculate position, and area. */
    for i=1:n
        x(i)    = sqr((i-1)*dx);
        a(i)    = AMVMIN;
        a(i)    = a(i) + max(x(i) - LMV1, 0.) * WMV1 +..
                  sqr(max(min(x(i) - LMV1, LMV2 - LMV1), 0.)) /..
                  (LMV2 - LMV1) * (WMV2 - WMV1) / 2.;
        a(i)    = a(i) + max(x(i) - LMV2, 0.) * (WMV2 - WMV1) +..
                  sqr(max(min(x(i) - LMV2, LMV3 - LMV2), 0.)) /..
                  (LMV3 - LMV2) * (WMV3 - WMV2) / 2.;
        a(i)    = a(i) + max(x(i) - LMV3, 0.) * (WMV3 - WMV2) +..
                  sqr(max(min(x(i) - LMV3, LMV4 - LMV3), 0.)) /..
                  (LMV4 - LMV3) * (WMV4 - WMV3) / 2.;
    end
endfunction
