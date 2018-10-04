function [y] = is_real_matrix(x)

// Output variables initialisation (not found in input variables)
y=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// Copyright (C) 2011-2014 L. Markowsky <lmarkov@users.sourceforge.net>
// 
// This file is part of the fuzzy-logic-toolkit.
// 
// The fuzzy-logic-toolkit is free software; you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
// 
// The fuzzy-logic-toolkit is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with the fuzzy-logic-toolkit; see the file COPYING.  If not,
// see <http://www.gnu.org/licenses/>.
// 
// Return 1 if var(x).entries is a non-empty matrix of real or integer-valued scalars,
// and return 0 else.
// 
// Examples:
// is_real_matrix(6)            ==> 0
// is_real_matrix([])           ==> 0
// is_real_matrix([1 2; 3 4])   ==> 1
// is_real_matrix([1 2 3])      ==> 1
// is_real_matrix([i 2 3])      ==> 0
// is_real_matrix(""""hello"""")      ==> 0
// Author:        L. Markowsky
// Keywords:      fuzzy-logic-toolkit fuzzy private parameter-test
// Directory:     fuzzy-logic-toolkit/inst/private/
// Filename:      is_real_matrix.m
// Last-Modified: 20 Aug 2012

// !! L.36: Unknown function ismatrix not converted, original calling sequence used.

if ~ismatrix(x) then
  y = 0;
else
  y = 1;
  // !! L.40: Matlab function numel not yet converted, original calling sequence used.

  for i = mtlb_imp(1,numel(x))
    %v03 = %f;  if or(type(mtlb_e(x,i))==[1,5,8]) then %v03 = sum(length(mtlb_e(x,i)))==1;end;
    if ~%v03 & isreal(mtlb_e(x,i),0) then
      y = 0;
    end;
  end;
end;

// ! L.47: mtlb(resume) can be replaced by resume() or resume whether resume is an M-file or not.
mtlb(resume)
endfunction
