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
 * @file  rtss_scs_tr2eul.c
 *
 * @brief Computational Function for the Scicos block named "rt_tr2eul_if"
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
void rtss_scs_tr2eul_init_(scicos_block * block)
{
    SCSREAL_COP * phi = GetRealOutPortPtrs(block,1),
                * theta = GetRealOutPortPtrs(block,2),
                * psi = GetRealOutPortPtrs(block,3);
    *phi = 0.0;
    *theta = 0.0;
    *psi = 0.0;
}

/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2eul_inout_(scicos_block * block)
{
    SCSREAL_COP * t = GetRealInPortPtrs(block,1);
    SCSREAL_COP * phi = GetRealOutPortPtrs(block,1),
                * theta = GetRealOutPortPtrs(block,2),
                * psi = GetRealOutPortPtrs(block,3);
    double sf, cf;

    *phi = atan2(t[9], t[8]); /* phi = atan2(ay, ax) = atan2(T(2,3), T(1,3)) */
    sf = sin(*phi); cf = cos(*phi);
    *theta = atan2(cf*t[8]+sf*t[9],t[10]); /* theta = atan2(cf*ax + sf*ay, az) = atan2(cf*T(1,3) + sf*T(2,3), T(3,3)) */
    *psi = atan2(-sf*t[0]+cf*t[1], -sf*t[4]+cf*t[5]); /* psi = atan2(-sf*nx + cf*ny, -sf*ox + cf*oy)
                                                             = atan2(-sf*T(1,1) + cf*T(2,1), -sf*T(1,2) + cf*T(2,2)) */
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_tr2eul_end_(scicos_block * block)
{
    SCSREAL_COP * phi = GetRealOutPortPtrs(block,1),
                * theta = GetRealOutPortPtrs(block,2),
                * psi = GetRealOutPortPtrs(block,3);
    *phi = 0.0;
    *theta = 0.0;
    *psi = 0.0;
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) computational function for the Scicos block named "rt_tr2eul_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 */
void
rtss_scs_tr2eul_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            rtss_scs_tr2eul_inout_(block);
            break;

        case Initialization:
            rtss_scs_tr2eul_init_(block);
            break;

        case Ending:
            rtss_scs_tr2eul_end_(block);
            break;

        default:
            break;
    }
}
/** @} */
