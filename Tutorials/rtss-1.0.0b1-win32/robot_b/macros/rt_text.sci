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



function [currtxt] = rt_text(cfh, x, y, str, erasemode, z)
// File name:       rt_text.sci
//
// Function:        rt_text
//
// Description:     create text object in current axes
//
// Annotations:     Scilab equivalent for MATLAB(R) function text is missing.
//                  This code implements a simple emulator of that function.
//                  Extremely simple, only erasemode option can be specified.
//
// References:      none
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout,%nargin] = argn(0);

    scf(cfh);   // useful when rt_text is called by a function (not from workspace)

    cfh.pixel_drawing_mode = erasemode;
    xstring(x,y,str);
    currtxt = gce();
    if %nargin > 5 then
        currtxt.data = [x,y,z];
    end

endfunction
