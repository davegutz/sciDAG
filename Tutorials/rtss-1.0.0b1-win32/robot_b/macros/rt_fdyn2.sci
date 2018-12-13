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



function [yd] = rt_fdyn2(t, y, robot, torqfun, varargin)
// File name:       rt_fdyn2.sci
//
// Functions:       rt_fdyn2
//
// Description:     evaluate the robot velocity and acceleration for forward dynamics
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/fdyn2.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    n = robot.n;

    q = y(1:n);
    qd = y(n+1:2*n);

    // evaluate the torque function if one is given
    if ~isempty(torqfun) then

        execstr("[tau] = " + torqfun + "(t, q, qd, varargin(:));");

    else

        tau = zeros(n,1);

    end

    qdd = rt_accel(robot, q, qd, tau);
    yd = [qd; qdd];

endfunction
