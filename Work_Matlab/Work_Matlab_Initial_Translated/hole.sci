function [area] = hole(x,d) // @(#)hole.m 1.2 93/06/22

// Output variables initialisation (not found in input variables)
area=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// HOLE.Calculate hole area as a function of uncovered length.
// Author:     Dave Gutz 09-Jun-90.
// Revisions:  None.

// Inputs:
// xSpool edge relative to start of hole.
// dHole diameter.

// Local:
// rHole radius.
// fracFraction of hole uncovered.
// fracFraction of hole uncovered.

r = d/2;
x = mtlb_max(mtlb_min(x,mtlb_s(d,1.000000000D-16)),1.000000000D-16);
frac = mtlb_s(1,x/r);

if mtlb_logic(frac,">",1.000000000D-16) then
  area = atan(sqrt(mtlb_s(1,frac*frac))/frac);
else
  if mtlb_logic(frac,"<",-1.000000000D-16) then
    area = mtlb_a(%pi,atan(sqrt(mtlb_s(1,frac*frac))/frac));
  else
    area = %pi/2;
  end;
end;
area = mtlb_s((r*r)*area,mtlb_s(r,x)*sqrt(x*mtlb_s(2 .*r,x)));
area = mtlb_max(area,1.000000000D-16);
endfunction
