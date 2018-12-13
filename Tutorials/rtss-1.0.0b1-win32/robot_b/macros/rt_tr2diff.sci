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



function [d] = rt_tr2diff(t1, t2)
// File name:       rt_tr2diff.sci
//
// Function:        rt_tr2diff
//
// Description:     convert a homogeneous transform to a differential motion vector
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  MATLAB(R) function cross is missing, rt_cross clone implemented.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/tr2diff.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout,%nargin] = argn(0);

    if %nargin == 1 then

        d = [t1(1:3,4); 0.5*[t1(3,2)-t1(2,3); t1(1,3)-t1(3,1); t1(2,1)-t1(1,2)]];

    else

        d = [t2(1:3,4) - t1(1:3,4); 0.5*(rt_cross(t1(1:3,1),t2(1:3,1)) + rt_cross(t1(1:3,2),t2(1:3,2)) + rt_cross(t1(1:3,3),t2(1:3,3)))];

    end

endfunction
