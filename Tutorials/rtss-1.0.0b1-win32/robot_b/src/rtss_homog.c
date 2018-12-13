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
 * @file  rtss_homog.c
 *
 * @brief Implementation of HOMOGENEOUS TRANSFORMS module
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
 * $LastChangedDate: 2009-07-31 10:14:22 +0200(ven, 31 lug 2009) $
 */



#include "../includes/rtss_error.h"  /* Interface to ERROR module */
#include "../includes/rtss_homog.h"  /* Interface to HOMOGENEOUS TRANSFORMS module */



/**
 * @brief Composition of a sequence of coordinate transformations
 *
 * @param[in]  Tap pointer to rtss_homog object representing a first coordinate transformation
 * @param[in]  Tbp pointer to rtss_homog object representing a second coordinate transformation
 * @param[out] Tcp pointer to rtss_homog object describing the configuration resulting from the composition
 *                 (matrix product) of the two coordinate transformations.
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_homog_compose_(rtss_homog * Tcp, rtss_homog * Tap, rtss_homog * Tbp)
{
    /* rotational part of resulting transform */
    rtss_math_dgemm(1.0, RTSS_MATH_NOTRANS, 3, 3, rtssHomogNum(*Tap, RTSS_HOMOG_ROT),
                            RTSS_MATH_NOTRANS, 3, rtssHomogNum(*Tbp, RTSS_HOMOG_ROT),
                                0.0, rtssHomogNum(*Tcp, RTSS_HOMOG_ROT));
    /* translational part of resulting transform */
    Tcp->p = Tap->p;
    rtss_math_dgemv(1.0, RTSS_MATH_NOTRANS, 3, 3, rtssHomogNum(*Tap, RTSS_HOMOG_ROT),
                            rtssHomogNum(*Tbp, RTSS_HOMOG_TRANSL),
                                1.0, rtssHomogNum(*Tcp, RTSS_HOMOG_TRANSL));
    return(RTSS_SUCCESS);
}
