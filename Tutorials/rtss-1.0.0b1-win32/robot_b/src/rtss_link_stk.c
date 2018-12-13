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
 * @file  rtss_link_stk.c
 *
 * @brief Implementation of LINK submodule
 *
 * Definition of the functions interacting with Scilab stack (STK)
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
 *  $LastChangedDate: 2009-08-15 19:14:27 +0200(sab, 15 ago 2009) $
 */



#include <string.h>                     /* for checking the mlist's type */
#include <stack-c.h>                    /* Scilab Stack and other */
#include "../includes/rtss_mem_alloc.h" /* rtss_malloc, rtss_free */
#include "../includes/rtss_error.h"     /* Interface to ERROR module */
#include "../includes/rtss_link.h"      /* Interface to LINK submodule */

/**
 * @brief Service routine which initializes an rtss_link object from an mlist in the Scilab stack
 *
 * Reading the link parameters from the Scilab stack (STK), is not
 * a problem and it can be efficiently done by using the Scilab
 * Interface Library (SIL).
 *
 * Note about empty vars that will be initialized with default values (TODO)
 *
 * @param[out] lp pointer to the initialized object
 * @param[in]  pos number of the variable that identifies the link structure in
 *                 the stack STK.
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_link_init_from_stk(rtss_link * lp, int pos)
{
    int mv, nv, iv;
    char ** type;

    if (!lp)
        rtss_err_null_ptr();

    GetRhsVar(pos, "m", &mv, &nv, &iv);

    /* check if is a link and do initialize it */
    GetListRhsVar(pos, 1, "S", &mv, &nv, &type);
    if (strcmp(type[0], "link")) {
        rtss_free(type[0]);
        rtss_free(type);
        rtss_err_fail(999, "The input argument is not a link");
    }
    rtss_free(type[0]);
    rtss_free(type);
    rtssLinkInit(lp);

    /* get its parameters */
    /*                    */
    /* getting element 2: alpha    */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 2, "d", &mv, &nv, &iv);
    lp->alpha = *stk(iv);

    /* getting element 3: A        */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 3, "d", &mv, &nv, &iv);
    lp->A = *stk(iv);

    /* getting element 4: theta    */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 4, "d", &mv, &nv, &iv);
    lp->theta = *stk(iv);

    /* getting element 5: D        */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 5, "d", &mv, &nv, &iv);
    lp->D = *stk(iv);

    /* getting element 6: sigma    */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 6, "d", &mv, &nv, &iv);
    lp->sigma = (int) *stk(iv);

    /* getting element 7: mdh      */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 7, "d", &mv, &nv, &iv);
    lp->mdh = (int) *stk(iv);

    /* getting element 8: offset   */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 8, "d", &mv, &nv, &iv);
    lp->offset = *stk(iv);

    /* getting element 9: m        */
    /* scalar (1-by-1) real matrix */
    /* COULD BE EMPTY              */
    GetListRhsVar(pos, 9, "d", &mv, &nv, &iv);
    lp->m = (mv) ? *stk(iv) : 1;

    /* getting element 10: r       */
    /* scalar (3-by-1) real matrix */
    /* COULD BE EMPTY              */
    GetListRhsVar(pos, 10, "d", &mv, &nv, &iv);
    if (mv)
        rtssLinkSetCOG(*lp, stk(iv));

    /* getting element 11: I       */
    /* scalar (3-by-3) real matrix */
    /* COULD BE EMPTY              */
    GetListRhsVar(pos, 11, "d", &mv, &nv, &iv);
    if (mv)
        rtssLinkSetInertia(*lp, stk(iv), TRUE_);

    /* getting element 12: Jm      */
    /* scalar (1-by-1) real matrix */
    /* COULD BE EMPTY              */
    GetListRhsVar(pos, 12, "d", &mv, &nv, &iv);
    lp->Jm = (mv) ? *stk(iv) : 0;

    /* getting element 13: G       */
    /* scalar (1-by-1) real matrix */
    /* COULD BE EMPTY              */
    GetListRhsVar(pos, 13, "d", &mv, &nv, &iv);
    lp->G = (mv) ? *stk(iv) : 0;

    /* getting element 14: B       */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 14, "d", &mv, &nv, &iv);
    lp->B = *stk(iv);

    /* getting element 15: Tc      */
    /* scalar (1-by-2) real matrix */
    GetListRhsVar(pos, 15, "d", &mv, &nv, &iv);
    lp->Tc[0] = (stk(iv))[0]; lp->Tc[1] = (stk(iv))[1];

    /* getting element 16: qlim    */
    /* scalar (1-by-2) real matrix */
    /* COULD BE EMPTY              */
    GetListRhsVar(pos, 16, "d", &mv, &nv, &iv);
    if (mv) {
        lp->qlim[0] = (stk(iv))[0];
        lp->qlim[1] = (stk(iv))[1];
    }

    return(RTSS_SUCCESS);
}
