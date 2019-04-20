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
global LINCOS_OVERRIDE figs LIN time_tic time_toc
global GEO G INI FP mv_x mv_xa mv_xin Tf
global ic
mprintf('In %s\n', sfilename())  
try close(figs); end
LINCOS_OVERRIDE = 0;

GEO.ln_vs = lti_man_n_vm(GEO.ln_vs, FP.sg, FP.beta);
GEO.ln_p3s = lti_man_n_vm(GEO.ln_p3s, FP.sg, FP.beta);
GEO.main_line = lti_man_n_mm(GEO.main_line, FP.sg, FP.beta);
G.mline.ln_vs = lti_man_n_vm(G.mline.ln_vs, FP.sg, FP.beta);
G.ifc.ln_p3s = lti_man_n_vm(G.ifc.ln_p3s, FP.sg, FP.beta);
G.mline.main_line = lti_man_n_mm(G.mline.main_line, FP.sg, FP.beta);
G.acsupply.ltank = lti_man_n_mv(G.acsupply.ltank, FP.sg, FP.beta);
G.acsupply.lengine = lti_man_n_mv(G.acsupply.lengine, FP.sg, FP.beta);

if ~INI.batch then
    if INI.initialized & INI.skip_init then
        btn = messagebox('Reinitialization needed?', 'Query Re-Init', 'question', ['yes', 'no'], 'modal');
        mprintf("Skipping init\n");
        if btn~=1 then
            mprintf('running...\n');
            time_tic = getdate();
            return;
        end
    end
else
    if INI.initialized then
        mprintf("Skipping init\n");
        time_tic = getdate();
        return;
    end
end

// Inputs
INI.wf36 = 107.08;
INI.ps3 = 15;

// Boundary conditions TODO:  need better logic
INI.wf1bias = 673.32808;
INI.ven_ps = 73.595;
INI.ven_pd = 1451.2;
INI.pamb = 14.696;
INI.pr = 198.59;

// Initialize
exec('./Callbacks/Solve_start04alone.sce', -1);
exec('./Callbacks/mvwin_b.sci', -1);
[xb, ab] = mvwin_b(40);
exec('./Callbacks/mvwin_a.sci', -1);
[xa, aa] = mvwin_a(40);
mv_x = DI.ifc.Calc.Comp.fmv.mv.Result.x; 
if isempty(mv_xa), mv_xa = mv_x.values(:,1); end
mv_aa = interp1(xa, aa, mv_xa, 'linear', aa(1));
mv_xb = interp1(ab, xb, mv_aa);
mv_x.values(:,1) = mv_xb;
x0 = mv_x.values(1,1);
xE = mv_x.values($,1);
mv_xin = struct('time', [0 0.00099 .00100 Tf]', 'values', [x0 x0 xE xE]');
//mv_x.values(:,1) = mv_xb*0+mv_xb(1);
INI.ln_vs = ini_man_n_vm(GEO.ln_vs, INI.p1so, INI.wf1v);
INI.ln_p3s = ini_man_n_vm(GEO.ln_p3s, INI.p3s, 0);
INI.main_line = ini_man_n_mm(GEO.main_line, INI.p3, INI.wf3);
INI.mline.ln_vs = ini_man_n_vm(G.mline.ln_vs, INI.p1so, INI.wf1v);
INI.ifc.ln_p3s = ini_man_n_vm(G.ifc.ln_p3s, INI.p3s, 0);
INI.mline.main_line = ini_man_n_mm(G.mline.main_line, INI.p3, INI.wf3);
mprintf('mv_x=%8.6f-%8.6f\n', mv_x.values(1,1), mv_x.values($,1));
INI.initialized = %t;
time_tic = getdate();

// placeholder for VEN Unit stuff
INI.xnven = DV.pump.In.rpm.values(1,1);
INI.xn25 = DV.I.xn25.values(1,1);
INI.disp = DV.pump.In.disp.values(1,1);
INI.pdven = DV.pd.values(1,1);
INI.psven = DV.I.ps_psia.values(1,1);
INI.pact.x = DV.pumpAct.x.values(1,1);
INI.reg.x = DV.reg.Result.x.values(1,1);
INI.pxven = DV.px.values(1,1);
INI.rrv.x = DV.rrv.Result.x.values(1,1);
INI.bias.x = DV.bias.Result.x.values(1,1);
//INI.xnven = 3243.2;
//INI.xn25 = 6884.0;
//INI.disp = 0.28047000;
//INI.pdven = 1451.20000000;
//INI.psven = 73.59500000;
//INI.pact.x = 0.09052700;
//INI.reg.x =-0.00178570;
//INI.pxven = 728.50000000;
//INI.rrv.x = 0.00000001;
//INI.bias.x = -0.00000738;

// Cleanup
INI = order_all_fields(INI);

// Temporary version of the final initialization method (newIni.sce) ic = INIx
load('init_00_08000_00000_16005_09060_147_79_13_sNone_ic.dat');
ic.acbst_dP = ic.acsupply.acbst.dP_Pump;
ic.acmbst_dP = ic.acsupply.acmbst.dP_Pump;
ic.acsupply.ltank = ini_man_n_mv(G.acsupply.ltank, ic.acsupply.ltank.p, ic.acsupply.ltank.wf);
ic.acsupply.lengine = ini_man_n_mv(G.acsupply.lengine, ic.acsupply.lengine.p, ic.acsupply.lengine.wf);


mprintf('Completed %s\n', sfilename())  
