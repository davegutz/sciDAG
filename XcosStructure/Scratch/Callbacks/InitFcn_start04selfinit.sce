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
// Jsn 1, 2019      DA Gutz     Created
// 
global LINCOS_OVERRIDE figs
global GEO INI FP
mprintf('In %s\n', sfilename())  
try close(figs); end
LINCOS_OVERRIDE = 0;

GEO.ln_vs = lti_man_n_vm(GEO.ln_vs, FP.sg, FP.beta);
GEO.ln_p3s = lti_man_n_vm(GEO.ln_p3s, FP.sg, FP.beta);
GEO.main_line = lti_man_n_mm(GEO.main_line, FP.sg, FP.beta);

INI.ln_vs = ini_man_n_vm(GEO.ln_vs, 448.552, 711.774);
INI.ln_p3s = ini_man_n_vm(GEO.ln_p3s, 395.834, 0);
INI.main_line = ini_man_n_mm(GEO.main_line, 59.4582, 100);
INI.p3s = 395.834;
INI.px = 317.942;
INI.p2 = 395.834;
INI.p3 = 59.4582;
INI.pnozin = 19.4582;
INI.p1so = 448.552;
INI.wf3s = 0;
INI.vsv.x = 0.1163907;
INI.reg.x = -0.0017857;
INI.mv.x = -0.0422341;
INI.mvtv.x = -0.038153;
INI.hs.x = 0.0062509;
INI.wf1bias = 673.32808;
INI.ven_ps = 73.595;
INI.ven_pd = 1451.2;
INI.pamb = 14.696;
INI.pr = 198.59;
INI.ps3 = 15;


FP.sg = fp_sg.values(1,:);
FP.beta = fp_beta.values(1,:);
FP.dwdc = DWDC(FP.sg);
FP.tvp = 7;

mprintf('Completed %s\n', sfilename())  
