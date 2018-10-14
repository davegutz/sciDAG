function [sys] = lti_m_valve_a(pd,ps,wf)

// Output variables initialisation (not found in input variables)
sys=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// function sys = lti_m_valve_a(pd, ps, wf)
// Building block for a metering valve.  Square law orifice.
// Version with ps and pd inputs.
// Author:       D. A. Gutz
// Written:      19-Aug-92
// Revisions:    none.
// Input:
// pd        Discharge pressure, psia.
// ps        Supply pressure, psia.
// wf        Discharge flow out, pph.
// Output:
// sys       Packed system of Input and Output.
// Differential IO:
// ps        Input # 1, supply pressure, psia.
// pd        Input # 2, discharge pressure, psia.
// wfdem     Input # 3, metering valve area in flow units, pph.
// wf        Output # 1, discharge flow out, pph.
// 
// Local:
// dwdp        Sensitivity pressure to flow, pph/psi.
// 
// States:
// none.
// 
// Functions called:
// or_wptoa    Orifice calculation.

// Parameters.
// none.

// Partials.
dwdp = wf/(2*mtlb_s(ps,pd));


// Connections and system construction.
a = [];
b = [];
c = [];
e = [dwdp,-dwdp,1];
sys = pack_ss(a,b,c,e);
endfunction