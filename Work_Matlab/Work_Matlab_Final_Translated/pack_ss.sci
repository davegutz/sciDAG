function [sys] = pack_ss(a,b1,b2,c1,c2,e11,e12,e21,e22)
// PACK_SSForm a system from component matrices.
// 
// Syntax: SYS = PACK_SS(A,B1,B2,C1,C2,E11,E12,E21,E22) or ...
//         SYS = PACK_SS(A,B1,B2,C1,C2) or ...
//         SYS = PACK_SS(A,B,C,E) or ...
//         SYS = PACK_SS(A,B,C)
// 
// Purpose:The first version of PACK_SS ''packs'' a full set of
//nine matrices defining a TITO system into a single
//data element.  The function uses the NaN (not_a_number)
//symbol to denote partitioning between the A, B, C, and
//E sections and the Inf (infinity) symbol to denote
//partitioning between B1 and B2, C1 and C2, and E11, E12,
//E21, and E22.  If the A matrix is empty, a static system
//made up only of the partitioned E matrix is returned
// 
//The second version creates an appropiate identically zero 
//partitioned E matrix to complete the TITO system.
// 
//The third version ''packs'' the four matrices of a SISO
//state-space realization into a single data element using
//the NaN symbol to denote partitioning.
// 
//The fourth version creates an identically zero E matrix to
//complete the SISO system.
// 
// Input:A,B1,B2,C1,E11,E12,E21,E22 - Regular matrices denoting
//   the elements of a TITO state-space system, or ...
//A,B,C,E - Regular matrices denoting the elements of 
//   a SISO state-space system.
//(Note that the dimensions of these matrices must be 
//   conformable in either case.)
// 
// Output:SYS -  Resulting packed matrix system, with state
//   dimension equal to the dimension of A.
// 
// See Also:UNPACK_SS, MAT2SYS, SYS2MAT

// Calls: 
// 
// Called By:
//**********************************************************************
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

// Output variables initialisation (not found in input variables)
sys=[];

// Number of arguments in function call
[%nargout,%nargin] = argn(0)

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// 
// --- SISO case ---
// 
// Check Arguements
// 
if %nargin==3 | %nargin==4 then
  // 
  // Check dimensions of a, b, c
  // 
  b = b1;  c = b2;
  [ma,na] = size(a);  [mb,nb] = size(b);  [mc,nc] = size(c);
  if ma<>na | mb<>ma | nc<>na then
    error("Matrix dimensions are incompatible for packing")
  end;
  // 
  // Now check dimension of e matrix or build it with zeros
  // 
  if %nargin==3 then
    e = zeros(mc,nb);
  else
    e = c1;  [me,ne] = size(e);
    if me<>mc | ne<>nb & ~isempty(a) then
      error("Matrix dimensions are incompatible for packing")
    end;
  end;
  // 
  // Calculations
  // 
  if isempty(a) then
    sys = e;
  else
    sys = [a,%nan*ones(ma,1),b;%nan*ones(1,ma+1+nb);c,%nan*ones(mc,1),e];
  end;

  //**********************************************************************

  // 
  // --- TITO case ---
  // 
  // Check Arguments
  // 
else
  if %nargin==5 | %nargin==9 then
    // 
    // Check dimensions of a, b1, b2, c1, and c2 matrices
    // 
    [ma,na] = size(a);
    [mb1,nb1] = size(b1);  [mb2,nb2] = size(b2);
    [mc1,nc1] = size(c1);  [mc2,nc2] = size(c2);
  
    if ma<>na | mb1 & mb1<>ma | mb2 & mb2<>ma | mc1 & nc1<>na | mc2 & nc2<>na then
      error("Matrix dimensions are incompatible for packing")
    end;
    // 
    // Now build any missing e matrices and check e matrix dimensions
    // 
    if %nargin==5 then
      e11 = zeros(mc1,nb1);  e12 = zeros(mc1,nb2);
      e21 = zeros(mc2,nb1);  e22 = zeros(mc2,nb2);
    end;
    [me11,ne11] = size(e11);  [me12,ne12] = size(e12);
    [me21,ne21] = size(e21);  [me22,ne22] = size(e22);
    // 
    // when a is not empty we have the dynamic system case
    // 
    if ~isempty(a) then
      if mb1 & mc1 & me11<>mc1 | ne11<>nb1 | mb2 & mc1 & me12<>mc1 | ne12<>nb2 | mb1 & mc2 & me21<>mc2 | ne21<>nb1 | mb2 & mc2 & me22<>mc2 | ne22<>nb2 then
        error("Matrix dimensions are incompatible for packing")
      else
        if ~mb1 | ~mc1 & me11<>0 | ~mb2 | ~mc1 & me12<>0 | ~mb1 | ~mc2 & me21<>0 | ~mb2 | ~mc2 & me22<>0 then
          error("Matrix dimensions are incompatible for packing")
        end;
      end;
      // 
      // Calculation
      // 
      sys = [a,%nan*ones(ma,1),b1,%inf*ones(ma,1),b2;%nan*ones(1,na+nb1+nb2+2);c1,%nan*ones(mc1,1),e11,%inf*ones(mc1,1),e12;%inf*ones(1,na),%nan,%inf*ones(1,nb1+nb2+1);c2,%nan*ones(mc2,1),e21,%inf*ones(mc2,1),e22];
      // 
      // if a is empty we have the static system case
      // 
    else
      if me11 & me21 & ne11<>ne21 | ne11 & ne12 & me11<>me12 | ne21 & ne22 & me21<>me22 | me12 & me22 & ne12<>ne22 then
        error("Matrix dimensions incompatible for packing")
      end;
      // 
      // Calculation
      // 
      sys = [e11,%inf*ones(max([me11,me12]),1),e12;%inf*ones(1,max([ne11+ne12+1,ne21+ne22+1]));e21,%inf*ones(max([me21,me22]),1),e22];
    end;
  
    //**********************************************************************
  
    // 
    // If neither the normal case nor the TITO case, print error
    // 
  else
    error("Invalid number of input arguments to PACK_SS")
  end;
end;
endfunction
