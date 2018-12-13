/*-----------------------------------------------------------------------------------
 *  Copyright (c) 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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
 * @file  rtss_kinematics.c
 *
 * @brief Implementation of KINEMATICS submodule
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         March 2008
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-08-23 19:43:41 +0200(dom, 23 ago 2009) $
 */



#include <math.h>                   /* sin, cos */
#include <stack-c.h>                /* TRUE_, FALSE_ */
#include "../includes/rtss_error.h" /* Interface to ERROR module */
#include "../includes/rtss.h"       /* Interface to KINEMATICS submodule */

/**
 * @brief Service routine which allocates a workspace (space of memory), for
 *        manipulator Jacobian computation
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wjptr Initialized pointer to the workspace for Jacobian computation
 */
int
rtss_wsjacob0_init(rtss_wsjacob0 * wjptr, int dof)
{
    if (!wjptr)
        rtss_err_null_ptr();
    if ((wjptr->data = rtss_malloc(6*dof*sizeof(double))) == NULL)
        rtss_err_fail(999, "Cannot allocate the workspace for manipulator Jacobian computation");
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for destructing constituent links of an rtss_robot object
 *
 * @param[out] wjptr freed pointer to rtss_wsjacob0 objects
 */
int
rtss_wsjacob0_destroy(rtss_wsjacob0 * wjptr)
{
    if (!wjptr)
        rtss_err_null_ptr();
    rtss_free(wjptr->data);
    return(RTSS_SUCCESS);
}

/**
 * @brief Rotation matrix and translation vectors for STANDARD DH-based link objects
 *
 * @param[out] lp pointer to rtss_link object whose attributes R, r and pstar have being modified
 * @param[in]  q pointer to joint parameter
 *
 * @author     Peter I. Corke, CSIRO Division of Manufacturing Technology
 * @author     modified by Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 *
 * @note       Modifications are the following:
 *               - changed name and order of input parameters
 *               - code adapted to use the new RtssLink structure
 *               - sorted the standard-DH-based algorithm from the modified-DH-based
 *
 * @note       Modifications on May 2008:
 *               - using the new librtssc modular organization
 *               - matrices are bidimensional double arrays
 *
 * @note       Modifications on April 2009:
 *               - DYNAMICS module is now using all the data structures from the MATH module,
 *                 i.e. matrices and vectors are no longer implemented by arrays of doubles.
 *
 * @date       March 2008
 */
static void
rtss_kin_link_trans_dh_(rtss_link * lp, double * q)
{
    double th, d, st, ct, sa, ca;

    switch(lp->sigma) {

        case RTSS_REVOLUTE_JOINT:
            th = *q + lp->offset;
            d = lp->D;
            break;

        case RTSS_PRISMATIC_JOINT:
            th = lp->theta;
            d = *q + lp->offset;
            break;

    }

    /* sincos */
    st = sin(th); ct = cos(th);
    sa = sin(lp->alpha); ca = cos(lp->alpha);

    /* assignments for the coordinate transform between consecutive links */
    rtssLinkSetCoordTransform(*lp, ct, -ca*st,  sa*st, lp->A*ct,
                                   st,  ca*ct, -sa*ct, lp->A*st,
                                  0.0,     sa,     ca,        d);

    /* assignments for pstar vector */
    rtssLinkSetPstar(*lp, lp->A,
                           d*sa,
                           d*ca);
}

/**
 * @brief      Rotation matrix and translation vector for MODIFIED DH-based link objects
 *
 * @note       This routine does not modify the pstar vector, because it's not used when simulating
 *             MDH-based robot kinematics and dynamics.
 * @param[out] lp pointer to rtss_link object whose attributes R, and r have being modified
 * @param[in]  q pointer to joint parameter
 *
 * @author     Peter I. Corke, CSIRO Division of Manufacturing Technology
 * @author     modified by Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 *
 * @note       Modifications are the following:
 *               - changed name and order of input parameters
 *               - code adapted to use the new RtssLink structure
 *               - sorted the standard-DH-based algorithm from the modified-DH-based
 *
 * @note       Modifications on May 2008:
 *               - using the new librtssc modular organization
 *               - matrices are bidimensional double arrays
 *
 * @note       Modifications on April 2009:
 *               - DYNAMICS module is now using all the data structures from the MATH module,
 *                 i.e. matrices and vectors are no longer implemented by arrays of doubles.
 *
 * @date       March 2008
 */
static void
rtss_kin_link_trans_mdh_(rtss_link * lp, double * q)
{
    double th, d, st, ct, sa, ca;

    switch(lp->sigma) {

        case RTSS_REVOLUTE_JOINT:
            th = *q + lp->offset;
            d = lp->D;
            break;

        case RTSS_PRISMATIC_JOINT:
            th = lp->theta;
            d = *q + lp->offset;
            break;

    }

    /* sincos */
    st = sin(th); ct = cos(th);
    sa = sin(lp->alpha); ca = cos(lp->alpha);

    /* assignments for the coordinate transform between consecutive links */
    rtssLinkSetCoordTransform(*lp,    ct,   -st, 0.0, lp->A,
                                   st*ca, ca*ct, -sa, -d*sa,
                                   st*sa, ct*sa,  ca,  d*ca);

}

/**
 * @brief Compute manipulator Jacobian in end-effector coordinate frame, for STANDARD DH-based
 *        robot models
 *
 * @param[in]  rp pointer to rtss_robot object representing the STANDARD DH-based serial n-link
 *                manipulator
 * @param[in]  q pointer to joint parameter
 * @param[out] jep pointer to the 6xn matrix which represents the manipulator Jacobian as
 *                 expressed in the end-effector coordinate frame
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static int
rtss_kin_jacobn_dh_(double * jnp, rtss_robot * rp, double * q)
{
    double * d, * delta;
    rtss_homog tr, u; /* homogeneous matrices for temporary computations */
    rtss_link * lp = rp->links;
    int n = rp->dof, i;

    tr = rp->tool;
    for (i = n - 1; i >= 0; i--) {
        d = &(jnp[i*6]);
        delta = &(jnp[3 + i*6]);
        rtss_kin_link_trans(&(lp[i]), &(q[i]));
        rtss_homog_compose(&u, &(lp[i].T), &tr);
        switch(lp[i].sigma) {

            case RTSS_REVOLUTE_JOINT:
                d[0] = rtssHomogNumRot(u,2,1)*rtssHomogNumTransl(u,1) -
                           rtssHomogNumRot(u,1,1)*rtssHomogNumTransl(u,2); /* U(2,1)*U(1,4)-U(1,1)*U(2,4) */
                d[1] = rtssHomogNumRot(u,2,2)*rtssHomogNumTransl(u,1) -
                           rtssHomogNumRot(u,1,2)*rtssHomogNumTransl(u,2); /* U(2,2)*U(1,4)-U(1,2)*U(2,4) */
                d[2] = rtssHomogNumRot(u,2,3)*rtssHomogNumTransl(u,1) -
                           rtssHomogNumRot(u,1,3)*rtssHomogNumTransl(u,2); /* U(2,3)*U(1,4)-U(1,3)*U(2,4) */
                delta[0] = rtssHomogNumRot(u,3,1);
                delta[1] = rtssHomogNumRot(u,3,2);
                delta[2] = rtssHomogNumRot(u,3,3);
                break;

            case RTSS_PRISMATIC_JOINT:
                d[0] = rtssHomogNumRot(u,3,1);
                d[1] = rtssHomogNumRot(u,3,2);
                d[2] = rtssHomogNumRot(u,3,3);
                delta[0] = 0.0;
                delta[1] = 0.0;
                delta[2] = 0.0;
                break;

        }
        if (i != 0)
            tr = u;
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Compute manipulator Jacobian in end-effector coordinate frame, for MODIFIED DH-based
 *        robot models
 *
 * @param[in]  rp pointer to rtss_robot object representing the MODIFIED DH-based serial n-link
 *                manipulator
 * @param[in]  q pointer to joint parameter
 * @param[out] jep pointer to the 6xn matrix which represents the manipulator Jacobian as
 *                 expressed in the end-effector coordinate frame
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static int
rtss_kin_jacobn_mdh_(double * jnp, rtss_robot * rp, double * q)
{
    double * d, * delta;
    rtss_homog tr, u; /* homogeneous matrices for temporary computations */
    rtss_link * lp = rp->links;
    int n = rp->dof, i;

    u = rp->tool;
    for (i = n - 1; i >= 0; i--) {
        d = &(jnp[i*6]);
        delta = &(jnp[3 + i*6]);
        switch(lp[i].sigma) {

            case RTSS_REVOLUTE_JOINT:
                d[0] = rtssHomogNumRot(u,2,1)*rtssHomogNumTransl(u,1) -
                           rtssHomogNumRot(u,1,1)*rtssHomogNumTransl(u,2); /* U(2,1)*U(1,4)-U(1,1)*U(2,4) */
                d[1] = rtssHomogNumRot(u,2,2)*rtssHomogNumTransl(u,1) -
                           rtssHomogNumRot(u,1,2)*rtssHomogNumTransl(u,2); /* U(2,2)*U(1,4)-U(1,2)*U(2,4) */
                d[2] = rtssHomogNumRot(u,2,3)*rtssHomogNumTransl(u,1) -
                           rtssHomogNumRot(u,1,3)*rtssHomogNumTransl(u,2); /* U(2,3)*U(1,4)-U(1,3)*U(2,4) */
                delta[0] = rtssHomogNumRot(u,3,1);
                delta[1] = rtssHomogNumRot(u,3,2);
                delta[2] = rtssHomogNumRot(u,3,3);
                break;

            case RTSS_PRISMATIC_JOINT:
                d[0] = rtssHomogNumRot(u,3,1);
                d[1] = rtssHomogNumRot(u,3,2);
                d[2] = rtssHomogNumRot(u,3,3);
                delta[0] = 0.0;
                delta[1] = 0.0;
                delta[2] = 0.0;
                break;

        }
        if (i != 0) {
            tr = u;
            rtss_kin_link_trans(&(lp[i]), &(q[i]));
            rtss_homog_compose(&u, &(lp[i].T), &tr);
        }
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Link rotation matrix and translation vectors
 *
 * @param[out] lp pointer to rtss_link object whose attributes R, r and pstar have being modified
 * @param[in]  q pointer to joint parameter
 */
void
rtss_kin_link_trans(rtss_link * lp, double * q)
{
    (lp->mdh == RTSS_DH_MODIFIED) ? rtss_kin_link_trans_mdh_(lp, q) : rtss_kin_link_trans_dh_(lp, q);
}

/**
 * @brief Compute the forward kinematics for a serial n-link manipulator
 *
 * @param[in]  rp pointer to rtss_robot object representing the serial n-link manipulator
 * @param[in]  q pointer to joint parameter
 * @param[out] twep pointer to rtss_homog object describing the configuration of the
                    manipulator end-effector with respect to the world frame
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_kin_fkine_(rtss_homog * twep, rtss_robot * rp, double * q)
{
    int i;
    rtss_homog tr; /* homogeneous matrix for temporary computations */
    rtss_link * lp = rp->links;

    rtss_kin_link_trans(&(lp[0]), &(q[0]));
    rtss_homog_compose(&tr, &(rp->base), &(lp[0].T)); /* Tw1:= Tw0 * T01 */
    for (i = 1; i < rp->dof; i++) {
        rtss_kin_link_trans(&(lp[i]), &(q[i]));
        rtss_homog_compose(twep, &tr, &(lp[i].T));    /* Twi:= Tw{i-1} * T{i-1}i, i = 2..n */
        tr = *twep;
    }
    rtss_homog_compose(twep, &tr, &(rp->tool));       /* Twe:= Twn * Tne */
    return(RTSS_SUCCESS);
}

/**
 * @brief Compute manipulator Jacobian in end-effector coordinate frame
 *
 * @param[in]  rp pointer to rtss_robot object representing the serial n-link manipulator
 * @param[in]  q pointer to joint parameter
 * @param[out] jep pointer to the 6xn matrix which represents the manipulator Jacobian as
 *                 expressed in the end-effector coordinate frame
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_kin_jacobn_(double * jnp, rtss_robot * rp, double * q)
{
    return((rp->mdh == RTSS_DH_STANDARD) ?
        rtss_kin_jacobn_dh_(jnp, rp, q) : rtss_kin_jacobn_mdh_(jnp, rp, q));
}

/**
 * @brief Compute manipulator Jacobian in base coordinate frame
 *
 * @param[in]  rp pointer to rtss_robot object representing the serial n-link manipulator
 * @param[in]  q pointer to joint parameter
 * @param[in]  wjptr pointer to the workspace used for Jacobian matrix computation
 * @param[out] j0 pointer to the 6xn matrix which represents the manipulator Jacobian as
 *                expressed in base coordinate frame
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_kin_jacob0_(double * j0, rtss_robot * rp, double * q, rtss_wsjacob0 * wjptr)
{
    double tu[36];
    rtss_homog tn; /* homog transform for temporary computation */

    rtss_kin_jacobn(wjptr->data, rp, q); /* Jn = rt_jacobn(robot, q); */
    rtss_kin_fkine(&tn, rp, q);          /* Tn = rt_fkine(robot, q); */
    /* Tu = [R zeros(3,3); zeros(3,3) R] */
    /* Tu(1:3,1:3) = R */                                                                               /* Tu(4:6,1:3) = 0 */
    tu[0] = rtssHomogNumRot(tn,1,1); tu[6] = rtssHomogNumRot(tn,1,2); tu[12] = rtssHomogNumRot(tn,1,3); tu[18] = 0.0;                     tu[24] = 0.0;                     tu[30] = 0.0;
    tu[1] = rtssHomogNumRot(tn,2,1); tu[7] = rtssHomogNumRot(tn,2,2); tu[13] = rtssHomogNumRot(tn,2,3); tu[19] = 0.0;                     tu[25] = 0.0;                     tu[31] = 0.0;
    tu[2] = rtssHomogNumRot(tn,3,1); tu[8] = rtssHomogNumRot(tn,3,2); tu[14] = rtssHomogNumRot(tn,3,3); tu[20] = 0.0;                     tu[26] = 0.0;                     tu[32] = 0.0;
    /* Tu(4:6,1:3) = 0 */                                                                               /* Tu(4:6,4:6) = R */
    tu[3] = 0.0;                     tu[9]  = 0.0;                    tu[15] = 0.0;                     tu[21] = rtssHomogNumRot(tn,1,1); tu[27] = rtssHomogNumRot(tn,1,2); tu[33] = rtssHomogNumRot(tn,1,3);
    tu[4] = 0.0;                     tu[10] = 0.0;                    tu[16] = 0.0;                     tu[22] = rtssHomogNumRot(tn,2,1); tu[28] = rtssHomogNumRot(tn,2,2); tu[34] = rtssHomogNumRot(tn,2,3);
    tu[5] = 0.0;                     tu[11] = 0.0;                    tu[17] = 0.0;                     tu[23] = rtssHomogNumRot(tn,3,1); tu[29] = rtssHomogNumRot(tn,3,2); tu[35] = rtssHomogNumRot(tn,3,3);
    /* J0 = Tu * Jn */
    rtss_math_dgemm(1.0, RTSS_MATH_NOTRANS, 6, 6, tu,
                            RTSS_MATH_NOTRANS, rp->dof, wjptr->data,
                                0.0, j0);
    return(RTSS_SUCCESS);
}
