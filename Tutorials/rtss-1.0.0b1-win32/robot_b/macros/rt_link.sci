// Copyright (C) 1999-2002, by Peter I. Corke
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



function [l] = rt_link(dh, convention)
// File name:       rt_link.sci
//
// Function:        rt_link
//
// Description:     construct/clone a link object
//
// Annotations:     the link data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  A description of the link data structure (DS) follows.
//
//                  A link is a Scilab mlist with 16 fields. The first field is the string
//                  vector ["link"] (the type of DS).
//                  The other fields of the link DS are due to
//
//                      kinematic parameters (fields from 2 to 8)
//                      =========================================
//                          alpha   (2)
//                          A       (3)
//                          theta   (4)
//                          D       (5)
//                          sigma   (6)
//                          mdh     (7)
//                          offset  (8)
//
//                      dynamic parameters (fields from 9 to 15)
//                      ========================================
//                          m       (9)
//                          r       (10)
//                          I       (11)
//                          Jm      (12)
//                          G       (13)
//                          B       (14)
//                          Tc      (15)
//
//                      joint limit support (field 16)
//                      ==============================
//                          qlim    (16)
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/link.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-06-13 10:37:22 +0200(ven, 13 giu 2008) $

    [%nargout, %nargin] = argn(0);

    if %nargin > 2 then
        error(77);  // wrong number of rhs arguments
    end

    if %nargin == 0 then

        // create a default link
        alpha = 0;
        A = 0;
        theta = 0;
        D = 0;
        sigma = 0;
        mdh = 0;
        offset = 0;
        m = [];
        r = [];
        I = [];
        Jm = [];
        G = [];
        B = 0;
        Tc = [0, 0];
        qlim = [];
        l = mlist(["link"], alpha, A, theta, D, sigma, mdh, offset,..
            m, r, I, Jm, G, B, Tc, qlim);

    else

        if ~((typeof(dh) == "constant" & isreal(dh) & size(dh,1) == 1) | (typeof(dh) == "link")) then
            error("error in specifying first parameter: it can be a real row vector or a link");
        end

        if %nargin > 1 & ~(typeof(convention) == "string" & size(convention,"*") == 1) then
            error("convention must be a string");
        end

        if typeof(dh) == "link" then

            // clone passed link
            l = dh;

        elseif length(dh) < 6 then

            // create a link from a legacy DH matrix
            if length(dh) < 4 then
                error("must provide <alpha A theta D> params");
            end
            alpha = dh(1);
            A = dh(2);
            theta = dh(3);
            D = dh(4);
            sigma = 0;
            if length(dh) > 4 & dh(5) ~= 0 then
                sigma = 1;
            end
            if %nargin > 1 then
                if part(convention, [1,2,3]) == "mod" then
                    mdh = 1;
                elseif part(convention, [1,2,3]) == "sta" then
                    mdh = 0;
                else
                    error("convention must be modified or standard");
                end
            else
                mdh = 0;    // default to standard D&H
            end
            offset = 0;
            m = [];         // we know nothing about the dynamics
            r = [];
            I = [];
            Jm = [];
            G = [];
            B = 0;
            Tc = [0, 0];
            qlim = [];
            l = mlist(["link"], alpha, A, theta, D, sigma, mdh, offset,..
                m, r, I, Jm, G, B, Tc, qlim);

        else

            // create a link from a legacy DYN matrix
            if length(dh) < 16 then
                error("insufficient number of params in dh");
            end
            alpha = dh(1);
            A = dh(2);
            theta = dh(3);
            D = dh(4);
            sigma = bool2s(dh(5) ~= 0);
            if %nargin > 1 then
                if part(convention,[1,2,3]) == "mod" then
                    mdh = 1;
                elseif part(convention,[1,2,3]) == "sta" then
                    mdh = 0;
                else
                    error("convention must be modified or standard");
                end
            else
                mdh = 0;    // default to standard D&H
            end
            offset = 0;
            m = dh(6);
            r = dh(7:9)';
            v = dh(10:15);
            I = [v(1) v(4) v(6);..
                 v(4) v(2) v(5);..
                 v(6) v(5) v(3)];
            Jm = dh(16);
            G = 1;
            if length(dh) > 16 then
                G = dh(17);
            end
            B = 0;
            if length(dh) > 17 then
                B = dh(18);
            end
            Tc = [0, 0];
            if length(dh) > 18 then
                Tc = dh(19:20);
            end
            qlim = [];
            l = mlist(["link"], alpha, A, theta, D, sigma, mdh, offset,..
                m, r, I, Jm, G, B, Tc, qlim);

        end

    end

endfunction
