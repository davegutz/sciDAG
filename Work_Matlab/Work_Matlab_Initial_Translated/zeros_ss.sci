function [sys] = zeros_ss(n,m) //function sys = zeros_ss(n,m);

// Output variables initialisation (not found in input variables)
sys=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// Wrapper for isicles functions to avoid error return for 0 index.
// D. Gutz 1/27/04
// Inputs:
// same as matlab zeros function.
// Outputs:
// same as matlab zeros function.

if mtlb_logic(mtlb_double(n),"==",0) & mtlb_logic(mtlb_double(m),"<>",0) | mtlb_logic(mtlb_double(n),"<>",0) & mtlb_logic(mtlb_double(m),"==",0) then
  sys = [];
else
  sys = zeros(mtlb_double(n),mtlb_double(m));
end;
endfunction
