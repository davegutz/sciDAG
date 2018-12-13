/*-----------------------------------------------------------------------------------
 *  Copyright 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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
 * @file  rtss.h
 *
 * @brief RTSS Interface Function Library: Kinematics, Dynamics, Trajectory Generation
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
 * $LastChangedDate: 2009-08-23 19:43:41 +0200(dom, 23 ago 2009) $
 */



#ifndef RTSS_HDR
#define RTSS_HDR
#include "rtss_mem_alloc.h" /* rtss_malloc, rtss_free */
#include "rtss_math.h"      /* RTSS Interface for MATH module */
#include "rtss_homog.h"     /* RTSS Interface for HOMOGENEOUS TRANSFORMS module */
#include "rtss_link.h"      /* RTSS Interface for LINK submodule */
#include "rtss_robot.h"     /* RTSS Interface for ROBOT submodule */
/**
 * @addtogroup rtssifl INTERFACE FUNCTION LIBRARY
 */
/**
 * @ingroup rtssifl
 */
/**
 * @defgroup kinematics KINEMATICS
 */
/** @{ */
/**
 * @brief Data structure describing the workspace used for computing the Jacobian matrix
 *        of a n-DOF manipulator, wrt the base frame
 *
 * Detailed description goes here (TODO).
 *
 */
typedef struct rtss_kin_wsjacob0_ {

    double * data; /**< buffer containing a 6xn Jacobian matrix for workspace computations */

} rtss_wsjacob0;

/**
 * @brief Allocate a workspace (space of memory), for manipulator Jacobian computation
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wjptr Initialized pointer to the workspace for Jacobian computation
 */
#define rtssWSpaceJ0Init(wjptr,dof) if(rtss_wsjacob0_init(wjptr,dof) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief De-allocate a workspace, used for manipulator Jacobian computation
 *
 * @param[out] wjptr freed pointer to rtss_wsjacob0 objects
 */
#define rtssWSpaceJ0Destroy(wjptr) if(rtss_wsjacob0_destroy(wjptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Service routine for the allocation of a workspace, for manipulator Jacobian computation
 */
int rtss_wsjacob0_init(rtss_wsjacob0 * , int);

/**
 * @brief Service routine for destructing a workspace used for manipulator Jacobian computation
 */
int rtss_wsjacob0_destroy(rtss_wsjacob0 *);

/**
 * @brief Link rotation matrix and translation vectors
 */
void rtss_kin_link_trans(rtss_link * , double *);

/**
 * @brief Compute the forward kinematics for a serial n-link manipulator
 */
int rtss_kin_fkine_(rtss_homog * , rtss_robot * , double *);

/**
 * @brief Compute manipulator Jacobian in end-effector coordinate frame
 */
int rtss_kin_jacobn_(double * , rtss_robot * , double *);

/**
 * @brief Compute manipulator Jacobian in base coordinate frame
 */
int rtss_kin_jacob0_(double * , rtss_robot * , double * , rtss_wsjacob0 *);

/**
 * @brief Error checking for function rtss_kin_fkine_()
 */
#define rtss_kin_fkine(Twep, robp, q) if(rtss_kin_fkine_(Twep, robp, q) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_kin_jacobn_()
 */
#define rtss_kin_jacobn(Jn, robp, q) if(rtss_kin_jacobn_(Jn, robp, q) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_kin_jacob0_()
 */
#define rtss_kin_jacob0(J0, robp, q, wjptr) if(rtss_kin_jacob0_(J0, robp, q, wjptr) == RTSS_FAILURE) {rtss_err_call();}
/** @} */

/**
 * @ingroup rtssifl
 */
/**
 * @defgroup dynamics DYNAMICS
 */
/** @{ */
/**
 * @brief Data structure describing the workspace used for manipulator
 *        joint-space inertia matrix computations
 *
 * Detailed description goes here (TODO).
 *
 */
typedef struct rtss_dyn_wsinertia_ {

    double * zeros; /**< address of the buffer containing the <em>zero-valued</em> joint velocity vector */
    double * eye_r; /**< address of the buffer containing the <em>zero-valued</em> joint acceleration vector */

} rtss_wsinertia;

/**
 * @brief Allocate and initialize a workspace (space of memory), for manipulator
 *        joint-space inertia matrix computations
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wiptr pointer to the workspace for joint-space inertia matrix computations
 */
#define rtssWSpaceInertiaInit(wiptr,dof) if(rtss_wsinertia_init(wiptr,dof) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief De-allocate a workspace, used for manipulator joint-space inertia matrix computations
 *
 * @param[out] wiptr freed pointer to rtss_wsinertia objects
 */
#define rtssWSpaceInertiaDestroy(wiptr) if(rtss_wsinertia_destroy(wiptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Service routine for the allocation and initialization of a workspace, for manipulator
 *        joint-space inertia matrix computations
 */
int rtss_wsinertia_init(rtss_wsinertia * , int);

/**
 * @brief Service routine for destructing a workspace used for manipulator joint-space inertia matrix computations
 */
int rtss_wsinertia_destroy(rtss_wsinertia *);

/**
 * @brief Data structure describing the workspace used for manipulator
 *        Coriolis/centripetal torque components computations
 *
 * Detailed description goes here (TODO).
 *
 */
typedef struct rtss_dyn_wscoriolis_ {

    double * zeros; /**< address of the buffer containing the <em>zero-valued</em> joint acceleration vector */

} rtss_wscoriolis;

/**
 * @brief Allocate and initialize a workspace (space of memory), for manipulator
 *        Coriolis/centripetal torques computation
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wcptr pointer to the workspace for gravity torque components computations
 */
#define rtssWSpaceCoriolisInit(wcptr,dof) if(rtss_wscoriolis_init(wcptr,dof) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief De-allocate a workspace, used for manipulator Coriolis/centripetal torques computation
 *
 * @param[out] wcptr freed pointer to rtss_wscoriolis objects
 */
#define rtssWSpaceCoriolisDestroy(wcptr) if(rtss_wscoriolis_destroy(wcptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Service routine for the allocation and initialization of a workspace, for manipulator
 *        Coriolis/centripetal torques computation
 */
int rtss_wscoriolis_init(rtss_wscoriolis * , int);

/**
 * @brief Service routine for destructing a workspace used for manipulator Coriolis/centripetal torques computation
 */
int rtss_wscoriolis_destroy(rtss_wscoriolis *);

/**
 * @brief Data structure describing the workspace used for manipulator
 *        gravity torque components computations
 *
 * Detailed description goes here (TODO).
 *
 */
typedef struct rtss_dyn_wsgravload_ {

    double * zeros; /**< address of the buffer containing the <em>zero-valued</em> joint velocity/acceleration vector */

} rtss_wsgravload;

/**
 * @brief Allocate and initialize a workspace (space of memory), for manipulator
 *        gravity torque components computations
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wgptr pointer to the workspace for gravity torque components computations
 */
#define rtssWSpaceGravloadInit(wgptr,dof) if(rtss_wsgravload_init(wgptr,dof) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief De-allocate a workspace, used for manipulator gravity torque components computations
 *
 * @param[out] wgptr freed pointer to rtss_wsgravload objects
 */
#define rtssWSpaceGravloadDestroy(wgptr) if(rtss_wsgravload_destroy(wgptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Service routine for the allocation and initialization of a workspace, for manipulator
 *        gravity torque components computations
 */
int rtss_wsgravload_init(rtss_wsgravload * , int);

/**
 * @brief Service routine for destructing a workspace used for manipulator gravity torque components computations
 */
int rtss_wsgravload_destroy(rtss_wsgravload *);

/**
 * @brief Data structure describing the workspace used for manipulator
 *        joint acceleration vector computations
 *
 * Detailed description goes here (TODO).
 *
 */
typedef struct rtss_dyn_wsaccel_ {

    double * wgctorq;       /**< address of the buffer containing data for gravity and Coriolis torques computation */
    rtss_wsinertia winer;   /**< address of the buffer containing data for inertia matrix computation */
    double * inertia;       /**< address of the buffer containing the inertia matrix */
    rtss_imatrix imat;      /**< address of the buffer used for the computation of the inverse of the inertia matrix */

} rtss_wsaccel;

/**
 * @brief Allocate a workspace (space of memory), for manipulator joint acceleration vector computation
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] waptr pointer to the workspace for joint acceleration vector computation
 */
#define rtssWSpaceAccelInit(waptr,dof) if(rtss_wsaccel_init(waptr,dof) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief De-allocate a workspace, used for manipulator joint acceleration vector computation
 *
 * @param[out] waptr freed pointer to rtss_wsaccel objects
 */
#define rtssWSpaceAccelDestroy(waptr) if(rtss_wsaccel_destroy(waptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Service routine for the allocation of a workspace, for manipulator joint acceleration vector computation
 */
int rtss_wsaccel_init(rtss_wsaccel * , int);

/**
 * @brief Service routine for destructing a workspace used for manipulator joint acceleration vector computation
 */
int rtss_wsaccel_destroy(rtss_wsaccel *);

/**
 * @brief Compute inverse dynamics via recursive Newton-Euler formulation
 */
int rtss_dyn_frne_(double * , rtss_robot * , int , double * , double * , double * , double *);

/**
 * @brief Compute the manipulator joint-space inertia matrix
 */
int rtss_dyn_inertia_(double * , rtss_robot * , double * , rtss_wsinertia *);

/**
 * @brief Compute the manipulator Coriolis/centripetal torque components
 */
int rtss_dyn_coriolis_(double * , rtss_robot * , double * , double * , rtss_wscoriolis *);

/**
 * @brief Compute the manipulator gravity torque components
 */
int rtss_dyn_gravload_(double * , rtss_robot * , double * , rtss_wsgravload *);

/**
 * @brief Compute the manipulator joint acceleration vector
 */
int rtss_dyn_accel_(double * , rtss_robot * , double * , double * , double * , rtss_wsaccel *);

/**
 * @brief Error checking for function rtss_dyn_frne_()
 */
#define rtss_dyn_frne(tau, robp, mq, q, qd, qdd, fext) if(rtss_dyn_frne_(tau, robp, mq, q, qd, qdd, fext) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_dyn_inertia_()
 */
#define rtss_dyn_inertia(imatrix, robp, q, wiptr) if(rtss_dyn_inertia_(imatrix, robp, q, wiptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_dyn_coriolis_()
 */
#define rtss_dyn_coriolis(ctorq, robp, q, qd, wcptr) if(rtss_dyn_coriolis_(ctorq, robp, q, qd, wcptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_dyn_gravload_()
 */
#define rtss_dyn_gravload(gtorq, robp, q, wgptr) if(rtss_dyn_gravload_(gtorq, robp, q, wgptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_dyn_accel_()
 */
#define rtss_dyn_accel(qdd, robp, q, qd, torque, waptr) if(rtss_dyn_accel_(qdd, robp, q, qd, torque, waptr) == RTSS_FAILURE) {rtss_err_call();}
/** @} */
#endif /* RTSS_HDR */
