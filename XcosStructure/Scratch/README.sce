// Copyright (C) 2018 - Dave Gutz
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
// Dec 17, 2018     DA Gutz         Created
// 

// Library is ../Lib.   execute make_libScratch.sce and init_libScratch.sce to
// rebuild.   May have to re-drag libScratch blocks out of Pallette browser for
// some rebuild configurations.   The functions below call init_libScratch 
// automatically but do not call make_libScratch.   When you call 
// make_libScratch it will do a clear/close so that you are forced to re-run
// the init_libScratch and avoid a lot of headscratching.

// Be sure to install PSO toolbox using Applications - Module Manager - Optimization

// Make source all models
exec('C:\Users\Dave\Documents\GitHub\sciDAG\XcosStructure\Lib\make_libScratch.sce',-1)

// Start flow system development
// c-code model run first in Linux Ubuntu to generate .csv files in Data folder
// First version to zoom on each component
// See Diagrams/start04_handSketch.png for high-level schematic
//
// First version
exec('init_start04detail.sce', -1);
// press play.   May throw memory error.   Activate "stacksize('max')" line
// in PreLoadFcn_start04detail.sce.   May not run on all platforms - comment
// it back out to run without bomb
// interactive result in Results/expected_start04detail*.png
// Formal plots in Results/expected_start04detail_formal*.png
exec('init_start04.sce', -1);
//
// Third version to let components interact.  Implicit initialization.
// press play.  Same memory issues as ...detail.sce
// interactive results in Results.   Formal plots in Results
exec('C:\Users\Dave\Documents\GitHub\sciDAG\XcosStructure\Scratch\init_start04detail.sce',-1)
//
// Fourth version to self initialize using a solver
// press play.  Same memory issues as ...detail.sce
// interactive results in Results.   Formal plots in Results
exec('C:\Users\Dave\Documents\GitHub\sciDAG\XcosStructure\Scratch\init_start04selfinit.sce',-1)
// To run steady state with oscillations
GEO.ln_vs.c=0;
// To see linear response XTV-->XTV
exec('./Scripts/linearize_start04selfinit.sce', -1);
// expected result in Results/expected_FREQ_RESP_start04selfinit.png
exec('benchmark_valve_start04selfinit.sce', -1)
// between 9 and 10 seconds is typical
//

// Fifth version to self initialize using a solver and run
// without data from c-model to drive it in any way.   Use
// to investigate solver choices.
// press play.  Same memory issues as ...detail.sce
// interactive results in Results.   Formal plots in Results
exec('C:\Users\Dave\Documents\GitHub\sciDAG\XcosStructure\Scratch\init_start04alone.sce',-1)
// To run steady state with oscillations
GEO.ln_vs.c=0;
// To see linear response XTV-->XTV
exec('./Scripts/linearize_start04alone.sce', -1);
// expected result in Results/expected_FREQ_RESP_start04alone.png
exec('benchmark_valve_start04alone.sce', -1)
// between 9 and 10 seconds is typical

// Sixth version to self initialize and match with Simulink model
// Note:  lost ability to port Simulink data to this model due to
// start of using Yubi key.   An exact match doesn't happen here
// when running at home.   But at work, the latest data files
// from Simulink are in Scratch/data and that's where match needs
// to be evaluated.   Expected results contains both results.
// Prework
    // In simulink
    //% uiopen('F414_Fuel.slx',1)
    //% Z.INPUTS_TUNE_T_C_S_D_V = {'Basic Data', 'cOp09', 'sNone',  'dNone', 'vPwf2'};
    //% sim('F414_Fuel.slx')
    //% save('IRP_datalog','-v7.3') 
    //% writeAllLogs('IRP')

    // copy *_IRP.csv to ./Data
    [D, N, time] = load_csv_data('./Data/DV_IRP.csv', 1);
    exec('./Data/load_decode_csv_data.sce', -1);
    [D, N, time] = load_csv_data('./Data/DI_IRP.csv', 1);
    exec('./Data/load_decode_csv_data.sce', -1);
    clear D N
    save('DATA_00_08000_00000_16005_09060_147_79_13_sNone.dat', 'DV', 'DI');

    exec('.\init_simu.sce',-1)
    // run briefly to generate INI
    exec('.\newIni.sce', -1) // 10 minutes run time
    save('./Data/init_00_08000_00000_16005_09060_147_79_13.dat', 'INI');
    ic = INI;
    save('init_00_08000_00000_16005_09060_147_79_13_sNone_ic.dat', 'ic')
    save_file = './Results/ic_simul.csv';
    [fdo, err] = mopen(save_file, 'wt');write_struct_row(ic, 'ic', fdo,',');mclose(fdo);rotate_file(save_file, save_file);

// Normal run
// Load the simulation
exec('.\init_simul.sce',-1)
// Run
// Executed init_simul.sce up to importXcosDiagram*********
// Ready to play...press the right arrow icon on simul diagram at top
// Plot
exec('Callbacks/StopFcn_simul.sce', -1)

// Freeze stuff
G.ifc.mvtv.fstf=1e12;
G.ifc.hs.fstf=1e12;
G.ifc.vo_p1so.vol = 1e12;
G.ifc.vo_p3.vol = 1e24;
G.ifc.vo_pd.vol = 1e24;
G.ifc.vo_px.vol = 1e24;
G.mline.vo_pnozin.vol = 1e24;
G.mline.main_line.l = 1e26;
G.mline.main_line.a = 1e24;
// Save off data
save_file = './Results/g_simul.csv';
geo_write(save_file, G)
// Save off plots
MOD.plotEnable = %t;MOD.plotAll=%t;MOD.exportFigs=%t;
exec('Callbacks/StopFcn_simul.sce', -1)
// The files 'Results/simul*.png' are pngs of all the plots.
// These don't overplot well because the basic Simulink model
// changed and with the Yubi key lockdown of work site (MOD.atWork=%t)
// it was not possible to update the 'Data/*.csv' files. 
// conbine pdfs in "PDF Shaper Free" using Action - Modify - Rotate Pages - 270 and
// Action - Modify - Merge

// check lines
s=1;
// mv
pipeMV=pipeMV_default;pipeMV.c=0.01*s;pipeMV.n=8;pipeMV.l=G.mline.ln_vs.l;pipeMV.a=G.mline.ln_vs.a;pipeMV.vol=G.mline.ln_vs.vol;pipeMV = lti_man_n_mv(pipeMV, FP.sg, FP.beta);lMV=syslin('c',pipeMV.A,pipeMV.B,pipeMV.C,pipeMV.D);lmvtf=ss2tf(lMV);
figure('Figure_name', 'MV');subplot(2,2,1);bode(lmvtf(1,1));subplot(2,2,2);bode(lmvtf(1,2));subplot(2,2,3);bode(lmvtf(2,1));subplot(2,2,4);bode(lmvtf(2,2));
// mm
pipeMM=pipeMM_default;pipeMM.c=0.01*s;pipeMM.n=8;pipeMM.l=G.mline.ln_vs.l;pipeMM.a=G.mline.ln_vs.a;pipeMM.vol=G.mline.ln_vs.vol;pipeMM = lti_man_n_mm(pipeMM, FP.sg, FP.beta);lMM=syslin('c',pipeMM.A,pipeMM.B,pipeMM.C,pipeMM.D);lmmtf=ss2tf(lMM);
figure('Figure_name', 'MM');subplot(2,2,1);bode(lmmtf(1,1));subplot(2,2,2);bode(lmmtf(1,2));subplot(2,2,3);bode(lmmtf(2,1));subplot(2,2,4);bode(lmmtf(2,2));
// vm
pipeVM=pipeVM_default;pipeVM.c=0.01*s;pipeVM.n=8;pipeVM.l=G.mline.ln_vs.l;pipeVM.a=G.mline.ln_vs.a;pipeVM.vol=G.mline.ln_vs.vol;pipeVM = lti_man_n_vm(pipeVM, FP.sg, FP.beta);lVM=syslin('c',pipeVM.A,pipeVM.B,pipeVM.C,pipeVM.D);lvmtf=ss2tf(lVM);
figure('Figure_name', 'VM');subplot(2,2,1);bode(lvmtf(1,1));subplot(2,2,2);bode(lvmtf(1,2));subplot(2,2,3);bode(lvmtf(2,1));subplot(2,2,4);bode(lvmtf(2,2));
// vv
pipeVV=pipeVV_default;pipeVV.c=0.01*s;pipeVV.n=8;pipeVV.l=G.mline.ln_vs.l;pipeVV.a=G.mline.ln_vs.a;pipeVV.vol=G.mline.ln_vs.vol;pipeVV = lti_man_n_vv(pipeVV, FP.sg, FP.beta);lVV=syslin('c',pipeVV.A,pipeVV.B,pipeVV.C,pipeVV.D);lvvtf=ss2tf(lVV);
figure('Figure_name', 'VV');subplot(2,2,1);bode(lvvtf(1,1));subplot(2,2,2);bode(lvvtf(1,2));subplot(2,2,3);bode(lvvtf(2,1));subplot(2,2,4);bode(lvvtf(2,2));

// Test pipes
exec('init_pipe.sce', -1);
// press play
// expected result in Results/expected_pipe.png


// Test orifices
exec('init_orifice.sce', -1);
// press play
// expected result in Results/expected_orifice.png

// Test valve
exec('init_valve.sce', -1);
// press play
// expected result in Results/expected_valve.png

// Test table
exec('init_table.sce', -1);
// press play
// expected result in Results/expected_table.png

// Test sec_order_x
exec('init_sec_order_1.sce', -1);
// press play
// expected result in Results/expected_sec_order_1.png
exec('init_sec_order_2.sce', -1);
// press play
// expected result in Results/expected_sec_order_2.png
exec('init_sec_order_3.sce', -1);
// press play
// expected result in Results/expected_sec_order_3.png
exec('init_sec_order_4.sce', -1);
// press play
// expected result in Results/expected_sec_order_4.png
exec('init_sec_order_5.sce', -1);
// press play
// expected result in Results/expected_sec_order_5.png
exec('init_sec_order_6.sce', -1);
// press play
// expected result in Results/expected_sec_order_6.png

// Load scratch552_UseLib.xcos
exec(init_scratch552_UseLib.sce, -1);

