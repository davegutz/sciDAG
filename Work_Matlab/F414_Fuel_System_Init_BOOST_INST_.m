function ic = F414_Fuel_System_Init_BOOST_INST_(ic, GEO, E, FP)
%%function [ic, GEOE] = F414_Fuel_System_Init_BOOST_INST_(ic, GEO, E, FP)
% 29-Apr-2012   DA Gutz     Created
% 05-Jun-2017   DA Gutz     PB1,PB2 names


% Inputs:   pengine, wfc, wfcvg, wfb, wfs, wfr
% Outputs:  wfengine, p1, pb2, prven=pb1

% Name changes
ice = ic.engboost;
icv = ic.venstart;
GEOE = GEO.engboost;
GEOV = GEO.venstart;
ice.wfr     = ic.wfr;
ice.wfs     = ic.wfs;

ice.mfp.N  = ic.xn25 * E.xnmainpt/E.xn25p;
icv.boost.N  = ic.xn25 * E.xnvent/E.xn25p;

ic.wf1p         = ic.wf1cx + ic.wfb;
ic.wfoc         = ic.wf1p - ic.wfccvg - ic.wfcfvg - ic.wfc;
ic.wffilt       = ic.wfoc + ic.wfs;
ic.wfb2         = ic.wffilt - ice.wfr;
ic.wfengine     = ic.wfb2;
[~, icv.boost.dp] = ip_wtodp(GEOV.boost.a, GEOV.boost.b, GEOV.boost.c, GEOV.boost.d, GEOV.boost.r1, GEOV.boost.r2, GEOV.boost.r2, GEOV.boost.w2, icv.boost.N, ic.wfb2, FP.sg, GEOV.boost.tau);
ic.pb1          = ic.pengine + icv.boost.dp;
icv.filt.dp     = ic.pb1-or_awtop(GEOV.filt.Ao, -ic.wffilt, ic.pb1, GEOV.filt.cd, FP.sg);
ic.pb2          = ic.pb1 - icv.filt.dp;
ice.focOr.dp    = ic.pb2-or_awtop(GEOE.focOr.Ao, -ic.wfoc, ic.pb2, GEOE.focOr.cd, FP.sg);
ic.poc          = ic.pb2 - ice.focOr.dp;
[~, ice.mfp.dp] = ip_wtodp(GEOE.mfp.a, GEOE.mfp.b, GEOE.mfp.c, GEOE.mfp.d, GEOE.mfp.r1, GEOE.mfp.r2, GEOE.mfp.r2, GEOE.mfp.w2, ice.mfp.N, ic.wf1p, FP.sg, GEOE.mfp.tau);
ic.p1           = ice.mfp.dp + ic.poc;

% Assign
ice.inlet.wf    = ic.wfengine;
ice.inlet.p     = ic.pengine;
icv.pb1         = ic.pb1;
icv.boost.wf    = ic.wfb2;
icv.boost.ps    = ic.pengine;
icv.boost.pd    = ic.pb1;
icv.vo_pb1.p    = ic.pb1;
icv.vo_pb1.wf   = ic.wffilt;
icv.filt.wf     = ic.wffilt;
icv.filt.p      = ic.pb1;
icv.filt.ps     = ic.pb1;
icv.filt.pd     = ic.pb2;
icv.vo_pb2.p    = ic.pb2;
icv.vo_pb2.wf   = ic.wffilt;
ice.fab.wf      = ic.wffilt - ic.wfs;
ice.fab.p       = ic.pb2;
ice.aboc.p      = ic.pb2;
ice.aboc.wf     = ic.wffilt - ic.wfs;
ice.faboc       = ice.aboc;
ice.vo_poc.p    = ic.poc;
ice.vo_poc.wf   = ic.wfoc;
ice.focOr.wf    = ic.wfoc;
ic.wfabocx1     = ic.wfoc;
ic.wfocmx1      = ic.wfoc;
ice.focOr.ps    = ic.pb2;
ice.focOr.pd    = ic.poc;
ice.ocm1.p      = ic.poc;
ice.ocm1.wf     = ic.wfocmx1;
ice.ocm2.p      = ic.poc;
ice.ocm2.wf     = ic.wf1p;
ice.mfp.ps      = ic.poc;
ice.mfp.pd      = ic.p1;
ice.mfp.wf      = ic.wf1p;

% Re-assign
ic.engboost = ice;
