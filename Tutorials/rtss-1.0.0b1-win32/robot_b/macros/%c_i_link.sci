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



function [l] = %c_i_link(field, v, l)
// File name:       %c_i_link.sci
//
// Function:        l.field = v
//
// Description:     insert a string in a link object
//
// Annotations:     the link data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/subsasgn.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-03-09 18:46:40 +0100(dom, 09 mar 2008) $

    if typeof(field) ~= "string" then           // if field is not a string

        error("only .field supported");      

    elseif field == "sigma" then

        v = convstr(v);
        if v == "r" then
            l.sigma = 0;
        elseif v == "p" then
            l.sigma = 1;
        else
            error("sigma can be 0, nonzero, ''R'', ''r'', ''P'' or ''p''");
        end

    else

        error("unknown method");

    end

endfunction
