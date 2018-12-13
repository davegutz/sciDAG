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



function [v] = %robot_e(field, r)
// File name:       %robot_e.sci
//
// Function:        v = r.field
//
// Description:     extract data from robot object
//
// Annotations:     the robot data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  The consistency of the DS is ensured by the robot constructor (rt_robot.sci)
//                  and the insertion functions:
//                      %s_i_robot.sci;
//                      %c_i_robot.sci;
//                      %l_i_robot.sci;
//                      %st_i_robot.sci,
//                  therefore no check on the data being extracted is required.
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
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/subsref.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-03-25 13:26:23 +0100(mar, 25 mar 2008) $

    if typeof(field) ~= "string" then

        error("only .field supported");

    else

        select field,

            //
            // constituent links parameters
            //
            case "links" then

                v = getfield(5, r);

            case "n" then

                v = getfield(6, r);

            //
            // extension parameters
            //
            case "gravity" then

                v = getfield(8, r);

            case "tool" then

                v = getfield(10, r);

            case "base" then

                v = getfield(9, r);

            case "mdh" then

                v = getfield(7, r);

            //
            // descriptive strings
            //
            case "name" then

                v = getfield(2, r);

            case "manuf" then

                v = getfield(3, r);

            case "comment" then

                v = getfield(4, r);

            //
            // graphics support
            //
            case "handles" then
                v = getfield(11, r);

            case "q" then
            
                v = getfield(12, r);

            case "plotopt" then
                v = getfield(13, r);

            case "lineopt" then
            
                v = getfield(14, r);

            case "shadowopt" then
            
                v = getfield(15, r);

            //
            // legacy DH/DYN support
            //
            case "dh" then

                v = [];
                for i = 1:r.n,
                    v = [v; r.links(i).dh];
                end

            case "dyn" then

                l1 = r.links(1);
                v = l1.dyn;
                for i = 2:r.n,
                    li = r.links(i);
                    if length(li.m) ~= length(l1.m) then
                        error("cannot return the legacy DYN matrix: masses have incompatible dimensions");
                    elseif length(li.r) ~= length(l1.r) then
                        error("cannot return the legacy DYN matrix: COG vectors have incompatible dimensions");
                    elseif length(li.I) ~= length(l1.I) then
                        error("cannot return the legacy DYN matrix: inertia matrices have incompatible dimensions");
                    elseif length(li.Jm) ~= length(l1.Jm) then
                        error("cannot return the legacy DYN matrix: motor inertias have incompatible dimensions");
                    elseif length(li.G) ~= length(l1.G) then
                        error("cannot return the legacy DYN matrix: gear ratios have incompatible dimensions");
                    else
                        v = [v; li.dyn];
                    end
                end

            //
            // joint limit support
            //
            case "offset" then
            
                v = [];
                for i = 1:r.n,
                    v = [v; r.links(i).offset];
                end

            case "qlim" then
            
                v = [];
                for i = 1:r.n,
                    v = [v; r.links(i).qlim];
                end

            case "islimit" then
            
                u = r.qlim;
                if isempty(u) then
                    error("no limits assigned to link");
                else
                    v = mlist(["islimit"], u);
                end

            //
            // otherwise
            //
            else
                error("unknown method");

        end

    end

endfunction
