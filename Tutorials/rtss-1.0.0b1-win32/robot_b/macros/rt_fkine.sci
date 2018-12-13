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



function [t] = rt_fkine(robot, q)
// File name:       rt_fkine.sci
//
// Functions:       rt_fkine
//
// Description:     compute the forward kinematics for a serial n-link manipulator
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/fkine.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    // evaluate fkine for each point on a trajectory of 
    // theta_i or q_i data
    n = robot.n;
    L = robot.links;

    if length(q) == n then          // q is a vector and it is interpreted as a joint state vector
        t = robot.base;
        for i=1:n,
            t = t * L(i)(q(i));
        end
        t = t * robot.tool;

    else                            // q is a matrix and each row is interpreted as a joint state vector 

        if size(q,2) ~= n then              // if numcol(q) ~= n then bad data
            error("bad data");
        end                                 // else...

        t = zeros(4,4,0);
        for qv=q',                                  // for each trajectory point
            tt = robot.base;
            for i=1:n,
                tt = tt * L(i)(qv(i));
            end
            t = cat(3, t, tt * robot.tool);
        end
    end

endfunction
