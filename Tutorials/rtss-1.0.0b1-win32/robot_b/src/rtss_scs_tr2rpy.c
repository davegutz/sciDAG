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
 * @file  rtss_scs_tr2rpy.c
 *
 * @brief Computational Function for the Scicos block named "rt_tr2rpy_if"
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



#include <math.h>                   /* sin, cos */
#include <scicos/scicos_block4.h>   /* Scicos Block Structure */



/**
 * @brief Initialize states and other initializations
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2rpy_init_(scicos_block * block)
{
    SCSREAL_COP * roll = GetRealOutPortPtrs(block,1),
                * pitch = GetRealOutPortPtrs(block,2),
                * yaw = GetRealOutPortPtrs(block,3);
    *roll = 0.0;
    *pitch = 0.0;
    *yaw = 0.0;
}

/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2rpy_inout_(scicos_block * block)
{
    SCSREAL_COP * t = GetRealInPortPtrs(block,1);
    SCSREAL_COP * roll = GetRealOutPortPtrs(block,1),
                * pitch = GetRealOutPortPtrs(block,2),
                * yaw = GetRealOutPortPtrs(block,3);
    double sr, cr;

    *roll = atan2(t[1], t[0]); /* roll = atan2(ny, nx) = atan2(T(2,1), T(1,1)) */
    sr = sin(*roll); cr = cos(*roll);
    *pitch = atan2(-t[2], cr*t[0]+sr*t[1]); /* pitch = atan2(-nz, cr*nx+sr*ny) = atan2(-T(3,1),cr*T(1,1)+sr*T(2,1)) */
    *yaw = atan2(sr*t[8]-cr*t[9], cr*t[5]-sr*t[4]); /* psi = atan2(sr*ax-cr*ay, cr*oy-sr*ox)
                                                           = atan2(sr*T(1,3)-cr*T(2,3), cr*T(2,2)-sr*T(1,2)) */
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2rpy_end_(scicos_block * block)
{
    SCSREAL_COP * roll = GetRealOutPortPtrs(block,1),
                * pitch = GetRealOutPortPtrs(block,2),
                * yaw = GetRealOutPortPtrs(block,3);
    *roll = 0.0;
    *pitch = 0.0;
    *yaw = 0.0;
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) computational function for the Scicos block named "rt_tr2rpy_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 */
void
rtss_scs_tr2rpy_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            rtss_scs_tr2rpy_inout_(block);
            break;

        case Initialization:
            rtss_scs_tr2rpy_init_(block);
            break;

        case Ending:
            rtss_scs_tr2rpy_end_(block);
            break;

        default:
            break;
    }
}
/** @} */
