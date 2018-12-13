// Copyright (C) 1999  Peter Corke
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



function %link_p(l, fulldisp)
// File name:       %link_p.sci
//
// Functions:       %link_p, disp
//
// Description:     gives a one-line summary of the link's kinematic parameters
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  MATLAB(R) equivalent "inputname" function is not implemented
//                  in Scilab.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/display.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout,%nargin] = argn(0);

    rt_char(l);

    if %nargin > 1 then

        if ~isempty(l.m) then
            printf("  m    = %f\n", l.m)
        end
        if ~isempty(l.r) then
            mprintf("  r    = %f %f %f\n", l.r');
        end
        if ~isempty(l.I) then
            mprintf("  I    = | %f %f %f |\n", l.I(1,:));
            mprintf("         | %f %f %f |\n", l.I(2,:));
            mprintf("         | %f %f %f |\n", l.I(3,:));
        end
        if ~isempty(l.Jm) then
            printf("  Jm   = %f\n", l.Jm);
        end
        if ~isempty(l.B) then
            printf("  B    = %f\n", l.B);
        end
        if ~isempty(l.Tc) then
            printf("  Tc   = %f(+) %f(-)\n", l.Tc(1), l.Tc(2));
        end
        if ~isempty(l.G) then
            printf("  G    = %f\n", l.G);
        end
        if ~isempty(l.qlim) then
            printf("  qlim = %f to %f\n", l.qlim(1), l.qlim(2));
        end
    end

endfunction
