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



function [res] = %islimit_e(field, v)
// File name:       %islimit_e.sci
//
// Function:        res = v(field)
//
// Description:     joint limit vector, for each joint set to -1, 0 or 1
//                  depending if below low limit, OK or greater than upper
//
// Annotations:     the robot data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  TODO
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/subsref.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-03-26 16:07:35 +0100(mer, 26 mar 2008) $

    v = getfield(2, v);
    mv = size(v,1);
    res = [];

    if type(field) == 1 then            //if field is a double

        if and(size(field) == [mv, 1]) | and(size(field) == [1, mv]) then
            for i = 1:mv,
                res = [res; bool2s(field(i) > v(i,2)) - bool2s(field(i) < v(i,1))];
            end
        else
            error("argument for islimit method has wrong length");
        end

    else

        error("expecting double-type argument for islimit method");

    end

endfunction
