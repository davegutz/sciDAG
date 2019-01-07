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
// Jan 7, 2019     DA Gutz     Created 
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define r_IN(n, i)  ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters

// Object parameters.  1st index is 1-based, 2nd index is 0-based.
#define TB      ((GetRealOparPtrs(blk,1))[0]); // lbm

// inputs
#define X (r_IN(0,0)) // Input

// states

// outputs
#define Z       (r_OUT(0, 0))       // Output

// other constants

void table1_a(scicos_block *blk, int flag)
{
//    double mass = 0;

    // compute info needed for all passes

    // Different cases
    switch (flag)
    {
        case 0:
            break;

        case 1:
            // compute the outputs of the block
            Z = X;
           break;

        case 9:
            // compute zero crossing surfaces and set modes
            break;
    }
}
