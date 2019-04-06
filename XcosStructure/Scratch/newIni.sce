// Copyright (C) 2019  - Dave Gutz
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
// Mar 23, 2019    DA Gutz     Created
//
// run exec('./init_start04alone.sce', -1) first
exec('./Callbacks/solve_VEN.sci', -1);
exec('./Callbacks/solve_MAIN.sci', -1);
exec('./Callbacks/solve_IFC.sci', -1);
exec('./Callbacks/regwin_a.sci', -1);

clear INIx

INIx.wf36 = INI.wf36;
INIx.pamb = INI.pamb;
INIx.p1so = INI.p1so;
INIx.awfb = 0;
INIx.ven.fxven = 0;
//INIx.ven.pr = INI.pr;
//INIx.ven.ps = INI.pr;
INIx.ven.pamb =INI.pamb;

// To match matlab case
FP.sg = 0.79;
FP.kvis = 1.3;
FP.beta = 159200;
FP.dwdc = 102.6522;
FP.avis = 1.4823e-7;
FP.tvp_margin = -1e6;
FP.tvp = 5;
INIx.wf36 = 9060;
INIx.pamb = 14.7;
INIx.p1so = 1978.3;
INIx.awfb = 1e-5;



INIx.ven.pamb =INIx.pamb;
INIx.ven.fxven = 10000;
INIx.ven.guess.fxven = INIx.ven.fxven;
INIx.ven.guess.xn25 = lookup(INIx.ven.fxven, G.guess.xn25);
INIx.ven.guess.x1_xehsv = lookup(INIx.ven.fxven, G.guess.xehsv);
INIx.ven.guess.x2_prod = lookup(INIx.ven.fxven, G.guess.prod);
INIx.ven.guess.x3_xbi  = lookup(INIx.ven.fxven, G.guess.xbias);
INIx.ven.guess.x4_pd = lookup(INIx.ven.fxven, G.guess.pd);
INIx.ven.guess.x5_disp = lookup(INIx.ven.fxven, G.guess.disp);
INIx.ven.guess.x_xreg = lookup(INIx.ven.fxven, G.guess.xreg);
INIx.ven.x1_xehsv = INIx.ven.guess.x1_xehsv;
INIx.ven.x2_prod = INIx.ven.guess.x2_prod;
INIx.ven.x3_xbi  = INIx.ven.guess.x3_xbi;
INIx.ven.x4_pd = INIx.ven.guess.x4_pd;
INIx.ven.x5_disp = INIx.ven.guess.x5_disp;
INIx.ven.x_xreg = INIx.ven.guess.x_xreg;
 
INIx.ven.pr = 276.9033;
INIx.ven.ps = 276.8327;
INIx.xn25 = INIx.ven.guess.xn25;
INIx.ven.N = INIx.xn25/G.eng.xn25p*G.eng.xnvent;


// Eng Boost
INIx.sAC = 1;
INIx.wfr = 0;
INIx.wfs = 0;
INIx.wf1cvg = 0;
INIx.wf1fvg = 0;
INIx.wf1v = 0;
INIx.precx = INIx.pamb;
INIx.eng.wf36 = INIx.wf36;
INIx.verbose = 3;
INIx.linearizing = 0;
INIx.single_pass = 0;

//INIx = solve_MAIN(INIx, G, FP);
//
//INIx.pr = INIx.pc;
//

[INIx, Gx] = solve_VEN(INIx, G, FP);
INIx = order_all_fields(INIx); 
