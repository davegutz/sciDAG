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
#include "table.h"
#include "hyd_mod.h"
#define r_IN(n, i)  ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])

// parameters
#define SG              (GetRparPtrs(blk)[0]) // Fluid specific gravity
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

// **********valve_a
// valve_a Object parameters.  1st index is 1-based, 2nd index is 0-based.
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
#define PS  (r_IN(0,0)) // Supply pressure, psia
#define PD  (r_IN(1,0)) // Discharge pressure, psia
#define PH  (r_IN(2,0)) // High discharge pressure, psia
#define PRS (r_IN(3,0)) // Reference opposite spring end pressure, psia
#define PR  (r_IN(4,0)) // Regulated pressure, psia
#define PXR (r_IN(5,0)) // Reference pressure, psia
#define XOL (r_IN(6,0)) // Spool displacement toward drain, in (open loop)

// outputs
#define WFS     (r_OUT(0,0))    // Supply flow in, pph
#define WFD     (r_OUT(1,0))    // Discharge flow out, pph
#define WFH     (r_OUT(2,0))    // High discharge flow in, pph
#define WFVRS   (r_OUT(3,0))    // Reference opposite spring end flow in, pph
#define WFVR    (r_OUT(4,0))    // Reference flow out, pph
#define WFVX    (r_OUT(5,0))    // Damping flow out, pph
#define Vo      (r_OUT(6,0))    // Spool velocity toward drain, in/sec
#define Xo      (r_OUT(7,0))    // Spool displacement toward drain, in
#define UF_NET  (r_OUT(8,0))    // Unbalanced force toward drain net friction and damping, lbf
#define MODE    (r_OUT(9,0))    // Spool displacement toward drain, in


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


    // inputs and outputs
    double ps = PS;
    double pd = PD;
    double ph = PH;
    double prs = PRS;
    double pr = PR;
    double pxr = PXR;
    double xol = XOL;
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
    px = OR_AWPDTOPS(ao, wfvx, pxr, cdo, sg);
    ad = tab1(X, AD, AD+N_AD, N_AD);
    ah = tab1(X, AH, AH+N_AH, N_AH);
    fjd = cp * fabs(ps - pd)*ad;
    fjh = -cp * fabs(ps - ph)*ah;
    ftd = ld * 0.01365 * cd * Xdot * SSQRT(sg*(ps - pd));
    fth = -lh * 0.01365 * cd * Xdot * SSQRT(sg*(ps - ph));
    df = ps*(ax1-ax4) + prs*ax4 - pr*(ax1-ax2) - px*ax2 \
             - fs - X*ks - fjd - fjh - ftd - fth;
    

    if(mode0==mode_lincos_override)
    {
        DFnet = df - Xdot*c;
    }
    else if(mode0==mode_move_plus)
    {
        DFnet = df - fdyf - Xdot*c;
    }
    else if(mode0==mode_move_neg)
    {
        DFnet = df + fdyf - Xdot*c;
    }
    else if(mode0==mode_stop_min)
    {
        DFnet = max(df - fstf, 0);
        stops = 1;
    }
    else if(mode0==mode_stuck_plus)
    {
        DFnet = max(df - fstf, 0);
    }
    else if(mode0==mode_stop_max)
    {
        DFnet = min(df + fstf, 0);
        stops = 1;
    }
    else if(mode0==mode_stuck_neg)
    {
        DFnet = min(df + fstf, 0);
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
            wfd = OR_APTOW(ad, ps, pd, cd, sg);
            wfh = OR_APTOW(ah, ph, ps, cd, sg);
            wfs = wfd - wfh + Xdot*dwdc*(ax1-ax4);
            wfvrs  = Xdot*dwdc*ax4;
            wfvr   = Xdot*dwdc*(ax1-ax2);
            WFS = wfs;
            WFD = wfd;
            WFH = wfh;
            WFVRS = wfvrs;
            WFVR = wfvr;
            WFVX = wfvx;
            Vo = Xdot;
            Xo = X;
            UF_NET = DFnet;
            MODE = DFnet/mass*386;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = Xdot;
			surf1 = df-fstf;
			surf2 = df+fstf;
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
#undef C
#undef CD
#undef CP
#undef FDYF
#undef FS
#undef FSTF
#undef KS
#undef LD
#undef M
#undef XMAX
#undef XMIN
#undef N_AD
#undef AD
#undef XOL
#undef Vo
#undef Xo
#undef UF_NET
#undef MODE

// **********trivalve_a1
// trivalve_a1 Object parameters.  1st index is 1-based, 2nd index is 0-based.
#define NOPAR   (blk->nopar)
#define ADL     ((GetRealOparPtrs(blk,1))[0]);  // Spool drain end leakage area, sqin
#define AHD     ((GetRealOparPtrs(blk,2))[0]);  // Calculated drain end spool head area, sqin
#define AHS     ((GetRealOparPtrs(blk,3))[0]);  // Supply end spool head area, sqin
#define ALD     ((GetRealOparPtrs(blk,4))[0]);  // Drain end load head area, sqin
#define ALE     ((GetRealOparPtrs(blk,5))[0]);  // Bitter end load head area, sqin
#define ALR     ((GetRealOparPtrs(blk,6))[0]);  // Supply end load head area, sqin
#define AR      ((GetRealOparPtrs(blk,7))[0]);  // Calculated spool rod area, sqin
#define ASL     ((GetRealOparPtrs(blk,8))[0]);  // Spool supply end leakage area, sqin
#define C       ((GetRealOparPtrs(blk,9))[0]);  // Dynamic damping, lbf/(in/s)
#define CD      ((GetRealOparPtrs(blk,10))[0]); // Window discharge coefficient
#define CP      ((GetRealOparPtrs(blk,11))[0]); // Pressure force coeff, usually .69
#define FDYF    ((GetRealOparPtrs(blk,12))[0]); // Dynamic friction, lbf
#define FS      ((GetRealOparPtrs(blk,13))[0]); // Total spring preload toward drain, lbf
#define FSTF    ((GetRealOparPtrs(blk,14))[0]); // Spool static friction, lbf
#define KS      ((GetRealOparPtrs(blk,15))[0]); // Total spring rate, load decreases as valve moved toward drain, lbf/in
#define LD      ((GetRealOparPtrs(blk,16))[0]); // Damping effective length, the axial length between incoming and outgoing drain flow, in, positive
#define LS      ((GetRealOparPtrs(blk,17))[0]); // Damping effective length, the axial length between incoming and outgoing supply flow, in, positive
#define M       ((GetRealOparPtrs(blk,18))[0]); // Total mass, spool plus load, lbm.
#define XMAX    ((GetRealOparPtrs(blk,19))[0]); // Max stroke, in
#define XMIN    ((GetRealOparPtrs(blk,20))[0]); // Min stroke, in
#define N_AD    (blk->oparsz[20])
#define AD      (GetRealOparPtrs(blk,21))  // Table
#define N_AS    (blk->oparsz[21])
#define AS      (GetRealOparPtrs(blk,22))  // Table

// inputs
#define PS      (r_IN(0,0)) // Supply pressure, psia
#define PD      (r_IN(1,0)) // Drain pressure, psia
#define PX      (r_IN(2,0)) // Servo pressure, psia
#define PED     (r_IN(3,0)) // Drain end pressure, psia
#define PEL     (r_IN(4,0)) // Bitter end land load pressure, psia
#define PES     (r_IN(5,0)) // Supply end pressure, psia
#define PLD     (r_IN(6,0)) // Pressure on drain side of load land, psia
#define PLR     (r_IN(7,0)) // Pressure on supply side of load land, psia
#define FEXT    (r_IN(8,0)) // External load toward drain, lbf
#define XOL     (r_IN(9,0))// Spool displacement toward drain, in (open loop)

// outputs
#define WFS     (r_OUT(0,0))    // Supply flow in, pph
#define WFD     (r_OUT(1,0))    // Discharge flow out, pph
#define WFX     (r_OUT(2,0))    // Flow out control port, pph
#define WFDE    (r_OUT(3,0))    // Leakage out drain end, pph
#define WFLE    (r_OUT(4,0))    // Flow out of bitter end of land load, pph
#define WFSE    (r_OUT(5,0))    // Leakage out supply end, pph
#define WFLD    (r_OUT(6,0))    // Flow out drain end of land load, pph
#define WFLR    (r_OUT(7,0))    // Flow into supply end of land load, pph
#define WFSX    (r_OUT(8,0))    // Flow from supply to control, pph
#define WFXD    (r_OUT(9,0))    // Flow from control to drain, pph
#define Vo      (r_OUT(10,0))   // Spool velocity toward drain, in/sec
#define Xo      (r_OUT(11,0))   // Spool displacement toward drain, in
#define UF_NET  (r_OUT(12,0))   // Unbalanced force toward drain net friction and damping, lbf
#define MODE    (r_OUT(13,0))   // Spool displacement toward drain, in


#define REG_UNDERLAP -.001    /* "  Dead zone of drain, - is underlap. */
#define SBIAS .005              /* dead zone of supply + is underlap */
#define DBIAS .000              /* dead zone of drain + is underlap */
#define DORIFS   .125            /* "  Supply Reg. hole dia, in. */
#define DORIFD   .125            /* "  Drain Reg. hole dia, in. */
#define HOLES   2               /* "  # reg holes. */
#define CLEAR   .0004           /* "  Reg. dia clearance, in. */
#define WS      0.0               /* Reg supply linear window width, in*/
#define WD      0               /* Reg drain linear window width, in*/

void    reg_win_a(double x, double *as, double *ad){
double   xcrl;   /* Aux. leak dim, in. */
double   xscl;   /* Aux. leak dim, in. */
double   thcrl;  /* Aux. leak scaler. */
double   thscl;  /* Aux. leak scaler. */
double   alk;    /* Leak area, sqin. */

xcrl    = max(min(-(x+DBIAS) - REG_UNDERLAP, DORIFD), 0.);
xscl    = max(min((x+SBIAS), DORIFS), 0.);
thcrl   = acos(1. - xcrl * 2. / DORIFD);
thscl   = acos(1. - xscl * 2. / DORIFS);
alk     = CLEAR * (DORIFS + DORIFD)/2. * (PI - thcrl - thscl);
*as     = HOLES * ( max(hole(max(min(x+SBIAS, DORIFS), 0.), DORIFS),
			max(min(x+SBIAS, DORIFS),0.)*WS)
			+ alk);
*ad     = HOLES * ( max(hole(max(min(-(x+DBIAS) - REG_UNDERLAP, DORIFD), 0.), DORIFD),
			max(min(-(x+DBIAS) - REG_UNDERLAP, DORIFD), 0.)*WD) + alk);
return;
}   /* End reg_win_a. */

// *******trivalve_a1
void trivalve_a1(scicos_block *blk, int flag)
{
    double DFnet = 0;
    int stops = 0;
    double ad = 0;
    double as = 0;
    double mass = M;
    double c = C;
    double fstf = FSTF;
    double fdyf = FDYF;
    double xmin = XMIN;
    double xmax = XMAX;
    double EPS = 0;  // TODO:  delete this.  Holdover from non-zero-crossing implementation


    // inputs and outputs
    double ps = PS;
    double pd = PD;
    double px = PX;
    double ped = PED;
    double pel = PEL;
    double pes = PES;
    double pld = PLD;
    double plr = PLR;
    double fext = FEXT;
    double xol = XOL;
    double wfs, wfd, wfx, wfde, wfle, wfse, wfld, wflr, wfsx, wfxd;

    double fjd = 0;
    double fjs = 0;
    double ftd, fts;
    double cp = CP;
    double cd = CD;
    double sg = SG;
    double ld = LD;
    double ls = LS;
    double df = 0;
    double adl = ADL;
    double ahd = AHD;
    double ahs = AHS;
    double ald = ALD;
    double ale = ALE;
    double alr = ALR;
    double ar = AR;
    double asl = ASL;
    double fs = FS;
    double ks = KS;
    double dwdc = DWDC(sg);

    // compute info needed for all passes
//    ad = tab1(X, AD, AD+N_AD, N_AD);
//    as = tab1(X, AS, AS+N_AS, N_AS);
    reg_win_a(X, &as, &ad);
    fjd = cp * fabs(pd - px)*ad;
    fjs = -cp * fabs(px - ps)*as;
    ftd = ld * 0.01365 * cd * Xdot * SSQRT(sg*(pd - px));
    fts = -ls * 0.01365 * cd * Xdot * SSQRT(sg*(ps - px));
    df = pes*ahs - ped*ahd + plr*alr - pld*ald - pel*ale \
             + fext - fs - X*ks - fjd - fjs - ftd - fts;
    

    if(mode0==mode_lincos_override)
    {
        DFnet = df - Xdot*c;
    }
    else if(mode0==mode_move_plus)
    {
        DFnet = df - fdyf - Xdot*c;
    }
    else if(mode0==mode_move_neg)
    {
        DFnet = df + fdyf - Xdot*c;
    }
    else if(mode0==mode_stop_min)
    {
        DFnet = max(df - fstf, 0);
        stops = 1;
    }
    else if(mode0==mode_stuck_plus)
    {
        DFnet = max(df - fstf, 0);
    }
    else if(mode0==mode_stop_max)
    {
        DFnet = min(df + fstf, 0);
        stops = 1;
    }
    else if(mode0==mode_stuck_neg)
    {
        DFnet = min(df + fstf, 0);
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
            wfsx = OR_APTOW(as, ps, px, cd, sg);
            wfxd = OR_APTOW(ad, px, pd, cd, sg);
            wfx = wfsx - wfxd;
            wfse = OR_APTOW(asl, ps, pes, cd, sg);
            wfde = OR_APTOW(adl, pd, ped, cd, sg);
            wfs = wfsx - wfse;
            wfd = wfxd - wfde;
            wfse -= Xdot*dwdc*ahs;
            wfde += Xdot*dwdc*ahd;
            wfld = Xdot*dwdc*ald;
            wfle = Xdot*dwdc*ale;
            wflr = Xdot*dwdc*alr;
            WFS = wfs;
            WFD = wfd;
            WFX = wfx;
            WFDE = wfde;
            WFLE = wfle;
            WFSE = wfse;
            WFLD = wfld;
            WFLR = wflr;
            WFSX = wfsx;
            WFXD = wfxd;
            Vo = Xdot;
            Xo = X;
            UF_NET = DFnet;
            MODE = DFnet/mass*386;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = Xdot;
			surf1 = df-fstf;
			surf2 = df+fstf;
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
