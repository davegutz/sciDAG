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



function  [tau] = rt_friction(obj, qd)
// File name:       rt_friction.sci
//
// Functions:       rt_friction
//
// Description:     compute joint friction torque
//
// Annotations:     this code is a Scilab port of corresponding functions in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/friction.m
//                  Robotics Toolbox for MATLAB(R), robot7.1/@robot/friction.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    if typeof(obj) == "link" then

        qd = qd(:);
        tau = obj.B * qd + (qd > 0) * obj.Tc(1) + (qd < 0) * obj.Tc(2);

    elseif typeof(obj) == "robot" then

        tau = [];
        L = obj.links;
        for i = 1:obj.n,
            tau = [tau; rt_friction(L(i), qd(i))];
        end

    else

        error("first argument should be a link or a robot");

    end

endfunction
