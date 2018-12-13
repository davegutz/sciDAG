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



function [x, y, z] = rt_cylinder(r, n)
// File name:       rt_cylinder.sci
//
// Function:        rt_cylinder
//
// Description:     generate cylinder
//
// Annotations:     Scilab equivalent for MATLAB(R) function cylinder is missing.
//                  This code implements a simple emulator of that function.
//                  Extremely simple, returns the x-, y- and z-coordinates of a cylinder
//                  with a radius r. The cylinder has n equally spaced points around its
//                  circumference.
//
// References:      MATLAB(R), toolbox/matlab/specgraph/cylinder.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    r = [r; r];

    theta = (0:n)/n*2*%pi;
    sin_theta = sin(theta);
    sin_theta(n+1) = 0;

    x = r * cos(theta);
    y = r * sin_theta;
    z = (0:1)' * ones(1,n+1);

endfunction
