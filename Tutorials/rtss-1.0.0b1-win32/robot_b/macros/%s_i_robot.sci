// Copyright (C) 2007, 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function [r] = %s_i_robot(field, v, r)
// File name:       %s_i_robot.sci
//
// Function:        r.field = v
//
// Description:     insert numeric data in a robot object
//
// Annotations:     the robot data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  The first field of robot DS is the string vector ["robot"] (see the robot
//                  object constructor rt_robot.sci), therefore ALL the other fields in the
//                  DS are NOT directly accessible from the outside. In this way, it is
//                  possible to implement insertion rules to assure the consistency of the DS.
//
//                  Note that, since the direct modification of link's parameters is not
//                  allowed, complex algorithms of insertion can not be performed. When required,
//                  this routine makes an access to link's data at a lower level; first, by
//                  extracting the constituent links from the robot, then changing their
//                  attributes, and finally rebuilding the modified robot.
//                  Specifically, the following complex insertion
//
//                                      r.links(i).<ATTRIB> = <VALUE>
//
//                  is performed via the three following instructions:
//                                      L = r.links;
//                                      L(i).<ATTRIB> = <VALUE>
//                                      r = rt_robot(r, L);
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/subsasgn.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-04-25 13:45:38 +0200(sab, 25 apr 2009) $

    if typeof(field) ~= "string" then

        error("only .field supported");

    else

        select field,

            case "q" then

                if isempty(v) | and(size(v) == [r.n, 1]) | and(size(v) == [1, r.n]) then
                    setfield(12, v, r);
                else
                    error("insufficient rows in joint vector");
                end

            case "gravity" then

                if length(v) == 3 then
                    setfield(8, v(:), r);
                else
                    error("gravity must be a 3-elements vector");
                end

            case "base" then

                if rt_ishomog(v) then
                    setfield(9, v, r);
                else
                    error("base must be a homogeneous transform");
                end

            case "tool" then

                if rt_ishomog(v) then
                    setfield(10, v, r);
                else
                    error("tool must be a homogeneous transform");
                end

            case "mdh" then

                if length(v) == 1 & (v == 0 | v == 1) then
                    //r.links(i).mdh = v, i=1,..,n
                    L = r.links;
                    for i = 1:r.n,
                        L(i).mdh = v;
                    end
                    r = rt_robot(r, L);
                    setfield(7, v, r);
                else
                    error("mdh must be scalar between 0 and 1");
                end

            case "offset" then

                if and(size(v) == [r.n, 1]) then
                    // r.links(i).offset = v(i), i=1,..,n
                    L = r.links;
                    for i = 1:r.n,
                        L(i).offset = v(i);
                    end
                    r = rt_robot(r, L);
                else
                    error("insufficient rows in joint coordinate offset vector");
                end

            case "qlim" then

                if and(size(v) == [r.n, 2]) then
                    // r.links(i).qlim = v(i,:), i=1,..,n
                    L = r.links;
                    for i = 1:r.n,
                        L(i).qlim = v(i,:);
                    end
                    r = rt_robot(r, L);
                else
                    error("insufficient rows in joint limit matrix");
                end

            else

                error("unknown method");

        end

    end

endfunction
