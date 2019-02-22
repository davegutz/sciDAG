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
// Jan 10, 2019    DA Gutz        Created
// 

function area = hole(x, d)
    r = d / 2.;
    x = max( (min(x, d - 1e-16)), 1e-16);
    frac = 1. - x / r;
    if frac > 1e-16 then
        area = atan( sqrt(1. - frac * frac) / frac);
    elseif frac < -1e-16 then
        area = pi + atan( sqrt(1. - frac * frac) / frac);
    else
        area = pi / 2.;
    end
    area = r * r * area   -   (r - x) * sqrt(x * (2.*r - x));
    area = max(area, 1e-16);
endfunction

function [x, a, wv] = vsvwin_a(n)
    AVSVMIN = 1e-8;       // Min area, sqin. */
    XVSVMAX = .125;       // Max value of table. */
    VSVHOLES = 6;         // FRC dwg 7/19/01 */
    VSVHDIA  = .094;      // FRC dwg 7/19/01 */
    VSVDIA  = .266;       // FRC dwg 7/19/01 */
    VSVHMX  = .02;        // FRC dwg 7/19/01 */
    x = zeros(n);
    a = zeros(n);
    wv = zeros(n);

    // Calculate evenly spaced position interval. */
    dx  = XVSVMAX / (n - 1);

    // Calculate position, and area. */
    for i=1:n
        x(i)    = (i-1)*dx;
        %xend    = XVSVMAX - x(i);
        a(i)    = AVSVMIN;
        a(i)   = a(i) + VSVHOLES * hole(max(min(%xend, VSVHMX), 0.), VSVHDIA);
        if VSVHMX < %xend then
            a(i) = a(i) + VSVDIA*3.1415926 * (%xend - VSVHMX);
        end
    end

    // Calculate width = da/dx. */
    for i = 1:n-1
        wv(i)   = abs(a(i+1) - a(i)) / dx;
    end
    wv(n) = wv(n-1);
endfunction
