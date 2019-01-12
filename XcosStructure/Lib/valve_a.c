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
// Jan 1, 2019     DA Gutz     Created 
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
#include "tables.h"
#define r_IN(n, i)  ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters
#define SG              (GetRparPtrs(blk)[0]) // Fluid specific gravity
#define LINCOS_OVERRIDE (GetRparPtrs(blk)[1]) // flag to disable friction for linearization

// Object parameters.  1st index is 1-based, 2nd index is 0-based.
#define NOPAR   (blk->nopar)
#define AO      ((GetRealOparPtrs(blk,1))[0]);  // Valve damp orifice area, sqin
#define AX1     ((GetRealOparPtrs(blk,2))[0]);  // Supply to reference cross section, sqin
#define AX2     ((GetRealOparPtrs(blk,3))[0]);  // Damping cross section, sqin
#define AX3     ((GetRealOparPtrs(blk,4))[0]);  // Supply cross section, sqin
#define AX4     ((GetRealOparPtrs(blk,5))[0]);  // Supply to opposite spring end cross section, sqin
#define C       ((GetRealOparPtrs(blk,6))[0]);  // Damping coefficient, lbf/in/s
#define CLIN    ((GetRealOparPtrs(blk,7))[0]);  // Damping coefficient when linearizing (LINCOS_OVERRIDE), lbf/in/s
#define CD      ((GetRealOparPtrs(blk,8))[0]);  // Coefficient of discharge
#define CDO     ((GetRealOparPtrs(blk,9))[0]);  // Damping orifice coefficient of discharge
#define CP      ((GetRealOparPtrs(blk,10))[0]); // Pressure force coefficient, usually .69
#define FDYF    ((GetRealOparPtrs(blk,11))[0]); // Dynamic friction, lbf
#define FS      ((GetRealOparPtrs(blk,12))[0]); // Spring preload, lbf
#define FSTF    ((GetRealOparPtrs(blk,13))[0]); // Static friction, lbf
#define KS      ((GetRealOparPtrs(blk,14))[0]); // Spring rate, lbf/in
#define LD      ((GetRealOparPtrs(blk,15))[0]); // Damping length supply to discharge (effective), in
#define LH      ((GetRealOparPtrs(blk,16))[0]); // Damping length supply to high discharge (effective), in
#define M       ((GetRealOparPtrs(blk,17))[0]); // Total mass (valve + spring contribution), lbm
#define XMAX    ((GetRealOparPtrs(blk,18))[0]); // Max stroke, in
#define XMIN    ((GetRealOparPtrs(blk,19))[0]); // Min stroke, in
#define N_AD    (blk->oparsz[19])
#define AD      (GetRealOparPtrs(blk,20))  // Table
#define N_AH    (blk->oparsz[20])
#define AH      (GetRealOparPtrs(blk,21))  // Table

// inputs
#define DF (r_IN(0,0)) // force imbalance

// states
#define X       (GetState(blk)[0])      // position state
#define V       (GetDerState(blk)[0])   // derivative of position
#define Xdot    (GetState(blk)[1])      // velocity state
#define A       (GetDerState(blk)[1])   // derivative of velocity

// outputs
#define Xo      (r_OUT(0, 0))       // position, in
#define Vo      (r_OUT(1, 0))       // velocity, in/s
#define DFneto  (r_OUT(2, 0))       // unbalanced force, lbf
#define mode0o  (r_OUT(3, 0))       // mode
#define Mo      (r_OUT(4, 0))       // mass

// other constants
#define surf0   (GetGPtrs(blk)[0])
#define surf1   (GetGPtrs(blk)[1])
#define surf2   (GetGPtrs(blk)[2])
#define surf3   (GetGPtrs(blk)[3])
#define surf4   (GetGPtrs(blk)[4])
#define mode0   (GetModePtrs(blk)[0])


// if X>=Xmax, then mode is 3
// if X<=xmin, then mode is -3
// if Xdot >= EPS, then mode is 2
// if Xdot <= -EPS, then mode is -2
// if 0<=Xdot<EPS and u<FSTF, then mode is 1
// if -EPS<Xdot<=0 and u>-FSTF, then mode is -1
#define mode_stop_max 3
#define mode_stop_min -3
#define mode_move_plus 2
#define mode_move_neg -2
#define mode_stuck_plus 1
#define mode_stuck_neg -1
#define mode_lincos_override 0
#define SQR(A)      ((A)*(A))
#define SGN(A)      ((A) < 0. ? -1 : 1)
#define SSQRT(A)    (SGN(A)*sqrt(fabs(A)))
#define SSQR(A)     (SGN(A)*SQR(A))
#define OR_APTOW(A, PS, PD, CD, SG)\
                 ((A) * 19020. * (CD) * SSQRT((SG) * ((PS) - (PD))))
#define OR_AWTOP(A, W, PD, CD, SG)\
                 ((PD) + SSQR((W) / 19020. / max((A), 1e-12) / (CD)) / (SG))
#define LA_KPTOW(K, PS, PD, KVIS)\
                 (K) / (KVIS) * ((PS) - (PD))
#define LA_WPTOK(WF, PS, PD, KVIS)\
                 (KVIS) * (WF) / ((PS) - (PD))
#define LA_LRECPTOW(L, R, E, C, PS, PD, KVIS)\
                    (4.698e8 * (R) *((C)*(C)*(C)) / (KVIS) /\
		     (L) * (1. + 1.5 * SQR((E)/(C))) * ((PS) - (PD)))
#define OR_WPTOA(W, PS, PD, CD, SG)\
                 ((W) / SGN((PS) - (PD)) /\
            max(sqrt(fabs((SG) * ((PS) - (PD)))), 1e-16) / (CD) / 19020.)
#define DWDC(SG)    (129.93948 * (SG))

void valve_a(scicos_block *blk, int flag)
{
    double DFnet = 0;
    int stops = 0;
    double ad = 0;
    double ah = 0;
    double mass = M;
    double c = C;
    double fstf = FSTF;
    double fdyf = FDYF;
    double xmin = XMIN;
    double xmax = XMAX;
    double EPS = 0;  // TODO:  delete this.  Holdover from non-zero-crossing implementation

// ps    I # 1, supply pressure, psia.
// pd    I # 2, discharge pressure, psia.
// ph    I # 3, high discharge pressure, psia.
// prs   I # 4, Reference opposite spring eng pressure, psia.
// pr    I # 5, Regulated pressure, psia.
// pxr   I # 6, Reference pressure, psia.
// x     I # 7, spool displacement toward drain, in(open loop)
// wfs   O # 1, supply flow in, pph.
// wfd   O # 2, discharge flow out, pph.
// wfh   O # 3, high discharge flow in, pph.
// wfvrs O # 4, reference opposite spring end flow in, pph.
// wfvr  O # 5, reference flow out, pph.
// wfvx  O # 6, damping flow out, pph.
// dxdt  O # 7, spool velocity toward drain, in/sec.
// x     O # 8, spool displacement toward drain, in.

    // inputs and outputs
    double ps, pd, ph, prs, pr, pxr;
    double wfs, wfd, wfh, wfvrs, wfvr;

    double fjd = 0;
    double fjh = 0;
    double ftd, fth;
    double cp = CP;
    double cd = CD;
    double sg = SG;
    double ld = LD;
    double lh = LH;
    double df = 0;
    double ax1 = AX1;
    double ax2 = AX2;
    double ax3 = AX3;
    double ax4 = AX4;
    double fs = FS;
    double ks = KS;
    double dwdc = DWDC(sg);
    double wfvx, px;
    double ao = AO;
    double cdo = CDO;

    // compute info needed for all passes
    wfvx   = Xdot*dwdc*ax2;
    px = OR_APTOW(ao, wfvx, pxr, cdo, sg);
    ad = tab1(X, AD, AD+N_AD, N_AD);
    ah = tab1(X, AH, AH+N_AH, N_AH);
    fjd = cp * fabs(ps - pd)*ad;
    fjh = -cp * fabs(ps - ph)*ah;
    ftd = ld * 0.01365 * cd * Xdot * SSQRT(sg*(ps - pd));
    fth = -lh * 0.01365 * cd * Xdot * SSQRT(sg*(ps - ph));
    df = ps*(ax1-ax4) + prs*ax4 - pr*(ax1-ax2) - px*ax2 \
             - fs - X*ks - fjd - fjh - ftd - fth;
    wfd = OR_APTOW(ad, ps, pd, cd, sg);
    wfh = OR_APTOW(ah, ph, ps, cd, sg);
    wfs = wfd - wfh + Xdot*dwdc*(ax1-ax4);
    wfvrs  = Xdot*dwdc*ax4;
    wfvr   = Xdot*dwdc*(ax1-ax2);

    if(mode0==mode_lincos_override)
    {
        DFnet = DF - Xdot*c;
    }
    else if(mode0==mode_move_plus)
    {
        DFnet = DF - fdyf - Xdot*c;
    }
    else if(mode0==mode_move_neg)
    {
        DFnet = DF + fdyf - Xdot*c;
    }
    else if(mode0==mode_stop_min)
    {
        DFnet = max(DF - fstf, 0);
        stops = 1;
    }
    else if(mode0==mode_stuck_plus)
    {
        DFnet = max(DF - fstf, 0);
    }
    else if(mode0==mode_stop_max)
    {
        DFnet = min(DF + fstf, 0);
        stops = 1;
    }
    else if(mode0==mode_stuck_neg)
    {
        DFnet = min(DF + fstf, 0);
    }

    switch (flag)
    {
        case 0:
           // compute the derivative of the continuous time states
            if(mode0==mode_lincos_override)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else if(mode0==mode_move_plus)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else if(mode0==mode_move_neg)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else if(mode0==mode_stop_min)
            {
                V = 0;
                A = 0;
                Xdot = 0;
            }
            else if(mode0==mode_stuck_plus)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else if(mode0==mode_stop_max)
            {
                V = 0;
                A = 0;
                Xdot = 0;
            }
            else if(mode0==mode_stuck_neg)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            break;

        case 1:
            // compute the outputs of the block
            Xo = X;
            Vo = Xdot;
            DFneto = DFnet;
            mode0o = mode0;
            Mo = ah;
           break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = Xdot;
			surf1 = DF-fstf;
			surf2 = DF+fstf;
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
