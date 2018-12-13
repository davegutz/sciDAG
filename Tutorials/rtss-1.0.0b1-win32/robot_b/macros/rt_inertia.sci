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



function [M] = rt_inertia(robot, q)
// File name:       rt_inertia.sci
//
// Function:        rt_inertia
//
// Description:     compute the manipulator joint-space inertia matrix
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  Avoided the use of cat function, for efficiency.
//                  Avoided repeated calls to functions ones(), zeros(), eye(), for
//                  efficiency.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/inertia.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    n = robot.n;
    C = ones(n,1);
    Z = zeros(n,n);
    I = eye(n,n);
    G = [0; 0; 0];
    M = [];

    for i = 1:size(q,1),
        M(:, :, i) = rt_frne(robot, C*q(i,:), Z, I, G);
    end

endfunction
