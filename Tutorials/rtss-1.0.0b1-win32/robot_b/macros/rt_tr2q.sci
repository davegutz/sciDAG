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



function [q] = rt_tr2q(t)
// File name:       rt_tr2q.sci
//
// Function:        rt_tr2q
//
// Description:     convert homogeneous transform to a unit-quaternion
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@quaternion/quaternion.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    qs = sqrt(trace(t)+1)/2.0;
    kx = t(3,2) - t(2,3);                           // Oz - Ay
    ky = t(1,3) - t(3,1);                           // Ax - Nz
    kz = t(2,1) - t(1,2);                           // Ny - Ox

    if (t(1,1) >= t(2,2)) & (t(1,1) >= t(3,3)) then 
        kx1 = t(1,1) - t(2,2) - t(3,3) + 1;         // Nx - Oy - Az + 1
        ky1 = t(2,1) + t(1,2);                      // Ny + Ox
        kz1 = t(3,1) + t(1,3);                      // Nz + Ax
        add = (kx >= 0);
    elseif (t(2,2) >= t(3,3)) then
        kx1 = t(2,1) + t(1,2);                      // Ny + Ox
        ky1 = t(2,2) - t(1,1) - t(3,3) + 1;         // Oy - Nx - Az + 1
        kz1 = t(3,2) + t(2,3);                      // Oz + Ay
        add = (ky >= 0);
    else
        kx1 = t(3,1) + t(1,3);                      // Nz + Ax
        ky1 = t(3,2) + t(2,3);                      // Oz + Ay
        kz1 = t(3,3) - t(1,1) - t(2,2) + 1;         // Az - Nx - Oy + 1
        add = (kz >= 0);
    end

    if add then
        kx = kx + kx1;
        ky = ky + ky1;
        kz = kz + kz1;
    else
        kx = kx - kx1;
        ky = ky - ky1;
        kz = kz - kz1;
    end

    nm = norm([kx ky kz]);
    if nm == 0 then
        q = rt_quaternion([1 0 0 0]);
    else
        s = sqrt(1 - qs^2) / nm;
        qv = s*[kx ky kz];

        q = rt_quaternion([qs qv]);

    end

endfunction
