function [flag,na] = istito(sys)
// ISTITODetermine whether argument is a TITO system.
// 
// Syntax: FLAG = ISTITO(SYS) or
//         [FLAG,NA] = ISTITO(SYS)
// 
// Purpose:The function ISTITO determines whether the packed matrix
//is in SISO or TITO form.  It may also be asked to return
//the state dimension of the system.
// 
// Input:SYS  - a packed matrix system
// 
// Output:FLAG - one of two values:
//  0 - SYS is SISO
//  1 - SYS is TITO
//NA   - state dimension of SYS
// 
// See Also:
// Called By: STAR_SS
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
flag=[];
na=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// 
// Calculations
// 
num = max(size(mtlb_find(mtlb_all(~(abs(sys)<%inf)))));
if num==2 then
  // dynamic TITO case
  flag = 1;
  na = mtlb_s(mtlb_find(mtlb_all(isnan(sys))),1);
else
  if num==1 then
    if isempty(mtlb_find(mtlb_all(isnan(sys)))) then
      // static TITO case
      flag = 1;
      na = 0;
    else
      // dynamic SISO case
      flag = 0;
      na = mtlb_s(mtlb_find(mtlb_all(isnan(sys))),1);
    end;
  else
    // static SISO case
    flag = 0;
    na = 0;
  end;
end;
endfunction
