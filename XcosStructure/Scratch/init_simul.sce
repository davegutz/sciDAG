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
// Mar 24, 2019    DA Gutz     Created
//
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
// Jan 1, 2019      DA Gutz     Created
// 
funcprot(0);
getd('../Lib')
this = sfilename();
base = strsplit(this, '.');
base = base(1);
root = strsplit(base, 'init_');
root = root(2);
this_xcos_file = root + '.xcos';
this_zcos_file = root + '.zcos';
this_path = get_absolute_file_path(this);
chdir(this_path);
n_fig = -1;
xdel(winsid())
//mclose('all');   This cannot be scripted, has to be called at command line

global m k c
global loaded_scratch root sys_f scs_m cpr
global G MOD ic FP LIN mv_x mv_xa mv_xin Tf
global bl_start bl_mv bl_mvtv bl_hs bl_a_tvb
global DI DV

// Memory of setup
// Auto data overplot load
stack_size = stacksize('max');
MOD = tlist(["mod_ctrl", "initialized", "skip_init", "batch", "tPumpFail",...
             "zeroP3lineDamp"], %f, %f, %f, %inf, %f);
MOD.skip_init = %t;         // Load in pre-solved initial condition
MOD.zeroP3lineDamp = %t;   //  Special switch to match simulink model (not intended for final model) 

// Load external reference data
if MOD.zeroP3lineDamp then
    [D, N, time] = load_csv_data_row('./Data/FP_IRP_0d.csv', 1);
    [n_names, m_names] = size(N);
    for i = 1:m_names
        execstr(N(i) + "=D(" + string(i) + ",1);")
    end
    [D, N, time] = load_csv_data('./Data/DVS_IRP_0d.csv', 1);
    exec('./Data/load_decode_csv_data.sce', -1);
    [D, N, time] = load_csv_data('./Data/DIS_IRP_0d.csv', 1);
    exec('./Data/load_decode_csv_data.sce', -1);
    clear D N n_names m_names
else
    [D, N, time] = load_csv_data_row('./Data/FP_IRP.csv', 1);
    [n_names, m_names] = size(N);
    for i = 1:m_names
        execstr(N(i) + "=D(" + string(i) + ",1);")
    end
    [D, N, time] = load_csv_data('./Data/DVS_IRP.csv', 1);
    exec('./Data/load_decode_csv_data.sce', -1);
    [D, N, time] = load_csv_data('./Data/DIS_IRP.csv', 1);
    exec('./Data/load_decode_csv_data.sce', -1);
    clear D N n_names m_names
end

// Driven inputs  TODO: standalone model should not have any driven
xn25 = DI.eng.xn25;
hs_x = DI.ifc.Calc.Comp.hs.Result.x;
tri_ps = DV.reg.In.ps;
tri_pd = DV.reg.In.pd;
tri_px = DV.reg.In.px;
tri_ped = DV.reg.In.ped;
tri_pel = DV.reg.In.pel;
tri_pes = DV.reg.In.pes;
tri_pld = DV.reg.In.pld;
tri_plr = DV.reg.In.plr;
tri_fext = DV.reg.In.fext;
tri_wfse = DV.reg.Result.wf.wfse;
tri_wfs = DV.reg.Result.wf.wfs;
vdpp_wf = DV.pump.Result.wf;
vdpp_pd = DV.pump.In.pd;
start_wfs = DV.pump.In.pd; start_wfs.values = start_wfs.values*0;
vload_rline_ps = DV.rline_ps;
pr_ven = DV.I.pr_psia;
vload_ehsv_wfs = DV.ehsv.SPOOL.wfs;
rrv_wfvx = DV.pump.In.pd; rrv_wfvx.values = rrv_wfvx.values*0;
rrv_wfd = DV.pump.In.pd; rrv_wfd.values = rrv_wfd.values*0;
vdpp_ps = DV.I.ps_psia;
wfengine = DI.ac.Mon_ABOOST.wfengine;
hs_pos = DI.ifc.Calc.Comp.hs.Result.x;
hs_dxdt = DI.ifc.Calc.Comp.hs.Result.dxdt;
hs_ufmod = DI.ifc.Calc.Comp.hs.Result.uf_mod;
hs_plx = DI.ifc.Calc.Comp.hs.plx;
hs_wff = DI.ifc.Calc.Comp.hs.Result.wf.wff;
hs_wfh = DI.ifc.Calc.Comp.hs.Result.wf.wfh;
hs_wfl = DI.ifc.Calc.Comp.hs.Result.wf.wfl;
hs_cf = DI.ifc.Calc.Comp.hs.Result.wf.cf;
hs_pl = DI.ifc.Calc.Comp.hs.In.pl;
hs_ph = DI.ifc.Calc.Comp.hs.In.ph;
hs_pf = DI.ifc.Calc.Comp.hs.In.pf;
p3 = DI.ifc.Calc.Press.p3;
wf3s = DI.ifc.Calc.Flow.wf3s;
p3s = DI.ifc.Calc.Press.p3s;
wf3sx = DI.ifc.Calc.Flow.lnp3s.wf3sx;
p3sx = DI.ifc.Calc.Flow.lnp3s.p3sx;
p3sxm = DI.ifc.Calc.Flow.lnp3s.p3sxm;
ACmotivepull = DI.ac.Mon_ABOOST.ACmotivepull;
pacbmix = DI.ac.Mon_ABOOST.pacbmix;
pdacbst = DI.ac.Mon_ABOOST.pdacbst;
pdacmbst = DI.ac.Mon_ABOOST.pdacmbst;
pengine = DI.ac.Mon_ABOOST.pengine;
psacbst = DI.ac.Mon_ABOOST.psacbst;
wfacbst = DI.ac.Mon_ABOOST.wfacbst;
wfacmbst = DI.ac.Mon_ABOOST.wfacmbst;
wfbypass = DI.ac.Mon_ABOOST.wfbypass;
wfengine = DI.ac.Mon_ABOOST.wfengine;
wftank = DI.ac.Mon_ABOOST.wftank;

// Length of simulation
Tf = time($);

// Real time plot buffer
Tb = Tf;

// Data storage setup
TBUF = 0.0001;
NBUF = ceil(Tf/TBUF);
clear D N time


LIN.open_tv = 0;

// Fuel properties
FP.dwdc = DWDC(FP.sg);
FP.avis = AVIS(FP.sg, FP.kvis);
FP.tvp = 7;
FP.tvp_margin = -1e6;

// Structures
vlink_default = tlist(["vlk", "ctqpv", "cva", "cdv", "cftpa", "ytqa", "ytqrs",..
                       "cdabdamp", "fsb", "ksb"],..
                       0, 0, 0, 0, ctab1_default, ctab1_default,..
                       0, 0, 0);
function str = %vlk_string(v)
    str = msprintf('''%s'' type:  ctqpv=%f, cva=%f, cdv=%f, cftpa=%f,',..
             typeof(v), v.ctqpv, v.cva, v.cdv, v.cftpa);
    str = str + 'ytqa: ' + string(v.ytqa) + ',';
    str = str + 'ytqrs: '+ string(v.ytqrs);
endfunction
function str = vlk_fstring(v)
    str = msprintf('type,''%s'',\nctqpv,%f,\ncva,%f,\ncdv,%f,\ncftpa,%f,\nytqa,%s\nytqrs,%s\n',..
             typeof(v), v.ctqpv, v.cva, v.cdv, v.cftpa, ctab1_fstring(v.ytqa), ctab1_fstring(v.ytqrs));
endfunction
function str = %vlk_p(v)
    str = string(v);
    disp(str)
endfunction
wf1leak_default = tlist(["wf1leak", "Ao", "k", "Do"], 0, 0, 0);
function str = %wf1l_string(v)
    str = msprintf('''%s'' type:  Ao=%f, k=%f, Do=%f',..
             typeof(v), v.Ao, v.k, v.Do);
endfunction
function str = wf1l_fstring(v)
    str = msprintf('type,''%s'',\nAo,%f,\nk,%f,\nDo,%f,\n',..
             typeof(v), v.Ao, v.k, v.Do);
endfunction
function str = %wf1l_p(v)
    str = string(v);
    disp(str)
endfunction

MLINE = tlist(["sys_mline", "vo_pnozin", "ln_vs", "main_line", "noz"],vol_default, pipeVM_default, pipeMM_default, ctab1_default);
IFC = tlist(["sys_ifc", "mv", "mvtv", "hs", "mo_p3s", "vo_pd",  "vo_p3", "vo_p1so", "vo_px", "vo_p3s", "ln_p3s", "a_p3s", "a_tvb", "mvwin", "check", "k1leak", "a1leak", "prtv"], hlfvlv_a_default, vlv_a_default, head_b_default, mom_default, vol_default, vol_default, vol_default, vol_default, vol_default, pipeVM_default, or_default, or_default, ctab1_default, vlv_a_default, 0, 0, vlv_a_default);
EPMP = tlist(["sys_ebp", "mfp", "wf1leak", "faboc", "ocm1", "ocm2", "focOr", "vo_poc", "boost", "inlet", "or_filt", "mom_filt", "vo_pb1", "vo_pb2", "vo_p1"], cpmp_default, wf1leak_default, pipeMM_default, pipeMM_default, pipeVM_default, or_default, vol_default, cpmp_default, pipeMM_default, or_default, mom_default, vol_default, vol_default, vol_default);
VEN = tlist(["sys_ven", "vdpp", "vsv", "reg", "pact", "pact_lk", "vlink", "vleak", "rrv", "vo_pcham", "vo_px", "bias", "ehsv_klk", "ehsv_powlk", "ksb", "fsb", "leako"], vdp_default, vlv_a_default, tv_a1_default, actuator_a_b_default, la_default, vlink_default, la_default, vlv_a_default, vol_default, vol_default, actuator_a_b_default, 0, 0, 0, 0, la_default);
ENG = tlist(["sys_eng", "pcn25r", "N25c100Pct", "N25100Pct", "N2c100Pct", "xn25p", "xnvent", "xnmainpt", "ctstd", "spcn25", "sfxven", "swf", "sawfb", "fxvent", "t25t", "ps3t", "dps3dwt", "pcn2rt", "pcn25rt"], ctab1_default, 0, 0, 0, 0, 0, 0, 0, [0 1], [0 1], [0 1], [0 1], [0 1], ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default);
ACSUPPLY = tlist(["sys_acsup", "ltank", "lengine", "acbst", "acmbst", "motor"], pipeMV_default, pipeMV_default, cpmp_default, cpmp_default, or_default);
VENLOAD = tlist(["sys_venload", "act_c", "ehsv", "ehsv_klk", "ehsv_powlk", "rline", "hline", "vo_rcham", "vo_hcham"], actuator_a_c_default, fehsv2_default, 0, 0, pipeVM_default, pipeVM_default, vol_default, vol_default);
GUESS = tlist(["v_guess", "xn25", "disp", "xehsv", "xreg", "xbias", "pd", "prod", "px", "phead"], ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default, ctab1_default);

G = tlist(['geo', 'ifc', 'ebp', 'ven', 'venload', 'eng', 'mline', 'acsupply', 'guess'], IFC, EPMP, VEN, VENLOAD, ENG, MLINE, ACSUPPLY, GUESS);

clear IFC EPMP VEN VENLOAD ENG MLINE ACSUPPLY GUESS

// Temporary.  TODO:  remove this line and use zcos diagram + pre_xcos...
exec('./Callbacks/PreLoadFcn_simul.sce', -1);

function geo_write(file_name, g)
    [fid, err] = mopen(file_name, 'wt');
    if fid<0,
        error(err)
    end
    mfprintf(fid, 'type,''%s'',\n', typeof(g));
    mfprintf(fid, 'G.mline.vo_pnozin.%s\n', vol_fstring(g.mline.vo_pnozin));
    mfprintf(fid, 'G.mline.ln_vs.%s\n', pipe_fstring(g.mline.ln_vs));
    mfprintf(fid, 'G.mline.main_line.%s\n', pipe_fstring(g.mline.main_line));
    mfprintf(fid, 'G.mline.noz.%s\n', ctab1_fstring(g.mline.noz));
    mfprintf(fid, 'G.eng.ctstd,%f\n', g.eng.ctstd);
    mfprintf(fid, 'G.eng.N25c100Pct,%f\n', g.eng.N25c100Pct);
    mfprintf(fid, 'G.eng.N25100Pct,%f\n', g.eng.N25100Pct);
    mfprintf(fid, 'G.eng.N2c100Pct,%f\n', g.eng.N2c100Pct);
    mfprintf(fid, 'G.eng.xnmainpt,%f\n', g.eng.xnmainpt);
    mfprintf(fid, 'G.eng.xn25p,%f\n', g.eng.xn25p);
    mfprintf(fid, 'G.eng.xnvent,%f\n', g.eng.xnvent);
    mfprintf(fid, 'G.eng.spcn25,[');mfprintf(fid, '%f ', g.eng.spcn25(:)); mfprintf(fid, '],\n');
    mfprintf(fid, 'G.eng.sfxven,[');mfprintf(fid, '%f ', g.eng.sfxven(:)); mfprintf(fid, '],\n');
    mfprintf(fid, 'G.eng.sawfb,[');mfprintf(fid, '%f ', g.eng.sawfb(:)); mfprintf(fid, '],\n');
    mfprintf(fid, 'G.eng.swf,[');mfprintf(fid, '%f ', g.eng.swf(:)); mfprintf(fid, '],\n');
    mfprintf(fid, 'G.eng.pcn25r.%s\n', ctab1_fstring(g.eng.pcn25r));
    mfprintf(fid, 'G.eng.dps3dwt.%s\n', ctab1_fstring(g.eng.dps3dwt));
    mfprintf(fid, 'G.eng.pcn2rt.%s\n', ctab1_fstring(g.eng.pcn2rt));
    mfprintf(fid, 'G.eng.pcn25rt.%s\n', ctab1_fstring(g.eng.pcn25rt));
    mfprintf(fid, 'G.eng.ps3t.%s\n', ctab1_fstring(g.eng.ps3t));
    mfprintf(fid, 'G.eng.t25t.%s\n', ctab1_fstring(g.eng.t25t));
//    mfprintf(fid, 'G.eng.fxvent.%s\n', ctab1_fstring(g.eng.fxvent));
    mfprintf(fid, 'G.ifc.a1leak,%f\n', g.ifc.a1leak);
    mfprintf(fid, 'G.ifc.k1leak,%f\n', g.ifc.k1leak);
    mfprintf(fid, 'G.ifc.mv.%s\n', hlfvlv_a_fstring(g.ifc.mv));
    mfprintf(fid, 'G.ifc.mvwin.%s\n', ctab1_fstring(g.ifc.mvwin));
    mfprintf(fid, 'G.ifc.hs.%s\n', hdb_fstring(g.ifc.hs));
    mfprintf(fid, 'G.ifc.mvtv.%s\n', vlv_a_fstring(g.ifc.mvtv));
    mfprintf(fid, 'G.ifc.prtv.%s\n', vlv_a_fstring(g.ifc.prtv));
    mfprintf(fid, 'G.ifc.a_tvb.%s\n', or_fstring(g.ifc.a_tvb));
    mfprintf(fid, 'G.ifc.check.%s\n', vlv_a_fstring(g.ifc.check));
    mfprintf(fid, 'G.ifc.vo_p1so.%s\n', vol_fstring(g.ifc.vo_p1so));
    mfprintf(fid, 'G.ifc.vo_pd.%s\n', vol_fstring(g.ifc.vo_pd));
    mfprintf(fid, 'G.ifc.vo_p3.%s\n', vol_fstring(g.ifc.vo_p3));
    mfprintf(fid, 'G.ifc.vo_px.%s\n', vol_fstring(g.ifc.vo_px));
    mfprintf(fid, 'G.ifc.mo_p3s.%s\n', mom_fstring(g.ifc.mo_p3s));
    mfprintf(fid, 'G.ifc.a_p3s.%s\n', or_fstring(g.ifc.a_p3s));
    mfprintf(fid, 'G.ifc.vo_p3s.%s\n', vol_fstring(g.ifc.vo_p3s));
    mfprintf(fid, 'G.ifc.ln_p3s.%s\n', pipe_fstring(g.ifc.ln_p3s));
    mfprintf(fid, 'G.ven.fsb,%f\n', g.ven.fsb);
    mfprintf(fid, 'G.ven.ksb,%f\n', g.ven.ksb);
    mfprintf(fid, 'G.ven.pact_lk.%s\n', la_fstring(g.ven.pact_lk));
    mfprintf(fid, 'G.ven.leako.%s\n', la_fstring(g.ven.leako));
    mfprintf(fid, 'G.ven.vleak.%s\n', la_fstring(g.ven.vleak));
    mfprintf(fid, 'G.ven.pact.%s\n', aab_fstring(g.ven.pact));
    mfprintf(fid, 'G.ven.bias.%s\n', aab_fstring(g.ven.bias));
    mfprintf(fid, 'G.ven.vsv.%s\n', vlv_a_fstring(g.ven.vsv));
    mfprintf(fid, 'G.ven.rrv.%s\n', vlv_a_fstring(g.ven.rrv));
    mfprintf(fid, 'G.ven.vdpp.%s\n', vdp_fstring(g.ven.vdpp));
    mfprintf(fid, 'G.ven.reg.%s\n', tv_a1_fstring(g.ven.reg));
    mfprintf(fid, 'G.ven.vlink.%s\n', vlk_fstring(g.ven.vlink));
    mfprintf(fid, 'G.ven.vo_pcham.%s\n', vol_fstring(g.ven.vo_pcham));
    mfprintf(fid, 'G.ven.vo_px.%s\n', vol_fstring(g.ven.vo_px));
    mfprintf(fid, 'G.venload.ehsv.%s\n', fehsv2_fstring(g.venload.ehsv));
    mfprintf(fid, 'G.venload.ehsv_klk,%f\n', g.venload.ehsv_klk);
    mfprintf(fid, 'G.venload.ehsv_powlk,%f\n', g.venload.ehsv_powlk);
    mfprintf(fid, 'G.venload.act_c.%s\n', aac_fstring(g.venload.act_c));
    mfprintf(fid, 'G.venload.vo_hcham.%s\n', vol_fstring(g.venload.vo_hcham));
    mfprintf(fid, 'G.venload.vo_rcham.%s\n', vol_fstring(g.venload.vo_rcham));
    mfprintf(fid, 'G.venload.rline.%s\n', pipe_fstring(g.venload.rline));
    mfprintf(fid, 'G.acsupply.ltank.%s\n', pipe_fstring(g.acsupply.ltank));
    mfprintf(fid, 'G.acsupply.lengine.%s\n', pipe_fstring(g.acsupply.lengine));
    mfprintf(fid, 'G.acsupply.acmbst.%s\n', cpmp_fstring(g.acsupply.acmbst));
    mfprintf(fid, 'G.acsupply.acbst.%s\n', cpmp_fstring(g.acsupply.acbst));
    mfprintf(fid, 'G.acsupply.motor.%s\n', or_fstring(g.acsupply.motor));
    mfprintf(fid, 'G.ebp.inlet.%s\n', pipe_fstring(g.ebp.inlet));
    mfprintf(fid, 'G.ebp.ocm1.%s\n', pipe_fstring(g.ebp.ocm1));
    mfprintf(fid, 'G.ebp.ocm2.%s\n', pipe_fstring(g.ebp.ocm2));
    mfprintf(fid, 'G.ebp.faboc.%s\n', pipe_fstring(g.ebp.faboc));
    mfprintf(fid, 'G.ebp.vo_poc.%s\n', vol_fstring(g.ebp.vo_poc));
    mfprintf(fid, 'G.ebp.focOr.%s\n', or_fstring(g.ebp.focOr));
    mfprintf(fid, 'G.ebp.or_filt.%s\n', or_fstring(g.ebp.or_filt));
    mfprintf(fid, 'G.ebp.mom_filt.%s\n', mom_fstring(g.ebp.mom_filt));
    mfprintf(fid, 'G.ebp.vo_pb1.%s\n', vol_fstring(g.ebp.vo_pb1));
    mfprintf(fid, 'G.ebp.vo_pb2.%s\n', vol_fstring(g.ebp.vo_pb2));
    mfprintf(fid, 'G.ebp.wf1leak.%s\n', wf1l_fstring(g.ebp.wf1leak));
    mfprintf(fid, 'G.ebp.boost.%s\n', cpmp_fstring(g.ebp.boost));
    mfprintf(fid, 'G.ebp.mfp.%s\n', cpmp_fstring(g.ebp.mfp));
    mfprintf(fid, 'G.ebp.vo_p1.%s\n', vol_fstring(g.ebp.vo_p1));
    mclose(fid);
endfunction

function gstr = %ge_string(g)
    // string geo overload
    gstr = '';
    gstr = msprintf('''%s'' type:  \n', typeof(g));
    gstr = gstr + msprintf('vdpp = %s;\n', string(g.vdpp));
    gstr = gstr + msprintf('vsv = %s;\n', string(g.vsv));
    gstr = gstr + msprintf('reg = %s;\n', string(g.reg));
    gstr = gstr + msprintf('pact = %s;\n', string(g.pact));
    gstr = gstr + msprintf('pact_lk = %s;\n', string(g.pact_lk));
    gstr = gstr + msprintf('vlink = %s;\n', string(g.vlink));
    gstr = gstr + msprintf('ehsv_klk = %s;\n', string(g.ehsv_klk));
    gstr = gstr + msprintf('ehsv_powlk = %s;\n', string(g.ehsv_powlk));
    gstr = gstr + msprintf('rrv = %s;\n', string(g.rrv));
    gstr = gstr + msprintf('vo_pcham = %s;\n', string(g.vo_pcham));
    gstr = gstr + msprintf('vo_vpx = %s;\n', string(g.vo_vpx));
    gstr = gstr + msprintf('bias = %s;\n', string(g.bias));
    gstr = gstr + msprintf('mv = %s;\n', string(g.mv));
    gstr = gstr + msprintf('mvtv = %s;\n', string(g.mvtv));
    gstr = gstr + msprintf('hs = %s;\n', string(g.hs));
    gstr = gstr + msprintf('noz = %s;\n', string(g.noz));
    gstr = gstr + msprintf('mo_p3s = %s;\n', string(g.mo_p3s));
    gstr = gstr + msprintf('vo_p2 = %s;\n', string(g.vo_p2));
    gstr = gstr + msprintf('vo_p3 = %s;\n', string(g.vo_p3));
    gstr = gstr + msprintf('vo_p1so = %s;\n', string(g.vo_p1so));
    gstr = gstr + msprintf('vo_px = %s;\n', string(g.vo_px));
    gstr = gstr + msprintf('vo_p3s = %s;\n', string(g.vo_p3s));
    gstr = gstr + msprintf('vo_pnozin = %s;\n', string(g.vo_pnozin));
    gstr = gstr + msprintf('ln_p3s = %s;\n', string(g.ln_p3s));
    gstr = gstr + msprintf('ln_vs = %s;\n', string(g.ln_vs));
    gstr = gstr + msprintf('main_line = %s;\n', string(g.main_line));
    gstr = gstr + msprintf('a_p3s = %s;\n', string(g.a_p3s));
    gstr = gstr + msprintf('a_tvb = %s;\n', string(g.a_tvb));
    gstr = gstr + msprintf('mvwin = %s;\n', string(g.mvwin));
endfunction

function %ge_p(g)
    disp(string(g));
endfunction


loaded_scratch = %f;
LINCOS_OVERRIDE = 0;
LINCOS_OPEN_LOOP = 0;
exec('Callbacks\pre_xcos_simulate_default.sci');
exec('Callbacks\post_xcos_simulate_default.sci');
loadXcosLibs(); loadScicos();


if ~win64() then
  warning(_("This module requires a Windows x64 platform."));
  return
end

// Load library
exec('../Lib/init_libScratch.sce', -1);
chdir(this_path);

mprintf('Executed ' + this + ' up to importXcosDiagram*********\n');

try
    importXcosDiagram("./"+this_zcos_file);
    xcos('./'+this_zcos_file);
catch
    importXcosDiagram("./"+this_xcos_file);
    xcos('./'+this_xcos_file);
end


mprintf('Ready to play...press the right arrow icon on %s diagram at top.\n', root);

//scicos_simulate(scs_m);
//scs_m.props.context


