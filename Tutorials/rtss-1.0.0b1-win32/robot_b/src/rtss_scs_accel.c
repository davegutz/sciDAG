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
 * @file  rtss_scs_accel.c
 *
 * @brief Computational Function for the Scicos block named "rt_accel_if"
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
struct rtss_scs_accel_generic_ {

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
int rtss_scs_accel_init_(scicos_block * block)
{
    struct rtss_scs_accel_generic_ * aptr;

    /* block->work */
    if ((GetWorkPtrs(block) = rtss_malloc(sizeof(struct rtss_scs_accel_generic_))) == NULL) {
        set_block_error(-16);
        return(RTSS_FAILURE);
    }
    aptr = (struct rtss_scs_accel_generic_ *) GetWorkPtrs(block);

    /* robot (rbtp) */
    rtssRobotInitFromScicosBlk(&(aptr->rbtp), block);

    /* workspace for the computation of joint acceleration vector (wacc): */
    /* can't use the macro rtssWSpaceAccelInit(), since both the robot data ptr and */
    /* block->works must be freed, whether the workspace initialization fails */
    if (rtss_wsaccel_init(&(aptr->wacc), aptr->rbtp.dof) == RTSS_FAILURE) {
        set_block_error(-16);
        rtssRobotDestroyLinks(&(aptr->rbtp));
        rtss_free(aptr);
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
rtss_scs_accel_inout_(scicos_block * block)
{
    SCSREAL_COP * q, * qd, * torque;        /* inputs */
    SCSREAL_COP * qdd;                      /* outputs */
    struct rtss_scs_accel_generic_ * aptr;  /* workspace data */

    q = GetRealInPortPtrs(block, 1);
    qd = GetRealInPortPtrs(block, 2);
    torque = GetRealInPortPtrs(block, 3);
    qdd = GetRealOutPortPtrs(block, 1);
    aptr = (struct rtss_scs_accel_generic_ *) GetWorkPtrs(block);
    if(rtss_dyn_accel_(qdd, &(aptr->rbtp), q, qd, torque, &(aptr->wacc)) == RTSS_FAILURE) {
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
rtss_scs_accel_end_(scicos_block * block)
{
    struct rtss_scs_accel_generic_ * aptr;

    aptr = (struct rtss_scs_accel_generic_ *) GetWorkPtrs(block);
    rtssRobotDestroyLinks(&(aptr->rbtp));
    rtssWSpaceAccelDestroy(&(aptr->wacc));
    rtss_free(aptr);
    return(RTSS_SUCCESS);
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) Computational Function for the Scicos block named
 *        "rt_accel_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_scs_accel_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            if (rtss_scs_accel_inout_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        case Initialization:
            if (GetNopar(block) == 0)
                rtss_err_fail(999, "Problems with RTSS Accel block. Did you forget to specify the robot model to be simulated?");
            if (rtss_scs_accel_init_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        case Ending:
            if (GetNopar(block) > 0)
                if (rtss_scs_accel_end_(block) == RTSS_FAILURE)
                    rtss_err_call();
            break;

        default:
            break;
    }
    return(RTSS_SUCCESS);
}
/** @} */
