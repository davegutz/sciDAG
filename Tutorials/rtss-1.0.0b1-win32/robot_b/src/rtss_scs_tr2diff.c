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
 * @file  rtss_scs_tr2diff.c
 *
 * @brief Computational Function for the Scicos block named "rt_tr2diff_if"
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
 * $LastChangedDate: 2009-09-14 18:19:57 +0200(lun, 14 set 2009) $
 */



#include <scicos/scicos_block4.h>   /* Scicos Block Structure */
#include "../includes/rtss_error.h" /* Interface to ERROR module */
#include "../includes/rtss_math.h"  /* Interface to MATH module */



/**
 * @brief Initialize states and other initializations
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2diff_init_(scicos_block * block)
{
    SCSREAL_COP * d = GetRealOutPortPtrs(block,1);
    d[0] = 0.0;
    d[1] = 0.0;
    d[2] = 0.0;
    d[3] = 0.0;
    d[4] = 0.0;
    d[5] = 0.0;
}

/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static
int rtss_scs_tr2diff_inout_(scicos_block * block)
{
    SCSREAL_COP * t1, * t2; /* inputs */
    SCSREAL_COP * d;        /* outputs */

    t1 = GetRealInPortPtrs(block,1);
    t2 = GetRealInPortPtrs(block,2);
    d = GetRealOutPortPtrs(block,1);
    rtss_math_cross(&(d[3]), 1.0, t1, 0.5, t2);         /* d(4:6) = 0.5*rt_cross(t1(1:3,1),t2(1:3,1)) */
    rtss_math_cross(d, 1.0, &(t1[4]), 0.5, &(t2[4]));   /* tmp assign: d(1:3) = 0.5*rt_cross(t1(1:3,2),t2(1:3,2)) */
    rtss_math_daxpy(3, 1.0, d, &(d[3]));                /* d(4:6) = d(1:3) + d(4:6) */
    rtss_math_cross(d, 1.0, &(t1[8]), 0.5, &(t2[8]));   /* tmp assign: d(1:3) = 0.5*rt_cross(t1(1:3,3),t2(1:3,3)) */
    rtss_math_daxpy(3, 1.0, d, &(d[3]));                /* d(4:6) = d(1:3) + d(4:6) */
    d[0] = t2[12] - t1[12]; /* alternative is to use a combination of blas dcopy/daxpy */
    d[1] = t2[13] - t1[13];
    d[2] = t2[14] - t1[14];
    return(RTSS_SUCCESS);
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2diff_end_(scicos_block * block)
{
    SCSREAL_COP * d = GetRealOutPortPtrs(block,1);
    d[0] = 0.0;
    d[1] = 0.0;
    d[2] = 0.0;
    d[3] = 0.0;
    d[4] = 0.0;
    d[5] = 0.0;
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) computational function for the Scicos block named "rt_tr2diff_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_scs_tr2diff_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            if (rtss_scs_tr2diff_inout_(block) == RTSS_FAILURE)
                rtss_err_call();
            break;

        case Initialization:
            rtss_scs_tr2diff_init_(block);
            break;

        case Ending:
            rtss_scs_tr2diff_end_(block);
            break;

        default:
            break;
    }
    return(RTSS_SUCCESS);
}
/** @} */
