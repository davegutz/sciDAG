// Copyright (SZ) 2019 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// Jan 7, 2019     DA Gutz     Created 
#include <scicos_block4.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "table.h"

// parameters
/* B I N S E A R C H
*
*   Purpose:    Find x in { v[0] <= v[1] <= ... ,= v[n-1] } and calculate
*               the fraction of range that x is positioned.  No extrapolation.
*
*   Author:     Dave Gutz 09-Jun-90.
*   Revisions:  Dave Gutz 20-Aug-90 Input x instead of *x to protect
*                   integrity of calling function.
*                      16-Aug-93   Pointers.
*   Inputs:
*       Name        Type        Length      Definition
*       x           double      1           Input to vector.
*       n           int         1           Size of vector.
*       v           double      n           Vector.
*   Outputs:
*       Name        Type        Length      Definition
*       *dx         double      1           Fraction of range for x.
*       *low        int         1           Current low end of range.
*       *high       int         1           Current high end of range.
*   Hardware dependencies:  ANSI C.
*   Header needed in scope of caller:   None.
*   Global variables used:  None.
*   Functions called:   None.
*/
void binsearch(double x, double *v, int n, int *high, int *low, 
                double *dx){
    int mid;
    
    /* Initialize high and low  */
    *low    = 0;
    *high   = n-1;

    /* Check endpoints  */
    if(x >= *(v+*high)){
        *low    = *high;
        *dx     = 0.;
    }
    else if(x <= *(v+*low)){
        *high   = *low;
        *dx     = 0.;
    }

    /* Search if necessary  */
    else{
        while( (*high -  *low) > 1){
            mid = (*low + *high) / 2;
            if(*(v+mid) > x)
                *high   = mid;
            else
                *low    = mid;
        }
        *dx = (x - *(v+*low)) / (*(v+*high) - *(v+*low));
    }
}   /* End binsearch    */

/* T A B 1
*
*   Purpose:    Univariant arbitrarily spaced table look-up.
*
*   Author:     Dave Gutz 09-Jun-90.
*   Revisions:  Dave Gutz 20-Aug-90 Input x instead of *x to protect
*                   integrity of calling function.
*                         16-Aug-93   Pointers.
*   Inputs:
*       Name        Type        Length      Definition
*       n           int         1           Number of points.
*       x           double      1           Independent variable.
*       v           double      1           Breakpoint table.
*       y           double      n           Table data.
*   Outputs:
*       Name        Type        Length      Definition
*       tab1        double       1           Result of table lookup.
*   Hardware dependencies:  ANSI C.
*   Header needed in scope of caller:   tables.h
*   Global variables used:  None.
*   Functions called:   binsearch.
*/
double tab1(double x, double *v, double *y, int n){
    double dx;
    int high, low;
    void binsearch(double x, double *v, int n, int *high, 
                    int *low, double *dx);
    if(n<1) return y[0];
    binsearch(x, v, n, &high, &low, &dx);
    return *(y+low) + dx * (*(y+high) - *(y+low));
}   /* End tab1 */


/* T A B 2
*
*   Purpose:    Bivariant arbitrarily spaced table look-up.
*
*   Author:     Dave Gutz 20-Aug-90.
*   Revisions:            16-Aug-93   Pointers.
*   Inputs:
*       Name        Type        Length      Definition
*       n1          int         1           Number of ind var #1 brkpts.
*       n2          int         1           Number of ind var #2 brkpts.
*       x1          double      1           Independent variable #1.
*       x2          double      1           Independent variable #2.
*       v1          double      n1          Breakpoints for var #1.
*       v2          double      n2          Breakpoints for var #2.
*       y           double      n1*n2       Table data.
*   Outputs:
*       Name        Type        Length      Definition
*       tab2        double      1           Result of table lookup.
*   Hardware dependencies:  ANSI C.
*   Header needed in scope of caller:   tables.h
*   Global variables used:  None.
*   Functions called:   binsearch.
*/
double tab2(double x1, double x2, double *v1, double *v2, double *y, int n1,
                int n2){
    double dx1, dx2, r0, r1;
    int high1, high2, low1, low2, temp1, temp2;
    void binsearch(double x, double *v, int n, int *high, 
                    int *low, double *dx);
    if(n1<1 || n2<1) return y[0];
    binsearch(x1, v1, n1, &high1, &low1, &dx1);
    binsearch(x2, v2, n2, &high2, &low2, &dx2);
    temp1   = low1 * n2 + low2;
    temp2   = low1 * n2 + high2;
    r0      = *(y+temp1) + dx1 * (*(y+high1*n2+low2)  - *(y+temp1));
    r1      = *(y+temp2) + dx1 * (*(y+high1*n2+high2) - *(y+temp2));
    return  r0 + dx2 * (r1 - r0);
}   /* End tab2 */


// Object parameters.  1st index is 1-based, 2nd index is 0-based
#define r_IN(n, i)  ((GetRealInPortPtrs(blk, n+1))[(i)])
#define r_OUT(n, i) ((GetRealOutPortPtrs(blk, n+1))[(i)])
#define TB      (GetRealOparPtrs(blk,1))  // Table
#define N_TB    (blk->oparsz[0])
#define NOPAR   (blk->nopar)
#define SX      ((GetRealOparPtrs(blk,2))[0])  // Scalar input
#define DX      ((GetRealOparPtrs(blk,3))[0])  // Scalar input
#define SZ      ((GetRealOparPtrs(blk,4))[0])  // Scalar input
#define DZ      ((GetRealOparPtrs(blk,5))[0])  // Scalar input
// inputs
#define X   (r_IN(0,0))     // Input
// states - none
// outputs
#define Z   (r_OUT(0, 0))  // Output
// other constants - none

//********table1_a
void table1_a(scicos_block *blk, int flag)
{   
    double *tb = TB; 
    double z;
    // compute info needed for all passes
    z = tab1(X, tb, tb+N_TB, N_TB);
    Z = (z*SX + DX)*SZ + DZ;
}

//********tabl
void ctab1(scicos_block *blk, int flag)
{   
    double *tb = TB; 
    double z;
    // compute info needed for all passes
    z = tab1(X, tb, tb+N_TB, N_TB);
    Z = (z*SX + DX)*SZ + DZ;
}
