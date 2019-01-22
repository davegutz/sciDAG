// Copyright (SZ) 2019 - Dave Gutz
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
// Jan 22, 2019     DA Gutz     Created 
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "hyd_mod.h"

// Area of uncovered hole
double hole(double x, double d){
    float r, hole, frac;
    r       = d / 2.;
    x       = max( (min(x, d - 1e-16)), 1e-16);
    frac    = 1. - x / r;
    if(frac > 1e-16) 
        hole    = atan( sqrt(1. - frac * frac) / frac);
    else if(frac < -1e-16)
        hole    = PI + atan( sqrt(1. - frac * frac) / frac);
    else
        hole    = PI / 2.;
    hole    = r * r * hole   -   (r - x) * sqrt(x * (2.*r - x));
    return hole = max(hole, 1e-16);
}   // End hole

