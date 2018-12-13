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



function [t] = rt_mlinktran(a, b, c, d)
// File name:       rt_mlinktran.sci
//
// Function:        rt_mlinktran
//
// Description:     compute the link transform from modified Denavit-Hartenberg
//                  kinematic parameters
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/subsref.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout,%nargin] = argn(0);

    if %nargin == 4 then
        alpha = a;
        an = b;
        theta = c;
        dn = d;
    else
        if size(a,2) < 4 then
            error("too few columns in DH matrix");
        end
        alpha = a(1);
        an = a(2);
        if size(a,2) > 4 then
            if a(5) == 0 then
                // revolute
                theta = b;
                dn = a(4);
            else
                // prismatic
                theta = a(3);
                dn = b;
            end
        else
            // assume revolute if no sigma given
            theta = b;
            dn = a(4);
        end
    end
    sa = sin(alpha);
    ca = cos(alpha);
    st = sin(theta);
    ct = cos(theta);

    t = [ct -st 0 an; st*ca ct*ca -sa -sa*dn; st*sa ct*sa ca ca*dn; 0 0 0 1];

endfunction
