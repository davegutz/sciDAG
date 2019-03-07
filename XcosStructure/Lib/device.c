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
// Jan 22, 2019    DA Gutz        Created
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
// install "Microsoft Visuall c_++ 2013 Resistributable (x64)"
// verify proper install by 
// -->findmsvccompiler() ==> msvc120express
// and 
// -->haveacompiler() ==> T
//// libs = 'c_:\Program"" ""Files\scilab-5.5.2\bin\scicos'
// libs = 'c_:\PROGRA~1\SCILAB~1.2\bin\scicos'
// incs = 'c_:\PROGRA~1\SCILAB~1.2\modules\scicos_blocks\includes'
// ilib_for_link('friction','friction_comp.c',libs,'c','','LibScratchLoader.sce', 'Scratch', '','-I'+incs, '', '');
// This is the computational function for a Scicos model block.
// The model is of a dynamic/static friction model
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "table.h"
#include "hyd_mod.h"
#define r_IN(n, i)  ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters
#define sg              (GetRparPtrs(blk)[0]) // Fluid specific gravity
#define LINCOS_OVERRIDE (GetRparPtrs(blk)[1]) // flag to disable friction for linearization

// states
#define X       (GetState(blk)[0])      // Position state
#define V       (GetDerState(blk)[0])   // Derivative of position
#define Xdot    (GetState(blk)[1])      // Velocity state
#define A       (GetDerState(blk)[1])   // Derivative of velocity

// other constants
#define surf0   (GetGPtrs(blk)[0])
#define surf1   (GetGPtrs(blk)[1])
#define surf2   (GetGPtrs(blk)[2])
#define surf3   (GetGPtrs(blk)[3])
#define surf4   (GetGPtrs(blk)[4])
#define mode0   (GetModePtrs(blk)[0])

// Zero-crossing modes
#define mode_stop_max 3
#define mode_stop_min -3
#define mode_move_plus 2
#define mode_move_neg -2
#define mode_stuck_plus 1
#define mode_stuck_neg -1
#define mode_lincos_override 0

// **********head_b
// valve_a Object parameters.  1st index is 1-based, 2nd index is 0-based.
#define NOPAR   (blk->nopar)
#define f_an    (*GetRealOparPtrs(blk,1))   // Nozzle flow area, sqin
#define f_cn    (*GetRealOparPtrs(blk,2))   // Nozzle discharge coeff
#define f_dn    (*GetRealOparPtrs(blk,3))   // Nozzle diameter, in
#define f_ln    (*GetRealOparPtrs(blk,4))   // Nozzle flat width, in
#define ae      (*GetRealOparPtrs(blk,5))   // Bellows effective area, sqin
#define ao      (*GetRealOparPtrs(blk,6))   // Bellows orifice area, sqin
#define c_      (*GetRealOparPtrs(blk,7))   // Bellows damping, lbf/in/s
#define cdo     (*GetRealOparPtrs(blk,8))   // Bellows orifice discharge coefficient
#define fb      (*GetRealOparPtrs(blk,9))   // Bellows preload at xmin, lbf
#define fdyf    (*GetRealOparPtrs(blk,10))  // Dynamic friction, lbf
#define fs      (*GetRealOparPtrs(blk,11))  // Spring preload at xmin, lbf
#define fstf    (*GetRealOparPtrs(blk,12))  // Static friction, lbf
#define kb      (*GetRealOparPtrs(blk,13))  // Spring rate, lbf/in
#define ks      (*GetRealOparPtrs(blk,14))  // Spring rate, lbf/in
#define m_      (*GetRealOparPtrs(blk,15))  // Total m_, lbm
#define xmax    (*GetRealOparPtrs(blk,16))  // Max head sensor position from flapper, in
#define xmin    (*GetRealOparPtrs(blk,17))  // Min head sensor position from flapper, in

// inputs
#define pf      (r_IN(0,0))     // Flapper supply, psia
#define ph      (r_IN(1,0))     // Cavity, psia
#define pl      (r_IN(2,0))     // Bellows supply, psia.
#define xol     (r_IN(3,0))     // Bellows displacement from flapper, in (open loop)

// outputs
#define wff     (r_OUT(0,0))    // Flapper discharge out, pph
#define wfh     (r_OUT(1,0))    // Cavity inflow, pph
#define wfl     (r_OUT(2,0))    // Bellows outflow, pph.
#define plx     (r_OUT(3,0))    // Bellows, psia.
#define v_out   (r_OUT(4,0))    // Velocity to open flapper, in/sec.
#define x_out   (r_OUT(5,0))    // Displacement from flapper, in
#define uf      (r_OUT(6,0))    // Unbalanced force from flapper, lbf
#define mode_out (r_OUT(7,0))   // ZCD mode


void head_b(scicos_block *blk, int flag)
{
    double uf_net = 0;
    int stops = 0;

    double f_f = 0;
    double f_cf = 0;
    double dwdc = DWDC(sg);
    
    // compute info needed for all passes
    wfl = Xdot*dwdc*ae;
    plx = OR_AWPDTOPS(ao, wfl, pl, cdo, sg);
    if(flag==-1) X = xol;   // Initialization call
    f_cf = tab1(f_ln/max(X, 1e-9), f_lqx, f_lqx+n_lqxcf, n_lqxcf);
    f_f = (pf - ph) * f_an * \
            (1. + 16. * SQR(f_cf * X / f_dn));
    uf  = ae * (ph - plx) + f_f - fs - fb - (ks + kb)*X - Xdot*c_;
    
    stops = 0;
    if(mode0==mode_lincos_override)
    {
        uf_net = uf;
    }
    else if(mode0==mode_move_plus)
    {
//        uf_net = uf - fdyf;
        uf_net = uf - fstf;
    }
    else if(mode0==mode_move_neg)
    {
//        uf_net = uf + fdyf;
        uf_net = uf + fstf;
    }
    else if(mode0==mode_stop_min)
    {
        uf_net = max(uf - fstf, 0);
        stops = 1;
    }
    else if(mode0==mode_stuck_plus)
    {
        uf_net = max(uf - fstf, 0);
    }
    else if(mode0==mode_stop_max)
    {
        uf_net = min(uf + fstf, 0);
        stops = 1;
    }
    else if(mode0==mode_stuck_neg)
    {
        uf_net = min(uf + fstf, 0);
    }

    switch (flag)
    {
        case 0:
            // compute the derivative of the continuous time states
            // TODO:  insert xol logic here
            if(mode0==mode_lincos_override)
            {
                V = Xdot;
                A = uf_net/m_*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else if(mode0==mode_move_plus || mode0==mode_move_neg)
            {
                V = Xdot;
                A = uf_net/m_*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else
            {
                V = 0;
                A = 0;
                Xdot = 0;
            }
            break;

        case -1:
        case 1:
            // compute the outputs of the block
            wff = SGN(pf - ph) * 19020. * \
                sqrt(fabs(pf - ph)*sg / \
                    (1./SQR(f_cn * f_an) + 1./SQR(f_cf * PI * f_dn * X)));
            wfh = wfl - wff;
            wff = wff;
            wfl = wfl;
            wfh = wfh;
            plx = plx;
            v_out = Xdot;
            x_out = X;
            uf = uf;
            mode_out = mode0;
//            mode_out = f_cf;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = Xdot;
			surf1 = uf-fstf;
			surf2 = uf+fstf;
            surf3 = X-xmin;
            surf4 = X-xmax;

            if (get_phase_simulation() == 1)
            {
                if(LINCOS_OVERRIDE && stops==0)
                    mode0 = mode_lincos_override;
                else if(surf3<=0 && surf1<=0)
                    mode0 = mode_stop_min;
                else if(surf4>=0 && surf2>=0)
                    mode0 = mode_stop_max;
                else if(uf>0)
                {
                    if(surf1<=0) mode0 = mode_stuck_plus;
                    else mode0 = mode_move_plus; 
                }
                else
                { 
                    if(surf2>=0) mode0 = mode_stuck_neg;
                    else mode0 = mode_move_neg; 
                 }
            }
            break;
    }
}
