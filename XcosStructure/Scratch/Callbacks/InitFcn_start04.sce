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

INI.ln_vs = ini_man_n_vm(GEO.ln_vs, p1so.values(1,:), wf1v.values(1,:));
INI.ln_p3s = ini_man_n_vm(GEO.ln_p3s, p3sup1.values(1,:), wf3s.values(1,:));
INI.main_line = ini_man_n_mm(GEO.main_line, p3.values(1,:), wfmd.values(1,:));
INI.p3s = p3s.values(1,:);
INI.px = px.values(1,:);
INI.p2 = p2.values(1,:);
INI.p3 = p3.values(1,:);
INI.pnozin = pnozin.values(1,:);
INI.p1so = p1so.values(1,:);
INI.wf3s = wf3s.values(1,:);
INI.vsv.x = start_x.values(1,:);
INI.reg.x = tri_x.values(1,:);
INI.mv.x = mv_x.values(1,:);
INI.mvtv.x = mvtv_x.values(1,:);
INI.hs.x = hs_x.values(1,:);
INI.wf1bias = wf1leak.values(1,:)+wf1vg.values(1,:)+wf1w.values(1,:)-wf1c.values(1,:);
INI.ven_ps = start_pxr.values(1,:);
INI.ven_pd = start_ps.values(1,:);
INI.pamb = mv_pa.values(1,:);
INI.pr = mv_pr.values(1,:);
INI.ps3 = ps3.values(1,:);


FP.sg = fp_sg.values(1,:);
FP.beta = fp_beta.values(1,:);
FP.dwdc = DWDC(FP.sg);
FP.tvp = 7;

mprintf('Completed %s\n', sfilename())  
