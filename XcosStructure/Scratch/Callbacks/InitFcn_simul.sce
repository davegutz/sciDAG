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
global G MOD ic FP mv_x mv_xa mv_xin Tf
mprintf('In %s\n', sfilename())  
try close(figs); end
LINCOS_OVERRIDE = 0;

G.mline.ln_vs = lti_man_n_vm(G.mline.ln_vs, FP.sg, FP.beta);
G.ifc.ln_p3s = lti_man_n_vm(G.ifc.ln_p3s, FP.sg, FP.beta);
G.mline.main_line = lti_man_n_mm(G.mline.main_line, FP.sg, FP.beta);
G.acsupply.ltank = lti_man_n_mv(G.acsupply.ltank, FP.sg, FP.beta);
G.acsupply.lengine = lti_man_n_mv(G.acsupply.lengine, FP.sg, FP.beta);
G.ebp.inlet = lti_man_n_mm(G.ebp.inlet, FP.sg, FP.beta);
G.ebp.faboc = lti_man_n_mm(G.ebp.faboc, FP.sg, FP.beta);
G.ebp.ocm1 = lti_man_n_mm(G.ebp.ocm1, FP.sg, FP.beta);
G.ebp.ocm2 = lti_man_n_vm(G.ebp.ocm2, FP.sg, FP.beta);
G.venload.rline = lti_man_n_vm(G.venload.rline, FP.sg, FP.beta);
G.venload.hline = lti_man_n_vm(G.venload.hline, FP.sg, FP.beta);

if 0 & ~MOD.batch then
    if MOD.initialized & MOD.skip_init then
        btn = messagebox('Reinitialization needed?', 'Query Re-Init', 'question', ['yes', 'no'], 'modal');
        mprintf("Skipping init\n");
        if btn~=1 then
            mprintf('running...\n');
            time_tic = getdate();
            return;
        end
    end
else
    if 0 & MOD.initialized then
        mprintf("Skipping init\n");
        time_tic = getdate();
        return;
    end
end

// Inputs  TODO:  need better logic
//MOD.wf36 = 107.08;
//MOD.ps3 = 15;

// Boundary conditions 
// Initialize TODO:  need better logic
//exec('./Callbacks/Solve_start04alone.sce', -1);

mv_x = DI.ifc.Calc.Comp.fmv.mv.Result.x; 
x0 = mv_x.values(1,1);
xE = mv_x.values($,1);
mv_xin = struct('time', [0 0.011000 .011001 Tf]', 'values', [x0 x0 xE xE]');
//mv_xin.values(:,1) = x0; // freeze
mprintf('mv_x=%8.6f-%8.6f\n', mv_x.values(1,1), mv_x.values($,1));
MOD.initialized = %t;

// placeholder for VEN Unit stuff TODO:  need better logic here

// Cleanup
// placeholder for cleanup

// Temporary version of the final initialization method (newIni.sce) ic = MODx
load('init_00_08000_00000_16005_09060_147_79_13_sNone_ic.dat');
ic.acbst_dP = ic.acsupply.acbst.dP_Pump;
ic.acmbst_dP = ic.acsupply.acmbst.dP_Pump;
ic.acsupply.ltank = ini_man_n_mv(G.acsupply.ltank, ic.acsupply.ltank.p, ic.acsupply.ltank.wf);
ic.acsupply.lengine = ini_man_n_mv(G.acsupply.lengine, ic.acsupply.lengine.p, ic.acsupply.lengine.wf);
ic.ebp.inlet = ini_man_n_mm(G.ebp.inlet, ic.ebp.inlet.p, ic.ebp.inlet.wf);
ic.ebp.faboc = ini_man_n_mm(G.ebp.faboc, ic.ebp.faboc.p, ic.ebp.faboc.wf);
ic.ebp.ocm1 = ini_man_n_mm(G.ebp.ocm1, ic.ebp.ocm1.p, ic.ebp.ocm1.wf);
ic.ebp.ocm2 = ini_man_n_vm(G.ebp.ocm2, ic.ebp.ocm2.p, ic.ebp.ocm2.wf);
ic.mline.main_line = ini_man_n_mm(G.mline.main_line, ic.pd, ic.wfmd);
ic.mline.ln_vs = ini_man_n_vm(G.mline.ln_vs, ic.ifc.p1so, ic.wf1v);
ic.ven.load.rline = ini_man_n_vm(G.venload.rline, ic.ven.load.rline.p, ic.ven.load.rline.wf);
ic.ven.load.hline = ini_man_n_vm(G.venload.hline, ic.ven.load.hline.p, ic.ven.load.hline.wf);
ic.wf1bias = 0;
ic.ifc.ln_p3s = ini_man_n_vm(G.ifc.ln_p3s, ic.ifc.p3, ic.ifc.wf3s);
ic.ven.vsv.x = G.ven.vsv.xmax;
ic.ven.rrv.x = G.ven.rrv.xmin;
ic.ven.load.act_c.x = 4.5;
ic = order_all_fields(ic);


if ic.wf36 > 900 then
    ic.ifc.check.a = G.ifc.check.ad.tb(4,2);
else
    ic.ifc.check.a = G.ifc.check.ad.tb(4,3);
end

// Clear save data so not fooled by plots if MOD.logAll=%f
clear VDATA IDATA MDATA ADATA LDATA PALL XALL WALL

mprintf('Completed %s\n', sfilename())  
