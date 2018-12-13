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
 * @file  rtss_scs_square.c
 *
 * @brief Computational Function for the Scicos block named "rt_square_if"
 *
 * Inspired to block rtai_square provided with RTAI-Lab by Roberto Bucher,
 * SUPSI (roberto.bucher@supsi.ch).
 *
 * @note References: RTAI-Lab, rtai-3.7.1/rtai-lab/scicoslab/devices/rtai_square.c
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
 * @brief Initialize states and other initializations
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_square_init_(scicos_block * block)
{
    double * y = GetRealOutPortPtrs(block,1);
    y[0] = 0.0;
}

/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_square_inout_(scicos_block * block)
{
    int nP;
    double * rpar = GetRparPtrs(block),
           * y = GetRealOutPortPtrs(block,1),
             z = get_scicos_time() - rpar[4];

    if (z < 0)
        y[0] = 0.0;
    else {
        nP = (int)(z/rpar[1]); /* number of periods */
        if ((z - nP*rpar[1]) < rpar[2])
            /* pulse is ON */
            y[0] = rpar[3] + rpar[0];
        else
            /* pulse is OFF */
            y[0] = rpar[3];
    }
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_square_end_(scicos_block * block)
{
    double * y = GetRealOutPortPtrs(block,1);
    y[0] = 0.0;
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) computational function for the Scicos block named "rt_square_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 *
 * @note References: RTAI-Lab, rtai-3.7.1/rtai-lab/scicoslab/devices/rtai_square.c
 */
void
rtss_scs_square_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            rtss_scs_square_inout_(block);
            break;

        case Ending:
            rtss_scs_square_end_(block);
            break;

        case Initialization:
            rtss_scs_square_init_(block);
            break;

        default:
            break;
    }
}
/** @} */
