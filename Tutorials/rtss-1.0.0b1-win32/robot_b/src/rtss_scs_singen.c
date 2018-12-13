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
 * @file  rtss_scs_singen.c
 *
 * @brief Computational Function for the Scicos block named "rt_singen_if"
 *
 * Inspired to block rtai_sinus provided with RTAI-Lab by Roberto Bucher,
 * SUPSI (roberto.bucher@supsi.ch).
 *
 * @note References: RTAI-Lab, rtai-3.7.1/rtai-lab/scicoslab/devices/rtai_sinus.c
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



#include <math.h>                   /* sin */
#include <scicos/scicos_block4.h>   /* Scicos Block Structure */



/**
 * @brief Initialize states and other initializations
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_singen_init_(scicos_block * block)
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
void rtss_scs_singen_inout_(scicos_block * block)
{
    double t = get_scicos_time();
    double * rpar = GetRparPtrs(block);
    double * y = GetRealOutPortPtrs(block,1);

    if (t < rpar[4])
        y[0] = 0.0;
    else
        y[0] = rpar[0]*sin(rpar[1]*(t-rpar[4]) + rpar[2]) + rpar[3];
}

/**
 * @brief Final call to block for ending the simulation
 *
 * @param[in] block pointer to the structure containing block informations
 */
static
void rtss_scs_singen_end_(scicos_block * block)
{
    double * y = GetRealOutPortPtrs(block,1);
    y[0] = 0.0;
}

/**
 * @addtogroup scs SCS
 */
/** @{ */
/**
 * @brief C (Type 4) computational function for the Scicos block named "rt_singen_if"
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 *
 * @note References: RTAI-Lab, rtai-3.7.1/rtai-lab/scicoslab/devices/rtai_sinus.c
 */
void
rtss_scs_singen_cf4(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            rtss_scs_singen_inout_(block);
            break;

        case Ending:
            rtss_scs_singen_end_(block);
            break;

        case Initialization:
            rtss_scs_singen_init_(block);
            break;

        default:
            break;
    }
}
/** @} */
