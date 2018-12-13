// Copyright (C) 1999-2002, by Peter I. Corke
// Copyright (C) 2007, 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function  [r2] = rt_perturb(r, p)
// File name:       rt_perturb.sci
//
// Function:        rt_perturb
//
// Description:     randomly modify some dynamic parameters
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/perturb.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-07-04 20:17:57 +0200(sab, 04 lug 2009) $

    [%nargout, %nargin] = argn(0);

    if typeof(r) ~= "robot" then
        error("first argument should be a robot");
    end
    if %nargin == 1 then
        p = 0.1;                            // 10 percent disturb by default
    end

    l2 = r.links;                           // clone each link
    s = (2*rand(r.n,2) - 1)*p + 1;          // s(:,1) are the perturbs on masses
                                            // s(:,2) are the perturbs on inertiae
    for i = 1:r.n,
        l2(i).m = l2(i).m * s(i,1);
        l2(i).I = l2(i).I * s(i,2);
    end
    r2 = rt_robot(r, l2);                   // clone the robot using l2
    r2.name = "P/" + r.name;

endfunction
