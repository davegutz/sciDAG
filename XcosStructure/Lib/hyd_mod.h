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
// Jan 14, 2019    DA Gutz        Created
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
#endif
