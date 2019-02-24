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
global GEO INI FP mv_x
mprintf('In %s\n', sfilename())  
try close(figs); end
LINCOS_OVERRIDE = 0;

GEO.ln_vs = lti_man_n_vm(GEO.ln_vs, FP.sg, FP.beta);
GEO.ln_p3s = lti_man_n_vm(GEO.ln_p3s, FP.sg, FP.beta);
GEO.main_line = lti_man_n_mm(GEO.main_line, FP.sg, FP.beta);

// Inputs
INI.wf36 = 100;
INI.ps3 = 15;

// Boundary conditions TODO:  need better logic
INI.wf1bias = 673.32808;
INI.ven_ps = 73.595;
INI.ven_pd = 1451.2;
INI.pamb = 14.696;
INI.pr = 198.59;

// Init guess TODO:  need better logic
INI.p1so = 442.72465;
INI.p2 = 388.48432;
INI.px = 310.97791;

// Initialize
exec('./Callbacks/Solve_start04selfinit.sce', -1);
mv_x.values(:,1) = mv_x.values(:,1)*0+INI.mv.x;
INI.ln_vs = ini_man_n_vm(GEO.ln_vs, INI.p1so, INI.wf1v);
INI.ln_p3s = ini_man_n_vm(GEO.ln_p3s, INI.p3s, 0);
INI.main_line = ini_man_n_mm(GEO.main_line, INI.p3, INI.wf36);
mprintf('mv_x=%8.6f-%8.6f\n', mv_x.values(1,1), mv_x.values($,1));

mprintf('Completed %s\n', sfilename())  
