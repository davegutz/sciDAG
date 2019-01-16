// Copyright (C) 2009-2016   Lukas F. Reichlin
//
// This file is part of LTI Syncope.
//
// LTI Syncope is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// LTI Syncope is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with LTI Syncope.  If not, see <http://www.gnu.org/licenses/>.
//
// Problem: Solve the system equations of
//   .
// E x(t) = A x(t) + B e(t)
//
//   y(t) = C x(t) + D e(t)
//
//   e(t) = u(t) + M y(t)
//
// in order to build
//   .
// K x(t) = F x(t) + G u(t)
//
//   y(t) = H x(t) + J u(t)
//
// Solution: Laplace Transformation
// E s X(s) = A X(s) + B U(s) + B M Y(s)                     [1]
//
//     Y(s) = C X(s) + D U(s) + D M Y(s)                     [2]
//
// solve [2] for Y(s)
// Y(s) = [I - D M]^(-1) C X(s)  +  [I - D M]^(-1) D U(s)
//
// substitute Z = [I - D M]^(-1)
// Y(s) = Z C X(s) + Z D U(s)                                [3]
//
// insert [3] in [1], solve for X(s)
// X(s) = [s E - (A + B M Z C)]^(-1) (B + B M Z D) U(s)      [4]
//
// inserting [4] in [3] finally yields
// Y(s) = Z C [s E - (A + B M Z C)]^(-1) (B + B M Z D) U(s)  +  Z D U(s)
//        \ /    |   \_____ _____/       \_____ _____/          \ /
//         H     K         F                   G                 J
//
// Author: Lukas Reichlin <lukas.reichlin@gmail.com>
// Created: September 2009
// October 2019  Dave Gutz  Add unpack_ss option.
// Version: 0.3.1
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
// Oct 4, 2018  DA Gutz Created
function [sys] = sys_connect(sys, m)
  a = sys.a;
  b = sys.b;
  c = sys.c;
  d = sys.d;
  [rows, cols] = size(d);
  z = eye(rows,rows) - d*m;
  if(rcond(z) >= %eps)  // check for singularity
    sys.a = a + b*m/z*c;  // F
    sys.b = b + b*m/z*d;  // G
    sys.c = z\c;          // H
    sys.d = z\d;          // J
    // sys.e remains constant: [] for ss models, e for dss models
  else
    // construct descriptor model
    // try to introduce the least states
    [pp, mm] = size (d);
    [n, cols] = size(a);
//    try
//        temp = sys.e;
//    catch
//      sys.e = eye(n,n);
//    end
    if(mm <= pp)
      // Introduce state variable e = u + My
      //   .
      // E x =  A x +      B e + 0 u
      //   .
      // 0 e = MC x + (MD-I) e + I u  
      //    
      //   y =  C x +      D e + 0 u
      //
      sys.a = [a, b; m*c, m*d-eye(mm,mm)];
      sys.b = [zeros(n,mm); eye(mm,mm)];
      sys.c = [c, d];
      sys.d = zeros (pp,mm);
      //sys.e = blkdiag (sys.e, zeros (mm,mm));
    else
      // Introduce state variable y
      //   .
      // E x = A x + BM y + B u
      //   .
      // 0 y = C x -  Z y + D u  
      //    
      //   y = 0 x +  I y + 0 u
      //          
      sys.a = [a, b*m; c, -z];
      sys.b = [b; d];
      sys.c = [zeros(pp,n), eye(pp,pp)];
      sys.d = zeros (pp,mm);
      //sys.e = blkdiag (sys.e, zeros (pp,pp));
    end
  end
  
endfunction
