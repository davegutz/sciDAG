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



function [r] = %c_i_robot(field, v, r)
// File name:       %c_i_robot.sci
//
// Function:        r.field = v
//
// Description:     insert strings in a robot object
//
// Annotations:     the robot data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  The first field of robot DS is the string vector ["robot"] (see the robot
//                  object constructor rt_robot.sci), therefore ALL the other fields in the
//                  DS are NOT directly accessible from the outside. In this way, it is
//                  possible to implement insertion rules to assure the consistency of the DS.
//
//                  Below, the robot DS is recalled.
//
//                      type of DS (field 1)
//                      ====================
//                          ["robot"]   (1)
//
//                      descriptive parameters (fields from 2 to 4)
//                      ===========================================
//                          name        (2)
//                          manuf       (3)
//                          comment     (4)
//
//                      constituent links parameters (fields from 5 to 6)
//                      =================================================
//                          links       (5) --list of links
//                          n           (6)
//
//                      extension parameters (fields from 7 to 10)
//                      ==========================================
//                          mdh         (7)
//                          gravity     (8)
//                          base        (9)
//                          tool        (10)
//
//                      graphic support parameters (fields from 11 to 15)
//                      =================================================
//                          handles     (11)
//                          q           (12)
//                          plotopt     (13)
//                          lineopt     (14)
//                          shadowopt   (15)
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/subsasgn.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-03-25 13:26:23 +0100(mar, 25 mar 2008) $

    if typeof(field) ~= "string" then

        error("only .field supported");

    elseif size(v,"*") ~= 1 then

        error(field + " should not be a matrix of strings");

    else

        select field,

            case "name" then

                setfield(2, v, r);

            case "manuf" then

                setfield(3, v, r);

            case "comment" then

                setfield(4, v, r);

            else

                error("unknown method");

        end

    end

endfunction
