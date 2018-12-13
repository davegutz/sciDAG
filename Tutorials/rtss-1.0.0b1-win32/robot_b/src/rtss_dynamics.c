/*-----------------------------------------------------------------------------------
 *  Copyright (C) 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



/**
 * @file  rtss_dynamics.c
 *
 * @brief Implementation of DYNAMICS submodule
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         May 2008
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-08-23 19:43:41 +0200(dom, 23 ago 2009) $
 */



#include <stack-c.h>                /* TRUE_, FALSE_ */
#include "../includes/rtss_error.h" /* Interface to ERROR module */
#include "../includes/rtss.h"       /* Interface to DYNAMICS submodule */

/*--------------------------------------------------------------------
 * Symbols and abbreviations used in comments 
 *
 *      Abbreviation    Corresponding Macro     Meaning
 *      ============    ===================     =======
 *      OMEGA(j)        rtssLinkOmega(L[j])     Angular velocity
 *      OMEGADOT(j)     rtssLinkOmegaDot(L[j])  Angular acceleration
 *      ACC(j)          rtssLinkAcc(L[j])       Linear acceleration
 *      ACC_COG(j)      rtssLinkAccCOG(L[j])    Linear acceln of COG
 *      f(j)            rtssLinkForce(L[j])     Force on link j due to link j-1
 *      n(j)            rtssLinkMoment(L[j])    Torque on link j due to link j-1
 *      ROT(j)          rtssLinkRot(L[j])       Link rotation matrix
 *      M(j)            L[j].m                  Link mass
 *      PSTAR(j)        rtssLinkPstar(L[j])     Offset link j from link (j-1) wrt link i
 *      TRANSL(j)       rtssLinkTransl(L[j])    Offset link j from link (j-1) wrt link j-1
 *      R_COG(j)        rtssLinkCOG(L[j])       COG link j w.r.t. link j
 *      INERTIA(j)      rtssLinkInertia(L[j])   Inertia of link about COG
 *
 * They should make the main code easier to read.
 *-------------------------------------------------------------------- */

/**
 * @brief Recursive Newton-Euler algorithm for STANDARD DH-based robot objects
 *
 * @param[in]  robot pointer to robot object to be simulated
 * @param[in]  np number of points in the input trajectory
 * @param[in]  q pointer to the joint state vector
 * @param[in]  qd pointer to the joint velocity vector
 * @param[in]  qdd pointer to the joint acceleration vector
 * @param[in]  fext pointer to vector of external generalized force acting on the end of
 *                  manipulator and expressed in the end-effector coordinate frame
 * @param[out] tau pointer to vector of resulting joint torque
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 *
 * @author     Peter I. Corke, CSIRO Division of Manufacturing Technology
 * @author     modified by Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 *
 * @note       Modifications are the following:
 *               - changed name and order of input parameters
 *               - code adapted to use the new RtssLink and RtssRobot structures
 *               - sorted the standard-DH-based algorithm from the modified-DH-based
 *               - the whole trajectory is valued in this function
 *               - avoided use of parameter @p stride
 *               - disabled debug.
 *               - fixed bug #1869464. For further details see:<br>
 * <code> http://sourceforge.net/tracker/index.php?func=detail&aid=1869464&group_id=206553&atid=998060 </code><br>
 * <code> http://rtss.svn.sourceforge.net/viewvc/rtss/branches/rel-0.2.x/src/rt_frne.c?r1=43&r2=42&pathrev=43 </code>
 *
 * @note       Modifications on May 2008:
 *               - using the new librtssc modular organization
 *               - matrices are bidimensional double arrays
 *               - using the new RTSS math library with its interface to Netlib's BLAS
 *
 * @note       Modifications on April 2009:
 *               - DYNAMICS module is now using all the data structures from the MATH module,
 *                 i.e. matrices and vectors are no longer implemented by arrays of doubles.
 *
 * @date       May 2008
 */
static int
rtss_dyn_frne_dh_(double * tau, rtss_robot * robot, int np, double * q, double * qd, double * qdd, double * fext)
{
    int p, j, N;
    double t;
    rtss_link * L;
    rtss_vect3 zero, t1, t2;
    rtss_vect3 qdv, qddv;
    rtss_vect3 z0;
    rtss_vect3 f_tip, n_tip;

    /* initialize zero, z0, f_tip and n_tip */
    rtssVect3SetAll(zero, 0.0, 0.0, 0.0);
    rtssVect3SetAll(z0, 0.0, 0.0, 1.0);
    n_tip = f_tip = zero;

    /* get robot DOF and a pointer to robot's constituent links */
    N = robot->dof;
    L = robot->links;

    /* for each point in the input trajectory   */
    for (p = 0; p < np; p++) {

        /* update all position dependent variables */
        for (j = 0; j < N; j++)
            rtss_kin_link_trans(&L[j], &q[p + j*np]);

        /* angular rate and acceleration vectors only have finite z-axis component */
        qddv = qdv = zero;

        /* setup external force/moment vectors */
        if (fext) {
            rtssVect3Set(f_tip, fext);
            rtssVect3Set(n_tip, &fext[3]);
        }

        /* forward recursion -- the kinematics  */
        /*                                      */
        for (j = 0; j < N; j++) {

            /* create angular vector from scalar input */
            rtssVect3SetZ(qdv, qd[p + j*np]);
            rtssVect3SetZ(qddv, qdd[p + j*np]);

            switch(L[j].sigma) {

                case RTSS_REVOLUTE_JOINT:
                    /* calculate OMEGA(j) */
                    /* OMEGA(0):= ROT'(0)*qdv                                 */
                    /* OMEGA(j):= ROT'(j)*(qdv + OMEGA(j-1)), j = 1, ..., N-1 */
                    t1 = qdv;
                    if (j)
                        rtss_math_daxpy(3, 1.0, rtssLinkOmega(L[j-1]), rtssVect3Num(t1));
                    rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssVect3Num(t1), 0.0, rtssLinkOmega(L[j]));

                    /* calculate OMEGADOT(j) */
                    /* OMEGADOT(0):= ROT'(0)*qddv                                                            */
                    /* OMEGADOT(j):= ROT'(j)*(qddv + OMEGADOT(j-1) + cross(OMEGA(j-1),qdv)), j = 1, ..., N-1 */
                    t1 = qddv;
                    if (j) {
                        rtss_math_daxpy(3, 1.0, rtssLinkOmegaDot(L[j-1]), rtssVect3Num(t1));
                        rtss_math_cross(rtssLinkOmegaDot(L[j]), 1.0, rtssLinkOmega(L[j-1]), 1.0, rtssVect3Num(qdv));  /* temporary assignment to OMEGADOT(j) */
                        rtss_math_daxpy(3, 1.0, rtssLinkOmegaDot(L[j]), rtssVect3Num(t1));
                    }
                    rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssVect3Num(t1), 0.0, rtssLinkOmegaDot(L[j])); /* actual assignemnt to OMEGADOT(j) */

                    /* calculate ACC(j) */
                    /* ACC(0):= cross( OMEGA(0), cross(OMEGA(0), PSTAR(0)) ) + cross(OMEGADOT(0), PSTAR(0)) + ROT'(0)*robot.gravity */
                    /* ACC(j):= cross( OMEGA(j), cross(OMEGA(j), PSTAR(j)) ) + cross(OMEGADOT(j), PSTAR(j)) + ROT'(j)*ACC(j-1), j = 1, ..., N-1 */
                    rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmega(L[j]), 1.0, rtssLinkPstar(L[j]));
                    rtss_math_cross(rtssLinkAcc(L[j]), 1.0, rtssLinkOmega(L[j]), 1.0, rtssVect3Num(t1)); /* temporary assignment to ACC(j) */
                    rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmegaDot(L[j]), 1.0, rtssLinkPstar(L[j]));
                    rtss_math_daxpy(3, 1.0, rtssVect3Num(t1), rtssLinkAcc(L[j])); /* temporary assignment to ACC(j) */
                    rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), (j) ?
                            rtssLinkAcc(L[j-1]) : rtssRobotGravity(*robot), 1.0, rtssLinkAcc(L[j])); /* actual assignemnt to ACC(j) */
                    break;

                case RTSS_PRISMATIC_JOINT:
                    /* calculate OMEGA(j) */
                    /* OMEGA(0):= zero                                  */
                    /* OMEGA(j):= ROT'(j)*(OMEGA(j-1)), j = 1, ..., N-1 */
                    if (j == 0)
                        L[j].omega = zero;
                    else
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssLinkOmega(L[j-1]), 0.0, rtssLinkOmega(L[j])); /* actual assignemnt to OMEGA(j) */

                    /* calculate OMEGADOT(j) */
                    /* OMEGADOT(0):= zero                                     */
                    /* OMEGADOT(j):= ROT'(j)*(OMEGADOT(j-1)), j = 1, ..., N-1 */
                    if (j == 0)
                        L[j].omega_d = zero;
                    else
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssLinkOmegaDot(L[j-1]), 0.0, rtssLinkOmegaDot(L[j])); /* actual assignemnt to OMEGADOT(j) */

                    /* calculate ACC(j) */
                    /* ACC(0):= ROT'(0)*(qddv + robot.gravity) + cross(OMEGADOT(0),PSTAR(0)) + 2*cross(OMEGA(0), ROT'(0)*qdv) + cross(OMEGA(0),cross(OMEGA(0), PSTAR(0)))*/
                    /* ACC(j):= ROT'(j)*(qddv + ACC(j-1)) + cross(OMEGADOT(j),PSTAR(j)) + 2*cross(OMEGA(j), ROT'(j)*qdv) + cross(OMEGA(j),cross(OMEGA(j), PSTAR(j))), j = 1, ..., N-1 */
                    if (j == 0)
                        t1 = robot->gravity;
                    else
                        t1 = L[j-1].acc;
                    rtss_math_daxpy(3, 1.0, rtssVect3Num(qddv), rtssVect3Num(t1)); /* t1 <- qddv + (ACC(j-1)||robot.gravity) */
                    rtss_math_cross(rtssLinkAcc(L[j]), 1.0, rtssLinkOmegaDot(L[j]), 1.0, rtssLinkPstar(L[j])); /* ACC(j) <- cross(OMEGADOT(j),PSTAR(j))*/
                    rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssVect3Num(t1), 1.0, rtssLinkAcc(L[j])); /* SUM OF FIRST TWO ADDENDS: ACC(j) <- ROT'(j)*t1 + ACC(j) */
                    rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssVect3Num(qdv), 0.0, rtssVect3Num(t1)); /* t1 <- ROT'(j)*qdv */
                    rtss_math_cross(rtssVect3Num(t2), 1.0, rtssLinkOmega(L[j]), 1.0, rtssVect3Num(t1)); /* t2 <- cross(OMEGA(j), t1)*/
                    rtss_math_daxpy(3, 2.0, rtssVect3Num(t2), rtssLinkAcc(L[j])); /* ADD THE THIRD ADDEND: ACC(j) <- ACC(j) + 2*t2*/
                    rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmega(L[j]), 1.0, rtssLinkPstar(L[j])); /* t1 <- cross(OMEGA(j), PSTAR(j)) */
                    rtss_math_cross(rtssVect3Num(t2), 1.0, rtssLinkOmega(L[j]), 1.0, rtssVect3Num(t1)); /* t2 <- cross(OMEGA(j),t1) */
                    rtss_math_daxpy(3, 1.0, rtssVect3Num(t2), rtssLinkAcc(L[j])); /* ADD THE FOURTH ADDEND: ACC(j) <- ACC(j) + t2*/
                    break;

            }

            /* calculate ACC_COG(j) */
            /* ACC_COG(0):= cross( OMEGA(0), cross(OMEGA(0), R_COG(0)) ) + cross(OMEGADOT(0), R_COG(0)) + ACC(0) */
            /* ACC_COG(j):= cross( OMEGA(j), cross(OMEGA(j), R_COG(j)) ) + cross(OMEGADOT(j), R_COG(j)) + ACC(j), j = 1, ..., N-1 */
            rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmega(L[j]), 1.0, rtssLinkCOG(L[j]));
            rtss_math_cross(rtssLinkAccCOG(L[j]), 1.0, rtssLinkOmega(L[j]), 1.0, rtssVect3Num(t1)); /* temporary assignment to ACC_COG(j) */
            rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmegaDot(L[j]), 1.0, rtssLinkCOG(L[j]));
            rtss_math_daxpy(3, 1.0, rtssVect3Num(t1), rtssLinkAccCOG(L[j])); /* temporary assignment to ACC_COG(j) */
            rtss_math_daxpy(3, 1.0, rtssLinkAcc(L[j]), rtssLinkAccCOG(L[j])); /* actual assignment to ACC_COG(j) */
        }

        /* backward recursion -- the kinetics   */
        /*                                      */
        for (j = N - 1; j >= 0; j--) {
            /* compute f(j) */
            /* f(N-1):= M(N-1)*ACC_COG(N-1) + f_tip       */
            /* f(j)  := ROT(j+1)*f(j+1) + M(j)*ACC_COG(j) */
            if (j == N - 1) {
                L[j].f = f_tip;
                rtss_math_daxpy(3, L[j].m, rtssLinkAccCOG(L[j]), rtssLinkForce(L[j]));
            }
            else {
                L[j].f = L[j].abar;
                rtss_math_dgemv(1.0, RTSS_MATH_NOTRANS, 3, 3, rtssLinkRot(L[j+1]), rtssLinkForce(L[j+1]), L[j].m, rtssLinkForce(L[j]));
            }

            /* compute n(j) */
            /* case j == N-1                                                                                    */
            /*      x:= cross( PSTAR(j) + R_COG(j), M(j)*ACC_COG(j) ) + cross( PSTAR(j), f_tip ) + n_tip        */
            /*      wd:= OMEGADOT(j)                                                                            */
            /*      y:= cross( OMEGA(j), INERTIA(j)*OMEGA(j) ) + x                                              */
            /*      n(j) = INERTIA(j)*wd + y                                                                    */
            /*                                                                                                  */
            /* case j == 0, ..., N-2                                                                            */
            /*      x:= cross( OMEGA(j), INERTIA(j)*OMEGA(j) ) + cross( PSTAR(j) + R_COG(j), M(j)*ACC_COG(j) )  */
            /*      wd:= OMEGADOT(j)                                                                            */
            /*      y:= INERTIA(j)*wd + x                                                                       */
            /*      z:= cross( ROT(j+1)'*PSTAR(j), f(j+1) ) + n(j+1)                                            */
            /*      n(j):= ROT(j+1)*z + y                                                                       */
            /*                                                                                                  */
            /* that can also be written as follows:                                                             */
            /*                                                                                                  */
            /* r:= cross( OMEGA(j), INERTIA(j)*OMEGA(j) ) + cross( PSTAR(j) + R_COG(j), M(j)*ACC_COG(j) )       */
            /* u:= INERTIA(j)*OMEGADOT(j) + r                                                                   */
            /*                                                                                                  */
            /* case j == N-1                                                                                    */
            /*      n(j) = u + cross( PSTAR(j), f_tip ) + n_tip                                                 */
            /*                                                                                                  */
            /* case j == 0, ..., N-2                                                                            */
            /*      x:= cross( ROT(j+1)'*PSTAR(j), f(j+1) ) + n(j+1)                                            */
            /*      n(j):= ROT(j+1)*x + u                                                                       */
            /*                                                                                                  */
            rtss_math_dsymv(1.0, 3, rtssLinkInertia(L[j]), rtssLinkOmega(L[j]), 0.0, rtssVect3Num(t1));
            rtss_math_cross(rtssVect3Num(t2), 1.0, rtssLinkOmega(L[j]), 1.0, rtssVect3Num(t1));
            t1 = L[j].rbar;
            rtss_math_daxpy(3, 1.0, rtssLinkPstar(L[j]), rtssVect3Num(t1));
            rtss_math_cross(rtssLinkMoment(L[j]), 1.0, rtssVect3Num(t1), L[j].m, rtssLinkAccCOG(L[j]));
            rtss_math_daxpy(3, 1.0, rtssVect3Num(t2), rtssLinkMoment(L[j]));                                                     /* n(j) <- r */
            rtss_math_dsymv(1.0, 3, rtssLinkInertia(L[j]), rtssLinkOmegaDot(L[j]), 1.0, rtssLinkMoment(L[j]));  /* n(j) <- u =  INERTIA(j)*wd + r */
            if (j == N-1) {
                rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkPstar(L[j]), 1.0, rtssVect3Num(f_tip));
                rtss_math_daxpy(3, 1.0, rtssVect3Num(n_tip), rtssVect3Num(t1));
                rtss_math_daxpy(3, 1.0, rtssVect3Num(t1), rtssLinkMoment(L[j]));                                                 /* actual assignment to n(N-1) */
            }
            else {
                rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j+1]), rtssLinkPstar(L[j]), 0.0, rtssVect3Num(t1));
                rtss_math_cross(rtssVect3Num(t2), 1.0, rtssVect3Num(t1), 1.0, rtssLinkForce(L[j+1]));
                rtss_math_daxpy(3, 1.0, rtssLinkMoment(L[j+1]), rtssVect3Num(t2));                                               /* t2 <- x */
                rtss_math_dgemv(1.0, RTSS_MATH_NOTRANS, 3, 3, rtssLinkRot(L[j+1]), rtssVect3Num(t2), 1.0, rtssLinkMoment(L[j])); /* actual assignment to  n(j) */
            }
        }

        /* compute the torque total for each axis   */
        /*                                          */
        for (j = 0; j < N; j++) {
            rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssVect3Num(z0), 0.0, rtssVect3Num(t1));
            switch (L[j].sigma) {
                case RTSS_REVOLUTE_JOINT:
                    t = rtss_math_ddot(3, rtssLinkMoment(L[j]), rtssVect3Num(t1));
                    break;

                case RTSS_PRISMATIC_JOINT:
                    t = rtss_math_ddot(3, rtssLinkForce(L[j]), rtssVect3Num(t1));
                    break;
            }

            /* add actuator dynamics and friction */
            t += (L[j].G) * (
                (L[j].G) * (L[j].Jm) * qdd[p + j*np] +
                (L[j].B) * qd[p + j*np] +
                (qd[p + j*np] > 0 ? L[j].Tc[0] : 0.0) +
                (qd[p + j*np] < 0 ? L[j].Tc[1] : 0.0));
            tau[p + j*np] = t;
        }

    }
    return(RTSS_SUCCESS);

}

/**
 * @brief      Recursive Newton-Euler algorithm for MODIFIED DH-based robot objects
 *
 * @param[in]  robot pointer to robot object to be simulated
 * @param[in]  np number of points in the input trajectory
 * @param[in]  q pointer to the joint state vector
 * @param[in]  qd pointer to the joint velocity vector
 * @param[in]  qdd pointer to the joint acceleration vector
 * @param[in]  fext pointer to vector of external generalized force acting on the end of
 *                   manipulator and expressed in the end-effector coordinate frame
 * @param[out] tau pointer to vector of resulting joint torque
 *
 * @author     Peter I. Corke, CSIRO Division of Manufacturing Technology
 * @author     modified by Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 *
 * @note       Modifications are the following:
 *               - changed name and order of input parameters
 *               - code adapted to use the new RtssLink and RtssRobot structures
 *               - sorted the standard-DH-based algorithm from the modified-DH-based
 *               - the whole trajectory is valued in this function
 *               - avoided use of parameter @p stride
 *               - disabled debug.
 *
 * @note       Modifications on May 2008:
 *               - using the new librtssc modular organization
 *               - matrices are bidimensional double arrays
 *               - using the new RTSS math library with its interface to Netlib's BLAS
 *
 * @note       Modifications on April 2009:
 *               - DYNAMICS module is now using all the data structures from the MATH module,
 *                 i.e. matrices and vectors are no longer implemented by arrays of doubles.
 *               - fixed bug #2779877. For further details see:<br>
 * <code> http://sourceforge.net/tracker/?func=detail&aid=2779877&group_id=206553&atid=998060 </code><br>
 *
 * @date       May 2008
 */
static int
rtss_dyn_frne_mdh_(double * tau, rtss_robot * robot, int np, double * q, double * qd, double * qdd, double * fext)
{
    int p, j;
    double t;
    rtss_link * L;
    rtss_vect3 zero, t1, t2;
    rtss_vect3 qdv, qddv;
    rtss_vect3 z0;
    rtss_vect3 f_tip, n_tip;

    /* initialize zero, z0, f_tip and n_tip */
    rtssVect3SetAll(zero, 0.0, 0.0, 0.0);
    rtssVect3SetAll(z0, 0.0, 0.0, 1.0);
    n_tip = f_tip = zero;

    /* get a pointer to robot's constituent links */
    L = robot->links;

    /* for each point in the input trajectory   */
    for (p = 0; p < np; p++) {

        /* update all position dependent variables */
        for (j = 0; j < robot->dof; j++)
            rtss_kin_link_trans(&L[j], &q[p + j*np]);

        /* angular rate and acceleration vectors only have finite z-axis component */
        qdv = qddv = zero;

        /* setup external force/moment vectors */
        if (fext) {
            rtssVect3Set(f_tip, fext);
            rtssVect3Set(n_tip, &fext[3]);
        }

        /* forward recursion -- the kinematics  */
        /*                                      */
        for (j = 0; j < robot->dof; j++) {

            /* create angular vector from scalar input */
            rtssVect3SetZ(qdv, qd[p + j*np]);
            rtssVect3SetZ(qddv, qdd[p + j*np]);

            switch(L[j].sigma) {

                case RTSS_REVOLUTE_JOINT:
                    /* calculate OMEGA(j) */
                    /* OMEGA(0):= qdv                                       */
                    /* OMEGA(j):= ROT'(j)*OMEGA(j-1) + qdv, j = 1, ..., N-1 */
                    L[j].omega = qdv;
                    if (j) {
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssLinkOmega(L[j-1]), 0.0, rtssVect3Num(t1)); /* not rtss_math_dgemv because we're going to use t1 later */
                        rtss_math_daxpy(3, 1.0, rtssVect3Num(t1), rtssLinkOmega(L[j]));
                    }

                    /* calculate OMEGADOT(j) */
                    /* OMEGADOT(0):= qddv                                                                           */
                    /* OMEGADOT(j):= ROT'(j)*OMEGADOT(j-1) + cross(ROT'(j)*OMEGA(j-1), qdv) + qddv, j = 1, ..., N-1 */
                    L[j].omega_d = qddv;
                    if (j) {
                        rtss_math_cross(rtssVect3Num(t2), 1.0, rtssVect3Num(t1), 1.0, rtssVect3Num(qdv)); /* t2 <- cross(t1, qdv) */
                        rtss_math_daxpy(3, 1.0, rtssVect3Num(t2), rtssLinkOmegaDot(L[j]));    /* OMEGADOT(j) <- t2 + qddv */
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssLinkOmegaDot(L[j-1]), 1.0, rtssLinkOmegaDot(L[j])); /* OMEGADOT(j) <- ROT'(j)*OMEGADOT(j-1) + (t2 + qddv) */
                    }

                    /* calculate ACC(j)                                             */
                    /* ACC(0):= ROT'(j)*robot.gravity                               */
                    /* ACC(j):= ROT'(j)*( A1 + A2 + A3 ), j = 1, ..., N-1           */
                    /*          where:                                              */
                    /*          A1:= cross(OMEGADOT(j-1),TRANSL(j))                 */
                    /*          A2:= cross(OMEGA(j-1), cross(OMEGA(j-1),TRANSL(j))) */
                    /*          A3:= ACC(j-1)                                       */
                    if (j == 0)
                        t1 = robot->gravity;
                    else {
                        rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmega(L[j-1]), 1.0, rtssLinkTransl(L[j]));
                        rtss_math_cross(rtssVect3Num(t2), 1.0, rtssLinkOmega(L[j-1]), 1.0, rtssVect3Num(t1));
                        rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmegaDot(L[j-1]), 1.0, rtssLinkTransl(L[j]));
                        rtss_math_daxpy(3, 1.0, rtssVect3Num(t2), rtssVect3Num(t1)); /* t1 <- A2 + A1*/
                        rtss_math_daxpy(3, 1.0, rtssLinkAcc(L[j-1]), rtssVect3Num(t1)); /* t1 <- t1 + A3*/
                    }
                    rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssVect3Num(t1), 0.0, rtssLinkAcc(L[j]));
                    break;

                case RTSS_PRISMATIC_JOINT:

                    /* calculate OMEGA(j) */
                    /* OMEGA(0):= zero                                 */
                    /* OMEGA(j):= ROT'(j)*OMEGA(j-1)), j = 1, ..., N-1 */
                    if (j == 0)
                        L[j].omega = zero;
                    else
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssLinkOmega(L[j-1]), 0.0, rtssLinkOmega(L[j]));

                    /* calculate OMEGADOT(j) */
                    /* OMEGADOT(0):= zero                                  */
                    /* OMEGADOT(j):= ROT'(j)*OMEGADOT(j-1), j = 1, ..., N-1 */
                    if (j == 0)
                        L[j].omega_d = zero;
                    else
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssLinkOmegaDot(L[j-1]), 0.0, rtssLinkOmegaDot(L[j]));

                    /* calculate ACC(j) */
                    /* ACC(0):= ROT'(0)*robot.gravity + qddv                       */
                    /* ACC(j):= ROT'(j)*t1 + A, j = 1, ..., N-1                    */
                    /*                                                             */
                    /*          where:                                             */
                    /*                                                             */
                    /*  t1 := t1_1 + t1_2 + ACC(j-1)                               */
                    /*      t1_1 := cross(OMEGADOT(j-1), TRANSL(j))                */
                    /*      t1_2 := cross(OMEGA(j-1), cross(OMEGA(j-1),TRANSL(j))) */
                    /*  A := 2*A_1 + qddv                                          */
                    /*      A_1  := cross(ROT'(j)*OMEGA(j-1), qdv)                 */
                    L[j].acc = qddv;
                    if (j == 0) {
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssRobotGravity(*robot), 1.0, rtssLinkAcc(L[j]));
                    }
                    else {
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssLinkOmega(L[j-1]), 0.0, rtssVect3Num(t1));
                        rtss_math_cross(rtssVect3Num(t2), 1.0, rtssVect3Num(t1), 1.0, rtssVect3Num(qdv));
                        rtss_math_daxpy(3, 2.0, rtssVect3Num(t2), rtssLinkAcc(L[j])); /* temp assign */
                        rtss_math_cross(rtssVect3Num(t2), 1.0, rtssLinkOmega(L[j-1]), 1.0, rtssLinkTransl(L[j]));
                        rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmega(L[j-1]), 1.0, rtssVect3Num(t2)); /* t1 <- cross(OMEGA(j-1), cross(OMEGA(j-1),TRANSL(j))) */
                        rtss_math_cross(rtssVect3Num(t2), 1.0, rtssLinkOmegaDot(L[j-1]), 1.0, rtssLinkTransl(L[j]));
                        rtss_math_daxpy(3, 1.0, rtssVect3Num(t2), rtssVect3Num(t1)); /* t1 <- t1 + cross(OMEGADOT(j-1), TRANSL(j)) */
                        rtss_math_daxpy(3, 1.0, rtssLinkAcc(L[j-1]), rtssVect3Num(t1)); /* t1 <- t1 + ACC(j-1) */
                        rtss_math_dgemv(1.0, RTSS_MATH_TRANS, 3, 3, rtssLinkRot(L[j]), rtssVect3Num(t1), 1.0, rtssLinkAcc(L[j]));
                    }
                    break;
            }

            /* calculate ACC_COG(j) */
            /* ACC_COG(j):= A1 + A2 + A3, j = 0, ..., N-1                    */
            /*              where:                                           */
            /*              A1 := cross(OMEGA(j), cross(OMEGA(j), R_COG(j))) */
            /*              A2 := cross(OMEGADOT(j), R_COG(j))               */
            /*              A3 := ACC(j)                                     */
            rtss_math_cross(rtssLinkAccCOG(L[j]), 1.0, rtssLinkOmega(L[j]), 1.0, rtssLinkCOG(L[j])); /* temporary assignment */
            rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkOmega(L[j]), 1.0, rtssLinkAccCOG(L[j]));
            rtss_math_cross(rtssLinkAccCOG(L[j]), 1.0, rtssLinkOmegaDot(L[j]), 1.0, rtssLinkCOG(L[j])); /* temporary assignment */
            rtss_math_daxpy(3, 1.0, rtssVect3Num(t1), rtssLinkAccCOG(L[j])); /* temporary assignment */
            rtss_math_daxpy(3, 1.0, rtssLinkAcc(L[j]), rtssLinkAccCOG(L[j])); /* actual assignment to rtssLinkAccCOG */
        }

        /* backward recursion -- the kinetics   */
        /*                                      */
        for (j = robot->dof - 1; j >= 0; j--) {

            /* compute f(j) */
            /* f(N-1):= f_tip + M(j)*ACC_COG(j)                            */
            /* f(j)  := ROT(j+1)*f(j+1) + M(j)*ACC_COG(j) ,j = N-2, ..., 0 */
            if (j == (robot->dof - 1)) {
                L[j].f = f_tip;
                rtss_math_daxpy(3, L[j].m, rtssLinkAccCOG(L[j]), rtssLinkForce(L[j]));
            }
            else {
                L[j].f = L[j].abar;
                rtss_math_dgemv(1.0, RTSS_MATH_NOTRANS, 3, 3, rtssLinkRot(L[j+1]), rtssLinkForce(L[j+1]), L[j].m, rtssLinkForce(L[j]));
            }

            /* compute n(j)                                                                     */
            /*                                                                                  */
            /* n(j):= t1 + NN[j]                                                                */
            /*                                                                                  */
            /*          where:                                                                  */
            /*                                                                                  */
            /*      NN[j]   := cross(OMEGA(j), INERTIA(j)*OMEGA(j)) + INERTIA(j)*OMEGADOT(j)    */
            /*                                                                                  */
            /*          and:                                                                    */
            /* case j == N-1                                                                    */
            /*      t1      := n_tip + cross(R_COG(j), L[j].m*ACC_COG(j))                       */
            /*                                                                                  */
            /* case j == N-2, ..., 0                                                            */
            /*      t1      := A1 + cross(R_COG(j), L[j].m*ACC_COG(j))                          */
            /*          A1  := ROT(j+1)*n(j+1) + A2                                             */
            /*          A2  := cross(PSTAR(j+1), ROT(j+1)*f(j+1))                               */
            /*                                                                                  */
            rtss_math_dsymv(1.0, 3, rtssLinkInertia(L[j]), rtssLinkOmega(L[j]), 0.0, rtssVect3Num(t1));
            rtss_math_cross(rtssLinkMoment(L[j]), 1.0, rtssLinkOmega(L[j]), 1.0, rtssVect3Num(t1)); /* temp assign */
            rtss_math_dsymv(1.0, 3, rtssLinkInertia(L[j]), rtssLinkOmegaDot(L[j]), 1.0, rtssLinkMoment(L[j])); /* temp assign (compute NN[j]) */

            if (j == (robot->dof - 1))
                t1 = n_tip;
            else {
                rtss_math_dgemv(1.0, RTSS_MATH_NOTRANS, 3, 3, rtssLinkRot(L[j+1]), rtssLinkForce(L[j+1]), 0.0, rtssVect3Num(t2));
                rtss_math_cross(rtssVect3Num(t1), 1.0, rtssLinkTransl(L[j+1]), 1.0, rtssVect3Num(t2));
                rtss_math_dgemv(1.0, RTSS_MATH_NOTRANS, 3, 3, rtssLinkRot(L[j+1]), rtssLinkMoment(L[j+1]), 1.0, rtssVect3Num(t1));
            }

            rtss_math_cross(rtssVect3Num(t2), 1.0, rtssLinkCOG(L[j]), L[j].m, rtssLinkAccCOG(L[j]));
            rtss_math_daxpy(3, 1.0, rtssVect3Num(t2), rtssVect3Num(t1));
            rtss_math_daxpy(3, 1.0, rtssVect3Num(t1), rtssLinkMoment(L[j]));
        }

        /* compute the torque total for each axis   */
        /*                                          */
        for (j = 0; j < robot->dof; j++) {
            switch (L[j].sigma) {
                case RTSS_REVOLUTE_JOINT:
                    t = rtss_math_ddot(3, rtssLinkMoment(L[j]), rtssVect3Num(z0));
                    break;

                case RTSS_PRISMATIC_JOINT:
                    t = rtss_math_ddot(3, rtssLinkForce(L[j]), rtssVect3Num(z0));
                    break;
            }

            /* add actuator dynamics and friction */
            t += (L[j].G) * (
                (L[j].G) * (L[j].Jm) * qdd[p + j*np] +
                (L[j].B) * qd[p + j*np] +
                (qd[p + j*np] > 0 ? L[j].Tc[0] : 0.0) +
                (qd[p + j*np] < 0 ? L[j].Tc[1] : 0.0));
            tau[p + j*np] = t;
        }

    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for the allocation and initialization of a workspace, for manipulator
 *        joint-space inertia matrix computations
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wiptr pointer to an initialized workspace for inertia matrix computation
 */
int
rtss_wsinertia_init(rtss_wsinertia * wiptr, int dof)
{
    int i;

    if (!wiptr)
        rtss_err_null_ptr();
    if ((wiptr->zeros = rtss_malloc(dof*sizeof(double))) == NULL)
        rtss_err_fail(999, "Cannot allocate the workspace for manipulator joint-space inertia matrix computations");
    if ((wiptr->eye_r = rtss_malloc(dof*sizeof(double))) == NULL) {
        rtss_free(wiptr->zeros);
        rtss_err_fail(999, "Cannot allocate the workspace for manipulator joint-space inertia matrix computations");
    }
    for (i = 0; i < dof; i++) {
        wiptr->zeros[i] = 0.0;
        wiptr->eye_r[i] = 0.0;
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for destructing a workspace used for manipulator joint-space inertia matrix computations
 *
 * @param[out] wiptr freed pointer to rtss_wsinertia objects
 */
int
rtss_wsinertia_destroy(rtss_wsinertia * wiptr)
{
    if (!wiptr)
        rtss_err_null_ptr();
    rtss_free(wiptr->zeros);
    rtss_free(wiptr->eye_r);
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine which initializes a workspace for n-DOF manipulator
 *        Coriolis/centripetal torques computation
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wcptr pointer to an initialized workspace for Coriolis/centripetal torques computation
 */
int
rtss_wscoriolis_init(rtss_wscoriolis * wcptr, int dof)
{
    int i;

    if (!wcptr)
        rtss_err_null_ptr();
    if ((wcptr->zeros = rtss_malloc(dof*sizeof(double))) == NULL)
        rtss_err_fail(999, "Cannot allocate the workspace for manipulator Coriolis/centripetal torques computation");
    for (i = 0; i < dof; i++)
        wcptr->zeros[i] = 0.0;
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for destructing a workspace used for n-DOF manipulator
 *        Coriolis/centripetal torques computation
 *
 * @param[out] wcptr freed pointer to rtss_wsgravload objects
 */
int
rtss_wscoriolis_destroy(rtss_wscoriolis * wcptr)
{
    if (!wcptr)
        rtss_err_null_ptr();
    rtss_free(wcptr->zeros);
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine which initializes a workspace for n-DOF manipulator
 *        gravity torque components computations
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wgptr pointer to an initialized workspace for gravity torque components computations
 */
int
rtss_wsgravload_init(rtss_wsgravload * wgptr, int dof)
{
    int i;

    if (!wgptr)
        rtss_err_null_ptr();
    if ((wgptr->zeros = rtss_malloc(dof*sizeof(double))) == NULL)
        rtss_err_fail(999, "Cannot allocate the workspace for manipulator gravity torque components computations");
    for (i = 0; i < dof; i++)
        wgptr->zeros[i] = 0.0;
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for destructing a workspace used for n-DOF manipulator
 *        gravity torque components computations
 *
 * @param[out] wgptr freed pointer to rtss_wsgravload objects
 */
int
rtss_wsgravload_destroy(rtss_wsgravload * wgptr)
{
    if (!wgptr)
        rtss_err_null_ptr();
    rtss_free(wgptr->zeros);
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for the allocation of a workspace, for manipulator joint acceleration vector computation
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] waptr pointer to the workspace for joint acceleration vector computation
 */
int
rtss_wsaccel_init(rtss_wsaccel * waptr, int dof)
{
    if (!waptr)
        rtss_err_null_ptr();
    if ((waptr->wgctorq = rtss_malloc(dof*sizeof(double))) == NULL)
        rtss_err_fail(999, "Cannot allocate the workspace for gravity and Coriolis torques computation");
    if (rtss_wsinertia_init(&(waptr->winer), dof) == RTSS_FAILURE) {
        rtss_free(waptr->wgctorq);
        rtss_err_fail(999, "Cannot allocate the the buffer containing data for inertia matrix computation");
    }
    if ((waptr->inertia = rtss_malloc(dof*dof*sizeof(double))) == NULL) {
        rtss_free(waptr->wgctorq);
        rtssWSpaceInertiaDestroy(&(waptr->winer));
        rtss_err_fail(999, "Cannot allocate the workspace for inertia matrix computation");
    }
    if (rtss_imatrix_init(&(waptr->imat), dof) == RTSS_FAILURE) {
        rtss_free(waptr->wgctorq);
        rtssWSpaceInertiaDestroy(&(waptr->winer));
        rtss_free(waptr->inertia);
        rtss_err_fail(999, "Cannot allocate the the buffer to be used for the computation of the inverse of the inertia matrix");
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for destructing a workspace used for manipulator joint acceleration vector computation
 *
 * @param[out] waptr freed pointer to rtss_wsaccel objects
 */
int
rtss_wsaccel_destroy(rtss_wsaccel * waptr)
{
    if (!waptr)
        rtss_err_null_ptr();
    rtss_free(waptr->wgctorq);
    rtssWSpaceInertiaDestroy(&(waptr->winer));
    rtss_free(waptr->inertia)
    rtssWSpaceIMatrixDestroy(&(waptr->imat));
    return(RTSS_SUCCESS);
}

/**
 * @brief Compute inverse dynamics via recursive Newton-Euler formulation
 *
 * @param[in]  R pointer to robot object to be simulated
 * @param[in]  mq number of points in the input trajectory
 * @param[in]  q pointer to the joint state vector
 * @param[in]  qd pointer to the joint velocity vector
 * @param[in]  qdd pointer to the joint acceleration vector
 * @param[in]  fext pointer to vector of external generalized force acting on the end of
 *                   manipulator and expressed in the end-effector coordinate frame
 * @param[out] tau pointer to vector of resulting joint torque
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_dyn_frne_(double * tau, rtss_robot * R, int mq, double * q, double * qd, double * qdd, double * fext)
{
    return((R->mdh == RTSS_DH_MODIFIED) ?
        rtss_dyn_frne_mdh_(tau, R, mq, q, qd, qdd, fext) : rtss_dyn_frne_dh_(tau, R, mq, q, qd, qdd, fext));
}

/**
 * @brief Compute the manipulator joint-space inertia matrix
 *
 * @param[in]  R pointer to robot object to be simulated
 * @param[in]  q pointer to the joint state vector
 * @param[in]  wiptr pointer to the workspace used for joint-space inertia matrix computation
 * @param[out] inertia_matrix pointer to the computed joint-space inertia matrix of the manipulator
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_dyn_inertia_(double * inertia_matrix, rtss_robot * R, double * q, rtss_wsinertia * wiptr)
{
    int i;
    for (i = 0; i < R->dof; i++) {
        wiptr->eye_r[i] = 1;
        rtss_dyn_frne(&(inertia_matrix[i*R->dof]), R, 1, q, wiptr->zeros, wiptr->eye_r, NULL);
        wiptr->eye_r[i] = 0;
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Compute the manipulator Coriolis/centripetal torque components
 *
 * @param[in]  R pointer to robot object to be simulated
 * @param[in]  q pointer to the joint state vector
 * @param[in]  qd pointer to the joint velocity vector
 * @param[in]  wcptr pointer to the workspace used for Coriolis/centripetal torque components computation
 * @param[out] ctorq pointer to the vector of computed Coriolis/centripetal torque components
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_dyn_coriolis_(double * ctorq, rtss_robot * R, double * q, double * qd, rtss_wscoriolis * wcptr)
{
    rtss_dyn_frne(ctorq, R, 1, q, qd, wcptr->zeros, NULL);
    return(RTSS_SUCCESS);
}

/**
 * @brief Compute the manipulator gravity torque components
 *
 * @param[in]  R pointer to robot object to be simulated
 * @param[in]  q pointer to the joint state vector
 * @param[in]  wgptr pointer to the workspace used for gravity torque components computation
 * @param[out] gtorq pointer to the vector of computed gravity torque components
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_dyn_gravload_(double * gtorq, rtss_robot * R, double * q, rtss_wsgravload * wgptr)
{
    rtss_dyn_frne(gtorq, R, 1, q, wgptr->zeros, wgptr->zeros, NULL);
    return(RTSS_SUCCESS);
}

/**
 * @brief Compute the manipulator joint acceleration vector
 *
 * @param[in]  rp pointer to robot object to be simulated
 * @param[in]  q pointer to the joint state vector
 * @param[in]  qd pointer to the joint velocity vector
 * @param[in]  torque pointer to the generalized torque vector applied to manipulator end-effector
 * @param[in]  waptr pointer to the workspace used for joint acceleration vector computation
 * @param[out] qdd pointer to the vector of computed joint accelerations
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_dyn_accel_(double * qdd, rtss_robot * rp, double * q, double * qd, double * torque, rtss_wsaccel * waptr)
{
    double * inertia_matrix = waptr->inertia,
           * zeros = waptr->winer.zeros,
           * gctorq = waptr->wgctorq;
    rtss_vect3 ograv;

    /* inertia matrix computation */
    ograv = rp->gravity; rtssRobotSetGravity(*rp, zeros);
    rtss_dyn_inertia(inertia_matrix, rp, q, &(waptr->winer));
    rp->gravity = ograv;

    /* ineria matrix inversion */
    rtss_math_imat(rp->dof, inertia_matrix, waptr->imat.ipiv, waptr->imat.dwork);

    /* gravity and Coriolis torque (gctorq) computation */
    rtss_dyn_frne(gctorq, rp, 1, q, qd, zeros, NULL); /* direct call to rne function */

    /* acceleration */
    rtss_math_daxpy(rp->dof, -1.0, torque, gctorq);                     /* gctorq := gctorq - torque */
    rtss_math_dsymv(-1.0, rp->dof, inertia_matrix, gctorq, 0.0, qdd);   /* qdd := -inv(B)*(gctorq) */
    return(RTSS_SUCCESS);
}
