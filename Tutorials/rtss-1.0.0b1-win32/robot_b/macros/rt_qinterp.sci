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



function q = rt_qinterp(Q1, Q2, r)
// File name:       rt_qinterp.sci
//
// Function:        rt_qinterp
//
// Description:     interpolate unit-quaternions
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@quaternion/qinterp.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    if or(r < 0 | r > 1) then
        error("R out of range");
    end

    q1 = double(Q1);
    q2 = double(Q2);
    theta = acos(q1*q2.');
    q = list();
    count = 1;

    if length(r) == 1 then

        // r is a scalar, returns a unit quaternion
        if theta == 0 then
            q = Q1;
        else
            q = rt_quaternion( (sin((1-r)*theta)*q1 + sin(r*theta)*q2) / sin(theta) );
        end

    else

        // r is a vector, returns a list of quaternions
        for R = r(:).',
            if theta == 0 then
                qq = Q1;
            else
                qq = rt_quaternion( (sin((1-R)*theta)*q1 + sin(R*theta)*q2) / sin(theta) );
            end
            q(count) = qq;
            count = count + 1;
        end

    end

endfunction
