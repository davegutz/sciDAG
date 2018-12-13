/*-----------------------------------------------------------------------------------
 *  Copyright (C) 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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
 * @file  rtss_link.c
 *
 * @brief Implementation of LINK submodule
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         March 2008
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 *  $LastChangedDate: 2009-08-14 15:07:19 +0200(ven, 14 ago 2009) $
 */



#include "../includes/rtss_error.h"  /* Interface to ERROR module */
#include "../includes/rtss_link.h"   /* Interface to LINK submodule */

/**
 * @brief Service routine for the default initialization of an rtss_link object
 *
 * Differences with its Scilab counterpart (TODO).
 *
 * @param[out] lp pointer to the object initialized by default
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_link_init(rtss_link * lp)
{
    if (!lp)
        rtss_err_null_ptr();

    /* kinematic, dynamic and joint limit support parameters */
    lp->alpha = 0;
    lp->A = 0;
    lp->theta = 0;
    lp->D = 0;
    lp->sigma = RTSS_REVOLUTE_JOINT;
    lp->mdh = RTSS_DH_STANDARD;
    lp->offset = 0;
    lp->m = 1;
    rtssVect3SetAll(lp->rbar, 0, 0, 0);     /* explicit initialization (not offered by rtssLinkSetCOG macro) */
    rtssMatrix33SetAll(lp->I, 0, 0, 0,
                              0, 0, 0,
                              0, 0, 0);     /* explicit initialization (not offered by rtssLinkSetInertia macro) */
    lp->Jm = 0;
    lp->G = 0;
    lp->B = 0;
    lp->Tc[0] = 0; lp->Tc[1] = 0;
    lp->qlim[0] = 0; lp->qlim[1] = 0;

    /* intermediate variables */
    rtssLinkSetCoordTransform(*lp, 1, 0, 0, 0,
                                   0, 1, 0, 0,
                                   0, 0, 1, 0);
    rtssVect3SetAll(lp->pstar, 0, 0, 0);    /* explicit initialization (not offered by rtssLinkSetPstar macro) */
    rtssVect3SetAll(lp->omega, 0, 0, 0);    /* explicit initialization (not offered by rtssLinkSetOmega macro) */
    rtssVect3SetAll(lp->omega_d, 0, 0, 0);  /* explicit initialization (not offered by rtssLinkSetOmegaDot macro) */
    rtssVect3SetAll(lp->acc, 0, 0, 0);      /* explicit initialization (not offered by rtssLinkSetAcc macro) */
    rtssVect3SetAll(lp->abar, 0, 0, 0);     /* explicit initialization (not offered by rtssLinkSetAccCOG macro) */
    rtssVect3SetAll(lp->f, 0, 0, 0);        /* explicit initialization (not offered by rtssLinkSetForce macro) */
    rtssVect3SetAll(lp->n, 0, 0, 0);        /* explicit initialization (not offered by rtssLinkSetMoment macro) */
    return(RTSS_SUCCESS);
}
