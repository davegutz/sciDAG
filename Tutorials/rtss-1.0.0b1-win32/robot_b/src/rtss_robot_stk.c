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
 * @file  rtss_robot_stk.c
 *
 * @brief Implementation of ROBOT submodule
 *
 * Definition of the functions interacting with Scilab stack (STK)
 * A more detailed description goes here (TODO).
 *
 * @note TODO: memory management. For further details, see:<br>
 * <code> http://apps.sourceforge.net/mediawiki/rtss/index.php?title=Reduction_of_memory_leaks </code>
 * <code> http://apps.sourceforge.net/mediawiki/rtss/index.php?title=Profiling_RTSS </code>
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         April 2007
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2007, 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 *  $LastChangedDate: 2009-08-15 19:14:27 +0200(sab, 15 ago 2009) $
 */



#include <string.h>                     /* for checking the mlist's type */
#include <stack-c.h>                    /* Scilab's Stack and other */
#include "../includes/rtss_mem_alloc.h" /* rtss_malloc, rtss_free */
#include "../includes/rtss_error.h"     /* Interface to ERROR module */
#include "../includes/rtss_robot.h"     /* Interface to ROBOT submodule */

/*--------------------------------
 * Bunch of external declarations.
 *------------------------------ */
extern int * listentry(int * , int);

/**
 * @brief Service routine which initializes an rtss_robot object from an mlist in the Scilab stack
 *
 * In general, getting the robot parameters is not a problem and it can be efficiently done
 * by using the Scilab Interface Library (SIL). The only one difficulty here is with the
 * constituent links of the robot model.
 *
 * In order to be able to get the robot's links, it is necessary to "read" the Scilab
 * stack at a very low-level. This, since the SIL does not provide a straightforward way to
 * extract a LIST of MLISTS (list of links) from a MLIST (the robot). Some notes about this
 * are given below.
 *
 * Let v be the k-th RHS variable passed to the sci_gateway function. Then, we have that
 *   -# <code> sv = *Lstk(k) </code> is the address of the starting location of v in the stack STK;
 *   -# <code> iv = iadr(sv) </code> is the address of the starting location of its \e description (type,
 *      length, real or complex and so on), in the stack ISTK. Note that <code> sadr(iv) == sv </code>
 *   -# the address of the starting location of its \e values (\e structures, when v is a
 *      list) depends on the different types of variables.
 *
 * In particular, when v is a \b scalar M-by-N matrix, we have:
 *
 *   -# <code> sv = *Lstk(k) </code>, the starting location of v in STK;
 *   -# <code> iv = iadr(sv) </code>, the starting location of its \e description in ISTK;
 *     - <code> *istk(iv) == 1 </code>,   its type;
 *     - <code> *istk(iv+1) == M </code>, number of rows;
 *     - <code> *istk(iv+2) == N </code>, number of columns;
 *     - <code> *istk(iv+3) </code>,      0 if the matrix coefficients are real, 1 if they are complex;
 *   -# <code> svv = sadr(iv+4) </code>, the starting location of its \e values in STK;
 *     - <code> svv+(i-1)+(j-1)*M) </code>,     where the matrix element (i,j) is stored in STK (real case);
 *     - <code> svv+M*N+(i-1)+(j-1)*M) </code>, where the matrix element (i,j) is stored in STK (complex case);
 *
 * Instead, when v is a \b list with N elements we have:
 *
 *   -# <code> sv = *Lstk(k) </code>, the starting location of v in STK;
 *   -# <code> iv = iadr(sv) </code>, the starting location of its \e description in ISTK;
 *     - <code> *istk(iv) </code>,          its type (15 if v is a list, 17 if v is a mlist);
 *     - <code> N == *istk(iv+1) </code>,   its length;
 *     - <code> ivp = iv+2 </code>,         TODO
 *   -# <code> sel = sadr(ivp+N+1) </code>, starting location of the \e structure of the element 1 in the
 *                                          list. For a \b scalar matrix we would have:
 *     - <code> iel = iadr(sel) </code>,    starting location of its \e description in ISTK;
 *     - <code> selv = sadr(iel+4) </code>, starting location of its \e values in STK;
 *
 * Note that <code> sel = sadr(ivp+N+1) + *istk(ivp+(w-1)) - 1 </code> is the starting location of the \e structure of the
 * element w in the list.
 *
 * @param[out] rp  pointer to the initialized object
 * @param[in]  pos number of the variable that identifies the robot structure in
 *                 the stack STK.
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 *
 * @note References: Internals.pdf: Scilab's internals.
 */
int
rtss_robot_init_from_stk(rtss_robot * rp, int pos)
{
    integer * il_robot, * il_cllist, * il_link, * subheader;
    int j, N;
    int mv, nv, iv;
    char ** type;

    if (!rp)
        rtss_err_null_ptr();

    GetRhsVar(pos, "m", &mv, &nv, &iv);

    /* check if is a robot */
    GetListRhsVar(pos, 1, "S", &mv, &nv, &type);
    if (strcmp(type[0], "robot")) {
        rtss_free(type[0]);
        rtss_free(type);
        rtss_err_fail(999, "The input argument is not a robot");
    }
    rtss_free(type[0]);
    rtss_free(type);

    /* get its parameters */
    /*                    */
    /* elements from 2 to 4 are descriptive parameters */
    /* They aren't currently  supported                */
    /*                                                 */
    /* getting element 5: the constituent links list.  */
    /* LIST of MLISTS (list of links) inside           */
    /* an MLIST (the robot).                           */
    /* (N-by-1) LIST of MLISTS                         */
    /*                                          */
    /* and element 6: number of constituent     */
    /* links (i.e. the LIST length N).          */
    /* scalar (1-by-1) real matrix              */
    il_robot = (integer *) GetData(pos);                  /* getting the robot description */

    il_cllist = (integer *) (listentry(il_robot, 5));     /* 5-th element (LIST) in the robot MLIST */
    N = il_cllist[1];                                     /* LIST's length (i.e. element 6 --number of constituent links (N)) */

    rp->dof = N;                                          /* preparing rtss_robot structure for the links */
    rtssRobotCreateLinks(rp, N);
    for(j = 0; j < N; j++) {                              /* inserting each link inside the rtss_robot structure */
        il_link = (integer *) (listentry(il_cllist, j+1));
        rtssLinkInit(&rp->links[j]);                      /* default initialization of j-th rtss_link structure */

        /* get the parameters of (j+1)-th constituent link from the stack */
        /* and set them in the j-th rtss_link structure                   */
        subheader = (integer *) (listentry(il_link, 2));  /* scalar (1-by-1) real matrix */
        rp->links[j].alpha = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 3));  /* scalar (1-by-1) real matrix */
        rp->links[j].A = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 4));  /* scalar (1-by-1) real matrix */
        rp->links[j].theta = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 5));  /* scalar (1-by-1) real matrix */
        rp->links[j].D = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 6));  /* scalar (1-by-1) real matrix */
        rp->links[j].sigma = (int) (*(double *) (subheader+4));

        subheader = (integer *) (listentry(il_link, 7));  /* scalar (1-by-1) real matrix */
        rp->links[j].mdh = (int) (*(double *) (subheader+4));

        subheader = (integer *) (listentry(il_link, 8));  /* scalar (1-by-1) real matrix */
        rp->links[j].offset = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 9));  /* scalar (1-by-1) real matrix */
        if (subheader[1])
            rp->links[j].m = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 10)); /* scalar (3-by-1) real matrix */
        if (subheader[1])
            rtssLinkSetCOG(rp->links[j], (double *) (subheader+4));

        subheader = (integer *) (listentry(il_link, 11)); /* scalar (3-by-3) real matrix */
        if (subheader[1])
            rtssLinkSetInertia(rp->links[j], (double *) (subheader+4), TRUE_);

        subheader = (integer *) (listentry(il_link, 12));  /* scalar (1-by-1) real matrix */
        if (subheader[1])
            rp->links[j].Jm = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 13));  /* scalar (1-by-1) real matrix */
        if (subheader[1])
            rp->links[j].G = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 14));  /* scalar (1-by-1) real matrix */
        rp->links[j].B = *(double *) (subheader+4);

        subheader = (integer *) (listentry(il_link, 15)); /* scalar (1-by-2) real matrix */
        rp->links[j].Tc[0] = ((double *) (subheader+4))[0]; rp->links[j].Tc[1] = ((double *) (subheader+4))[1];

        subheader = (integer *) (listentry(il_link, 16)); /* scalar (1-by-2) real matrix */
        if (subheader[1]) {
            rp->links[j].qlim[0] = ((double *) (subheader+4))[0];
            rp->links[j].qlim[1] = ((double *) (subheader+4))[1];
        }
    }

    /* getting element 7: mdh      */
    /* scalar (1-by-1) real matrix */
    GetListRhsVar(pos, 7, "d", &mv, &nv, &iv);
    rp->mdh = (int) *stk(iv);

    /* getting element 8: gravity  */
    /* scalar (3-by-1) real matrix */
    GetListRhsVar(pos, 8, "d", &mv, &nv, &iv);
    rtssRobotSetGravity(*rp, stk(iv));

    /* getting element 9: base     */
    /* scalar (4-by-4) real matrix */
    GetListRhsVar(pos, 9, "d", &mv, &nv, &iv);
    rtssRobotSetBase(*rp, stk(iv));

    /* getting element 10: tool    */
    /* scalar (4-by-4) real matrix */
    GetListRhsVar(pos, 10, "d", &mv, &nv, &iv);
    rtssRobotSetTool(*rp, stk(iv));
    return(RTSS_SUCCESS);

}
