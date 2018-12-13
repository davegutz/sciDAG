/*-----------------------------------------------------------------------------------
 *  Copyright (C) 2007, 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
 *
 *  This file is part of RTSS, the Robotics Toolbox for Scilab/Scicos.
 *
 *  RTSS is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  RTSS is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with RTSS; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *--------------------------------------------------------------------------------- */



/*
 *  @author     Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 *  @date       April 2007
 *  @note       TODO: memory management. For further details, read
 *              http://apps.sourceforge.net/mediawiki/rtss/index.php?title=Reduction_of_memory_leaks
 *              http://apps.sourceforge.net/mediawiki/rtss/index.php?title=Profiling_RTSS
 *  $LastChangedDate: 2009-04-19 17:07:03 +0200(dom, 19 apr 2009) $
 */



#include <string.h>
#include <stack-c.h>
#include "../includes/rtss_error.h" /* Interface to ERROR module */
#include "../includes/rtss.h"       /* RTSS Interface Function Library header file */

int sci_rt_frne(fname)
    char * fname;
{
/*
 * sci_rt_frne : C interface for Scilab function rt_frne()
 *
 *  @brief      Compute the inverse dynamics via the recursive Newton-Euler formulation (SCI_GATEWAY function).
 *  @param      1, mlist. The complete Scilab Robot object.
 *  @param      2-6, joint state vector,
 *                   joint velocity vector,
 *                   joint acceleration vector,
 *                   gravity vector which overrides the default one,
 *                   external force/moment acting on the end of the manipulator.
 *  @return     LhsVar(1), joint torque matrix.
 *
 *  @note       this code is inspired by the MATLAB(R) MEX file implemented
 *              in the Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
 *  @ref        robot7.1/mex/frne.c  , Robotics Toolbox for MATLAB(R)
 *
 *  @author     Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 *  @date       April 2007
 */
    int mq, nq, mqd, nqd, mqdd, nqdd, mgrav, ngrav, mfext, nfext;
    int iq, iqd, iqdd, igrav, ifext, itau;
    int N;
    double * q, * qd, * qdd, * grav = NULL, * fext = NULL, * tau;
    rtss_robot R;

    CheckRhs(2, 6);    

    /*                                                           */
    /* init the robot and get its parameters from Scilab's stack */
    /* TODO: prevent eary memory allocation here!                */
    /*                                                           */
    rtssRobotInitFromStk(&R, 1);
    N = R.dof;

    /*                                 */
    /* get the others input parameters */
    /*                                 */
    switch(Rhs) {

        case 5:
            /* tau = rt_frne(robot, Q, QD, QDD, grav) */
            GetRhsVar(2, "d", &mq, &nq, &iq);
            GetRhsVar(3, "d", &mqd, &nqd, &iqd);
            GetRhsVar(4, "d", &mqdd, &nqdd, &iqdd);
            CheckSameDims(2, 3, mq, nq, mqd, nqd);
            CheckSameDims(3, 4, mqd, nqd, mqdd, nqdd);
            CheckLength(2, nq, N);
            GetRhsVar(5, "d", &mgrav, &ngrav, &igrav);
            CheckLength(5, mgrav*ngrav, 3);
            q = stk(iq);
            qd = stk(iqd);
            qdd = stk(iqdd);
            grav = stk(igrav);
            break;

        case 4:
            /* tau = rt_frne(robot, Q, QD, QDD)              *
             * tau = rt_frne(robot, [Q QD QDD], grav, fext)  */
            GetRhsVar(2, "d", &mq, &nq, &iq);
            if (nq == 3*N) {
                GetRhsVar(3, "d", &mgrav, &ngrav, &igrav);
                CheckLength(3, mgrav*ngrav, 3);
                GetRhsVar(4, "d", &mfext, &nfext, &ifext);
                CheckLength(4, mfext*nfext, 6);
                q = stk(iq);
                qd = stk(iq + mq*N);
                qdd = stk(iq + 2*mq*N);
                grav = stk(igrav);
                fext = stk(ifext);
            }
            else {
                GetRhsVar(3, "d", &mqd, &nqd, &iqd);
                GetRhsVar(4, "d", &mqdd, &nqdd, &iqdd);
                CheckSameDims(2, 3, mq, nq, mqd, nqd);
                CheckSameDims(3, 4, mqd, nqd, mqdd, nqdd);
                CheckLength(2, nq, N);
                q = stk(iq);
                qd = stk(iqd);
                qdd = stk(iqdd);
            }
            break;

        case 6:
            /* tau = rt_frne(robot, Q, QD, QDD, grav, fext) */
            GetRhsVar(2, "d", &mq, &nq, &iq);
            GetRhsVar(3, "d", &mqd, &nqd, &iqd);
            GetRhsVar(4, "d", &mqdd, &nqdd, &iqdd);
            CheckSameDims(2, 3, mq, nq, mqd, nqd);
            CheckSameDims(3, 4, mqd, nqd, mqdd, nqdd);
            CheckLength(2, nq, N);
            GetRhsVar(5, "d", &mgrav, &ngrav, &igrav);
            CheckLength(5, mgrav*ngrav, 3);
            GetRhsVar(6, "d", &mfext, &nfext, &ifext);
            CheckLength(6, mfext*nfext, 6);
            q = stk(iq);
            qd = stk(iqd);
            qdd = stk(iqdd);
            grav = stk(igrav);
            fext = stk(ifext);
            break;

        case 3:
            /* tau = rt_frne(robot, [Q QD QDD], grav) */
            GetRhsVar(2, "d", &mq, &nq, &iq);
            CheckLength(2, nq, 3*N);
            GetRhsVar(3, "d", &mgrav, &ngrav, &igrav);
            CheckLength(3, mgrav*ngrav, 3);
            q = stk(iq);
            qd = stk(iq + mq*N);
            qdd = stk(iq + 2*mq*N);
            grav = stk(igrav);
            break;

        case 2:
            /* tau = rt_frne(robot, [Q QD QDD]) */
            GetRhsVar(2, "d", &mq, &nq, &iq);
            CheckLength(2, nq, 3*N);
            q = stk(iq);
            qd = stk(iq + mq*N);
            qdd = stk(iq + 2*mq*N);
            break;

        default:
            rtss_err_fail(999, "you should not to be here...");
    }

    /*                              */
    /* compute the inverse dynamics */
    /*                              */
    CreateVar(Rhs + 1, "d", &mq, &N, &itau);            /* matrix for the return argument */
    tau = stk(itau);

    if (grav)                                           /* change robot parameters as the user wants */
        rtssRobotSetGravity(R, grav);

    rtss_dyn_frne(tau, &R, mq, q, qd, qdd, fext);       /* execute RNE algorithm */

    /*                                                       */
    /* destroy the constituent links (created via malloc()), */
    /* return result in Scilab's workspace,                  */
    /* and finally exit                                      */
    /*                                                       */
    rtssRobotDestroyLinks(&R);
    LhsVar(1) = Rhs + 1;                                /* return result in Scilab's workspace */
    return(RTSS_SUCCESS);
}
