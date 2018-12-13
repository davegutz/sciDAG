// Copyright (C) 1999-2002 by Peter I. Corke
// Copyright (C) 2007, 2008  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function [v] = %quat_e(field, q)
// File name:       %quat_e.sci
//
// Function:        v = q.field
//
// Description:     extract data from quaternion object
//
// Annotations:     the quaternion data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  The consistency of the DS is ensured by the quaternion constructor,
//                  therefore no check on the data being extracted is required.
//
//                  Below, the quaternion DS is recalled.
//
//                      type of DS (field 1)
//                      ====================
//                          ["quat"]    (1)
//
//                      scalar component (field 2)
//                      ==========================
//                          s           (2)
//
//                      vector part (field 3)
//                      =====================
//                          v           (3)
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@quaternion/subsref.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-03-26 19:09:34 +0100(mer, 26 mar 2008) $

    if typeof(field) ~= "string" then

        error("only .field supported");

    else

        select field,
            case "d" then
                v = double(q);
            case "s" then
                v = getfield(2, q);
            case "v" then
                v = getfield(3, q);
            case "t" then
                v = rt_q2tr(q);
            case "r" then
                v = rt_q2tr(q);
                v = v(1:3,1:3);
            else
                error("unknown method");
        end

    end

endfunction
