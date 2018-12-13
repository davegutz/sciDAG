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
 * @file  rtss_scs_jtraj.c
 *
 * @brief Computational Function for the Scicos block named "rt_jtraj_if"
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         August 2009
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-09-11 19:22:03 +0200(ven, 11 set 2009) $
 */



#include <scicos/scicos_block4.h>       /* Scicos Block Structure */
#include "../includes/rtss_mem_alloc.h" /* rtss_malloc, rtss_free */
#include "../includes/rtss_error.h"     /* Interface to ERROR module */
#include "../includes/rtss_math.h"      /* Interface to MATH module */



/**
 * @brief Data structure to be used in conjunction with block->work. Internal use only.
 */
struct rtss_scs_jtraj_generic_ {

    rtss_linterpn wlint;    /**< workspace for one-dimensional interpolation */
    SCSINT_COP n;           /**< number of joints */
    SCSREAL_COP * q;        /**< desired joint space trajectory defined at specific sample points (to be interpolated) */
    SCSREAL_COP * qd;       /**< desired joint velocity trajectory defined at specific sample points (to be interpolated) */
    SCSREAL_COP * qdd;      /**< desired joint acceleration trajectory defined at specific sample points (to be interpolated) */
    SCSREAL_COP * t;        /**< vector of sample points at which desired joint trajectories are defined (time vector) */

};

/**
 * @brief Initialize states and other initializations
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */ 
static
int rtss_scs_jtraj_init_(scicos_block * block)
{
    struct rtss_scs_jtraj_generic_ * jptr;

    /* block->work */
    if ((GetWorkPtrs(block) = rtss_malloc(sizeof(struct rtss_scs_jtraj_generic_))) == NULL) {
        set_block_error(-16);
        return(RTSS_FAILURE);
    }
    jptr = (struct rtss_scs_jtraj_generic_ *) GetWorkPtrs(block);

    /* rtss_linterpn initialization for one-dimensional interpolation (wlint): */
    /* can't use the macro rtssWSpaceLInterpNInit(), since block->works must be */
    /* freed, whether the workspace initialization fails */
    if (rtss_linterpn_init(&(jptr->wlint), 101, 1) == RTSS_FAILURE) {
        set_block_error(-16);
        rtss_free(jptr);
        return(RTSS_FAILURE);
    }

    /* block parameters */
    jptr->n = *GetIparPtrs(block);
    return(RTSS_SUCCESS);
}

/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static int
rtss_scs_jtraj_inout_(scicos_block * block)
{
    SCSREAL_COP * qp, * qdp, * qddp;            /* outputs */
    struct rtss_scs_jtraj_generic_ * jptr;      /* workspace data */
    SCSREAL_COP * rpar;
    double u = get_scicos_time();

    qp = GetRealOutPortPtrs(block, 1);
    qdp = GetRealOutPortPtrs(block, 2);
    qddp = GetRealOutPortPtrs(block, 3);
    rpar = GetRparPtrs(block);
    jptr = (struct rtss_scs_jtraj_generic_ *) GetWorkPtrs(block);
    /* workaround for rpar: don't initialize structs by using */
    /*                      data pointed by rpar inside the   */
    /*                      init function.                    */
    jptr->q = rpar;                                         /* columns 1:n */
    jptr->qd = &(rpar[(jptr->n)*(*(jptr->wlint.dimt))]);    /* columns n+1:2*n */
    jptr->qdd = &(rpar[(2*jptr->n)*(*(jptr->wlint.dimt))]); /* columns 2*n+1:3*n */
    jptr->t = &(rpar[(3*jptr->n)*(*(jptr->wlint.dimt))]);   /* column 3*n+1 */

    rtss_math_linterp1(qp, jptr->t, jptr->n, jptr->q, &u, &(jptr->wlint));
    rtss_math_linterp1(qdp, jptr->t, jptr->n, jptr->qd, &u, &(jptr->wlint));
    rtss_math_linterp1(qddp, jptr->t, jptr->n, jptr->qdd, &u, &(jptr->wlint));
    return(RTSS_SUCCESS);
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static int
rtss_scs_jtraj_end_(scicos_block * block)
{
    struct rtss_scs_jtraj_generic_ * jptr;

    jptr = (struct rtss_scs_jtraj_generic_ *) GetWorkPtrs(block);
    rtssWSpaceLInterpNDestroy(&(jptr->wlint));
    rtss_free(jptr);
    return(RTSS_SUCCESS);
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) Computational Function for the Scicos block named
 *        "rt_jtraj_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_scs_jtraj_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            if (rtss_scs_jtraj_inout_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        case Initialization:
            if (rtss_scs_jtraj_init_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        case Ending:
            if (rtss_scs_jtraj_end_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        default:
            break;
    }
    return(RTSS_SUCCESS);
}
/** @} */
