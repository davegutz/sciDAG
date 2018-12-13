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
 * @file  rtss_robot.c
 *
 * @brief Implementation of ROBOT submodule
 *
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



#include "../includes/rtss_mem_alloc.h" /* rtss_malloc, rtss_free */
#include "../includes/rtss_error.h"     /* Interface to ERROR module */
#include "../includes/rtss_robot.h"     /* Interface to ROBOT submodule */

/**
 * @brief Service routine for the default initialization of an rtss_robot object
 *
 * @param[out] rp pointer to the object initialized by default
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_robot_init(rtss_robot * rp)
{
    if (!rp)
        rtss_err_null_ptr();

    /* constituent links parameters */
    rp->dof = 0;
    rp->links = NULL;

    /* extension parameters */
    rp->mdh = RTSS_DH_STANDARD;
    rtssVect3SetAll(rp->gravity, 0, 0, 9.81);   /* explicit initialization (not offered by rtssRobotSetGravity macro) */
    rtssHomogSetAll(rp->base, 1, 0, 0, 0,
                              0, 1, 0, 0,
                              0, 0, 1, 0);      /* explicit initialization (not offered by rtssRobotSetBase macro) */
    rtssHomogSetAll(rp->tool, 1, 0, 0, 0,
                              0, 1, 0, 0,
                              0, 0, 1, 0);      /* explicit initialization (not offered by rtssRobotSetTool macro) */
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine which initializes an rtss_robot object from a Scicos block
 *
 * A more detailed description goes here (TODO).
 *
 * @param[out] rp  pointer to the initialized object
 * @param[in]  blk pointer to the structure containing Scicos block's information
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 * @note       TODO: setting link's qlim from qlim_matrix is still missing.
 */
int
rtss_robot_init_from_scicos_blk(rtss_robot * rp, scicos_block * block)
{
    SCSREAL_COP * legacy_matrix, * mdh, * offset_vector, * qlim_matrix, * gravity_vector, * base_frame, * tool_frame;
    int i, j, N, m;

    if (!rp)
        rtss_err_null_ptr();

    /* rebuild the robot object from the "unwrapped" robot stored in model.opar */
    /*                                                                          */
    /* elements from 2 to 4 are descriptive parameters */
    /* They aren't currently  supported.               */
    /*                                                 */
    /* getting elements 5: the constituent links list, */
    /* element 6: number of constituent links          */
    /* and element 7: mdh.                             */
    legacy_matrix = GetRealOparPtrs(block, 1);
    N = GetOparSize(block, 1, 1);
    m = GetOparSize(block, 1, 2);
    mdh = GetRealOparPtrs(block, 2);
    offset_vector = GetRealOparPtrs(block, 3);
    qlim_matrix = GetRealOparPtrs(block, 4);
    rp->dof = N;    /* preparing rtss_robot structure for the links */
    rtssRobotCreateLinks(rp, N);
    rp->mdh = (int)(*mdh);
    switch (m) {

        case RTSS_LEGACY_DYN: {
            /* create a link from a legacy DYN matrix */
            SCSREAL_COP legacy_dyn_row[RTSS_LEGACY_DYN]; /* needed to initialize link COG vector and link */
                                                         /* inertia matrix by using the corresponding macros */
            for(i = 0; i < N; i++) {
                for(j = 0; j < RTSS_LEGACY_DYN; j++)
                    legacy_dyn_row[j] = legacy_matrix[i + N*j];
                rtssLinkInit(&rp->links[i]); /* initialize the j-th rtss_link structure */
                rp->links[i].alpha = legacy_dyn_row[0];
                rp->links[i].A = legacy_dyn_row[1];
                rp->links[i].theta = legacy_dyn_row[2];
                rp->links[i].D = legacy_dyn_row[3];
                rp->links[i].sigma = (int) legacy_dyn_row[4];
                rp->links[i].mdh = (int)(*mdh);
                rp->links[i].offset = offset_vector[i];
                rp->links[i].m = legacy_dyn_row[5];
                rtssLinkSetCOG(rp->links[i], &legacy_dyn_row[6]);
                rtssLinkSetInertia(rp->links[i], &legacy_dyn_row[9], 0); /* 0 is FALSE_ */
                rp->links[i].Jm = legacy_dyn_row[15];
                rp->links[i].G = legacy_dyn_row[16];
                rp->links[i].B = legacy_dyn_row[17];
                rp->links[i].Tc[0] = legacy_dyn_row[18]; rp->links[i].Tc[1] = legacy_dyn_row[19];
                /* TODO QLIM */
            }
            break;
        }

        case RTSS_LEGACY_DH:
            /* create a link from a legacy DH matrix */
            for(i = 0; i < N; i++) {
                rtssLinkInit(&rp->links[i]); /* initialize the j-th rtss_link structure */
                rp->links[i].alpha = legacy_matrix[i];
                rp->links[i].A = legacy_matrix[i + N];
                rp->links[i].theta = legacy_matrix[i + N*2];
                rp->links[i].D = legacy_matrix[i + N*3];
                rp->links[i].sigma = (int) legacy_matrix[i + N*4];
                rp->links[i].mdh = (int)(*mdh);
                rp->links[i].offset = offset_vector[i];
                /* TODO QLIM */
            }
            break;

    }

    /* getting element 8: gravity */
    gravity_vector = GetRealOparPtrs(block, 5);
    rtssRobotSetGravity(*rp, gravity_vector);

    /* getting element 9: base    */
    base_frame = GetRealOparPtrs(block, 6);
    rtssRobotSetBase(*rp, base_frame);

    /* getting element 10: tool   */
    tool_frame = GetRealOparPtrs(block, 7);
    rtssRobotSetTool(*rp, tool_frame);
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for creating constituent links in an rtss_robot object
 *
 * @param[in] rp pointer to the rtss_robot object whose constituent links have to be created
 * @param[in] n number of constituent links to be created
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_robot_create_links(rtss_robot * rp, int n)
{
    if (!rp)
        rtss_err_null_ptr();
    if ((rp->links = rtss_malloc(n * sizeof(*rp->links))) == NULL)
        rtss_err_fail(999, "Cannot allocate memory for the constituent links");
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for destructing constituent links of an rtss_robot object
 *
 * @param[in] rp pointer to the rtss_robot object whose constituent links have to be destroyed
 * @return    RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_robot_destroy_links(rtss_robot * rp)
{
    if (!rp)
        rtss_err_null_ptr();
    rtss_free(rp->links);
    return(RTSS_SUCCESS);
}
