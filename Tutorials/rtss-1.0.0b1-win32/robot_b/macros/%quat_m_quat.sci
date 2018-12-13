// Copyright (C) 1999-2002, by Peter I. Corke
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



function [qp] = %quat_m_quat(q1, q2)
// File name:       %quat_m_quat.sci
//
// Functions:       %quat_m_quat, * (star)
//
// Description:     multiply quaternion by quaternion
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@quaternion/mtimes.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    // Multiply unit-quaternion by unit-quaternion
    // decompose into scalar and vector components
    s1 = q1.s;
    v1 = q1.v;
    s2 = q2.s;
    v2 = q2.v;
    // form the product
    qp = rt_quaternion([s1*s2-v1*v2' s1*v2+s2*v1+rt_cross(v1,v2)']);

endfunction
