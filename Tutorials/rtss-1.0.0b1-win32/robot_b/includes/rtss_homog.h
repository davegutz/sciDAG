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
 * @file  rtss_homog.h
 *
 * @brief Interface to HOMOGENEOUS TRANSFORMS module
 *
 * A rigid motion is one that preserves the distance between points and the angle between vectors.
 * RTSS represents rigid motions by using the \e homogeneous \e representations of elements in SE(3)
 * (\e rigid \e transformations) to describe the istantaneous position and orientation of a
 * coordinate frame relative to an inertial frame.
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         July 2009
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-08-15 19:14:27 +0200(sab, 15 ago 2009) $
 */



#ifndef RTSS_HOMOGENEOUS_TRANSFORMS_HDR
#define RTSS_HOMOGENEOUS_TRANSFORMS_HDR
#include "rtss_math.h"  /* Interface to MATH module */
/**
 * @defgroup homog HOMOGENEOUS TRANSFORMS
 */
/** @{ */
/**
 * @brief Enumeration for homogeneous transforms attributes
 */
enum rtss_homog_enum_ {

    RTSS_HOMOG_ROT,       /**< rotational submatrix of an homogeneous transform */
    RTSS_HOMOG_TRANSL     /**< translational component of an homogeneous transform */

};

/**
 * @brief Homogeneous representation of rigid motions and configurations of rigid objects
 */
typedef struct rtss_homog_ {

    rtss_matrix33 R;    /**< rotational component of a homogeneous transform */
    rtss_vect3 p;       /**< translational component of a homogeneous transform */

} rtss_homog;

/**
 * @brief Define NULL pointer value
 */
#ifndef NULL
    #define NULL ((void *)0)
#endif

/**
 * @brief Fill an homogeneous transform matrix
 * @param[out] ht  modified rtss_homog object
 * @param[in]  tr  pointer of first element of new homogeneous transform (4-by-4 matrix)
 */
#define rtssHomogSet(ht, tr) \
( \
    rtssMatrix33SetAll((ht).R, tr[0], tr[4], tr[8], \
                               tr[1], tr[5], tr[9], \
                               tr[2], tr[6], tr[10]), \
    rtssVect3Set((ht).p, &(tr[12])) \
)

/**
 * @brief Fill an homogeneous transform matrix by explicitly providing rotational and translational components
 * @param[out] ht modified rtss_homog object
 * @param[in]  R11, R12, R13 first row's components of the rotational submatrix of the homogeneous transform
 * @param[in]  R21, R22, R23 second row's components of the rotational submatrix of the homogeneous transform
 * @param[in]  R31, R32, R33 third row's components of the rotational submatrix of the homogeneous transform
 * @param[in]  Px, Py, Pz XYZ-axes components of the translational part of the homogeneous transform
 */
#define rtssHomogSetAll(ht, R11, R12, R13, Px, R21, R22, R23, Py, R31, R32, R33, Pz) \
( \
    rtssMatrix33SetAll((ht).R, R11, R12, R13, \
                               R21, R22, R23, \
                               R31, R32, R33), \
    rtssVect3SetAll((ht).p, Px, \
                            Py, \
                            Pz) \
)

/**
 * @brief Access to the data of an homogeneous transform
 *
 * @param[in] ht rtss_homog object
 * @param[in] part enumerator indicating the part of the transform to be accessed (transl/rot)
 * @return pointer to the address of first data of rotational or translational part of the homogeneous transform
 */
#define rtssHomogNum(ht, part) \
( \
    (part == RTSS_HOMOG_ROT) ? (rtssMatrix33Num((ht).R)) : ((part == RTSS_HOMOG_TRANSL) ? (rtssVect3Num((ht).p)) : NULL) \
)

/**
 * @brief Explicit extraction of an element in the rotation submatrix of an homogeneous transform
 *
 * @param[in] ht rtss_homog object
 * @param[in] i index of i-th row (from 1 to 3) of the rotation submatrix
 * @param[in] j index of j-th column (from 1 to 3) of the rotation submatrix
 * @return the element (i,j) in the rotation submatrix
 */
#define rtssHomogNumRot(ht, i, j) rtssMatrix33NumElem((ht).R, i, j)

/**
 * @brief Explicit extraction of an element in the translational component of an homogeneous transform
 *
 * @param[in] ht rtss_homog object
 * @param[in] i index of i-th row (from 1 to 3) of the translational component
 * @return the element i-th in the translational component of the homogeneous transform
 */
#define rtssHomogNumTransl(ht, i) rtssVect3NumElem((ht).p, i)

/**
 * @brief Convert an homogeneous transform in a double array with 16 elements
 * @param[out] tr pointer to the first element of the 16-element array of double
 * @param[in]  ht rtss_homog object
 */
#define rtssHomog2ArrayOfDbl(tr, ht) \
( \
    rtssMatrix33NumAll(tr[0], tr[4], tr[8], \
                       tr[1], tr[5], tr[9], \
                       tr[2], tr[6], tr[10], (ht).R), rtssVect3NumAll(tr[12], \
                                                                      tr[13], \
                                                                      tr[14], (ht).p), \
                 tr[3] = 0, tr[7] = 0, tr[11] = 0,                    tr[15] = 1 \
)

/**
 * @brief Composition of a sequence of coordinate transformations
 */
int rtss_homog_compose_(rtss_homog * , rtss_homog * , rtss_homog *);

/**
 * @brief Error checking for function rtss_homog_compose_()
 */
#define rtss_homog_compose(Tc, Ta, Tb) if(rtss_homog_compose_(Tc, Ta, Tb) == RTSS_FAILURE) {rtss_err_call();}
/** @} */
#endif /* RTSS_HOMOGENEOUS_TRANSFORMS_HDR */
