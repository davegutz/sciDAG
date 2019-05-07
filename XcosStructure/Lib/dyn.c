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
// May 7, 2019  DA Gutz     Created 
// The model is of a unity gain integrator with hard high and low limits.
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define r_IN(n, i) ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters
#define ymax (GetRparPtrs(blk)[0]) // integrator high limit
#define ymin (GetRparPtrs(blk)[1]) // integrator low limit

// inputs
#define in (r_IN(0,0)) // integrator input

// states
#define X (GetState(blk)[0]) // integrator state
#define Xdot (GetDerState(blk)[0]) // derivative of the integrator output

// outputs
#define y (r_OUT(0, 0)) // integrator output

// other constants
#define surf0 (GetGPtrs(blk)[0])
#define surf1 (GetGPtrs(blk)[1])
#define surf2 (GetGPtrs(blk)[2])
#define mode0 (GetModePtrs(blk)[0])


// if X is greater than ymax, then mode is 1
// if X is between ymax and zero, then mode is 2
// if X is between zero and ymin, then mode is 3
// if X is less than ymin, then mode is 4
#define mode_xhzl 1
#define mode_hxzl 2
#define mode_hzxl 3
#define mode_hzlx 4

void intgl(scicos_block *blk, int flag)
{
    switch (flag)
    {
        case 0:
            // compute the derivative of the continuous time state
            Xdot = in;
            break;

        case 1:
            // compute the outputs of the block
            y = X;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = X - ymax;
            surf1 = X;
            surf2 = X - ymin;

            if (get_phase_simulation() == 1)
            {
                if (surf0 >= 0)
                    mode0 = mode_xhzl;
                else if (surf2 <= 0)
                    mode0 = mode_hzlx;
                else if (surf1 > 0)
                    mode0 = mode_hxzl;
                else
                    mode0 = mode_hzxl;
            }
            break;
    }
}
