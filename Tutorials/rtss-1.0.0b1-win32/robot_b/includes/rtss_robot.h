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
 * @file  rtss_robot.h
 *
 * @brief Interface to ROBOT submodule
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
 * $LastChangedDate: 2009-08-23 19:43:41 +0200(dom, 23 ago 2009) $
 */



#ifndef RTSS_ROBOT_HDR
#define RTSS_ROBOT_HDR
#include "rtss_math.h"              /* Interface to MATH module */
#include "rtss_homog.h"             /* Interface to HOMOGENEOUS TRANSFORMS module */
#include "rtss_link.h"              /* Interface to LINK submodule */
#include <scicos/scicos_block4.h>   /* Scicos Block Structure */
/**
 * @addtogroup adt ABSTRACT DATA TYPES
 */
/**
 * @ingroup adt
 */
/**
 * @defgroup robot ROBOT
 */
/** @{ */
/**
 * @brief Data structure of robot objects
 *
 * Detailed description goes here (TODO).
 *
 * @note The data structure is inspired by the one implemented in the Robotics
 *       Toolbox for MATLAB(R) written by Peter I. Corke.
 *
 * @note Some parameters in the Scilab counterpart of the robot data structure
 *       --a Scilab mlist with 15 fields (see ../macros/rt_robot.sci, for further
 *       details)-- are NOT currently supported in the ROBOT submodule of librtssc
 *       library:
 *         - graphic support parameters: could use external C libraries for graphics
 *           e.g. OpenGL?
 *         - descriptive parameters such as "name", "manuf" and "comments" are mainly
 *           used for graphics and currently there is no need to be supported
 *
 * @note References: robot7.1/\@robot/robot.m, Robotics Toolbox for MATLAB(R)
 */
typedef struct rtss_robot_ {

    /**
    * @name constituent links parameters
    */
    /*@{*/
    rtss_link * links;  /**< pointer to array of constituent links */
    int dof;            /**< robot's number of DOF */
    /*@}*/
    /**
    * @name extension parameters
    */
    /*@{*/
    int mdh;            /**< DH convention. Determined from the constituent links */
    rtss_vect3 gravity; /**< vector defining gravity direction */
    rtss_homog base;    /**< homogeneous transform describing the config of the robot base */
    rtss_homog tool;    /**< homogeneous transform describing the config of the robot tool */
    /*@}*/

} rtss_robot;

/**
 * @brief Default initializer for rtss_robot objects
 *
 * @param[out] rp pointer to the object initialized by default
 */
#define rtssRobotInit(rp) if(rtss_robot_init(rp) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Initialize an rtss_robot object from an mlist in the Scilab stack
 *
 * @param[out] rp  pointer to the initialized object
 * @param[in]  pos number of the variable that identifies the robot structure in
 *                 the stack STK.
 */
#define rtssRobotInitFromStk(rp, pos) if(rtss_robot_init_from_stk(rp, pos) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Initialize an rtss_robot object from the data stored in a Scicos block
 * @param[out] rp  pointer to the initialized object
 * @param[in]  blk pointer to the structure containing Scicos block's information
 */
#define rtssRobotInitFromScicosBlk(rp, blk) \
            if(rtss_robot_init_from_scicos_blk(rp, blk) == RTSS_FAILURE) { \
                set_block_error(-16); \
                rtss_free(GetWorkPtrs(blk)); \
                return(RTSS_FAILURE); \
            }

/**
 * @brief Create constituent links in an rtss_robot object
 *
 * @param[out] rp pointer to the rtss_robot object whose constituent links have to be created
 * @param[in]  n number of constituent links to be created
 */
#define rtssRobotCreateLinks(rp, n) if(rtss_robot_create_links(rp, n) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Destroy constituent links in an rtss_robot object
 *
 * @param[out] rp pointer to the rtss_robot object whose constituent links have to be destroyed
 */
#define rtssRobotDestroyLinks(rp) if(rtss_robot_destroy_links(rp) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Set robot gravity vector
 *
 * @param[out] rob  modified rtss_robot object
 * @param[in]  vect array of values (3-elements array) for the robot (@p rob) gravity vector
 */
#define rtssRobotSetGravity(rob, vect) rtssVect3Set((rob).gravity, vect)

/**
 * @brief Access to data of robot gravity vector
 *
 * @param[in] rob rtss_robot object
 * @return pointer to the address of first data of robot gravity vector
 */
#define rtssRobotGravity(rob) rtssVect3Num((rob).gravity)

/**
 * @brief Set the homogeneous transform defining the robot base
 * @param[out] rob modified rtss_robot object
 * @param[in]  tr  pointer of first element of new homogeneous transform defining the
 *                 robot's base (4-by-4 matrix)
 */
#define rtssRobotSetBase(rob, tr) rtssHomogSet((rob).base, tr)

/**
 * @brief Access to the data of robot base homogeneous transform
 *
 * @param[in] rob rtss_robot object
 * @param[in] part enumerator indicating the part of the base transform to be accessed (transl/rot)
 * @return pointer to the address of first data of rotational or translational part of the robot base transform
 */
#define rtssRobotBase(rob, part) rtssHomogNum((rob).base, part)

/**
 * @brief Set homogeneous transform defining the robot tool
 * @param[out] rob modified rtss_robot object
 * @param[in]  tr  pointer of first element of new homogeneous transform defining the
 *                 robot tool (4-by-4 matrix)
 */
#define rtssRobotSetTool(rob, tr) rtssHomogSet((rob).tool, tr)

/**
 * @brief Access to the data of robot tool homogeneous transform
 *
 * @param[in] rob rtss_robot object
 * @param[in] part enumerator indicating the part of the tool transform to be accessed (transl/rot)
 * @return pointer to the address of first data of rotational or translational part of the robot tool transform
 */
#define rtssRobotTool(rob, part) rtssHomogNum((rob).tool, part)

/**
 * @brief Service routine for the default initialization of an rtss_robot object
 */
int rtss_robot_init(rtss_robot *);

/**
 * @brief Service routine which initializes an rtss_robot object from an mlist in the Scilab stack
 */
int rtss_robot_init_from_stk(rtss_robot * , int);

/**
 * @brief Service routine which initializes an rtss_robot object from a Scicos block
 */
int rtss_robot_init_from_scicos_blk(rtss_robot * , scicos_block *);

/**
 * @brief Service routine for creating constituent links in an rtss_robot object
 */
int rtss_robot_create_links(rtss_robot * , int);

/**
 * @brief Service routine for destructing constituent links of an rtss_robot object
 */
int rtss_robot_destroy_links(rtss_robot *);

/**
 * @brief Service routine which prints the values of an initialized rtss_robot object on the Scilab console
 */
int rtss_robot_print(rtss_robot *);
/** @} */
#endif /* RTSS_ROBOT_HDR */
