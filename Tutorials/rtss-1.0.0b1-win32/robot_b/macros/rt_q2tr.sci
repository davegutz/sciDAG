// Copyright (C) 1993  Peter Corke
// Copyright (C) 2007  Interdepartmental Research Center "E. Piaggio", University of Pisa
//
// This file is part of RTSS, the Robotics Toolbox for Scilab/Scicos.
//
// RTSS is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// RTSS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with RTSS; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA



function [t] = rt_q2tr(q)
// File name:       rt_q2tr.sci
//
// Function:        rt_q2tr
//
// Description:     convert unit-quaternion to homogeneous transform
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@quaternion/subsref.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    q = double(q);
    s = q(1);
    x = q(2);
    y = q(3);
    z = q(4);

    r = [1-2*(y^2+z^2) 2*(x*y-s*z) 2*(x*z+s*y); 2*(x*y+s*z) 1-2*(x^2+z^2) 2*(y*z-s*x); 2*(x*z-s*y) 2*(y*z+s*x) 1-2*(x^2+y^2)];
    t = eye(4,4);
    t(1:3,1:3) = r;
    t(4,4) = 1;

endfunction
