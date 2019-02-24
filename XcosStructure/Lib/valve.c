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
// Jan 26, 2019    DA Gutz        Created
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
//#define surf5   (GetGPtrs(blk)[5])
//#define surf6   (GetGPtrs(blk)[6])
#define mode0   (GetModePtrs(blk)[0])

// Zero-crossing modes
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
#define UF      (r_OUT(8,0))    // Unbalanced force toward drain, lbf
#define MODE    (r_OUT(9,0))    // Zero-crossing mode


void valve_a(scicos_block *blk, int flag)
{
    double DFnet = 0;
    int stops = 0;
    double ad = 0;
    double ah = 0;
    double mass = M;
    double c = C;
    double fstf = FSTF;
    //double fdyf = FDYF;
    double xmin = XMIN;
    double xmax = XMAX;

    // inputs and outputs
    double x = X;
    double ps = PS;
    double pd = PD;
    double ph = PH;
    double prs = PRS;
    double pr = PR;
    double pxr = PXR;
    double xol = XOL;
    double wfs, wfd, wfh, wfvrs, wfvr;

    int count = 0;
    double xp = XOL;

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
    double xmaxl = XMAX;
    double xminl = XMIN;

    // compute info needed for all passes
    wfvx   = Xdot*dwdc*ax2;
    px = OR_AWPDTOPS(ao, wfvx, pxr, cdo, sg);
    ftd = ld * 0.01365 * cd * Xdot * SSQRT(sg*(ps - pd));
    fth = -lh * 0.01365 * cd * Xdot * SSQRT(sg*(ps - ph));
    
    if(flag==-1)
    {
        // Initialization
        count = 0;
        while ((fabs(df)>1e-14 & count<100) | count<1)
        {
            count += 1;
            ad = tab1(x, AD, AD+N_AD, N_AD);
            ah = tab1(x, AH, AH+N_AH, N_AH);
            fjd = cp * fabs(ps - pd)*ad;
            fjh = -cp * fabs(ps - ph)*ah;
            df = ps*(ax1-ax4) + prs*ax4 - pr*(ax1-ax2) - px*ax2 \
                - fs - x*ks - fjd - fjh;
            xp = x;
            if(df>0)
            {
                x = (xp + xmaxl)/2;
                xminl = xp;
            }
            else
            {
                x = (xp + xminl)/2;
                xmaxl = xp;
            }
        }
        xol = x;
    }
    else
    {
        ad = tab1(x, AD, AD+N_AD, N_AD);
        ah = tab1(x, AH, AH+N_AH, N_AH);
        fjd = cp * fabs(ps - pd)*ad;
        fjh = -cp * fabs(ps - ph)*ah;
        df = ps*(ax1-ax4) + prs*ax4 - pr*(ax1-ax2) - px*ax2 \
             - fs - x*ks - fjd - fjh - ftd - fth - Xdot*c;
    }
    stops = 0;
    if(mode0==mode_lincos_override || flag==-1)
    {
        DFnet = df;
    }
    else if(mode0==mode_move_plus)
    {
//        DFnet = df - fdyf;
        DFnet = df - fstf;
    }
    else if(mode0==mode_move_neg)
    {
//        DFnet = df + fdyf;
        DFnet = df + fstf;
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
            // TODO:  insert xol logic here
            if(mode0==mode_lincos_override)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else if(mode0==mode_move_plus || mode0==mode_move_neg)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
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
            Xo = x;
            UF = df;
            MODE = mode0;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = Xdot;
//            surf1 = df-fdyf;
//            surf2 = df+fdyf;
            surf1 = df-fstf;
            surf2 = df+fstf;
            surf3 = x-xmin;
            surf4 = x-xmax;

            if (get_phase_simulation() == 1)
            {
                if(LINCOS_OVERRIDE && stops==0)
                    mode0 = mode_lincos_override;
                else if(surf3<=0 && surf1<=0)
                    mode0 = mode_stop_min;
                else if(surf4>=0 && surf2>=0)
                    mode0 = mode_stop_max;
                else if(Xdot>0)
                    mode0 = mode_move_plus;
                else if(Xdot<0)
                    mode0 = mode_move_neg;
                else
                { 
                    if(surf1>0) mode0 = mode_move_plus;
                    else if(surf2<0) mode0 = mode_move_neg;
                    else if(df>0)mode0 = mode_stuck_plus;
                    else mode0 = mode_stuck_neg;
                }
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
#undef UF

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
#define UF      (r_OUT(12,0))   // Unbalanced force toward drain, lbf
#define MODE    (r_OUT(13,0))   // Zero-crossing mode

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
//    double fdyf = FDYF;
    double xmin = XMIN;
    double xmax = XMAX;

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
    fts = ls * 0.01365 * cd * Xdot * SSQRT(sg*(ps - px));
    if(flag==-1)
    {
        // Initialization
        xol = (pes*ahs - ped*ahd + plr*alr - pld*ald - pel*ale \
             + fext + fs + fjd + fjs + ftd + fts - Xdot*c)/ks;
        df = 0;
    }
    else
    {
        df = pes*ahs - ped*ahd + plr*alr - pld*ald - pel*ale \
             + fext + fs - X*ks + fjd + fjs + ftd + fts - Xdot*c;
    }    
    stops = 0;
    if(mode0==mode_lincos_override)
    {
        DFnet = df;
    }
    else if(mode0==mode_move_plus)
    {
        DFnet = df - fstf;
    }
    else if(mode0==mode_move_neg)
    {
        DFnet = df + fstf;
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
            // TODO:  insert xol logic here
            if(mode0==mode_lincos_override)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
            }
            else if(mode0==mode_move_plus || mode0==mode_move_neg)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
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
            if(flag==-1)    Xo = xol;  // Initialization
            else            Xo = X;
            UF = df;
            MODE = mode0;
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
                else if(Xdot>0)
                    mode0 = mode_move_plus;
                else if(Xdot<0)
                    mode0 = mode_move_neg;
                else
                { 
                    if(surf1>0) mode0 = mode_move_plus;
                    else if(surf2<0) mode0 = mode_move_neg;
                    else if(df>0)mode0 = mode_stuck_plus;
                    else mode0 = mode_stuck_neg;
                }
            }
            break;
    }
}
#undef UF
#undef AX1
#undef AX2
#undef AX3
#undef C
#undef CD
#undef CP
#undef FDYF
#undef FSTF
#undef M
#undef XMAX
#undef XMIN
#undef PX
#undef PR
#undef PD
#undef XOL
#undef WFX
#undef Vo
#undef Xo
#undef UF
#undef MODE

// *******hlfvalve_a
// hlfvalve_a Object parameters.  1st index is 1-based, 2nd index is 0-based.
#define NOPAR   (blk->nopar)
#define ARC     ((GetRealOparPtrs(blk,1))[0]);  // Leakage area r to c, sqin
#define ARX     ((GetRealOparPtrs(blk,2))[0]);  // Leakage area r to x, sqin
#define ASR     ((GetRealOparPtrs(blk,3))[0]);  // Leakage area s to r, sqin
#define AWD     ((GetRealOparPtrs(blk,4))[0]);  // Leakage area w to d, sqin
#define AWX     ((GetRealOparPtrs(blk,5))[0]);  // Leakage area w to x, sqin
#define AX1     ((GetRealOparPtrs(blk,6))[0]);  // Supply cross section, sqin
#define AX2     ((GetRealOparPtrs(blk,7))[0]);  // Damping cross section, sqin
#define AX3     ((GetRealOparPtrs(blk,8))[0]);  // Cross section at a, sqin
#define AXA     ((GetRealOparPtrs(blk,9))[0]);  // Leakage area x to a, sqin
#define C       ((GetRealOparPtrs(blk,10))[0]); // Dynamic damping, lbf/(in/s)
#define CD      ((GetRealOparPtrs(blk,11))[0]); // Window discharge coefficient
#define CP      ((GetRealOparPtrs(blk,12))[0]); // Pressure force coeff, usually .69
#define FDYF    ((GetRealOparPtrs(blk,13))[0]); // Dynamic friction, lbf
#define FSTF    ((GetRealOparPtrs(blk,14))[0]); // Spool static friction, lbf
#define M       ((GetRealOparPtrs(blk,15))[0]); // Total mass, spool plus load, lbm.
#define XMAX    ((GetRealOparPtrs(blk,16))[0]); // Max stroke, in
#define XMIN    ((GetRealOparPtrs(blk,17))[0]); // Min stroke, in
#define N_AT    (blk->oparsz[17])
#define AT      (GetRealOparPtrs(blk,18))  // Table

// inputs
#define PS      (r_IN(0,0)) // Supply pressure, psia
#define PX      (r_IN(1,0)) // Damping pressure, psia
#define PR      (r_IN(2,0)) // Regulated pressure, psia
#define PC      (r_IN(3,0)) // End pressure, psia
#define PA      (r_IN(4,0)) // End pressure, psia
#define PW      (r_IN(5,0)) // Wash pressure, psia
#define PD      (r_IN(6,0)) // Discharge pressure, psia
#define XOL     (r_IN(7,0)) // Spool displacement toward drain, in (open loop)

// outputs
#define WFS     (r_OUT(0,0))    // Supply flow in, pph
#define WFD     (r_OUT(1,0))    // Discharge flow out, pph
#define WFSR    (r_OUT(2,0))    // Leakage s to r, pph
#define WFWD    (r_OUT(3,0))    // Leakage w to d, pph
#define WFW     (r_OUT(4,0))    // Into w, pph
#define WFWX    (r_OUT(5,0))    // Leakage w to x, pph
#define WFXA    (r_OUT(6,0))    // Leakage x to a, pph
#define WFRC    (r_OUT(7,0))    // Leakage r to c, pph
#define WFX     (r_OUT(8,0))    // Into x, pph
#define WFA     (r_OUT(9,0))    // Out a, pph
#define WFC     (r_OUT(10,0))   // Out c, pph
#define WFR     (r_OUT(11,0))   // Out r, pph
#define Vo      (r_OUT(12,0))   // Spool velocity toward drain, in/sec
#define Xo      (r_OUT(13,0))   // Spool displacement toward drain, in
#define UF      (r_OUT(14,0))   // Unbalanced force toward drain, lbf
#define MODE    (r_OUT(15,0))   // Zero-crossing mode
void hlfvalve_a(scicos_block *blk, int flag)
{
    double DFnet = 0;
    int stops = 0;
    double at = 0;
    double mass = M;
    double c = C;
    double fstf = FSTF;
//    double fdyf = FDYF;
    double xmin = XMIN;
    double xmax = XMAX;
    double fj = 0;

    // inputs and outputs
    double ps = PS;
    double px = PX;
    double pr = PR;
    double pc = PC;
    double pa = PA;
    double pw = PW;
    double pd = PD;
    double xol = XOL;
    double wfs, wfd, wfsr, wfwd, wfw, wfwx, wfxa, wfrc, wfx, wfa, wfc, wfr;

    double cp = CP;
    double cd = CD;
    double sg = SG;
    double df = 0;
    double arc = ARC;
    double arx = ARX;
    double asr = ASR;
    double awd = AWD;
    double awx = AWX;
    double ax1 = AX1;
    double ax2 = AX2;
    double ax3 = AX3;
    double axa = AXA;
    double dwdc = DWDC(sg);

    double x = X;

    // compute info needed for all passes
    if(mode0==mode_lincos_override || flag==-1) x = xol;
    at = tab1(x, AT, AT+N_AT, N_AT);
    df = -pr*(ax1-ax2) - pc*ax2 + pa*ax3 + px*(ax1-ax3) \
             + fj - Xdot*c;
    stops = 0;
    if(mode0==mode_lincos_override)
    {
        DFnet = df;
    }
    else if(mode0==mode_move_plus)
    {
        DFnet = df - fstf;
    }
    else if(mode0==mode_move_neg)
    {
        DFnet = df + fstf;
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
            else if(mode0==mode_move_plus || mode0==mode_move_neg)
            {
                V = Xdot;
                A = DFnet/mass*386.4; // 386.4 = 32.2*12 to convert ft-->in & lbm-->slugs
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
            wfs = OR_APTOW(at, ps, pd, cd, sg);
            wfsr = OR_APTOW(asr, ps, pr, cd, sg);
            wfwd = OR_APTOW(awd, pw, pd, cd, sg);
            wfwx = OR_APTOW(awx, pw, px, cd, sg);
            wfxa = OR_APTOW(axa, px, pa, cd, sg);
            wfrc = OR_APTOW(arc, pr, pc, cd, sg);
            wfd = wfs - wfsr + wfwd;
            wfa = -wfxa + dwdc*Xdot*ax3;
            wfc = wfrc + dwdc*Xdot*ax2;
            wfx = wfxa + dwdc*Xdot*(ax1-ax3) - wfwx;
            wfw = wfwx + wfwd;
            wfr = wfsr - wfrc + dwdc*Xdot*(ax1-ax2);
            WFS = wfs;
            WFD = wfd;
            WFSR = wfsr;
            WFWD = wfwd;
            WFW = wfw;
            WFWX = wfwx;
            WFXA = wfxa;
            WFRC = wfrc;
            WFX = wfx;
            WFA = wfa;
            WFC = wfc;
            WFR = wfr;
            Vo = Xdot;
            Xo = x;
            UF = df;
            MODE = mode0;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = Xdot;
            surf1 = df-fstf;
            surf2 = df+fstf;
            surf3 = x-xmin;
            surf4 = x-xmax;

            if (get_phase_simulation() == 1)
            {
                if(LINCOS_OVERRIDE && stops==0)
                    mode0 = mode_lincos_override;
                else if(surf3<=0 && surf1<=0)
                    mode0 = mode_stop_min;
                else if(surf4>=0 && surf2>=0)
                    mode0 = mode_stop_max;
                else if(Xdot>0)
                    mode0 = mode_move_plus;
                else if(Xdot<0)
                    mode0 = mode_move_neg;
                else
                { 
                    if(surf1>0) mode0 = mode_move_plus;
                    else if(surf2<0) mode0 = mode_move_neg;
                    else if(df>0)mode0 = mode_stuck_plus;
                    else mode0 = mode_stuck_neg;
                }
            }
            break;
    }
}
