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
 * @file  rtss_demo13_Dq0.c
 *
 * @brief Computational Function for the generic block Dq0 in diag13.cos
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         September 2009
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-09-09 18:42:46 +0200(mer, 09 set 2009) $
 */



#include <scicos/scicos_block4.h>       /* Scicos Block Structure */



/**
 * @brief Compute the outputs of the block
 *
 * @param[in] block pointer to the structure containing block informations
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
static void
rtss_demo13_Dq0_inout_(scicos_block * block)
{
    double * y1 = GetRealOutPortPtrs(block, 1);
    double * u1 = GetRealInPortPtrs(block, 1);
    double pi = 3.1415927;
    y1[0] = -250/3 * u1[0]/(16*pi*pi);
    y1[1] = -250/3 * u1[1]/(pi*pi);
    y1[2] = -250/3 * (u1[2]+pi)/(pi*pi);
}

/**
 * @brief Computational Function for the generic block Dq0 in diag13.cos
 *
 * @param[in] block pointer to the structure containing block informations
 * @param[in] flag  integer which indicates the job that the computational
 *                  function must perform
 */
void
rtss_demo13_Dq0(scicos_block * block, int flag)
{
    switch (flag) {
        case OutputUpdate:
            rtss_demo13_Dq0_inout_(block);
            break;

        default:
            break;
    }
}
