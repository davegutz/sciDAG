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
 * @file  rtss_math.h
 *
 * @brief Interface to MATH module
 *
 * A more detailed description goes here (TODO).
 *
 * <br>@b Author(s):    Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
 * <br>@b Date:         August 2008
 *
 * <b>Software License:</b><br>
 * <code> http://rtss.sourceforge.net/license.html </code>
 *
 * Copyright &copy; 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa<br>
 *
 * $LastChangedDate: 2009-08-23 19:43:41 +0200(dom, 23 ago 2009) $
 */



#ifndef RTSS_MATH_HDR
#define RTSS_MATH_HDR
/**
 * @defgroup math MATH
 */
/** @{ */
/**
 * @brief Enumeration for matrices
 */
enum rtss_math_enum_ {

    RTSS_MATH_NOTRANS,  /**< no transpose */
    RTSS_MATH_TRANS     /**< transpose */    

};

/**
 * @brief Data structure describing a vector with 3 elements
 */
typedef struct rtss_math_vect3_ {

    double data[3];    /**< vector data */

} rtss_vect3;

/**
 * @brief Set the X-axis component of an rtss_vect3 object
 * @param[out] vect modified rtss_vect3 object
 * @param[in]  x value for the X-axis component of @p vect
 */
#define rtssVect3SetX(vect, x) ((vect).data[0] = (x))


/**
 * @brief Set the Y-axis component of an rtss_vect3 object
 * @param[out] vect modified rtss_vect3 object
 * @param[in]  y value for the Y-axis component of @p vect
 */
#define rtssVect3SetY(vect, y) ((vect).data[1] = (y))

/**
 * @brief Set the Z-axis component of an rtss_vect3 object
 * @param[out] vect modified rtss_vect3 object
 * @param[in]  z value for the Z-axis component of @p vect
 */
#define rtssVect3SetZ(vect, z) ((vect).data[2] = (z))

/**
 * @brief Set the data of an rtss_vect3 object by explicitly providing all the components
 * @param[out] vect modified rtss_vect3 object
 * @param[in]  x X-axis component
 * @param[in]  y Y-axis component
 * @param[in]  z Z-axis component
 */
#define rtssVect3SetAll(vect, x, y, z) ((vect).data[0] = (x), (vect).data[1] = (y), (vect).data[2] = (z))

/**
 * @brief Set all the components of an rtss_vect3 object using a 3-elements array of double
 * @param[out] vect modified rtss_vect3 object
 * @param[in]  ar 3-elements array of double
 */
#define rtssVect3Set(vect, ar) ((vect).data[0] = (ar)[0], (vect).data[1] = (ar)[1], (vect).data[2] = (ar)[2])

/**
 * @brief Get the address of first data of an rtss_vect3 object
 * @param[in] vect rtss_vect3 object
 * @return pointer to first element of the vector data
 */
#define rtssVect3Num(vect) ((vect).data)

/**
 * @brief Explicit extraction of a component of an rtss_vect3 object
 * @param[in] vect rtss_vect3 object
 * @param[in] i index of i-th row (from 1 to 3) of the translational component
 * @return the element i-th in the vector data
 */
#define rtssVect3NumElem(vect, i) ((vect).data[i-1])

/**
 * @brief Explicit extraction of data contained in an rtss_vect3 object
 * @param[out] x X-axis component of vector @p vect
 * @param[out] y Y-axis component of vector @p vect
 * @param[out] z Z-axis component of vector @p vect
 * @param[in]  vect rtss_vect3 object
 */
#define rtssVect3NumAll(x, y, z, vect) ((x) = (vect).data[0], (y) = (vect).data[1], (z) = (vect).data[2])


/**
 * @brief Data structure describing a square matrix with 3 rows (and columns)
 *
 * Data are stored in Column Major Order.
 */
typedef struct rtss_math_matrix33_ {

    double data[9]; /**< matrix data in Column Major Order */

} rtss_matrix33;

/**
 * @brief Set the data of an rtss_matrix33 object using a 9-elements array of double
 * @param[out] matrix modified rtss_matrix33 object
 * @param[in]  bdar 9-elements array of double
 */
#define rtssMatrix33Set(matrix, bdar) \
(\
    (matrix).data[0] = (bdar)[0], (matrix).data[3] = (bdar)[3], (matrix).data[6] = (bdar)[6], \
    (matrix).data[1] = (bdar)[1], (matrix).data[4] = (bdar)[4], (matrix).data[7] = (bdar)[7], \
    (matrix).data[2] = (bdar)[2], (matrix).data[5] = (bdar)[5], (matrix).data[8] = (bdar)[8] \
)

/**
 * @brief Set the data of a symmetric 3-rows square matrix using a 6-elements array of double
 * @param[out] M modified symmetric 3-rows square matrix
 * @param[in]  v array of double whose six elements are \f$M_{11}\f$,
 *              \f$M_{22}\f$, \f$M_{33}\f$, \f$M_{12}\f$, \f$M_{23}\f$ and
 *              \f$M_{13}\f$
 */
#define rtssMatrix33SymSet(M, v) \
( \
    (M).data[0] = (v)[0], (M).data[3] = (v)[3], (M).data[6] = (v)[5], \
    (M).data[1] = (v)[3], (M).data[4] = (v)[1], (M).data[7] = (v)[4], \
    (M).data[2] = (v)[5], (M).data[5] = (v)[4], (M).data[8] = (v)[2] \
)

/**
 * @brief Set the data of an rtss_matrix33 object by explicitly providing all the components
 * @param[out] M rtss_matrix33 object
 * @param[in]  M11, M12, M13 first row's components of the matrix @p M
 * @param[in]  M21, M22, M23 second row's components of the matrix @p M
 * @param[in]  M31, M32, M33 third row's components of the matrix @p M
 */
#define rtssMatrix33SetAll(M, M11, M12, M13, M21, M22, M23, M31, M32, M33) \
( \
    (M).data[0] = (M11), (M).data[3] = (M12), (M).data[6] = (M13), \
    (M).data[1] = (M21), (M).data[4] = (M22), (M).data[7] = (M23), \
    (M).data[2] = (M31), (M).data[5] = (M32), (M).data[8] = (M33) \
)

/**
 * @brief Get the address of first data codified in an rtss_matrix33 object
 * @param[in] matrix rtss_matrix33 object
 * @return pointer to first element of the matrix data
 */
#define rtssMatrix33Num(matrix) ((matrix).data)

/**
 * @brief Explicit extraction of an element in an rtss_matrix33 object
 * @param[in] matrix rtss_matrix33 object
 * @param[in]  i index of i-th row (from 1 to 3)
 * @param[in]  j index of j-th column (from 1 to 3)
 * @return the element (i,j) in the matrix
 */
#define rtssMatrix33NumElem(matrix, i, j) ((matrix).data[(i-1)+(j-1)*3])

/**
 * @brief Explicit extraction of data contained in an rtss_matrix33 object
 * @param[out] M11, M12, M13 first row's components of the matrix @p M
 * @param[out] M21, M22, M23 second row's components of the matrix @p M
 * @param[out] M31, M32, M33 third row's components of the matrix @p M
 * @param[in]  M rtss_matrix33 object
 */
#define rtssMatrix33NumAll(M11, M12, M13, M21, M22, M23, M31, M32, M33, M) \
( \
    (M11) = (M).data[0], (M12) = (M).data[3], (M13) = (M).data[6], \
    (M21) = (M).data[1], (M22) = (M).data[4], (M23) = (M).data[7], \
    (M31) = (M).data[2], (M32) = (M).data[5], (M33) = (M).data[8] \
)

/**
 * @brief Data structure to be used for inverting a square matrix of order <code>n</code>
 */
typedef struct rtss_math_imatrix_ {

    int * ipiv;     /**< integer array of pivot indices */
    double * dwork; /**< double precision (workspace) array */

} rtss_imatrix;

/**
 * @brief Allocate a workspace in a Scicos block, for inverse matrix computation
 */
#define rtssWSpaceIMatrixInit(wimptr,dof) if(rtss_imatrix_init(wimptr,dof) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief De-allocate a workspace, used for inverse matrix computation
 *
 * @param[out] wimptr freed pointer to rtss_imatrix objects
 */
#define rtssWSpaceIMatrixDestroy(wimptr) if(rtss_imatrix_destroy(wimptr) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Service routine for the allocation of a workspace, for inverse matrix computation
 */
int rtss_imatrix_init(rtss_imatrix * , int);

/**
 * @brief Service routine for destructing a workspace used for inverse matrix computation
 */
int rtss_imatrix_destroy(rtss_imatrix *);

/**
 * @brief Data structure to be used for performing an n-dimensional linear interpolation
 *        between real vectors
 *
 * @note  Inspired to the routine for n-dimensional linear interpolation
 * written by Bruno Pincon (Bruno.Pincon@iecn.u-nancy.fr) for Scilab-4.x
 *
 * @note References: SCI/routines/calelm/someinterp.c
 */
typedef struct rtss_math_linterpn_ {

    int * dimt;     /**< number of points in the generic dimension */
    int n;          /**< number of dimensions */
    double * u;     /**< workspace array */
    double * v;     /**< workspace array */
    int * k;        /**< workspace array */
    int * ad;       /**< workspace array */

} rtss_linterpn;

/**
 * @brief Allocate a workspace in a Scicos block, for n-dimensional linear interpolation
 *
 * @param[in]  dimt  number of points in the generic dimension
 * @param[in]  n     number of dimensions
 * @param[out] wlint pointer to the workspace for n-dimensional linear interpolation
 */
#define rtssWSpaceLInterpNInit(wlint,dimt,n) if(rtss_linterpn_init(wlint,dimt,n) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief De-allocate a workspace, used for n-dimensional linear interpolation
 *
 * @param[out] wlint freed pointer to rtss_linterpn objects
 */
#define rtssWSpaceLInterpNDestroy(wlint) if(rtss_linterpn_destroy(wlint) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Service routine for the allocation of a workspace, for n-dimensional linear interpolation
 */
int rtss_linterpn_init(rtss_linterpn * , int , int);

/**
 * @brief Service routine for destructing a workspace used for n-dimensional linear interpolation
 */
int rtss_linterpn_destroy(rtss_linterpn *);

/**
 * @brief Constant times a vector plus a vector
 */
int rtss_math_daxpy_(int , double , double * , double *);

/**
 * @brief Forms the dot product of two vectors
 */
double rtss_math_ddot(int , double * , double *);

/**
 * @brief 3D vector cross product
 */
int rtss_math_cross_(double * , double , double * , double , double *);

/**
 * @brief Generic Matrix vector multiply
 */
int rtss_math_dgemv_(double , enum rtss_math_enum_ , int , int , double * , double * , double , double *);

/**
 * @brief Symmetric Matrix vector multiply
 */
int rtss_math_dsymv_(double , int , double * , double * , double , double *);

/**
 * @brief Generic Matrix matrix multiply
 */
int rtss_math_dgemm_(double , enum rtss_math_enum_ , int , int , double * , enum rtss_math_enum_ , int , double * , double , double *);

/**
 * @brief Generic matrix inversion
 */
int rtss_math_imat_(int , double * , int * , double *);

/**
 * @brief one-dimensional linear interpolation of real vectors
 */
int rtss_math_linterp1_(double * , double * , int , double * , double * , rtss_linterpn *);

/**
 * @brief Error checking for function rtss_math_daxpy_()
 */
#define rtss_math_daxpy(N, alpha, x, y) if(rtss_math_daxpy_(N, alpha, x, y) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_math_cross_()
 */
#define rtss_math_cross(c, alpha, a, beta, b) if(rtss_math_cross_(c, alpha, a, beta, b) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_math_dgemv_()
 */
#define rtss_math_dgemv(alpha, trans, mA, nA, A, x, beta, y) if(rtss_math_dgemv_(alpha, trans, mA, nA, A, x, beta, y) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_math_dsymv_()
 */
#define rtss_math_dsymv(alpha, nA, A, x, beta, y) if(rtss_math_dsymv_(alpha, nA, A, x, beta, y) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_math_dgemm_()
 */
#define rtss_math_dgemm(alpha, transA, m, k, A, transB, n, B, beta, C) if(rtss_math_dgemm_(alpha, transA, m, k, A, transB, n, B, beta, C) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_math_imat_()
 */
#define rtss_math_imat(mA, A, ipiv, dwork) if(rtss_math_imat_(mA, A, ipiv, dwork) == RTSS_FAILURE) {rtss_err_call();}

/**
 * @brief Error checking for function rtss_math_linterp1_()
 */
#define rtss_math_linterp1(yp, t, my, y, t_star, wlint) if(rtss_math_linterp1_(yp, t, my, y, t_star, wlint) == RTSS_FAILURE) {rtss_err_call();}

/** @} */
#endif /* RTSS_MATH_HDR */
