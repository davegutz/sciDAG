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
 * @file  rtss_link.h
 *
 * @brief Interface to LINK submodule
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
 * $LastChangedDate: 2009-07-31 16:38:55 +0200(ven, 31 lug 2009) $
 */



#ifndef RTSS_LINK_HDR
#define RTSS_LINK_HDR
#include "rtss_math.h"  /* Interface to MATH module */
#include "rtss_homog.h" /* Interface to HOMOGENEOUS TRANSFORMS module */
/**
 * @addtogroup adt ABSTRACT DATA TYPES
 */
/**
 * @ingroup adt
 */
/**
 * @defgroup link LINK
 */
/** @{ */
/**
 * @brief Enumeration for link's attributes
 */
enum rtss_link_enum_ {

    RTSS_DH_STANDARD = 0,       /**< Denavit-Hartenberg (DH) convention: 0 if standard */
    RTSS_DH_MODIFIED = 1,       /**< Denavit-Hartenberg (DH) convention: 1 if modified */
    RTSS_REVOLUTE_JOINT = 0,    /**< joint type: 0 for revolute */
    RTSS_PRISMATIC_JOINT = 1,   /**< joint type: non-zero for prismatic */
    RTSS_LEGACY_DH = 5,         /**< number of elements describing the link's kinematics */
    RTSS_LEGACY_DYN = 20        /**< number of elements describing the link's kinematics and dynamics */

};

/**
 * @brief Data structure of link objects
 *
 * Detailed description goes here (TODO).
 *
 * @note The data structure is inspired by the one implemented in the Robotics
 *       Toolbox for MATLAB(R) written by Peter I. Corke.
 *
 * @note References: robot7.1/mex/frne.h, Robotics Toolbox for MATLAB(R)
 */
typedef struct rtss_link_ {

    /**
    * @name kinematic parameters
    */
    /*@{*/
    double alpha;       /**< link twist angle */
    double A;           /**< link length */
    double theta;       /**< link rotation angle */
    double D;           /**< link offset distance */
    int sigma;          /**< joint type */
    int mdh;            /**< DH convention */
    double offset;      /**< joint coordinate offset */
    /*@}*/
    /**
    * @name dynamic parameters
    */
    /*@{*/
    double m;           /**< mass of link */
    rtss_vect3 rbar;    /**< centre of mass of link with respect to link origin */
    rtss_matrix33 I;    /**< inertia tensor of link with respect to link origin */
    double Jm;          /**< actuator inertia */
    double G;           /**< actuator gear ratio */
    double B;           /**< actuator friction damping coefficient */
    double Tc[2];       /**< actuator Coulomb friction coeffient */
    /*@}*/
    /**
    * @name joint limit parameters
    */
    /*@{*/
    double qlim[2];     /**< joint coordinate limits */
    /*@}*/
    /**
    * @name intermediate variables
    */
    /*@{*/
    rtss_homog T;       /**< coordinate transformation matrix between consecutive links */
    rtss_vect3 pstar;   /**< distance of link origin, say \f$i\f$-th, from the \f$i-1\f$-th with respect to \f$i\f$-th */
    rtss_vect3 omega;   /**< angular velocity */
    rtss_vect3 omega_d; /**< angular acceleration */
    rtss_vect3 acc;     /**< acceleration */
    rtss_vect3 abar;    /**< acceleration of centre of mass */
    rtss_vect3 f;       /**< inter-link force */
    rtss_vect3 n;       /**< inter-link moment */
    /*@}*/

} rtss_link;

/**
 * @brief Default initializer for rtss_link objects
 *
 * @param[out] lp pointer to the object initialized by default
 */
#define rtssLinkInit(lp) if(rtss_link_init(lp) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Initialize an rtss_link object from an mlist in the Scilab stack
 *
 * @param[out] lp  pointer to the initialized object
 * @param[in]  pos number of the variable that identifies the link structure in
 *                 the stack STK.
 */
#define rtssLinkInitFromStk(lp, pos) if(rtss_link_init_from_stk(lp, pos) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Set link COG vector
 *
 * @param[out] link modified rtss_link object
 * @param[in]  vect array of values (3-elements array) for the link (@p link) COG vector
 */
#define rtssLinkSetCOG(link, vect) rtssVect3Set((link).rbar, vect)

/**
 * @brief Access to data of link COG vector
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of link COG vector
 */
#define rtssLinkCOG(link) rtssVect3Num((link).rbar)

/**
 * @brief Set link inertia matrix
 *
 * @param[out] link modified rtss_link object
 * @param[in]  vect pointer of first element of new symmetric inertia matrix (square
 *                  matrix 3-by-3) or vector whose six elements are \f$I_{xx}\f$,
 *                  \f$I_{yy}\f$, \f$I_{zz}\f$, \f$I_{xy}\f$, \f$I_{yz}\f$ and
 *                  \f$I_{xz}\f$
 * @param[in]  bdar if TRUE_, it is assumed that @p vect is a bidimensional (3-by-3)
 *                  array in Column Major Order. If FALSE_, it is assumed that @p vect
 *                  is a 6-elements vector
 */
#define rtssLinkSetInertia(link, vect, bdar) \
( \
    (bdar) ? rtssMatrix33Set((link).I, vect) : rtssMatrix33SymSet((link).I, vect) \
)

/**
 * @brief Access to data of link inertia matrix
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of link inertia matrix
 */
#define rtssLinkInertia(link) rtssMatrix33Num((link).I)

/**
 * @brief Set the link rotation matrix defining link orientation with respect to that of the previous link
 *
 * @param[out] link modified rtss_link object
 * @param[in]  R11, R12, R13 first row's components of the rotational submatrix of the coordinate transform
 * @param[in]  R21, R22, R23 second row's components of the rotational submatrix of the coordinate transform
 * @param[in]  R31, R32, R33 third row's components of the rotational submatrix of the coordinate transform
 * @param[in]  Px, Py, Pz XYZ-axes components of the translational part of the coordinate transform
 */
#define rtssLinkSetCoordTransform(link, R11, R12, R13, Px, R21, R22, R23, Py, R31, R32, R33, Pz) \
                rtssHomogSetAll((link).T, R11, R12, R13, Px, R21, R22, R23, Py, R31, R32, R33, Pz)

/**
 * @brief Access to data of the rotation submatrix described by the coordinate transform between consecutive links
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of link rotation matrix
 */
#define rtssLinkRot(link) rtssHomogNum((link).T, RTSS_HOMOG_ROT)

/**
 * @brief Access to data of distance vector between the link origin, say \f$i\f$-th, and the \f$i-1\f$-th
 *        with respect to \f$i-1\f$-th
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of the translational part of \f$\mathbf{A}^{i-1}_{i}\f$
 */
#define rtssLinkTransl(link) rtssHomogNum((link).T, RTSS_HOMOG_TRANSL)

/**
 * @brief Set the distance of link origin, say \f$i\f$-th, from the \f$i-1\f$-th with respect to \f$i\f$-th
 *
 * @param[in] link modified rtss_link object
 * @param[in] pstar0 X-component of the distance vector
 * @param[in] pstar1 Y-component of the distance vector
 * @param[in] pstar2 Z-component of the distance vector
 */
#define rtssLinkSetPstar(link, pstar0, pstar1, pstar2) rtssVect3SetAll((link).pstar, pstar0, pstar1, pstar2)

/**
 * @brief Access to data of distance vector between the link origin, say \f$i\f$-th, and the \f$i-1\f$-th
 *        with respect to \f$i\f$-th
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of the negative translational part of \f$(\mathbf{A}^{i-1}_{i})^{-1}\f$
 */
#define rtssLinkPstar(link) rtssVect3Num((link).pstar)

/**
 * @brief Set link angular velocity
 *
 * @param[out] link modified rtss_link object
 * @param[in]  w0 X-component of angular velocity vector
 * @param[in]  w1 Y-component of angular velocity vector
 * @param[in]  w2 Z-component of angular velocity vector
 */
#define rtssLinkSetOmega(link, w0, w1, w2) rtssVect3SetAll((link).omega, w0, w1, w2)

/**
 * @brief Access to data of link angular velocity vector
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of link angular velocity vector
 */
#define rtssLinkOmega(link) rtssVect3Num((link).omega)

/**
 * @brief Set link angular acceleration
 *
 * @param[out] link modified rtss_link object
 * @param[in]  wd0 X-component of angular acceleration vector
 * @param[in]  wd1 Y-component of angular acceleration vector
 * @param[in]  wd2 Z-component of angular acceleration vector
 */
#define rtssLinkSetOmegaDot(link, wd0, wd1, wd2) rtssVect3SetAll((link).omega_d, wd0, wd1, wd2)

/**
 * @brief Access to data of link angular acceleration vector
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of link angular acceleration vector
 */
#define rtssLinkOmegaDot(link) rtssVect3Num((link).omega_d)

/**
 * @brief Set link linear acceleration
 *
 * @param[out] link modified rtss_link object
 * @param[in]  a0 X-component of linear acceleration vector
 * @param[in]  a1 Y-component of linear acceleration vector
 * @param[in]  a2 Z-component of linear acceleration vector
 */
#define rtssLinkSetAcc(link, a0, a1, a2) rtssVect3SetAll((link).acc, a0, a1, a2)

/**
 * @brief Access to data of link linear acceleration vector
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of link linear acceleration vector
 */
#define rtssLinkAcc(link) rtssVect3Num((link).acc)

/**
 * @brief Set linear acceleration of link COG
 *
 * @param[out] link modified rtss_link object
 * @param[in]  a0 X-component of linear acceleration of link COG vector
 * @param[in]  a1 Y-component of linear acceleration of link COG vector
 * @param[in]  a2 Z-component of linear acceleration of link COG vector
 */
#define rtssLinkSetAccCOG(link, a0, a1, a2) rtssVect3SetAll((link).abar, a0, a1, a2)

/**
 * @brief Access to data of linear acceleration vector of link COG
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of linear acceleration vector of link COG
 */
#define rtssLinkAccCOG(link) rtssVect3Num((link).abar)

/**
 * @brief Set inter-link force
 *
 * @param[out] link modified rtss_link object
 * @param[in]  f0 X-component of inter-link force vector
 * @param[in]  f1 Y-component of inter-link force vector
 * @param[in]  f2 Z-component of inter-link force vector
 */
#define rtssLinkSetForce(link, f0, f1, f2) rtssVect3SetAll((link).f, f0, f1, f2)

/**
 * @brief Access to data of inter-link force vector
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of inter-link force vector
 */
#define rtssLinkForce(link) rtssVect3Num((link).f)

/**
 * @brief Set inter-link moment
 *
 * @param[out] link modified rtss_link object
 * @param[in]  n0 X-component of inter-link moment vector
 * @param[in]  n1 Y-component of inter-link moment vector
 * @param[in]  n2 Z-component of inter-link moment vector
 */
#define rtssLinkSetMoment(link, n0, n1, n2) rtssVect3SetAll((link).n, n0, n1, n2)

/**
 * @brief Access to data of inter-link moment vector
 *
 * @param[in] link rtss_link object
 * @return pointer to the address of first data of inter-link moment vector
 */
#define rtssLinkMoment(link) rtssVect3Num((link).n)

/**
 * @brief Service routine for the default initialization of an rtss_link object
 */
int rtss_link_init(rtss_link *);

/**
 * @brief Service routine which initializes an rtss_link object from an mlist in the Scilab stack
 */
int rtss_link_init_from_stk(rtss_link * , int);

/**
 * @brief Service routine which prints the values of an initialized rtss_link object on the Scilab console
 */
int rtss_link_print(rtss_link *);
/** @} */
#endif /* RTSS_LINK_HDR */
