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



function [l] = %s_i_link(field, v, l)
// File name:       %s_i_link.sci
//
// Function:        l.field = v
//
// Description:     insert numeric data in a link object
//
// Annotations:     the link data structure (DS) is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  The first field of link DS is the string vector ["link"] (see the link
//                  object constructor rt_link.sci), therefore ALL the other fields in the
//                  DS are NOT directly accessible from the outside. In this way, it is
//                  possible to implement insertion rules to assure the consistency of the DS.
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
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/subsasgn.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-06-13 10:37:22 +0200(ven, 13 giu 2008) $

    if typeof(field) ~= "string" then           // if field is not a string

        error("only .field supported");      

    else

        select field,

            case "alpha" then

                if length(v) == 1 then
                    setfield(2, v, l)
                else
                    error("alpha must be scalar");
                end

            case "A" then

                if length(v) == 1 then
                    setfield(3, v, l)
                else
                    error("A must be scalar");
                end

            case "theta" then

                if length(v) == 1 then
                    setfield(4, v, l)
                else
                    error("theta must be scalar");
                end

            case "D" then

                if length(v) == 1 then
                    setfield(5, v, l)
                else
                    error("D must be scalar");
                end

            case "sigma" then

                if length(v) == 1 then
                    setfield(6, bool2s(v~=0), l)
                else
                    error("sigma must be scalar");
                end

            case "mdh" then

                if and(length(v) == 1 & (v == 0 | v == 1)) then
                    setfield(7, v, l)
                else
                    error("mdh must be scalar between 0 and 1");
                end

            case "offset" then

                if length(v) == 1 then
                    setfield(8, v, l)
                else
                    error("offset must be scalar");
                end

            case "m" then

                if length(v) == 1 | isempty(v) then
                    setfield(9, v, l)
                else
                    error("m must be scalar");
                end

            case "r" then

                if length(v) == 3 | isempty(v) then
                    setfield(10, v(:), l)
                else
                    error("COG vector should have 3 elements");
                end

            case "I" then

                if and(size(v) == [3,3]) | isempty(v) then
                    setfield(11, v, l);
                elseif length(v) == 3 then
                    setfield(11, diag(v), l);
                elseif and(size(v) == [6,1]) | and(size(v) == [1,6]) then
                    setfield(11, [v(1) v(4) v(6); v(4) v(2) v(5); v(6) v(5) v(3)], l);
                else
                    error("wrong insertion for matrix I");
                end

            case "Jm" then

                if length(v) == 1 | isempty(v) then
                    setfield(12, v, l)
                else
                    error("Jm must be scalar");
                end

            case "G" then

                if length(v) == 1 | isempty(v) then
                    setfield(13, v, l)
                else
                    error("G must be scalar");
                end

            case "B" then

                if length(v) == 1 then
                    setfield(14, v, l)
                else
                    error("B must be scalar");
                end

            case "Tc" then

                if length(v) == 1 then
                    setfield(15, [v, -v], l);
                elseif length(v) == 2 then
                    setfield(15, v(:)', l);
                else
                    error("Coulomb friction vector can have 1 (symmetric) or 2 (asymmetric) elements only");
                end

            case "qlim" then

                if length(v) == 2 | isempty(v) then
                    setfield(16, v(:)', l)
                else
                    error("joint limit vector must have 2 elements");
                end

            else

                error("unknown method");

        end

    end

endfunction
