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



function [tt] = rt_ctraj(t0, t1, n)
// File name:       rt_ctraj.sci
//
// Functions:       rt_ctraj
//
// Description:     compute a Cartesian trajectory between two points
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  Avoided the use of cat function, for efficiency.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/ctraj.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    if length(n) == 1 then
        i = 1:n;
        r = (i-1)/(n-1);
    else
        r = n(:).';
        n = length(r);
    end

    if or(r > 1 | r < 0) then
        error("path position values (R) must 0 <= R <= 1");
    end
    tt = [];

    for i = 1:n,
        tt(:,:,i) = rt_trinterp(t0, t1, r(i));
    end

endfunction
