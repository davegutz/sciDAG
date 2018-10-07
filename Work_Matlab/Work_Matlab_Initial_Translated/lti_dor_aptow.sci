function [sys] = lti_dor_aptow(wf,ps,pd,%cd,sg)

// Output variables initialisation (not found in input variables)
sys=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// function sys = dor_aptow(wf, ps, pd, cd, sg);
// Differential area/pressure to flow for a square law orifice.
// Author:D. A. Gutz
// Written:22-Jun-92
// Revisions:19-Aug-92Simplify return arguments.
//               26-Nov-2012 add divide by zero protection%
// Input:
// cdCoefficient of discharge.
// pdDischarge pressure, psia.
// psSupply pressure, psia.
// sgSpecific gravity.
// wfFlow, pph.
// 
// Differential IO.
// psInput # 1, supply pressure, psia.
// pdInput # 2, discharge pressure, psia.
// a         Input # 3, area perturbation, sqin.
// wfOutput # 1, flow, pph.
// 
// Output:
// sysDifferential orifice model.

// Local:
// aoOrifice area, sqin.
// dwfdaPartial flow to area, pph/sqin.
// dwfdpPartial flow to pressure, pph/psi.

// States:
// none.

// Functions called:
// or_wptoaOrifice area.
// ssqrtSigned square root.

// Parameters.
ao = or_wptoa(wf,ps,pd,%cd,sg);

// Partials.
dwfda = wf/ao;
// !! L.41: Unknown function sgn not converted, original calling sequence used.
psmpd = sgn(mtlb_s(ps,pd))*mtlb_max(abs(mtlb_s(ps,pd)),1.000000000D-16);// 11/26/2012 add divide by zero protection
dwfdp = wf/(2*psmpd);

// Connections and system construction.
a = [];
b = [];
c = [];
// ! L.48: mtlb(dwfdpdwfda) can be replaced by dwfdpdwfda() or dwfdpdwfda whether dwfdpdwfda is an M-file or not.
e = [dwfdp,-mtlb(dwfdpdwfda)];

// Form the system.
endfunction
