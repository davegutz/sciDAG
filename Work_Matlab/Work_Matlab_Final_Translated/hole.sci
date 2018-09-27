function [area] = hole(x,d) // @(#)hole.m 1.2 93/06/22
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
// Sep 26, 2018 	DA Gutz		Created
// 
//**********************************************************************


// Output variables initialisation (not found in input variables)
area=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);


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
