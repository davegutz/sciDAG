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



/**
 * @file  rtss_scs_feulerint.c
 *
 * @brief Computational Function for Euler fixed step-size solver block named "rt_fe_if"
 *
 * It performs discrete integral by forward Euler method.
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         April 2007
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2007, 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-09-14 18:19:57 +0200(lun, 14 set 2009) $
 */



#include <scicos/scicos_block4.h>   /* Scicos Block Structure */



/**
 * @brief Update state due to external activation
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_fe_updatestate_(scicos_block * block)
{
    int i;
    SCSREAL_COP * u = GetInPortPtrs(block,1),   /* address of input */
                * step = GetRparPtrs(block),    /* step of integration */
                * z = GetDstate(block);         /* address of discrete state */

    for(i = 0; i < GetInPortRows(block,1); i++) /* alternative is to use blas daxpy */
        z[i] = (*step)*u[i] + z[i];
}

/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_fe_inout_(scicos_block * block)
{
    int i;
    SCSREAL_COP * y = GetOutPortPtrs(block,1),
                * z = GetDstate(block);

    for(i = 0; i < GetInPortRows(block,1); i++) /* alternative is to use blas dcopy */
        y[i] = z[i];
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) computational function for the Scicos block named "rt_fe_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 */
void
rtss_scs_fe_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate: case Initialization:
            rtss_scs_fe_inout_(block);
            break;

        case StateUpdate:
            rtss_scs_fe_updatestate_(block);
            break;

        default:
            break;
    }
}
/** @} */
