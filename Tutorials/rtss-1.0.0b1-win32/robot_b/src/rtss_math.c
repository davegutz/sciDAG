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
 * @file  rtss_math.c
 *
 * @brief Implementation of MATH module
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
 * $LastChangedDate: 2009-08-23 20:16:31 +0200(dom, 23 ago 2009) $
 */



#include <machine.h>                    /* C2F(), integer */
#include "../includes/rtss_mem_alloc.h" /* rtss_malloc, rtss_free */
#include "../includes/rtss_error.h"     /* Interface to ERROR module */
#include "../includes/rtss_math.h"      /* Interface to MATH module */

/*-------------------------------------
 * Bunch of external declarations.
 *
 * Functions from Netlib's BLAS/LAPACK.
 *
 *---------------------------------- */
extern int C2F(daxpy) (integer * , double * , double * , integer * , double * , integer *);
extern double C2F(ddot) (integer * , double * , integer * , double * , integer *);
extern int C2F(dgemv) (char * , integer * , integer * , double * , double * , integer * , double * , integer * , double * , double * , integer *);
extern int C2F(dsymv) (char * , integer * , double * , double * , integer * , double * , integer * , double * , double * , integer *);
extern int C2F(dgemm) (char * , char * , integer * , integer * , integer * , double * , double * , integer * , double * , integer * , double * , double * , integer *);
extern int C2F(dgetrf) (integer * , integer * , double * , integer * , integer * , integer *);
extern int C2F(dgetri) (integer * , double * , integer * , integer * , double * , integer * , integer *);

/*-----------------------------------------------
 *
 * Routine for n-dimensional linear interpolation
 * by Bruno Pincon (Bruno.Pincon@iecn.u-nancy.fr)
 *
 *-------------------------------------------- */
extern void nlinear_interp(double ** , double [] , int [] , int , double ** , double [] , int , int , double [] , double [] , int [] , int []);

/**
 * @brief Service routine for the allocation of a workspace, for inverse matrix computation
 *
 * @param[in]  dof   number of degrees of freedom of the manipulator
 * @param[out] wimptr pointer to the workspace for inverse matrix computation
 */
int
rtss_imatrix_init(rtss_imatrix * wimptr, int dof)
{
    if (!wimptr)
        rtss_err_null_ptr();
    if ((wimptr->ipiv = rtss_malloc(dof*sizeof(int))) == NULL)
        rtss_err_fail(999, "Cannot allocate the workspace for inverse matrix computation");
    if ((wimptr->dwork = rtss_malloc(dof*sizeof(double))) == NULL) {
        rtss_free(wimptr->ipiv);
        rtss_err_fail(999, "Cannot allocate the workspace for inverse matrix computation");
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for destructing a workspace used for inverse matrix computation
 *
 * @param[out] wimptr freed pointer to rtss_imatrix objects
 */
int
rtss_imatrix_destroy(rtss_imatrix * wimptr)
{
    if (!wimptr)
        rtss_err_null_ptr();
    rtss_free(wimptr->ipiv);
    rtss_free(wimptr->dwork);
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for the allocation of a workspace, for n-dimensional linear interpolation
 *
 * @param[in]  dimt  number of points in the generic dimension
 * @param[in]  n     number of dimensions
 * @param[out] wlint pointer to the workspace for n-dimensional linear interpolation
 */
int
rtss_linterpn_init(rtss_linterpn * wlint, int dimt, int n)
{
    if (!wlint)
        rtss_err_null_ptr();
    if ((wlint->dimt = rtss_malloc(sizeof(int))) == NULL)
        rtss_err_fail(999, "Cannot allocate the workspace for n-dimensional linear interpolation");
    if ((wlint->u = rtss_malloc(sizeof(double))) == NULL) {
        rtss_free(wlint->dimt);
        rtss_err_fail(999, "Cannot allocate the workspace for n-dimensional linear interpolation");
    }
    if ((wlint->v = rtss_malloc((1 << n)*sizeof(double))) == NULL) {
        rtss_free(wlint->dimt);
        rtss_free(wlint->u);
        rtss_err_fail(999, "Cannot allocate the workspace for n-dimensional linear interpolation");
    }
    if ((wlint->k = rtss_malloc(sizeof(int))) == NULL) {
        rtss_free(wlint->dimt);
        rtss_free(wlint->u);
        rtss_free(wlint->v);
        rtss_err_fail(999, "Cannot allocate the workspace for n-dimensional linear interpolation");
    }
    if ((wlint->ad = rtss_malloc((1 << n)*sizeof(int))) == NULL) {
        rtss_free(wlint->dimt);
        rtss_free(wlint->u);
        rtss_free(wlint->v);
        rtss_free(wlint->k);
        rtss_err_fail(999, "Cannot allocate the workspace for n-dimensional linear interpolation");
    }
    *(wlint->dimt) = dimt;
    wlint->n = n;    
    return(RTSS_SUCCESS);
}

/**
 * @brief Service routine for destructing a workspace used for n-dimensional linear interpolation
 *
 * @param[out] wlint freed pointer to rtss_linterpn objects
 */
int
rtss_linterpn_destroy(rtss_linterpn * wlint)
{
    if (!wlint)
        rtss_err_null_ptr();
    rtss_free(wlint->dimt);
    rtss_free(wlint->u);
    rtss_free(wlint->v);
    rtss_free(wlint->k);
    rtss_free(wlint->ad);
    return(RTSS_SUCCESS);
}

/**
 * @brief      Constant times a vector plus a vector
 *
 * This function is an interface to Netlib's level 1 BLAS DAXPY, which performs the
 * vector-vector operation:\n
 * <code> y := alpha*x + y </code>
 * where <code>alpha</code> is scalar, <code>x</code> and
 * <code>y</code> are <code>N</code>-element vectors.
 *
 * This function imposes a restriction with respect to Netlib's DAXPY. Specifically,
 * INCX and INCY are always assumed equal to 1 and there's no chance to set them on-the-fly.
 *
 * @param[in]  N length of vectors @p x and @p y
 * @param[in]  alpha the scalar <code>alpha</code> in the vector-vector operation described
 *                   above
 * @param[in]  x pointer to the vector @p x
 * @param[in]  y pointer to the vector @p y
 * @param[out] y pointer to the result vector
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 *
 * @note    The level 1 BLAS perform no error checking but this function does.
 *
 * @note    It is worth pointing out that @p x and @p y must be different vectors or the
 *          function will fail. In other words, this function can \b not be used to compute\n
 *          <code> x := alpha*x + x </code>
 */
int
rtss_math_daxpy_(int N, double alpha, double * x, double * y)
{
    int inc = 1;

    if (!x || !y)
        rtss_err_null_ptr();
    C2F(daxpy)(&N, &alpha, x, &inc, y, &inc);
    return(RTSS_SUCCESS);
}

/**
 * @brief      Forms the dot product of two vectors
 *
 * This function is an interface to Netlib's level 1 BLAS DDOT, which performs the
 * vector-vector operation:\n
 * <code> dot <- x'y </code>
 * where <code>x</code> and <code>y</code> are <code>N</code>-element vectors.
 *
 * This function imposes a restriction with respect to Netlib's DDOT. Specifically,
 * INCX and INCY are always assumed equal to 1 and there's no chance to set them on-the-fly.
 *
 * @param[in]  N length of vectors @p x and @p y
 * @param[in]  x pointer to the vector @p x
 * @param[in]  y pointer to the vector @p y
 * @return     dot the dot product of @p x and @p y
 */
double
rtss_math_ddot(int N, double * x, double * y)
{
    int inc = 1;

    return C2F(ddot)(&N, x, &inc, y, &inc);
}

/**
 * @brief      Vector cross product
 *
 * This function performs the vector-vector operation:\n
 * <code> c := alpha*a </code> \f$ \times \f$ <code> beta*b </code>
 * where <code>alpha</code> and <code>beta</code> are scalar, whereas <code>a</code> and
 * <code>b</code> are <code>N</code>-element vectors.
 *
 * @param[in]  alpha the scalar <code>alpha</code> in the vector-vector operation described
 *                   above
 * @param[in]  a the first input vector
 * @param[in]  beta the scalar <code>beta</code> in the vector-vector operation described
 *                   above
 * @param[in]  b the second input vector
 * @param[out] c the cross product between <code> alpha*a </code> and <code> beta*b </code>
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_math_cross_(double * c, double alpha, double * a, double beta, double * b)
{
    if (!c || !a || !b)
        rtss_err_null_ptr();

    c[0] = a[1]*b[2] - a[2]*b[1];
    c[1] = a[2]*b[0] - a[0]*b[2];
    c[2] = a[0]*b[1] - a[1]*b[0];
    if (alpha*beta == 1.0)
        return(RTSS_SUCCESS);
    else if ((alpha == 1.0) && (beta != 1.0)) {
        c[0] = beta*c[0];
        c[1] = beta*c[1];
        c[2] = beta*c[2];
        return(RTSS_SUCCESS);
    }
    else if ((alpha != 1.0) && (beta == 1.0)) {
        c[0] = alpha*c[0];
        c[1] = alpha*c[1];
        c[2] = alpha*c[2];
        return(RTSS_SUCCESS);
    }
    else {
        c[0] = alpha*beta*c[0];
        c[1] = alpha*beta*c[1];
        c[2] = alpha*beta*c[2];
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief      Generic Matrix vector multiply
 *
 * This function is an interface to Netlib's level 2 BLAS DGEMV, which performs one
 * of the matrix-vector operations:\n
 * <code> y := alpha*A*x + beta*y </code>, or <code> y := alpha*A'*x + beta*y </code>,
 * where <code>alpha</code> and <code>beta</code> are scalars, <code>x</code> and
 * <code>y</code> are vectors and <code>A</code> is an <code>m</code> by <code>n</code>
 * matrix.
 *
 * This function imposes some restrictions with respect to Netlib's DGEMV. Specifically,
 *  - LDA is always assumed equal to <code>nA<code>;
 *  - both INCX and INCY are always assumed equal to 1.
 * There's no chance to set these parameters on-the-fly.
 *
 * @param[in]  alpha the scalar <code>alpha</code> in the matrix-vector operations described
 *                   above
 * @param[in]  trans whether or not the @p A matrix should be transposed before multiplication
 * @param[in]  mA number of rows of the matrix @p A
 * @param[in]  nA number of columns of the matrix @p A
 * @param[in]  A pointer to the matrix @p A, in Column Major Order
 * @param[in]  x pointer to the vector @p x, whose number of rows must be equal to @p nA
 * @param[in]  beta the scalar <code>beta</code> in the matrix-vector operations described
 *                  above
 * @param[in]  y pointer to the vector @p y, whose number of rows must be equal to @p mA
 * @param[out] y pointer to the result vector
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 *
 * @note    It is worth pointing out that @p x and @p y must be different vectors or the
 *          function will fail. In other words, this function can \b not be used to compute\n
 *          <code> x := alpha*A*x + beta*x </code>
 */
int
rtss_math_dgemv_(double alpha, enum rtss_math_enum_ trans, int mA, int nA, double * A, double * x, double beta, double * y)
{
    int inc = 1;

    if (!A || !x || !y)
        rtss_err_null_ptr();

    switch (trans) {
        case RTSS_MATH_TRANS:
            C2F(dgemv)("T", &mA, &nA, &alpha, A, &mA, x, &inc, &beta, y, &inc);
            break;
        case RTSS_MATH_NOTRANS:
            C2F(dgemv)("N", &mA, &nA, &alpha, A, &mA, x, &inc, &beta, y, &inc);
            break;
        default:
            rtss_err_fail(999, "trans must be %d or %d, but is set to %d", RTSS_MATH_TRANS, RTSS_MATH_NOTRANS, trans);
    }
    return(RTSS_SUCCESS);
}

/**
 * @brief      Symmetric Matrix vector multiply
 *
 * This function is an interface to Netlib's level 2 BLAS DSYMV, which performs the
 * following matrix-vector operation:\n
 * <code> y := alpha*A*x + beta*y </code>
 * where <code>alpha</code> and <code>beta</code> are scalars, <code>x</code> and
 * <code>y</code> are vectors and <code>A</code> is an <code>n</code> by <code>n</code>
 * symmetric matrix.
 *
 * This function imposes some restrictions with respect to Netlib's DSYMV. Specifically,
 *  - UPLO is always assumed to equal 'U', so that only the upper triangular part of <code>A<code>
 * is referenced;
 *  - LDA is always assumed equal to <code>nA<code>;
 *  - both INCX and INCY are always assumed equal to 1.
 * There's no chance to set these parameters on-the-fly.
 *
 * @param[in]  alpha the scalar <code>alpha</code> in the matrix-vector operations described
 *                   above
 * @param[in]  nA the order of the matrix @p A
 * @param[in]  A pointer to the matrix @p A
 * @param[in]  x pointer to the vector @p x, whose number of rows must be equal to @p nA
 * @param[in]  beta the scalar <code>beta</code> in the matrix-vector operations described
 *                  above
 * @param[in]  y pointer to the vector @p y, whose number of rows must be equal to @p mA
 * @param[out] y pointer to the result vector
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 *
 * @note    It is worth pointing out that @p x and @p y must be different vectors or the
 *          function will fail. In other words, this function can \b not be used to compute\n
 *          <code> x := alpha*A*x + beta*x </code>
 */
int
rtss_math_dsymv_(double alpha, int nA, double * A, double * x, double beta, double * y)
{
    int inc = 1;

    if (!A || !x || !y)
        rtss_err_null_ptr();

    C2F(dsymv)("U", &nA, &alpha, A, &nA, x, &inc, &beta, y, &inc);
    return(RTSS_SUCCESS);
}

/**
 * @brief Generic Matrix matrix multiply
 *
 * This function is an interface to Netlib's level 3 BLAS DGEMM, which performs one
 * of the matrix-matrix operations:\n
 * <code> C := alpha*op( A )*op( B ) + beta*C </code>
 * where <code>op( X )</code> is one of\n
 *
 *     <code>op( X ) = X</code> or <code>op( X ) = X'</code>,\n
 *
 * <code>alpha</code> and <code>beta</code> are scalars, and <code>A</code>, <code>B</code>
 * and <code>C</code> are matrices, with <code>op( A )</code> an @p m by @p k matrix,
 * <code>op( B )</code> a @p k by @p n matrix and <code>C</code> an @p m by @p n matrix.
 *
 * This function imposes some restrictions with respect to Netlib's DGEMM. Specifically,
 *  - LDA is always assumed equal to @p m when <code>transA = "N"</code>, otherwise is @p k;
 *  - LDB is always assumed equal to @p k when <code>transB = "N"</code>, otherwise is @p n;
 *  - LDC is always assumed equal to @p m;
 * There's no chance to set these parameters on-the-fly.
 *
 * @param[in]  alpha the scalar @p alpha in the matrix-matrix operations described above
 * @param[in]  transA whether or not the @p A matrix should be transposed before multiplication
 * @param[in]  m specifies the number of rows of the matrix <code>op( A )</code> and of the matrix @p C
 * @param[in]  k number of columns of the matrix <code>op( A )</code> (and of number of rows of
 *               <code>op( B )</code>)
 * @param[in]  A pointer to the matrix @p A, in Column Major Order
 * @param[in]  transB whether or not the @p B matrix should be transposed before multiplication
 * @param[in]  n specifies the number of columns of the matrix <code>op( B )</code> and of the matrix @p C
 * @param[in]  B pointer to the matrix @p B, in Column Major Order
 * @param[in]  beta the scalar @p beta in the matrix-matrix operations described above
 * @param[in]  C pointer to the result matrix @p C
 * @param[out] C pointer to the result matrix @p C
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 *
 * @note    It is worth pointing out that @p B and @p C must be different matrices or the
 *          function will fail. In other words, this function can \b not be used to compute\n
 *          <code> B := alpha*op( A )*op( B ) + beta*B </code>
 */
int
rtss_math_dgemm_(double alpha, enum rtss_math_enum_ transA, int m, int k, double * A, enum rtss_math_enum_ transB, int n, double * B, double beta, double * C)
{
    if (!A || !B || !C)
        rtss_err_null_ptr();

    switch (transA) {

        case RTSS_MATH_NOTRANS:
            switch (transB) {
                case RTSS_MATH_NOTRANS:
                    C2F(dgemm)("N", "N", &m, &n, &k, &alpha, A, &m, B, &k, &beta, C, &m);
                    break;
                case RTSS_MATH_TRANS:
                    C2F(dgemm)("N", "T", &m, &n, &k, &alpha, A, &m, B, &n, &beta, C, &m);
                    break;
                default:
                    rtss_err_fail(999, "transB must be %d or %d, but is set to %d", RTSS_MATH_TRANS, RTSS_MATH_NOTRANS, transB);
            }
            break;

        case RTSS_MATH_TRANS:
            switch (transB) {
                case RTSS_MATH_NOTRANS:
                    C2F(dgemm)("T", "N", &m, &n, &k, &alpha, A, &k, B, &k, &beta, C, &m);
                    break;
                case RTSS_MATH_TRANS:
                    C2F(dgemm)("T", "T", &m, &n, &k, &alpha, A, &k, B, &n, &beta, C, &m);
                    break;
                default:
                    rtss_err_fail(999, "transB must be %d or %d, but is set to %d", RTSS_MATH_TRANS, RTSS_MATH_NOTRANS, transB);
            }
            break;
            
        default:
            rtss_err_fail(999, "transA must be %d or %d, but is set to %d", RTSS_MATH_TRANS, RTSS_MATH_NOTRANS, transA);

    }
    return(RTSS_SUCCESS);
}

/**
 * @brief      Generic matrix inversion
 *
 * This function is an interface to Netlib's LAPACK routine DGETRI, which computes the
 * inverse of a matrix using the LU factorization computed by DGETRF.
 *
 * LAPACK routine DGETRF computes an LU factorization of a general <code>m</code> by <code>n</code>
 * matrix <code>A</code> using partial pivoting with row interchanges. The factorization has the form\n
 * <code> A = P * L * U</code>\n
 * where <code>P</code> is a permutation matrix, <code>L</code> is lower triangular with unit
 * diagonal elements (lower trapezoidal if <code>m > n</code>), and <code>U</code> is upper
 * triangular (upper trapezoidal if <code>m < n</code>).
 *
 * LAPACK routine DGETRI inverts <code>U</code> and then computes <code>inv(A)</code> by solving the
 * system\n
 * <code>inv(A)*L = inv(U) for inv(A)</code>.
 *
 * This function always calls DGETRF with a square (<code>n</code> by <code>n</code>) matrix
 * as input argument, and also imposes some restrictions with respect to Netlib's DGETRI.
 * Specifically,
 *  - LDA and LWORK are always assumed equal to <code>n<code>.
 * There's no chance to set these parameters on-the-fly.
 *
 * @param[in]  mA number of rows of the (square) matrix @p A
 * @param[in]  A pointer to the matrix @p A
 * @param[in]  ipiv pointer to the integer array of pivot indices
 * @param[in]  dwork pointer to the double precision (workspace) array
 * @param[out] A the inverse of the original matrix @p A
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_math_imat_(int mA, double * A, int * ipiv, double * dwork)
{
    int info;

    if (!A || !ipiv || !dwork)
        rtss_err_null_ptr();

    C2F(dgetrf)(&mA, &mA, A, &mA, ipiv, &info);
    if (info)
        return(RTSS_FAILURE);
    C2F(dgetri)(&mA, A, &mA, ipiv, dwork, &mA, &info);
    return(RTSS_SUCCESS);
}

/**
 * @brief one-dimensional linear interpolation of real vectors
 *
 * Interpolate each <em>column</em> vector in the matrix <code>y = [y1,...,yi,...,ym]</code>,
 * defined at the points <code>t</code>, at the point <code>t_star</code>. The sample points <code>t</code>
 * must be strictly monotonic (e.g. a time vector).
 *
 * This function is an interface to to the routine for linear interpolation written by
 * Bruno Pincon (Bruno.Pincon@iecn.u-nancy.fr) for Scilab-4.x.
 *
 * @note Remark: If <code>y</code> is an array, treat the columns of <code>y</code> seperately.
 *
 * @param[in]  t pointer to a strictly monotonic vector of sample points at which @p y is defined
 * @param[in]  my number of functions to be interpolated (columns of the matrix @p y)
 * @param[in]  y a pointer to a matrix whose columns are functions to be interpolated
 * @param[in]  t_star pointer to the point at which the interpolation of @p y has to be performed
 * @param[in]  wlint workspace arrays
 * @param[out] yp pointer to the vector containing the interpolated values of each column of @p y
 * @return     RTSS_SUCCESS if all has gone well, RTSS_FAILURE otherwise
 */
int
rtss_math_linterp1_(double * yp, double * t, int my, double * y, double * t_star, rtss_linterpn * wlint)
{
    int i, NATURAL=1;

    if (!yp || !t_star || !t || !y || !wlint)
        rtss_err_null_ptr();

    for (i = 0; i < my; i++)
        nlinear_interp(&t, &(y[i*wlint->dimt[0]]), wlint->dimt, 1, &t_star, &(yp[i]), 1, NATURAL, wlint->u, wlint->v, wlint->ad, wlint->k);
    return(RTSS_SUCCESS);
}
