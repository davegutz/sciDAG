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



function [currpoly] = rt_line(a0, a1, a2, a3, a4, a5, a6)
// File name:       rt_line.sci
//
// Function:        rt_line
//
// Description:     create line object
//
// Annotations:     Scilab equivalent for MATLAB(R) function line is missing.
//                  This code implements a simple emulator of that function.
//                  Extremely simple, only color, thickness and erasemode options
//                  can be specified.
//                  Parameters are specified as follows:
//                      a0 = figure handle
//                      a1 = x | color
//                      a2 = y | thickness
//                      a3 = z | erase mode
//                      a4 = color
//                      a5 = thickness
//                      a6 = erase mode
//
// References:      none
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout,%nargin] = argn(0);

    scf(a0);    // useful when rt_line is called by a function (not from workspace)

    if %nargin > 4 then
        a0.pixel_drawing_mode = a6;
        param3d(a1,a2,a3);
        xgrid();
        currpoly = gce();
        currpoly.foreground = color(a4);
        currpoly.thickness = a5;
    else
        a0.pixel_drawing_mode = a3;
        param3d([0;0],[0;0],[0;0]);
        xgrid();
        currpoly = gce();
        currpoly.foreground = color(a1);
        currpoly.thickness = a2;
    end

endfunction
