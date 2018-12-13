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



function [J] = rt_jacobn(robot, q)
// File name:       rt_jacobn.sci
//
// Function:        rt_jacobn
//
// Description:     compute manipulator Jacobian in end-effector coordinate frame
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/jacobn.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    n = robot.n;
    L = robot.links;

    J = [];
    U = robot.tool;
    for j=n:-1:1,

        if robot.mdh == 0 then              // standard DH convention
            U = L(j)( q(j) ) * U;
        end

        // revolute axis
        if L(j).RP == "R" then
            d = [-U(1,1)*U(2,4)+U(2,1)*U(1,4);..
                -U(1,2)*U(2,4)+U(2,2)*U(1,4);..
                -U(1,3)*U(2,4)+U(2,3)*U(1,4)];
            delta = U(3,1:3)';  // nz oz az

        // prismatic axis
        else
            d = U(3,1:3)';      // nz oz az
            delta = zeros(3,1); // 0  0  0

        end
        J = [[d; delta] J];

        if robot.mdh ~= 0 then              // modified DH convention
            U = L(j)( q(j) ) * U;
        end
    end

endfunction
