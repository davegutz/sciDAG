function [sys] = lti_man_n_mm(l,a,vol,n,spgr,%beta,c)

// Output variables initialisation (not found in input variables)
sys=[];

// Number of arguments in function call
[%nargout,%nargin] = argn(0)

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// function sys = lti_man_n_mm(l, a, vol, n, spgr, beta, c)
// Building block for a line distributed among equally sized
// volumes and momentum slices, with momentum first & last (n = #
// of volume nodes and n+1 = # momentum slices).
// Author:       D. A. Gutz
// Written:      22-Oct-2012
// Input:
// a     Line cross-section, sqin.
// beta  Fluid bulk modulus, psi.
// l     Line length, in.
// n     Number of momentum slices.
// spgr  Fluid specific gravity.
// vol   Line volume, cuin.
// c     Damping, psi/in/sec, (OPTIONAL).
// 
//Output:
// sys   Packed lti
// 
// Differential I/O:
// ps    Input  # 1, supply pressure, psia.
// pd    Input  # 2, discharge pressure, psia.
// wfs   Output # 1, supply flow, pph.
// wfd   Output # 2, discharge flow, pph.
// 
// Functions called:
// man_1_mv  Create single element line of ps, wfd input and wfs, pd output.
// mom_1     Create single momentum slice of ps, pd input and wf output.

// Check size.
if mtlb_logic(n,"<",1) then
  error("Number of nodes < 1 in man_n_mm.")
end;

// Single manifold slice.
if %nargin==7 then
  man = lti_man_1_mv(l/mtlb_a(n,1),a,vol/n,spgr,%beta,c);
else
  man = lti_man_1_mv(l/mtlb_a(n,1),a,vol/n,spgr,%beta);
end;

// Single momentum slice.
endmom = lti_mom_1(l/mtlb_a(n,1),a);

// Inputs are ps and pd.
u = [1,mtlb_a(2*n,2)];

// Outputs are wfs and wfd.
y = [1,mtlb_a(2*n,1)];

// Connections and system construction.
temp = man;
q = [];
for i = mtlb_imp(2,n)
  temp = adjoin(temp,man);
  q = [q;2*(i-1),2*(i-1)+1;2*(i-1)+1,2*(i-1)];
end;
temp = adjoin(temp,endmom);
q = [q;2*n,mtlb_a(2*n,1);mtlb_a(2*n,1),2*n];

// Form the system.
// !! L.62: Unknown function connect_ss not converted, original calling sequence used.
sys = connect_ss(sys,q,u,y);
endfunction
