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

function area = hole(xi, d)
    r = d / 2.;
    xi = max( (min(xi, d - 1e-16)), 1e-16);
    frac = 1. - xi / r;
    if frac > 1e-16 then
        area = atan( sqrt(1. - frac * frac) / frac);
    elseif frac < -1e-16 then
        area = %pi + atan( sqrt(1. - frac * frac) / frac);
    else
        area = %pi / 2.;
    end
    area = r * r * area   -   (r - xi) * sqrt(xi * (2.*r - xi));
    area = max(area, 1e-16);
endfunction

function [asi, adi] = calc_regwin_a(xi)
    VEN_REG_UNDERLAP = -.001;   // Dead zone of drain, - is underlap
    SBIAS = .005;               // dead zone of supply + is underlap
    DBIAS = .000;               // dead zone of drain + is underlap
    DORIFS = .125;              // Supply Reg. hole dia, in
    DORIFD = .125;              // Drain Reg. hole dia, in
    HOLES = 2;                  // # reg holes
    CLEAR = .0004;              // Reg. dia clearance, in
    WS = 0.0;                   // Reg supply linear window width, in
    WD = 0;                     // Reg drain linear window width, in
    
    xcrl    = max(min(-(xi+DBIAS) - VEN_REG_UNDERLAP, DORIFD), 0.);
    xscl    = max(min((xi+SBIAS), DORIFS), 0.);
    thcrl   = acos(1. - xcrl * 2. / DORIFD);
    thscl   = acos(1. - xscl * 2. / DORIFS);
    alk     = CLEAR * (DORIFS + DORIFD)/2. * (%pi - thcrl - thscl);
    asi     = HOLES * ( max(hole(max(min(xi+SBIAS, DORIFS), 0.), DORIFS),..
            max(min(xi+SBIAS, DORIFS),0.)*WS) + alk);
    adi     = HOLES * ( max(hole(max(min(-(xi+DBIAS) - VEN_REG_UNDERLAP, DORIFD), 0.),..
            DORIFD), max(min(-(xi+DBIAS) - VEN_REG_UNDERLAP, DORIFD), 0.)*WD) + alk);
endfunction

function [xi, as, ad] = regwin_a(n)
    XVSVMAX = 0.125;  // Max value of table
    as = zeros(n);
    ad = zeros(n);
    xi = zeros(n);

    // Calculate evenly spaced position interval
    dx  = XVSVMAX / (n - 1);

    // Calculate position, and area
    for i=1:n
        xi(i)    = (i-1)*dx;
        %xend    = XVSVMAX - xi(i);
        [as(i), ad(i)] = calc_regwin_a(%xend);
    end
endfunction
