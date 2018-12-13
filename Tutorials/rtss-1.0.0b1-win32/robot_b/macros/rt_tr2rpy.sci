// Copyright (C) 1993-2002, by Peter I. Corke
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



function [rpy] = rt_tr2rpy(m)
// File name:       rt_tr2rpy.sci
//
// Function:        rt_tr2rpy
//
// Description:     homogeneous transform to roll/pitch/yaw angles
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  tolerance modified to 10*eps.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/tr2rpy.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    // tolerance
    tol = 10 * %eps;

    rpy = zeros(1,3);

    if abs(m(1,1)) < tol & abs(m(2,1)) < tol then
        // singularity
        rpy(1) = 0;
        rpy(2) = atan(-m(3,1), m(1,1));
        rpy(3) = atan(-m(2,3), m(2,2));
    else
        rpy(1) = atan(m(2,1), m(1,1));
        sp = sin(rpy(1));
        cp = cos(rpy(1));
        rpy(2) = atan(-m(3,1), cp * m(1,1) + sp * m(2,1));
        rpy(3) = atan(sp * m(1,3) - cp * m(2,3), cp*m(2,2) - sp*m(1,2));
    end

endfunction
