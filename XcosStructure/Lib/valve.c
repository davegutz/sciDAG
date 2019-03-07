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
#define sg              (GetRparPtrs(blk)[0]) // Fluid specific gravity
#define LINCOS_OVERRIDE (GetRparPtrs(blk)[1]) // flag to disable friction for linearization

// states
#define X       (GetState(blk)[0])      // Position state
#define Xdot    (GetState(blk)[1])      // Velocity state
#define V       (GetDerState(blk)[0])   // Derivative of position
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
#define ao      (*GetRealOparPtrs(blk,1))   // Valve damp orifice area, sqin
#define ax1     (*GetRealOparPtrs(blk,2))   // Supply to reference cross section, sqin
#define ax2     (*GetRealOparPtrs(blk,3))   // Damping cross section, sqin
#define ax3     (*GetRealOparPtrs(blk,4))   // Supply cross section, sqin
#define ax4     (*GetRealOparPtrs(blk,5))   // Supply to opposite spring end cross section, sqin
#define c_      (*GetRealOparPtrs(blk,6))   // Damping coefficient, lbf/in/s
#define clin    (*GetRealOparPtrs(blk,7))   // Damping coefficient when linearizing (LINCOS_OVERRIDE), lbf/in/s
#define cd_     (*GetRealOparPtrs(blk,8))   // Coefficient of discharge
#define cdo     (*GetRealOparPtrs(blk,9))   // Damping orifice coefficient of discharge
#define cp      (*GetRealOparPtrs(blk,10))  // Pressure force coefficient, usually .69
#define fdyf    (*GetRealOparPtrs(blk,11))  // Dynamic friction, lbf
#define fs      (*GetRealOparPtrs(blk,12))  // Spring preload, lbf
#define fstf    (*GetRealOparPtrs(blk,13))  // Static friction, lbf
#define ks      (*GetRealOparPtrs(blk,14))  // Spring rate, lbf/in
#define ld      (*GetRealOparPtrs(blk,15)) // Damping length supply to discharge (effective), in
#define lh      (*GetRealOparPtrs(blk,16)) // Damping length supply to high discharge (effective), in
#define m_      (*GetRealOparPtrs(blk,17)) // Total mass (valve + spring contribution), lbm
#define xmax    (*GetRealOparPtrs(blk,18)) // Max stroke, in
#define xmin    (*GetRealOparPtrs(blk,19)) // Min stroke, in
#define N_AD    (blk->oparsz[19])
#define AD      (GetRealOparPtrs(blk,20))  // Table
#define N_AH    (blk->oparsz[20])
#define AH      (GetRealOparPtrs(blk,21))  // Table

// inputs
#define ps  (r_IN(0,0)) // Supply pressure, psia
#define pd  (r_IN(1,0)) // Discharge pressure, psia
#define ph  (r_IN(2,0)) // High discharge pressure, psia
#define prs (r_IN(3,0)) // Reference opposite spring end pressure, psia
#define pr  (r_IN(4,0)) // Regulated pressure, psia
#define pxr (r_IN(5,0)) // Reference pressure, psia
#define xol (r_IN(6,0)) // Spool displacement toward drain, in (open loop)

// outputs
#define wfs     (r_OUT(0,0))    // Supply flow in, pph
#define wfd     (r_OUT(1,0))    // Discharge flow out, pph
#define wfh     (r_OUT(2,0))    // High discharge flow in, pph
#define wfvrs   (r_OUT(3,0))    // Reference opposite spring end flow in, pph
#define wfvr    (r_OUT(4,0))    // Reference flow out, pph
#define wfvx    (r_OUT(5,0))    // Damping flow out, pph
#define v_out   (r_OUT(6,0))    // Spool velocity toward drain, in/sec
#define x_out   (r_OUT(7,0))    // Spool displacement toward drain, in
#define uf      (r_OUT(8,0))    // Unbalanced force toward drain, lbf
#define mode_out (r_OUT(9,0))   // Zero-crossing mode_out

void valve_a(scicos_block *blk, int flag)
{
    double uf_net = 0;
    int stops = 0;
    double ad = 0;
    double ah = 0;

    double xin = X;
    int count = 0;
    double xp = xol;

    double fjd = 0;
    double fjh = 0;
    double ftd = 0;
    double fth = 0;
    double dwdc = DWDC(sg);
    double px = 0;
    double xmaxl = xmax;
    double xminl = xmin;

    // compute info needed for all passes
    wfvx = Xdot*dwdc*ax2;
    px = OR_AWPDTOPS(ao, wfvx, pxr, cdo, sg);
    ftd = ld * 0.01365 * cd_ * Xdot * SSQRT(sg*(ps - pd));
    fth = -lh * 0.01365 * cd_ * Xdot * SSQRT(sg*(ps - ph));
    
    if(flag==-1)
    {
        // Initialization
        count = 0;
        X = (xmaxl + xminl)/2;
        while ((fabs(uf)>1e-14 & count<100) | count<1)
        {
            count += 1;
            ad = tab1(X, AD, AD+N_AD, N_AD);
            ah = tab1(X, AH, AH+N_AH, N_AH);
            fjd = cp * fabs(ps - pd)*ad;
            fjh = -cp * fabs(ps - ph)*ah;
            uf = ps*(ax1-ax4) + prs*ax4 - pr*(ax1-ax2) - px*ax2 \
                - fs - X*ks - fjd - fjh;
            xp = X;
            if(uf>0)
            {
                X = (xp + xmaxl)/2;
                xminl = xp;
            }
            else
            {
                X = (xp + xminl)/2;
                xmaxl = xp;
            }
        }
        xol = X;
    }
    else
    {
        // Open loop for driving with input
        if (LINCOS_OVERRIDE==1) xin = xol;
        else                    xin = X;
        ad = tab1(xin, AD, AD+N_AD, N_AD);
        ah = tab1(xin, AH, AH+N_AH, N_AH);
        fjd = cp * fabs(ps - pd)*ad;
        fjh = -cp * fabs(ps - ph)*ah;
        uf = ps*(ax1-ax4) + prs*ax4 - pr*(ax1-ax2) - px*ax2 \
             - fs - xin*ks - fjd - fjh - ftd - fth - Xdot*c_;
    }
    stops = 0;
    if(mode0==mode_lincos_override || flag==-1)
    {
        // Alternate frequency response
        if (LINCOS_OVERRIDE==2) uf_net = xol;
        else                    uf_net = uf;
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
            wfd = OR_APTOW(ad, ps, pd, cd_, sg);
            wfh = OR_APTOW(ah, ph, ps, cd_, sg);
            wfs = wfd - wfh + Xdot*dwdc*(ax1-ax4);
            wfvrs  = Xdot*dwdc*ax4;
            wfvr   = Xdot*dwdc*(ax1-ax2);
            v_out = Xdot;
            x_out = X;
            mode_out = mode0;
            break;

        case 9:
            // compute zero crossing surfaces and set modes
            surf0 = Xdot;
//            surf1 = uf-fdyf;
//            surf2 = uf+fdyf;
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
                else if(Xdot>0)
                    mode0 = mode_move_plus;
                else if(Xdot<0)
                    mode0 = mode_move_neg;
                else
                { 
                    if(surf1>0) mode0 = mode_move_plus;
                    else if(surf2<0) mode0 = mode_move_neg;
                    else if(uf>0)mode0 = mode_stuck_plus;
                    else mode0 = mode_stuck_neg;
                }
            }
            break;
    }
}
#undef cd_
#undef cp_
#undef fdyf
#undef fs
#undef fstf
#undef ks
#undef ld
#undef m_
#undef xmax
#undef xmin
#undef N_AD
#undef AD
#undef xol
#undef v_out
#undef x_out
#undef UF_NET
#undef mode_out
#undef uf
#undef c_

// **********trivalve_a1
// trivalve_a1 Object parameters.  1st index is 1-based, 2nd index is 0-based.
#define NOPAR   (blk->nopar)
#define adl     (*GetRealOparPtrs(blk,1))   // Spool drain end leakage area, sqin
#define ahd     (*GetRealOparPtrs(blk,2))   // Calculated drain end spool head area, sqin
#define ahs     (*GetRealOparPtrs(blk,3))   // Supply end spool head area, sqin
#define ald     (*GetRealOparPtrs(blk,4))   // Drain end load head area, sqin
#define ale     (*GetRealOparPtrs(blk,5))   // Bitter end load head area, sqin
#define alr     (*GetRealOparPtrs(blk,6))   // Supply end load head area, sqin
#define ar      (*GetRealOparPtrs(blk,7))   // Calculated spool rod area, sqin
#define asl     (*GetRealOparPtrs(blk,8))   // Spool supply end leakage area, sqin
//#define C       ((GetRealOparPtrs(blk,9))[0])   // Dynamic damping, lbf/(in/s)
#define c_      (*GetRealOparPtrs(blk,9))   // Dynamic damping, lbf/(in/s)
#define cd_     (*GetRealOparPtrs(blk,10))  // Window discharge coefficient
#define cp_     (*GetRealOparPtrs(blk,11))  // Pressure force coeff, usually .69
#define fdyf    (*GetRealOparPtrs(blk,12))  // Dynamic friction, lbf
#define fs      (*GetRealOparPtrs(blk,13))  // Total spring preload toward drain, lbf
#define fstf    (*GetRealOparPtrs(blk,14))  // Spool static friction, lbf
#define ks      (*GetRealOparPtrs(blk,15))  // Total spring rate, load decreases as valve moved toward drain, lbf/in
#define ld      (*GetRealOparPtrs(blk,16))  // Damping effective length, the axial length between incoming and outgoing drain flow, in, positive
#define ls      (*GetRealOparPtrs(blk,17))  // Damping effective length, the axial length between incoming and outgoing supply flow, in, positive
#define m_      (*GetRealOparPtrs(blk,18))  // Total mass, spool plus load, lbm.
#define xmax    (*GetRealOparPtrs(blk,19))  // Max stroke, in
#define xmin    (*GetRealOparPtrs(blk,20))  // Min stroke, in
#define N_AD    (blk->oparsz[20])
#define AD      (GetRealOparPtrs(blk,21))  // Table
#define N_AS    (blk->oparsz[21])
#define AS      (GetRealOparPtrs(blk,22))  // Table

// inputs
#define ps      (r_IN(0,0)) // Supply pressure, psia
#define pd      (r_IN(1,0)) // Drain pressure, psia
#define px      (r_IN(2,0)) // Servo pressure, psia
#define ped     (r_IN(3,0)) // Drain end pressure, psia
#define pel     (r_IN(4,0)) // Bitter end land load pressure, psia
#define pes     (r_IN(5,0)) // Supply end pressure, psia
#define pld     (r_IN(6,0)) // Pressure on drain side of load land, psia
#define plr     (r_IN(7,0)) // Pressure on supply side of load land, psia
#define fext    (r_IN(8,0)) // External load toward drain, lbf
#define xol     (r_IN(9,0))// Spool displacement toward drain, in (open loop)

// outputs
#define wfs     (r_OUT(0,0))    // Supply flow in, pph
#define wfd     (r_OUT(1,0))    // Discharge flow out, pph
#define wfx     (r_OUT(2,0))    // Flow out control port, pph
#define wfde    (r_OUT(3,0))    // Leakage out drain end, pph
#define wfle    (r_OUT(4,0))    // Flow out of bitter end of land load, pph
#define wfse    (r_OUT(5,0))    // Leakage out supply end, pph
#define wfld    (r_OUT(6,0))    // Flow out drain end of land load, pph
#define wflr    (r_OUT(7,0))    // Flow into supply end of land load, pph
#define wfsx    (r_OUT(8,0))    // Flow from supply to control, pph
#define wfxd    (r_OUT(9,0))    // Flow from control to drain, pph
#define v_out   (r_OUT(10,0))   // Spool velocity toward drain, in/sec
#define x_out   (r_OUT(11,0))   // Spool displacement toward drain, in
#define uf      (r_OUT(12,0))   // Unbalanced force toward drain, lbf
#define mode_out (r_OUT(13,0))  // Zero-crossing mode_out

#define REG_UNDERLAP -.001    /* "  Dead zone of drain, - is underlap. */
#define SBIAS .005              /* dead zone of supply + is underlap */
#define DBIAS .000              /* dead zone of drain + is underlap */
#define DORIFS   .125            /* "  Supply Reg. hole dia, in. */
#define DORIFD   .125            /* "  Drain Reg. hole dia, in. */
#define HOLES   2               /* "  # reg holes. */
#define CLEAR   .0004           /* "  Reg. dia clearance, in. */
#define WS      0.0               /* Reg supply linear window width, in*/
#define WD      0               /* Reg drain linear window width, in*/

// Hole ports need to be modeled real-time.   Table lookups are too imprecise causing noise
void    reg_win_a(double x, double *as, double *ad)
{
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
    double uf_net = 0;
    int stops = 0;
    double ad = 0;
    double as = 0;
    double fjd = 0;
    double fjs = 0;
    double ftd = 0;
    double fts = 0;
    double dwdc = DWDC(sg);

    // compute info needed for all passes
    //    ad = tab1(X, AD, AD+N_AD, N_AD);
    //    as = tab1(X, AS, AS+N_AS, N_AS);
    reg_win_a(X, &as, &ad);
    fjd = cp * fabs(pd - px)*ad;
    fjs = -cp * fabs(px - ps)*as;
    ftd = ld * 0.01365 * cd_ * Xdot * SSQRT(sg*(pd - px));
    fts = ls * 0.01365 * cd_ * Xdot * SSQRT(sg*(ps - px));
    if(flag==-1)
    {
        // Initialization
        xol = (pes*ahs - ped*ahd + plr*alr - pld*ald - pel*ale \
             + fext + fs + fjd + fjs + ftd + fts - Xdot*c_)/ks;
        uf = 0;
    }
    else
    {
        uf = pes*ahs - ped*ahd + plr*alr - pld*ald - pel*ale \
             + fext + fs - X*ks + fjd + fjs + ftd + fts - Xdot*c_;
    }    
    stops = 0;
    if(mode0==mode_lincos_override)
    {
        uf_net = uf;
    }
    else if(mode0==mode_move_plus)
    {
        uf_net = uf - fstf;
    }
    else if(mode0==mode_move_neg)
    {
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
            wfsx = OR_APTOW(as, ps, px, cd_, sg);
            wfxd = OR_APTOW(ad, px, pd, cd_, sg);
            wfx = wfsx - wfxd;
            wfse = OR_APTOW(asl, ps, pes, cd_, sg);
            wfde = OR_APTOW(adl, pd, ped, cd_, sg);
            wfs = wfsx - wfse;
            wfd = wfxd - wfde;
            wfse -= Xdot*dwdc*ahs;
            wfde += Xdot*dwdc*ahd;
            wfld = Xdot*dwdc*ald;
            wfle = Xdot*dwdc*ale;
            wflr = Xdot*dwdc*alr;
            v_out = Xdot;
            if(flag==-1)    x_out = xol;  // Initialization
            else            x_out = X;
            mode_out = mode0;
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
                else if(Xdot>0)
                    mode0 = mode_move_plus;
                else if(Xdot<0)
                    mode0 = mode_move_neg;
                else
                { 
                    if(surf1>0) mode0 = mode_move_plus;
                    else if(surf2<0) mode0 = mode_move_neg;
                    else if(uf>0)mode0 = mode_stuck_plus;
                    else mode0 = mode_stuck_neg;
                }
            }
            break;
    }
}
#undef c_
#undef uf
#undef ax1
#undef ax1
#undef ax2
#undef ax3
#undef cd_
#undef cp_
#undef fdyf
#undef fstf
#undef m_
#undef xmax
#undef xmin
#undef px
#undef pr
#undef pd
#undef xol
#undef wfx
#undef v_out
#undef x_out
#undef uf
#undef mode_out

// *******hlfvalve_a
// hlfvalve_a Object parameters.  1st index is 1-based, 2nd index is 0-based.
#define NOPAR   (blk->nopar)
#define arc     (*GetRealOparPtrs(blk,1))   // Leakage area r to c, sqin
#define arx     (*GetRealOparPtrs(blk,2))   // Leakage area r to x, sqin
#define asr     (*GetRealOparPtrs(blk,3))   // Leakage area s to r, sqin
#define awd     (*GetRealOparPtrs(blk,4))   // Leakage area w to d, sqin
#define awx     (*GetRealOparPtrs(blk,5))   // Leakage area w to x, sqin
#define ax1     (*GetRealOparPtrs(blk,6))   // Supply cross section, sqin
#define ax2     (*GetRealOparPtrs(blk,7))   // Damping cross section, sqin
#define ax3     (*GetRealOparPtrs(blk,8))   // Cross section at a, sqin
#define axa     (*GetRealOparPtrs(blk,9))   // Leakage area x to a, sqin
#define c_      (*GetRealOparPtrs(blk,10))  // Dynamic damping, lbf/(in/s)
#define cd_     (*GetRealOparPtrs(blk,11))  // Window discharge coefficient
#define cp_     (*GetRealOparPtrs(blk,12))  // Pressure force coeff, usually .69
#define fdyf    (*GetRealOparPtrs(blk,13))  // Dynamic friction, lbf
#define fstf    (*GetRealOparPtrs(blk,14))  // Spool static friction, lbf
#define m_      (*GetRealOparPtrs(blk,15))  // Total mass, spool plus load, lbm.
#define xmax    (*GetRealOparPtrs(blk,16))  // Max stroke, in
#define xmin    (*GetRealOparPtrs(blk,17))  // Min stroke, in
#define N_AT    (blk->oparsz[17])
#define AT      (GetRealOparPtrs(blk,18))  // Table

// inputs
#define ps      (r_IN(0,0)) // Supply pressure, psia
#define px      (r_IN(1,0)) // Damping pressure, psia
#define pr      (r_IN(2,0)) // Regulated pressure, psia
#define pc      (r_IN(3,0)) // End pressure, psia
#define pa      (r_IN(4,0)) // End pressure, psia
#define pw      (r_IN(5,0)) // Wash pressure, psia
#define pd      (r_IN(6,0)) // Discharge pressure, psia
#define xol     (r_IN(7,0)) // Spool displacement toward drain, in (open loop)

// outputs
#define wfs     (r_OUT(0,0))    // Supply flow in, pph
#define wfd     (r_OUT(1,0))    // Discharge flow out, pph
#define wfsr    (r_OUT(2,0))    // Leakage s to r, pph
#define wfwd    (r_OUT(3,0))    // Leakage w to d, pph
#define wfw     (r_OUT(4,0))    // Into w, pph
#define wfwx    (r_OUT(5,0))    // Leakage w to x, pph
#define wfxa    (r_OUT(6,0))    // Leakage x to a, pph
#define wfrc    (r_OUT(7,0))    // Leakage r to c, pph
#define wfx     (r_OUT(8,0))    // Into x, pph
#define wfa     (r_OUT(9,0))    // Out a, pph
#define wfc     (r_OUT(10,0))   // Out c, pph
#define wfr     (r_OUT(11,0))   // Out r, pph
#define v_out   (r_OUT(12,0))   // Spool velocity toward drain, in/sec
#define x_out   (r_OUT(13,0))   // Spool displacement toward drain, in
#define uf      (r_OUT(14,0))   // Unbalanced force toward drain, lbf
#define mode_out (r_OUT(15,0))  // Zero-crossing mode_out
void hlfvalve_a(scicos_block *blk, int flag)
{
    double uf_net = 0;
    int stops = 0;
    double at = 0;
    double fj = 0;
    double dwdc = DWDC(sg);

    // compute info needed for all passes
    if(mode0==mode_lincos_override || flag==-1) X = xol;
    at = tab1(X, AT, AT+N_AT, N_AT);
    uf = -pr*(ax1-ax2) - pc*ax2 + pa*ax3 + px*(ax1-ax3) \
             + fj - Xdot*c_;
    stops = 0;
    if(mode0==mode_lincos_override)
    {
        uf_net = uf;
    }
    else if(mode0==mode_move_plus)
    {
        uf_net = uf - fstf;
    }
    else if(mode0==mode_move_neg)
    {
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
            wfs = OR_APTOW(at, ps, pd, cd_, sg);
            wfsr = OR_APTOW(asr, ps, pr, cd_, sg);
            wfwd = OR_APTOW(awd, pw, pd, cd_, sg);
            wfwx = OR_APTOW(awx, pw, px, cd_, sg);
            wfxa = OR_APTOW(axa, px, pa, cd_, sg);
            wfrc = OR_APTOW(arc, pr, pc, cd_, sg);
            wfd = wfs - wfsr + wfwd;
            wfa = -wfxa + dwdc*Xdot*ax3;
            wfc = wfrc + dwdc*Xdot*ax2;
            wfx = wfxa + dwdc*Xdot*(ax1-ax3) - wfwx;
            wfw = wfwx + wfwd;
            wfr = wfsr - wfrc + dwdc*Xdot*(ax1-ax2);
            v_out = Xdot;
            x_out = X;
            mode_out = mode0;
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
                else if(Xdot>0)
                    mode0 = mode_move_plus;
                else if(Xdot<0)
                    mode0 = mode_move_neg;
                else
                { 
                    if(surf1>0) mode0 = mode_move_plus;
                    else if(surf2<0) mode0 = mode_move_neg;
                    else if(uf>0)mode0 = mode_stuck_plus;
                    else mode0 = mode_stuck_neg;
                }
            }
            break;
    }
}
