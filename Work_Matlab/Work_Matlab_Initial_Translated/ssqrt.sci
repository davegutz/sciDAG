function [y] = ssqrt(x) // SSQRT.Signed square root.

// Output variables initialisation (not found in input variables)
y=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

//  Author:D. A. Gutz
//  Written:22-Jun-92
//  Revisions:None.

//  Input:
//  xReal number.

//  Output:
//  ysign(x) * sqrt(abs(x))

//  Perform:
y = sign(x)*sqrt(abs(x));
endfunction
