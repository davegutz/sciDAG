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



function [v] = %link_e(field, l)
// File name:       %link_e.sci
//
// Function:        v = l(field) -- when field is a double, v = l.field -- when field
//                  is a string
//
// Description:     extract data from link object
//
// Annotations:     the link data structure (DS) is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  The consistency of the DS is ensured by the link constructor (rt_link.sci)
//                  and the insertion functions (%s_i_link.sci, %c_i_link.sci), therefore
//                  no check on the data being extracted is required.
//
//                  Below, the link DS is recalled.
//
//                      type of DS (field 1)
//                      ====================
//                          ["link"]    (1)
//
//                      kinematic parameters (fields from 2 to 8)
//                      =========================================
//                          alpha       (2)
//                          A           (3)
//                          theta       (4)
//                          D           (5)
//                          sigma       (6)
//                          mdh         (7)
//                          offset      (8)
//
//                      dynamic parameters (fields from 9 to 15)
//                      ========================================
//                          m           (9)
//                          r           (10)
//                          I           (11)
//                          Jm          (12)
//                          G           (13)
//                          B           (14)
//                          Tc          (15)
//
//                      joint limit support (field 16)
//                      ==============================
//                          qlim        (16)
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/subsref.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-06-13 10:37:22 +0200(ven, 13 giu 2008) $

    if length(field) == 1 & type(field) == 1 then   //if field is a double

        if l.mdh == 0 then
            v = rt_linktran([l.alpha l.A l.theta l.D l.sigma], field + l.offset);
        else
            v = rt_mlinktran([l.alpha l.A l.theta l.D l.sigma], field + l.offset);
        end

    elseif typeof(field) == "string" then           // if field is a string

        select field,

            //
            // kinematic parameters
            //
            case "alpha" then

                v = getfield(2, l);

            case "A" then

                v = getfield(3, l);

            case "theta" then

                v = getfield(4, l);

            case "D" then

                v = getfield(5, l);

            case "sigma" then

                v = getfield(6, l);

            case "mdh" then

                v = getfield(7, l);

            case "offset" then

                v = getfield(8, l);

            //
            // dynamic parameters
            //
            case "m" then

                v = getfield(9, l);

            case "r" then

                v = getfield(10, l);

            case "I" then

                v = getfield(11, l);

            case "Jm" then

                v = getfield(12, l);

            case "G" then

                v = getfield(13, l);

            case "B" then

                v = getfield(14, l);

            case "Tc" then

                v = getfield(15, l);

            //
            // joint limit support
            //
            case "qlim" then

                v = getfield(16, l);

            case "islimit" then              // additional method, not a field

                u = l.qlim;
                if isempty(u) then
                    error("no limits assigned to link");
                else
                    v = mlist(["islimit"], u);
                end

            //
            // legacy DH/DYN support
            //
            case "dyn" then                  // additional method, not a field

                if isempty(l.m) then
                    error("cannot return the legacy DYN matrix: non-optional link mass parameter missing");
                elseif isempty(l.r) then
                    error("cannot return the legacy DYN matrix: non-optional link COG parameter missing");
                elseif isempty(l.I) then
                    error("cannot return the legacy DYN matrix: non-optional link inertia parameter missing");
                elseif isempty(l.Jm) then
                    error("cannot return the legacy DYN matrix: non-optional motor inertia parameter missing");
                else
                    G = l.G; if isempty(G) then G = 1; end
                    v = [l.alpha, l.A, l.theta, l.D, l.sigma,..
                        l.m, l.r', l.I(1,1), l.I(2,2), l.I(3,3), l.I(1,2), l.I(2,3), l.I(1,3), l.Jm, G, l.B, l.Tc];
                end

            case "dh" then                   // additional method, not a field

                v = [l.alpha, l.A, l.theta, l.D, l.sigma];

            case "RP" then                   // additional method, not a field

                if l.sigma == 0 then
                    v = "R";
                else
                    v = "P";
                end

            else

                error("unknown method");

        end

    else

        error("only (doubles) or .field are supported");

    end

endfunction
