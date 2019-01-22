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

function [x, as, ad] = regwin_a(n)
    DBIAS = 
    
    x = zeros(n);
    as = zeros(n);
    ad = zeros(n);

xcrl    = max(min(-(x+DBIAS) - VEN_REG_UNDERLAP, DORIFD), 0.);
xscl    = max(min((x+SBIAS), DORIFS), 0.);
thcrl   = acos(1. - xcrl * 2. / DORIFD);
thscl   = acos(1. - xscl * 2. / DORIFS);
alk     = CLEAR * (DORIFS + DORIFD)/2. * (pi - thcrl - thscl);
*as     = HOLES * ( max(hole(max(min(x+SBIAS, DORIFS), 0.), DORIFS),
			max(min(x+SBIAS, DORIFS),0.)*WS)
			+ alk);
*ad     = HOLES * ( max(hole(max(min(-(x+DBIAS) - VEN_REG_UNDERLAP, DORIFD), 0.),
		       DORIFD),
			max(min(-(x+DBIAS) - VEN_REG_UNDERLAP, DORIFD), 0.)*WD)
		        + alk);



    // Calculate evenly spaced position interval. */
    dx  = XVSVMAX / (n - 1);

    // Calculate position, and area. */
    for i=1:n
        x(i)    = i*dx;
        %xend    = XVSVMAX - x(i);
        a(i)    = AVSVMIN;
        a(i)   = a(i) + VSVHOLES * hole(max(min(%xend, VSVHMX), 0.), VSVHDIA);
        if VSVHMX < %xend then
            a(i) = a(i) + VSVDIA*3.1415926 * (%xend - VSVHMX);
        end
    end

endfunction
