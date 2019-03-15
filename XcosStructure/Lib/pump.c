// Copyright (c_) 2019 - Dave Gutz
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
// Jan 26, 2019    DA Gutz        Created
// 
// Copyright (c_) 2019 - Dave Gutz
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
// Jan 27, 2019     DA Gutz     Created
//                          from http://www.scicos.org/ScicosCBlockTutorial.pdf
// Mar 10, 2019     DA Gutz     Add actuator_a_b
// 
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "table.h"
#include "hyd_mod.h"
#define r_IN(n, i)  ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters
#define sg      (GetRparPtrs(blk)[0]) // Fluid specific gravity
#define avis    (GetRparPtrs(blk)[1]) // Fluid absolute viscosity, lbf-sec/sqin

// **********vdpp**********************************************
// Object parameters.  1st index is 1-based, 2nd index is 0-based.
#define NOPAR   (blk->nopar)
#define cf      (*GetRealOparPtrs(blk,1)) // Flow load coefficient of torque
#define cn      (*GetRealOparPtrs(blk,2)) // Speed slip flow coefficient
#define cs      (*GetRealOparPtrs(blk,3)) // Laminar slip flow coefficient
#define ct      (*GetRealOparPtrs(blk,4)) // Turbulent slip flow coefficient

// inputs
#define rpm     (r_IN(0,0))     // Pump speed, rpm
#define disp_   (r_IN(1,0))     // Pump displacement, cuin/rev
#define pd      (r_IN(2,0))     // Discharge pressure, psia
#define ps      (r_IN(3,0))     // Bellows displacement from flapper, in (open loop)

// outputs
#define wf      (r_OUT(0,0))    // Pump flow, pph
#define mtdqp   (r_OUT(1,0))    // Dimensionless speed factor
#define eff_vol (r_OUT(2,0))    // Volumetric efficiency
#define pl      (r_OUT(3,0))    // Load pressure, psid

void vdp(scicos_block *blk, int flag)
{
    double dwdc = DWDC(sg);
    double cis;
    double rpm_lim = max(rpm, 1);
    double disp_lim = SGN(disp_) * max(fabs(disp_), 1e-24);
    // compute info needed for all passes
    pl = pd - ps;
    mtdqp = avis * .10471976 * rpm_lim / max(pl, 1e-6);
    eff_vol = 1. - cs/mtdqp -
        ct*1825*SSQRT(pl/sg)/rpm_lim/pow(disp_lim, .3333333) -
        cn;
    cis        = eff_vol * disp_ * rpm_lim / 60.;
    // gpm        = cis / 3.85;
    wf         = cis * dwdc;
}
// **********end vdpp**********************************************
