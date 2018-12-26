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
// Dec 15, 2018     DA Gutz     Created 
//                          from http://www.scicos.org/ScicosCBlockTutorial.pdf
// install "Microsoft Visuall C++ 2013 Resistributable (x64)"
// verify proper install by 
// -->findmsvccompiler() ==> msvc120express
// and 
// -->haveacompiler() ==> T
//// libs = 'C:\Program"" ""Files\scilab-5.5.2\bin\scicos'
// libs = 'C:\PROGRA~1\SCILAB~1.2\bin\scicos'
// incs = 'C:\PROGRA~1\SCILAB~1.2\modules\scicos_blocks\includes'
// ilib_for_link('friction','friction_comp.c',libs,'c','','LibScratchLoader.sce', 'Scratch', '','-I'+incs, '', '');
// This is the computational function for a Scicos model block.
// The model is of a dynamic/static friction model
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#define r_IN(n, i) ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters
#define FSTF (GetRparPtrs(blk)[0]) // static friction, lbf
#define FDYF (GetRparPtrs(blk)[1]) // dynamic friction, lbf
#define C (GetRparPtrs(blk)[2]) // damping coefficient, lbf/in/s
#define EPS (GetRparPtrs(blk)[3]) // boundary layer, in/s.***do't think this has
// any effect in xcos with zcd - holdover from Simulink modeling of friction
#define M (GetRparPtrs(blk)[4])     // 386/lbm
#define Xmin (GetRparPtrs(blk)[5])     // 386/lbm
#define Xmax (GetRparPtrs(blk)[6])     // 386/lbm
#define LINCOS_OVERRIDE (GetRparPtrs(blk)[7]) // flag to disable friction

// inputs
#define DF (r_IN(0,0)) // force imbalance

// states
#define X (GetState(blk)[0]) // position state
#define V (GetDerState(blk)[0]) // derivative of position
#define Xdot (GetState(blk)[1]) // velocity state
#define A (GetDerState(blk)[1]) // derivative of velocity

// outputs
#define Xo (r_OUT(0, 0)) // position, in
#define Vo (r_OUT(1, 0)) // velocity, in/s
#define DFmodo (r_OUT(2, 0)) // integrator output
#define mode0o (r_OUT(3, 0)) // mode0

// other constants
#define surf0 (GetGPtrs(blk)[0])
#define surf1 (GetGPtrs(blk)[1])
#define surf2 (GetGPtrs(blk)[2])
#define surf3 (GetGPtrs(blk)[3])
#define surf4 (GetGPtrs(blk)[4])
#define mode0 (GetModePtrs(blk)[0])


// if V >= EPS, then mode is 2
// if V <= -EPS, then mode is -2
// if 0<=V<EPS and u<FSTF, then mode is 1
// if -EPS<V<=0 and u>-FSTF, then mode is -1
#define mode_move_plus 2
#define mode_move_neg -2
#define mode_stuck_plus 1
#define mode_stuck_neg -1
#define mode_lincos_override 0

void friction(scicos_block *blk, int flag)
{
    static double DFmod;
    static int STOPS=0;
    switch (flag)
    {
        case 0:
            // compute the derivative of the continuous time state
            if(mode0==mode_lincos_override)
                DFmod = DF - Xdot*C;
            else if(mode0==mode_move_plus)
                DFmod = DF-FDYF - Xdot*C;
            else if(mode0==mode_move_neg)
                DFmod = DF+FDYF - Xdot*C;
            else if(mode0==mode_stuck_plus)
                DFmod = max(DF-FSTF, 0);
            else if(mode0==mode_stuck_neg)
                DFmod = min(DF+FSTF, 0);
            else
                DFmod = 0;
//            Vdot = DFmod*386.4/M;
            V = Xdot;
            A = DFmod/M*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            break;

        case 1:
            // compute the outputs of the block
            Xo = X;
            Vo = Xdot;
            DFmodo = DFmod;
            mode0o = mode0;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = Xdot;
			surf1 = DF-FSTF;
			surf2 = DF+FSTF;
            surf3 = X-Xmin;
            surf4 = X-Xmax;

            if (get_phase_simulation() == 1)
            {
                if(LINCOS_OVERRIDE && STOPS==0)
                    mode0 = mode_lincos_override;
                else if(surf0>EPS)
                    mode0 = mode_move_plus;
                else if(surf0<-EPS)
                    mode0 = mode_move_neg;
                else if(surf1>0)
                    mode0 = mode_stuck_plus;
                else if(surf2<0)
                    mode0 = mode_stuck_neg;
            }
            break;
    }
}
