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
exec('./Callbacks/solve_IFC.sci', -1);
IFC = tlist(["sys_ifc", "mv", "mvtv", "hs", "mo_p3s", "vo_p2",  "vo_p3", "vo_p1so", "vo_px", "vo_p3s", "ln_p3s", "a_p3s", "a_tvb", "mvwin", "check"],..
GEO.mv, GEO.mvtv, GEO.hs, GEO.mo_p3s, GEO.vo_p2, GEO.vo_p3, GEO.vo_p1so, GEO.vo_px, GEO.vo_p3s, GEO.ln_p3s, GEO.a_p3s, GEO.a_tvb, GEO.mvwin, G.ifc.check);

G = tlist(['geo', 'ifc'], IFC);

Z.awfb = 0;
INI.ifc.p1 = INI.p1so;
INI.wf1cvg = 0;
INI.wf1fvg = 0;
INI.wf1v = 0;
INI.pc = INI.pr;
INI.pd = INI.p3;
INI.precx = INI.pamb;
INI.eng.wf36 = INI.wf36;
INI.verbose = 5;
INI.linearizing = 0;


INIX = solve_IFC(INI, G.ifc, Z, FP);
