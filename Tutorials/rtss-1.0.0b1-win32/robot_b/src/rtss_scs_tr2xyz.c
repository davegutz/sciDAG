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
 * @file  rtss_scs_tr2xyz.c
 *
 * @brief Computational Function for the Scicos block named "rt_tr2xyz_if"
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



/**
 * @brief Initialize states and other initializations
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2xyz_init_(scicos_block * block)
{
    SCSREAL_COP * x = GetRealOutPortPtrs(block,1),
                * y = GetRealOutPortPtrs(block,2),
                * z = GetRealOutPortPtrs(block,3);
    x[0] = 0.0;
    y[0] = 0.0;
    z[0] = 0.0;
}

/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2xyz_inout_(scicos_block * block)
{
    SCSREAL_COP * t = GetRealInPortPtrs(block,1);
    SCSREAL_COP * x = GetRealOutPortPtrs(block,1),
                * y = GetRealOutPortPtrs(block,2),
                * z = GetRealOutPortPtrs(block,3);
    x[0] = t[12]; /* t[0 + 3*4] (i.e, t(1,4)) */
    y[0] = t[13]; /* t[1 + 3*4] (i.e, t(2,4)) */
    z[0] = t[14]; /* t[2 + 3*4] (i.e, t(3,4)) */
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2xyz_end_(scicos_block * block)
{
    SCSREAL_COP * x = GetRealOutPortPtrs(block,1),
                * y = GetRealOutPortPtrs(block,2),
                * z = GetRealOutPortPtrs(block,3);
    x[0] = 0.0;
    y[0] = 0.0;
    z[0] = 0.0;
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) computational function for the Scicos block named "rt_tr2xyz_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 */
void
rtss_scs_tr2xyz_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            rtss_scs_tr2xyz_inout_(block);
            break;

        case Initialization:
            rtss_scs_tr2xyz_init_(block);
            break;

        case Ending:
            rtss_scs_tr2xyz_end_(block);
            break;

        default:
            break;
    }
}
/** @} */
