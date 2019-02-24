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

INI.wf36 = 100;
INI.ps3 = 15;
//INI.pnozin = 19.458162;
INI.pnozin = min(130*(INI.wf36/540)^2, interp1(GEO.noz.tb(:,2), GEO.noz.tb(:,1), INI.wf36, 'linear', 'extrap'))+INI.ps3;
//INI.p3 = 59.4582;
INI.p3 = max(171.5*(INI.wf36/17000)^2, 40) + INI.pnozin;
INI.wfmd = INI.wf36;
INI.p3s = 395.834;
INI.px = 317.942;
INI.p2 = 395.834;
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
INI.prt = 132.879;
INI.ln_vs = ini_man_n_vm(GEO.ln_vs, INI.p1so, 711.774);
INI.ln_p3s = ini_man_n_vm(GEO.ln_p3s, INI.p3s, 0);
INI.main_line = ini_man_n_mm(GEO.main_line, 59.4582, INI.wf36);

if 1 then
INI.p1so = 442.72465;
INI.p2 = 388.48432;
INI.p3s = INI.p2;
INI.px = 310.97791;
INI.hs.x = 0.0071297;
INI.mv.x = 0.0132802;
INI.prt = INI.p1so  - 315;
mv_x.values(:,1) = mv_x.values(:,1)*0+INI.mv.x;
//mv_x.values(:,1) = mv_x.values(:,1)*0+mv_x.values(1,1);
INI.mvtv.x = -0.0380412;
INI.vsv.x = 0.1147568;
INI.wf36 = 100;

INI.wf36 = 100;
exec('./Callbacks/Solve_start04selfinit.sce', -1);

INI.ln_vs = ini_man_n_vm(GEO.ln_vs, INI.p1so, INI.wf1v);
INI.ln_p3s = ini_man_n_vm(GEO.ln_p3s, INI.p3s, 0);
INI.main_line = ini_man_n_mm(GEO.main_line, INI.p3, INI.wf36);
end
mprintf('mv_x=%8.6f-%8.6f\n', mv_x.values(1,1), mv_x.values($,1));

FP.sg = fp_sg.values(1,:);
FP.beta = fp_beta.values(1,:);
FP.dwdc = DWDC(FP.sg);
FP.tvp = 7;

mprintf('Completed %s\n', sfilename())  
