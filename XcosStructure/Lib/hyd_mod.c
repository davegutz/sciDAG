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
// Jan 22, 2019     DA Gutz         Created 
// Jun 06, 2019     DA Gutz         Add friction functions
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "hyd_mod.h"
//#define EPS 0.000001
#define EPS 0.05

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

// Friction functions
// Calculate surfaces
void friction_surf(double *surf0, double *surf1, double *surf2,
                   double *surf3, double *surf4, 
                   const double Xdot, const double uf, const double fstf,
                   const double X, const double xmin, const double xmax)
{
    *surf0 = Xdot;
    *surf1 = uf - fstf;
    *surf2 = uf + fstf;
    *surf3 = X - xmin;
    *surf4 = X - xmax;
}
// Calculate friction net effect
double friction_balance(const int mode, const double uf, const double fstf, const double fdyf, int *stops)
{
    double uf_net;
    *stops = 0;
    if(mode==mode_lincos_override)
    {
        uf_net = uf;
    }
    else if(mode==mode_move_plus)
    {
        uf_net = uf - fdyf;
    }
    else if(mode==mode_move_neg)
    {
        uf_net = uf + fdyf;
    }
    else if(mode==mode_stop_min)
    {
        uf_net = max(uf - fstf, 0);
        *stops = 1;
    }
    else if(mode==mode_stuck_plus)
    {
        uf_net = max(uf - fstf, 0);
    }
    else if(mode==mode_stop_max)
    {
        uf_net = min(uf + fstf, 0);
        *stops = 1;
    }
    else if(mode==mode_stuck_neg)
    {
        uf_net = min(uf + fstf, 0);
    }
    return uf_net;
}
// Calculate mode of zero-crossings
int friction_mode(const double LINCOS_OVERRIDE, const int stops, const double surf0,
    const double surf1, const double surf2, const double surf3, const double surf4,
    const double Xdot, const double uf)
{
    int mode;
    if(LINCOS_OVERRIDE && stops==0)
        mode = mode_lincos_override;
    // Driving into stops
    else if(surf3<=0 && surf1<=0)
        mode = mode_stop_min;
    else if(surf4>=0 && surf2>=0)
        mode = mode_stop_max;
    // Currently moving
    else if(Xdot>=EPS)
        mode = mode_move_plus;
    else if(Xdot<=-EPS)
        mode = mode_move_neg;
    // Currently stuck
    else
    { 
        if(surf1>0) mode = mode_move_plus;
        else if(surf2<0) mode = mode_move_neg;
        else if(uf>0)mode = mode_stuck_plus;
        else mode = mode_stuck_neg;
    }
    return mode;
}
