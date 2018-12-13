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



function [r] = rt_cross(v, w)
// File name:       rt_cross.sci
//
// Function:        rt_cross
//
// Description:     vector cross product
//
// Annotations:     Scilab equivalent for MATLAB(R) function cross is missing.
//                  This code implements a simple emulator of that function.
//                  Extremely simple, input arguments can be only 3-element vectors.
//
// References:      none
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [mv, nv] = size(v);
    [mw, nw] = size(w);
    if mv*nv ~= 3 | mw*nw ~= 3 then
        error("cross product can be done only for 3-element vectors");
    end

    r = [v(2)*w(3) - v(3)*w(2); v(3)*w(1) - v(1)*w(3); v(1)*w(2) - v(2)*w(1)];

endfunction
