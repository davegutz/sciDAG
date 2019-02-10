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
// Feb 10, 2019    DA Gutz        Created
// 
function [x, a] = mvtvwin(n)
    x = zeros(n);
    a = zeros(n);
    XTVMAX = 0.32;       // Max value of table
    XTVMIN = -.05;       // Min value of table

    //Calculate evenly spaced position interval. */
    dx  = (XTVMAX - XTVMIN) / (n -1);

    //Calculate position, and area. */
    for i=1:n
        x(i)    = XTVMIN + (i-1)*dx;
        if x(i) < 0 then
            a(i) = (x(i) - XTVMIN) * abs(0.002/XTVMIN);
        elseif x(i) < 0.24 then
            a(i) = -.0055 - 2.1876e-5*x(i) + .0075*exp(13.33*x(i));
        else
            a(i) = 2.47 * x(i) - .41446;
        end
    end
endfunction
