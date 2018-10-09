function [sys] = lti_ip_wpdtops(a,b,c,f,r1,b1,r2,b2,rpm,wf,sg,tau)

// Output variables initialisation (not found in input variables)
sys=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// function sys = ip_wpdtops(a, b, c, f, r1, b1, r2, b2, rpm, wf, sg, tau)
// Impeller model, flow and discharge pressure to supply.
// Author:   D. A. Gutz
// Written:  08-Jul-92
// Revisions:
//  19-Aug-92    DA Gutz     Simplify return arguments.
//  11-Apr-2014  DA Gutz     Add f coefficient
// 
// Input:
// a     Pump head coefficients.
// b              """"
// c              """"
// f              """"
// r1    Inner radius, in.
// b1    Inner disk width, in.
// r2    Outer radius, in.
// b2    Outer disk width, in.
// rpm   Speed.
// wf    Flow, pph.
// sg    Specific gravity.
// tau   Time constant, sec.
// 
// Differential IO:
// wf  Input  # 1, flow, pph.
// pd  Input  # 2, discharge pressure, psi.
// rpm Input  # 3, speed, rpm.
// ps  Output # 1, supply pressure, psi.
// 
// Output:
// sys   Packed system of Input and Output.
// 
// Local:
// dfcdwf    Flow coefficient due to flow, 1/pph.
// dhcdfc    Head coefficient due to flow coefficient.
// dpdhc     Pressure due to head coefficient, psi.
// dfcdrpm   Flow coefficient due to speed, 1/rpm.
// dwdc      Conversion cis to pph.
// fc        Flow coefficient.
// q         Connection matrix.
// u         Input matrix.
// y         Output matrix.
// 
// States:
// none.
// 
// Functions called:
// None.

// Parameters.
dwdc = 129.93948*sg;
fc = (5.851*wf)/((((dwdc*3.85)*b2)*(r2^2))*rpm);
// hc = a + (b + (c + f*fc)*fc)*fc;
// dp = 1.022e-6 * hc * sg * (r2^2 - r1^2) * rpm^2;

// Partials.
dfcdwf = fc/wf;
dhcdfc = mtlb_a(mtlb_a(b,(2*c)*fc),(3*f)*(fc^2));
dpdhc = ((0.000001022*sg)*mtlb_s(r2^2,r1^2))*(rpm^2);
dfcdrpm = (-fc)/rpm;

// Connections and system construction.
as = -1/tau;
bs = [((dfcdwf*dhcdfc)*dpdhc)/tau,0,((dfcdrpm*dhcdfc)*dpdhc)/tau];
cs = -1;
es = [0,1,0];
sys = pack_ss(as,bs,cs,es);
endfunction
