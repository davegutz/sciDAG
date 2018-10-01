function [sys] = lti_pos_pump(cs,ct,cn,ps,pd,rpm,%disp,kvis,sg)

// Output variables initialisation (not found in input variables)
sys=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// POS_PUMP.Positive displacement pump model.
// Author:D. A. Gutz
// Written:19-Aug-92
// Revisions:None.
// 
// Input:
// csLaminar slip flow coefficient.
// ctTurbulent slip flow coefficient. 
// cnSpeed slip flow coefficient.
// dispDisplacement, cuin/rev.
// psSupply, psia.
// pdDischarge, psia.
// kvisKinematic viscosity, centistokes.
// sgSpecific gravity.

// Differential IO:
// psInput # 1, supply pressure, psi.
// pdInput # 2, discharge pressure, psi.
// rpmInput # 3, speed, rpm.
// dispInput # 4, displacement, cuin/rev.
// wfOutput # 1, flow, pph.

// Output:
// sysPacked system of Input and Output.

// Local:
// qConnection matrix.
// uInput matrix.
// yOutput matrix.

// States:
// none.

// Functions called:
// None.

// Parameters.
// avisAbsolute viscosity, lbf-sec/sqin.
// cisFlow, cis.
// dwdcConversion cis to pph.
// eff_volVolumetric efficiency.
// mtdqpavis * rad/sec / pl, dimensionless speed factor.
// plLoad, psi.
// wfFlow, pph.

avis = ((0.00009312*0.00155)*sg)*kvis;
dwdc = 129.93948*sg;
pl = mtlb_s(pd,ps);
mtdqp = ((avis*0.10471976)*rpm)/pl;
eff_vol = mtlb_s(mtlb_s(mtlb_s(1,cs/mtdqp),(((ct*1825)*ssqrt(pl/sg))/rpm)/(%disp^0.3333)),cn);
cis = ((eff_vol*%disp)*rpm)/60;
wf = cis*dwdc;//#ok<NASGU>

// Partials.
dwfdcis = dwdc;
dcisdeff_vol = (%disp*rpm)/60;
deff_voldpl = (((((-ct)*1825)/sqrt(sg))/(2*sqrt(abs(pl))))/rpm)/(%disp^0.333);
dpldps = -1;
dpldpd = 1;
deff_voldmtdqp = cs/(mtdqp^2);
deff_volddisp = ((((0.33333*ct)*1825)*ssqrt(pl/sg))/rpm)/(%disp^1.333);
dmtdqpdpl = (-mtdqp)/pl;
dmtdqpdrpm = mtdqp/rpm;
dcisdrpm = cis/rpm;
dcisddisp = cis/%disp;

dwfdps = (dwfdcis*dcisdeff_vol)*mtlb_a(deff_voldpl*dpldps,(deff_voldmtdqp*dmtdqpdpl)*dpldps);

dwfdpd = (dwfdcis*dcisdeff_vol)*mtlb_a(deff_voldpl*dpldpd,(deff_voldmtdqp*dmtdqpdpl)*dpldpd);

dwfdrpm = dwfdcis*mtlb_a(dcisdrpm,(dcisdeff_vol*deff_voldmtdqp)*dmtdqpdrpm);

dwfddisp = dwfdcis*mtlb_a(dcisddisp,dcisdeff_vol*deff_volddisp);

// Connections and system construction.
asys = [];
bsys = [];
csys = [];
// ! L.80: mtlb(dwfdpsdwfdpddwfdrpmdwfddisp) can be replaced by dwfdpsdwfdpddwfdrpmdwfddisp() or dwfdpsdwfdpddwfdrpmdwfddisp whether dwfdpsdwfdpddwfdrpmdwfddisp is an M-file or not.
esys = mtlb(dwfdpsdwfdpddwfdrpmdwfddisp);
endfunction
