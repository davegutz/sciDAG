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
 * @file  rtss_scs_eul2tr.c
 *
 * @brief Computational Function for the Scicos block named "rt_eul2tr_if"
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
void rtss_scs_eul2tr_init_(scicos_block * block)
{
    SCSREAL_COP * t = GetRealOutPortPtrs(block,1);
    t[0] = 1.0; t[4] = 0.0; t[8] = 0.0;  t[12] = 0.0;
    t[1] = 0.0; t[5] = 1.0; t[9] = 0.0;  t[13] = 0.0;
    t[2] = 0.0; t[6] = 0.0; t[10] = 1.0; t[14] = 0.0;
    t[3] = 0.0; t[7] = 0.0; t[11] = 0.0; t[15] = 1.0;
}

/**
 * @brief Compute the outputs of the block
 *
 * This function uses the closed-form expression computed via postmultiplication
 * of the matrices of the elementary rotations about Z,Y,Z axes.
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_eul2tr_inout_(scicos_block * block)
{
    SCSREAL_COP * phi = GetRealInPortPtrs(block,1),
                * theta = GetRealInPortPtrs(block,2),
                * psi = GetRealInPortPtrs(block,3);
    SCSREAL_COP * t = GetRealOutPortPtrs(block,1);
    double sf = sin(*phi), cf = cos(*phi),
           st = sin(*theta), ct = cos(*theta),
           sp = sin(*psi), cp = cos(*psi);
    t[0] = cf*ct*cp - sf*sp; t[4] = -cf*ct*sp - sf*cp; t[8] = cf*st;  t[12] = 0.0;
    t[1] = sf*ct*cp + cf*sp; t[5] = -sf*ct*sp + cf*cp; t[9] = sf*st;  t[13] = 0.0;
    t[2] = -st*cp;           t[6] = st*sp;             t[10] = ct;    t[14] = 0.0;
    t[3] = 0.0;              t[7] = 0.0;               t[11] = 0.0;   t[15] = 1.0;
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_eul2tr_end_(scicos_block * block)
{
    SCSREAL_COP * t = GetRealOutPortPtrs(block,1);
    t[0] = 1.0; t[4] = 0.0; t[8] = 0.0;  t[12] = 0.0;
    t[1] = 0.0; t[5] = 1.0; t[9] = 0.0;  t[13] = 0.0;
    t[2] = 0.0; t[6] = 0.0; t[10] = 1.0; t[14] = 0.0;
    t[3] = 0.0; t[7] = 0.0; t[11] = 0.0; t[15] = 1.0;
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) computational function for the Scicos block named "rt_eul2tr_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 */
void
rtss_scs_eul2tr_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            rtss_scs_eul2tr_inout_(block);
            break;

        case Initialization:
            rtss_scs_eul2tr_init_(block);
            break;

        case Ending:
            rtss_scs_eul2tr_end_(block);
            break;

        default:
            break;
    }
}
/** @} */
