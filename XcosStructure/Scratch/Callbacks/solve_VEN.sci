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
// Mar 29, 2019 DA Gutz Created
//
function [ic, GEO] = solve_VEN(ic, GEO, FP)
    // 01-Mar-2017 DA Gutz Created
    // 05-Jun-2017 DA Gutz PB1,PB2 names
    RNULL = 0.002;  // Estimate of regulator null disp, in.
    DPNORM = 500;   // Estimate of pressure above supply without lead, psi
    DPLEAK = 120;   // Estimate of pressure above supply bled, psi
    DBIAS = 0;      // Dead zone of drain, + is underlap, in
    AVG_DISP = 0.5;

    // Name changes
    icv = ic.ven;
    ic.ven.load.fxven = icv.fxven;
    icvl = ic.ven.load;
    GEOV = GEO.ven;
    GEOVL = GEO.venload;
    RGEO = GEOV.reg;
    BIGEO = GEOV.bias;
    PAGEO = GEOV.pact;
    // TODO: add start valve SGEO = GEOV.start;
    GEOP = GEOV.vdpp;
    icv.pump.N = icv.N;
    AHEAD = GEOVL.act_c.ah;
    AROD = GEOVL.act_c.ar;
    icvl.act_c.v= 0; // Constraint
    icv.wfdstart= 0;
    icvl.ehsv.x = icv.x1_xehsv;

    // UBCs
    icvl.ehsv.wfs = 0;  // init
    icv.wfs = 0;        // init
    icv.wfr = 0;        // init
    icv.pa.wfr = 0;     // motionless
    icv.pa.wfh = 0;     // motionless
    icv.reg.wfde = 0;   // motionless init
    icv.reg.wflr = 0;   // motionless init
    icv.reg.wfld = 0;   // motionless init
    icv.reg.wfle = 0;   // motionless init
    icv.bias.wfr = 0;     // motionless init
    icv.bias.wfh = 0;     // motionless init
    icv.start.wf = 0;   // TODO: add start valve
    icv.start.wfvx = 0; // motionless init
    icv.prm = 0;
    icv.psm = 0;
    icv.wfrm = 0;
    icv.wfsm = 0;
    
    icv.epcham_count_max = 50;
    icv.epx_count_max = 50;
    icv.ebi_count_max = 50;
    icv.eprod_count_max = 20;
    icv.eall_count_max = 25;
    if ic.single_pass then
        icv.epcham_count_max = 1;
        icv.epx_count_max = 1;
        icv.ebi_count_max = 1;
        icv.eprod_count_max = 1;
        icv.eall_count_max = 1;
    end
    // xehsv loop
    // Inputs: pr, ps
    // Outputs: xehsv, prod, xbi, pd, xreg, disp, px, wfx, wflkout
    icv.eall = iterateInit(icvl.ehsv.x+0.006, icvl.ehsv.x-0.004, 200, 'xehsv_all'); 
    while ( (abs(icv.eall.e)>0.001 |...
        abs(icv.pr-icv.prm)>1e-6 | abs(icv.ps-icv.psm)>1e-6 |...
        abs(icv.wfr-icv.wfrm)>1e-3 | abs(icv.wfs-icv.wfsm)>1e-3 ) &...
        icv.eall.count<icv.eall_count_max) 
        icv.eall.count = icv.eall.count+1;
        icv.x1_xehsv = icv.eall.x;
        icvl.ehsv.x = icv.x1_xehsv;
        icv.wfrm = icv.wfr;
        icv.wfsm = icv.wfs;
        icv.prm = icv.pr;
        icv.psm = icv.ps;
        ic.wfr = icv.wfr;
        ic.wfs = icv.wfs;
        // Calculate ps and pr if either as input < 0
//        if Z.ps<0 | Z.pr<0 | (MOD.fullUp & Z.data.enable & Z.data.SOURCE) | (MOD.fullUp & ~(Z.data.enable & ~(Z.data.use.pr|Z.data.use.ps)))
        if 1
            [ic, GEO] = solve_MAIN(ic, GEO, FP);
            ic.pr = ic.pb1;
            ic.ps = ic.pb2;
            ic.xn25 = ic.eng.xn25;
            icv.filt = ic.ebp.filt;
            icv.vo_pb1 = ic.ebp.vo_pb1;
            icv.vo_pb2 = ic.ebp.vo_pb2;
        else
            ic.pr = Z.pr;
            ic.ps = Z.ps;
            ic.xn25 = Z.xn25;
        end
        icv.pr = ic.pr;
        icv.ps = ic.ps;
        icvl.ehsv.adh = lookup(icvl.ehsv.x, GEOVL.ehsv.awin_dh);
        icvl.ehsv.ash = lookup(-icvl.ehsv.x, GEOVL.ehsv.awin_sh);
        icvl.ehsv.adr = lookup(-icvl.ehsv.x, GEOVL.ehsv.awin_dr);
        icvl.ehsv.asr = lookup(icvl.ehsv.x, GEOVL.ehsv.awin_sr);
        // prod loop
        // Inputs: pr, ps, xehsv 
        // Outputs: prod, xbi, pd, xreg, disp, px, wfx, wflkout
        // icv.eprod = iterateInit(6000, 0, 1, 'prod_prodVol'); DAG 4/26/2017
        icv.eprod = iterateInit(6000, icv.ps, 1, 'prod_prodVol');
        while (abs(icv.eprod.e) > 1e-15 & icv.eprod.count<icv.eprod_count_max & abs(icv.eprod.dx)>0)
            icv.eprod.count = icv.eprod.count+1;
            icv.x2_prod = icv.eprod.x;
            icv.phead = (icv.x2_prod*AROD - icvl.fxven + icv.pamb*(AHEAD-AROD))/AHEAD;
            icvl.ehsv.wfhd = or_aptow(icvl.ehsv.adh, icv.phead, icv.ps, GEOVL.ehsv.cd_, FP.sg);
            icvl.ehsv.wfrd = or_aptow(icvl.ehsv.adr, icv.x2_prod, icv.ps, GEOVL.ehsv.cd_, FP.sg);
            icvl.wfb = or_aptow(GEOVL.act_c.ab, icv.x2_prod, icv.phead, GEOVL.act_c.cd_, FP.sg);
            icvl.wfrl = or_aptow(GEOVL.act_c.arl, icv.x2_prod, icv.ps, GEOVL.act_c.cd_, FP.sg);
            icvl.wfhl = or_aptow(GEOVL.act_c.ahl, icv.phead, icv.ps, GEOVL.act_c.cd_, FP.sg);

            // xbi loop
            // Inputs: pr, ps, prod, ehsv.wfs
            // Outputs: xbi, pd, xreg, disp, px, wfx, wflkout
            icv.ebi = iterateInit(GEOV.bias.xmax, GEOV.bias.xmin, 1, 'xbi_ebi');
            while (abs(icv.ebi.e) > 1e-13 & icv.ebi.count<icv.ebi_count_max & abs(icv.ebi.dx)>0)
                icv.ebi.count = icv.ebi.count+1;
                icv.bias.x = icv.ebi.x;
                icv.x3_xbi = icv.ebi.x;

                // pd loop
                // Inputs: pr, ps, prod, ehsv.wfs, xbi
                // Outputs: pd, xreg, disp, px, wfx, wflkout, wfr, wfs
                // icv.pump.pd = icv.x4_pd;
                icv.epx = iterateInit(6000, icv.ps, 1, 'pd_epx');
                while (abs(icv.epx.e ) > 1e-11 & icv.epx.count<icv.epx_count_max & abs(icv.epx.dx)>0)
                    icv.epx.count = icv.epx.count+1;
                    icv.pump.pd = icv.epx.x ;
                    icv.x4_pd = icv.epx.x ;

                    // Pump disp loop
                    // Inputs: pr, ps, pd, prod, ehsv.wfs, xbias
                    // Outputs: xreg, disp, px, wfx, wflkout
                    icv.reg.x = max(min(((icv.x4_pd-icv.ps)*RGEO.ahs + RGEO.fs - GEOV.fsb - GEOV.ksb*icv.bias.x)/(GEOV.ksb+RGEO.ks), RGEO.xmax), RGEO.xmin);
                    icv.x_xreg = icv.reg.x;
                    icv.pump.N = icv.N;
                    icv.pump.ps = icv.ps;
                    [RGEO.as, RGEO.ad] = calc_regwin_a(icv.reg.x);
                    icvl.ehsv.wfllk = GEOVL.ehsv_klk * FP.sg *((icv.x4_pd - icv.ps) / FP.avis)^GEOVL.ehsv_powlk;
                    icvl.ehsv.wfsh = or_aptow(icvl.ehsv.ash, icv.x4_pd, icv.phead, GEOVL.ehsv.cd_, FP.sg);
                    icvl.ehsv.wfsr = or_aptow(icvl.ehsv.asr, icv.x4_pd, icv.x2_prod, GEOVL.ehsv.cd_, FP.sg);
                    icvl.ehsv.wflk = abs(la_kptow(GEOVL.ehsv.kel, icv.x4_pd, icv.ps, FP.kvis));
                    icvl.ehsv.wfj = abs(or_aptow(GEOVL.ehsv.ael, icv.x4_pd, icv.ps, GEOVL.ehsv.cdl, FP.sg));
                    icvl.ehsv.wfr = icvl.ehsv.wfsr - icvl.ehsv.wfrd;
                    icvl.ehsv.wfh = icvl.ehsv.wfsh - icvl.ehsv.wfhd;
                    icvl.ehsv.wfd = icvl.ehsv.wflk + icvl.ehsv.wfj + icvl.ehsv.wfrd + icvl.ehsv.wfhd;
                    icvl.ehsv.wfs = icvl.ehsv.wflk + icvl.ehsv.wfj + icvl.ehsv.wfsr + icvl.ehsv.wfsh;
                    icvl.wfl = icvl.ehsv.wfs + icvl.ehsv.wfllk;
                    icv.epcham = iterateInit(0.30, 0.02, 1, 'disp_pcham');
                    while (abs(icv.epcham.e ) > 1e-15 & icv.epcham.count<icv.epcham_count_max & abs(icv.epcham.dx)>0)
                        icv.epcham.count= icv.epcham.count+1;
                        icv.pump.disp = icv.epcham.x;
                        icv.x5_disp = icv.pump.disp;
                        icv.pump = calc_pos_pump_a(GEOP, icv.pump, FP); // inputs: N, pd, ps, disp // outputs: wf
                        icv.pump.pa.x = asin(icv.pump.disp/ GEOV.vdpp.cdv);
                        icv.pump.theta = 180 /  %pi * icv.pump.pa.x;
                        icv.tqrs = lookup_super_short(icv.pump.theta, GEOV.vlink.ytqrs);
                        icv.ftpa = lookup_super_short(icv.pump.theta, GEOV.vlink.ytqa) * PAGEO.ah / GEOV.vlink.cftpa;
                        icv.tqpv = GEOV.vlink.ctqpv * (icv.x4_pd - icv.ps);
                        icv.tqa = icv.tqrs + icv.tqpv;
                        icv.px = icv.ps + icv.tqa/icv.ftpa;
                        icv.x_px = icv.px;
                        icv.pa.x = icv.pump.pa.x;
                        icv.reg.wfs = or_aptow(RGEO.as, icv.x4_pd, icv.px, RGEO.cd, FP.sg);
                        icv.reg.wfd = or_aptow(RGEO.ad, icv.px, icv.ps, RGEO.cd, FP.sg);
                        icv.reg.wfx = icv.reg.wfs - icv.reg.wfd;
                        icv.wfx = icv.reg.wfx;

                        icv.epcham.e = (icv.pump.wf - icv.reg.wfs - icvl.ehsv.wfs - icvl.ehsv.wfllk);
                        icv.epcham = iterate(icv.epcham, ic.verbose>3, 6, 0);
                    end // epcham

                    icv.x_disp = icv.epcham.x;
                    icv.e_regf = 0;
                    icv.e_px = 0;
                    icv.wflkout = la_lrecptow(GEOV.leako.l, GEOV.leako.r, GEOV.leako.ecc, GEOV.leako.rad_clear, icv.px, icv.ps, FP.kvis);
                    icv.epx.e = -(icv.wflkout - icv.wfx);
                    icv.epx = iterate(icv.epx, ic.verbose>3, 6, 0);
                    if ic.verbose>4 then
                        mprintf('x5_disp=%12.8f, x4_pd=%12.8f, x3_xbias=%12.8f, x2_prod=%12.8f, x1_xehsv=%12.8f\n', icv.x5_disp, icv.x4_pd, icv.x3_xbi, icv.x2_prod, icv.x1_xehsv);
                        mprintf('ps=%12.8f, pr=%12.8f, N=%12.8f, startwf=%12.8f, x_reg=%12.8f\n', icv.ps, icv.pr, icv.N, icv.start.wf, icv.x_xreg);
                    end
                end // epx


                icv.ebi.e = ((icv.bias.x+icv.reg.x)*GEOV.ksb - (icv.x2_prod-icv.ps)*(BIGEO.ah-BIGEO.ar) + GEOV.fsb);
                icv.ebi = iterate(icv.ebi, ic.verbose>3, 6, 1);
            end // ebi

            icv.eprod.e = -(icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfb - icvl.wfrl);
            icv.eprod = iterate(icv.eprod, ic.verbose>2, 5, 1);
        end // eprod

        icv.wfs = icv.pump.wf + icv.pa.wfr - icv.reg.wfd - icv.reg.wfde + icv.reg.wflr - icv.reg.wfld -...
        icv.reg.wfle + icv.bias.wfh + icv.bias.wfr - icv.start.wfvx - icv.wflkout;
        icv.wfr = icvl.ehsv.wfd + icvl.ehsv.wfllk + icvl.wfrl + icvl.wfhl;
        ic.wfr = icv.wfr;
        ic.wfs = icv.wfs;
        icv.eall.e = -(icvl.ehsv.wfsh - icvl.ehsv.wfhd + icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfrl - icvl.wfhl);
//        icv.eall = iterate(icv.eall, ic.verbose-MOD.linearizing>2, 12, 1); // Poorly behaved, use successive approximations (16)
        icv.eall = iterate(icv.eall, ic.verbose>2, 12, 1); // Poorly behaved, use successive approximations (16)
        if ic.verbose>4, mprintf('p-prm,ps-psm,wfr-wfrm,wfs-wfsm=%f,%f,%f,%f\n', icv.pr-icv.prm, icv.ps-icv.psm, icv.wfr-icv.wfrm, icv.wfs-icv.wfsm); end
    end // eall


    // This recalculation makes a useful double-check of the script
    icv.e1_eall = -(icvl.ehsv.wfsh - icvl.ehsv.wfhd + icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfrl - icvl.wfhl);
    icv.e2_eprod = -(icvl.ehsv.wfsr - icvl.ehsv.wfrd - icvl.wfb - icvl.wfrl);
    icv.e3_ebi = ((icv.bias.x+icv.reg.x)*GEOV.ksb - (icv.x2_prod-icv.ps)*(BIGEO.ah-BIGEO.ar) + GEOV.fsb);
    icv.e4_epx = -(icv.wfx - icv.wflkout);
    icv.e5_epcham = (icv.pump.wf - icv.reg.wfs - icvl.ehsv.wfs - icvl.ehsv.wfllk);
    icv.e_regf = -((icv.x4_pd-icv.ps)*RGEO.ahs + RGEO.fs - GEOV.fsb - GEOV.ksb*icv.bias.x - (GEOV.ksb+RGEO.ks)*icv.reg.x);
    icv.e_pumpf = (icv.px-icv.ps)*icv.ftpa - icv.tqa;

    // Assign
    icv.disp = icv.x_disp;
    icv.pd = icv.x4_pd;
    icv.prod = icv.x2_prod;
    icvl.mA = icvl.ehsv.x/GEOVL.ehsv.kix + GEOVL.ehsv.mAnull;
    icv.mA = icvl.mA;
    icv.vo_pcham.p = icv.x4_pd;
    icv.vo_pcham.wf = icv.pump.wf;
    icv.vo_px.p = icv.px;
    icv.vo_px.wf = icv.wflkout;
    icvl.vo_hcham.p = icv.phead;
    icvl.vo_hcham.wf= 0;
    icvl.vo_rcham.p = icv.x2_prod;
    icvl.vo_rcham.wf= 0;
    icvl.hline.p = icv.phead;
    icvl.hline.wf = -(icvl.ehsv.wfhd-icvl.ehsv.wfsh);
    icvl.rline.p = icv.x2_prod;
    icvl.rline.wf = icvl.ehsv.wfsr-icvl.ehsv.wfrd;
    icv.wfl = icvl.ehsv.wfs + icvl.ehsv.wfllk + icv.start.wf;

//    ic.F.VEN_LOAD_X = icv.fxven + Z.dFXVENX;
//    ic.F.A8_TM_DEM = icv.mA;
//    ic.F.VEN_LOAD_Xl = max(min(ic.F.VEN_LOAD_X, max(F.A8_GAIN_SCH_Y)), min(F.A8_GAIN_SCH_Y));
//    ic.F.VEN_LOAD_Xln= max(min(ic.F.VEN_LOAD_X, max(F.A8_NULL_SHIFT(:,1))), min(F.A8_NULL_SHIFT(:,1)));
//    ic.F.A8_GAIN = interp2(F.A8_GAIN_SCH_X, F.A8_GAIN_SCH_Y, F.A8_GAIN_SCH_Z', 0, ic.F.VEN_LOAD_Xl);
//    ic.F.A8_NULL = interp1(F.A8_NULL_SHIFT(:,1), F.A8_NULL_SHIFT(:,2), ic.F.VEN_LOAD_Xln); 
//    ic.F.A8_ERR = (ic.F.A8_NULL+F.A8_NULL_ADJ-ic.F.A8_TM_DEM)/F.A8_GAIN_ADJ/ic.F.A8_GAIN;
//    ic.F.A8_REF = (4.7-Z.xven)/4.7*100 - ic.F.A8_ERR;

    if ic.verbose>2
        mprintf('%s: ', sfilename());
        mprintf('%12.8f, %12.8f, %12.8f, %12.8f, %12.8f, %12.8f, %12.8f,', icv.x1_xehsv, icv.x2_prod, icv.x3_xbi, icv.x4_pd, icv.x5_disp, icv.x_xreg, icv.x_px);
        mprintf('-->');
        mprintf('%12.8f, %12.8f, %12.8f, %12.8f, %12.8f, %12.8f, %12.8f,', icv.e1_eall, icv.e2_eprod, icv.e3_ebi, icv.e4_epx, icv.e5_epcham, icv.e_regf, icv.e_pumpf); mprintf('\n');
    end

    // Re-assign
    ic.ven = icv;
    ic.ven.load = icvl;
endfunction
