// Copyright (C) 2019 - Dave Gutz
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
// Jan 14, 2019     DA Gutz         Created
// Jun 06, 2019     DA Gutz         Add friction functions
// 
#ifndef hyd_mod_h
#define hyd_mod_h

#define SQR(A)      ((A)*(A))
#define SGN(A)      ((A) < 0. ? -1 : 1)
#define SSQRT(A)    (SGN(A)*sqrt(fabs(A)))
#define SSQR(A)     (SGN(A)*SQR(A))

#define LA_KPTOW(K, PS, PD, KVIS)\
                 (K) / (KVIS) * ((PS) - (PD))
#define LA_WPTOK(WF, PS, PD, KVIS)\
                 (KVIS) * (WF) / ((PS) - (PD))
#define LA_LRECPTOW(L, R, E, C, PS, PD, KVIS)\
                    (4.698e8 * (R) *((C)*(C)*(C)) / (KVIS) /\
                                     (L) * (1. + 1.5 * SQR((E)/(C))) * ((PS) - (PD)))

#define OR_APTOW(A, PS, PD, CD, SG)\
                 ((A) * 19020. * (CD) * SSQRT((SG) * ((PS) - (PD))))
#define OR_AWPDTOPS(A, W, PD, CD, SG)\
                 ((PD) + SSQR((W) / 19020. / max((A), 1e-12) / (CD)) / (SG))
#define OR_AWPSTOPD(A, W, PS, CD, SG)\
                 ((PS) - SSQR((W) / 19020. / max((A), 1e-12) / (CD)) / (SG))
#define OR_WPTOA(W, PS, PD, CD, SG)\
                 ((W) / SGN((PS) - (PD)) /\
            max(sqrt(fabs((SG) * ((PS) - (PD)))), 1e-16) / (CD) / 19020.)

#define DWDC(SG)    (129.93948 * (SG))
#define PI          (3.1415926535897932384626433832795)
double hole(double x, double d);

// Sharp edge to reattached flow characteristic of flapper nozzle
static double f_lqx[]   = {1.2, 2.5, 4.5, 7.5,\
                            .61, .65, .88, .95};
static int n_lqxcf = 4; // Length of table above

// Friction functions
// Zero-crossing modes
#define mode_stop_max 3
#define mode_stop_min -3
#define mode_move_plus 2
#define mode_move_neg -2
#define mode_stuck_plus 1
#define mode_stuck_neg -1
#define mode_lincos_override 0
void friction_surf(double *surf0, double *surf1, double *surf2,
    double *surf3, double *surf4, const double Xdot, const double uf,
    const double fstf, const double X, const double xmin, const double xmax);
double friction_balance(const int mode, const double uf, const double fstf,
    const double fdyf, int *stops);
int friction_mode(const double LINCOS_OVERRIDE, const int stops, const double surf0,
    const double surf1, const double surf2, const double surf3, const double surf4,
    const double Xdot, const double uf);

#endif
