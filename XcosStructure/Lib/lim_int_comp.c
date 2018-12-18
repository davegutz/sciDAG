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
// Dec 15, 2018 	DA Gutz		Created 
//                          from http://www.scicos.org/ScicosCBlockTutorial.pdf
// install "Microsoft Visuall C++ 2013 Resistributable (x64)"
// verify proper install by 
// -->findmsvccompiler() ==> msvc120express
// and 
// -->haveacompiler() ==> T
//// libs = 'C:\Program"" ""Files\scilab-5.5.2\bin\scicos'
// libs = 'C:\PROGRA~1\SCILAB~1.2\bin\scicos'
// incs = 'C:\PROGRA~1\SCILAB~1.2\modules\scicos_blocks\includes'
// ilib_for_link('lim_int','lim_int_comp.c',libs,'c','','LibScratchLoader.sce', 'Scratch', '','-I'+incs, '', '');
// This is the computational function for a Scicos model block.
// The model is of a variable-gain integrator with hard high and low limits.
//#include "sciocos\scicos_block4.h"
//#include "scicos_blocks\include\scicos_block4.h"
//#include <scicos_blocks/includes/scicos_block4.h>
//#include <scicos_blocks/scicos_block.h>
//#include "C:\Program Files\scilab-5.5.2\modules\scicos_blocks\includes\scicos_block4.h"
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define r_IN(n, i) ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters
#define Lhi (GetRparPtrs(blk)[0]) // integrator high limit
#define Llo (GetRparPtrs(blk)[1]) // integrator low limit

// inputs
#define in (r_IN(0,0)) // integrator input
#define gainp (r_IN(1,0)) // integrator gain when X > 0
#define gainn (r_IN(2,0)) // integrator gain when X <= 0

// states
#define X (GetState(blk)[0]) // integrator state
#define Xdot (GetDerState(blk)[0]) // derivative of the integrator output

// outputs
#define out (r_OUT(0, 0)) // integrator output
#define Igain (r_OUT(1, 0)) // integrator gain

// other constants
#define surf0 (GetGPtrs(blk)[0])
#define surf1 (GetGPtrs(blk)[1])
#define surf2 (GetGPtrs(blk)[2])
#define mode0 (GetModePtrs(blk)[0])


// if X is greater than Lhi, then mode is 1
// if X is between Lhi and zero, then mode is 2
// if X is between zero and Llo, then mode is 3
// if X is less than Llo, then mode is 4
#define mode_xhzl 1
#define mode_hxzl 2
#define mode_hzxl 3
#define mode_hzlx 4

void lim_int(scicos_block *blk, int flag)
{
    double gain = 0;

    switch (flag)
    {
        case 0:
            // compute the derivative of the continuous time state
            if ((mode0 == mode_xhzl && in < 0) || mode0 == mode_hxzl)
                gain = gainp;
            else if ((mode0 == mode_hzlx && in > 0) || mode0 == mode_hzxl)
                gain = gainn;
            Xdot = gain * in;
            break;

        case 1:
            // compute the outputs of the block
            if (X >= Lhi || X <= Llo)
                Igain = 0;
            else if (X > 0)
                Igain = gainp;
            else
                Igain = gainn;
            out = X;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = X - Lhi;
            surf1 = X;
            surf2 = X - Llo;

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
