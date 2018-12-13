/*-----------------------------------------------------------------------------------
 *  Copyright (C) 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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
 * @file  rtss_scs_robot.c
 *
 * @brief Computational Function for the Scicos block named "rt_robot_if"
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         July 2009
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-08-23 19:43:41 +0200(dom, 23 ago 2009) $
 */



#include <scicos/scicos_block4.h>   /* Scicos Block Structure */
#include "../includes/rtss_error.h" /* Interface to ERROR module */
#include "../includes/rtss.h"       /* Interface to ROBOT and DYNAMICS submodules */



/**
 * @brief Data structure to be used in conjunction with block->work. Internal use only.
 */
struct rtss_scs_robot_generic_ {

    rtss_robot rbtp;    /**< robot data */
    rtss_wsaccel wacc;  /**< workspace used for joint acceleration vector computation */

};

/**
 * @brief Initialize states and other initializations
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */ 
static
int rtss_scs_robot_init_(scicos_block * block)
{
    struct rtss_scs_robot_generic_ * rptr;

    /* block->work */
    if ((GetWorkPtrs(block) = rtss_malloc(sizeof(struct rtss_scs_robot_generic_))) == NULL) {
        set_block_error(-16);
        return(RTSS_FAILURE);
    }
    rptr = (struct rtss_scs_robot_generic_ *) GetWorkPtrs(block);

    /* robot (rbtp) */
    rtssRobotInitFromScicosBlk(&(rptr->rbtp), block);

    /* workspace for the computation of joint acceleration vector (wacc): */
    /* can't use the macro rtssWSpaceAccelInit(), since both the robot data ptr and */
    /* block->works must be freed, whether the workspace initialization fails */
    if (rtss_wsaccel_init(&(rptr->wacc), rptr->rbtp.dof) == RTSS_FAILURE) {
        set_block_error(-16);
        rtssRobotDestroyLinks(&(rptr->rbtp));
        rtss_free(rptr);
        return(RTSS_FAILURE);
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static int
rtss_scs_robot_inout_(scicos_block * block)
{
    SCSREAL_COP * torque;                           /* inputs */
    SCSREAL_COP * q, * qd, * qdd;                   /* outputs */
    struct rtss_scs_robot_generic_ * rptr;          /* workspace data */
    SCSREAL_COP * x;                                /* address of continuous state */
    int i, dof;

    torque = GetRealInPortPtrs(block, 1);
    q = GetRealOutPortPtrs(block, 1);
    qd = GetRealOutPortPtrs(block, 2);
    qdd = GetRealOutPortPtrs(block, 3);
    x = GetState(block);
    rptr = (struct rtss_scs_robot_generic_ *) GetWorkPtrs(block);
    dof = rptr->rbtp.dof;

    /* updating outputs q and qd */
    for(i = 0; i < dof; i++) {
        q[i] = x[i];        /* alternative is to use blas dcopy */
        qd[i] = x[dof + i];
    }

    /* updating output qdd */
    if(rtss_dyn_accel_(qdd, &(rptr->rbtp), q, qd, torque, &(rptr->wacc)) == RTSS_FAILURE) {
        set_block_error(-7);
        return(RTSS_FAILURE);
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Update the continuous state of the block
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static int
rtss_scs_robot_updatestate_(scicos_block * block)
{
    SCSREAL_COP * torque;                   /* inputs */
    SCSREAL_COP * x, * xd;                  /* pointers to the continuous state and the derivative continuous state registers */
    SCSREAL_COP * q, * qd, * qdd;           /* state related pointers */
    struct rtss_scs_robot_generic_ * rptr;  /* workspace data */
    int i, dof;

    torque = GetRealInPortPtrs(block, 1);
    x = GetState(block);
    xd = block->xd;
    rptr = (struct rtss_scs_robot_generic_ *) GetWorkPtrs(block);
    dof = rptr->rbtp.dof;

    /* retrieving the joint variables from state x = [q; qd] */
    q = x;
    qd = &(x[dof]);

    /* updating the derivative of state xd = [qd; qdd] */
    /* qd */
    for(i = 0; i < dof; i++)
        xd[i] = qd[i];  /* alternative is to use blas dcopy */
    /* qdd */
    qdd = &(xd[dof]);
    if(rtss_dyn_accel_(qdd, &(rptr->rbtp), q, qd, torque, &(rptr->wacc)) == RTSS_FAILURE) {
        set_block_error(-7);
        return(RTSS_FAILURE);
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static int
rtss_scs_robot_end_(scicos_block * block)
{
    struct rtss_scs_robot_generic_ * rptr;

    rptr = (struct rtss_scs_robot_generic_ *) GetWorkPtrs(block);
    rtssRobotDestroyLinks(&(rptr->rbtp));
    rtssWSpaceAccelDestroy(&(rptr->wacc));
    rtss_free(rptr);
    return(RTSS_SUCCESS);
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) Computational Function for the Scicos block named
 *        "rt_robot_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_scs_robot_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            if (rtss_scs_robot_inout_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        case DerivativeState:
            if (rtss_scs_robot_updatestate_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        case Initialization:
            if (GetNopar(block) == 0)
                rtss_err_fail(999, "Problems with RTSS Robot block. Did you forget to specify the robot model to be simulated?");
            if (rtss_scs_robot_init_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        case ReInitialization:
            if (GetNopar(block) > 0)
                if (rtss_scs_robot_inout_(block) == RTSS_FAILURE)
                    rtss_err_call();
            break;

        case Ending:
            if (GetNopar(block) > 0)
                if (rtss_scs_robot_end_(block) == RTSS_FAILURE)
                    rtss_err_call();
            break;

        default:
            break;
    }
    return(RTSS_SUCCESS);
}
/** @} */
