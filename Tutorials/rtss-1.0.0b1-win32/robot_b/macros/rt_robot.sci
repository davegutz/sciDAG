// Copyright (C) 1999-2002 by Peter I. Corke
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



function [r] = rt_robot(L, a1, a2, a3)
// File name:       rt_robot.sci
//
// Function:        rt_robot
//
// Description:     construct/clone a robot object
//
// Annotations:     the robot data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  A description of the robot data structure (DS) follows.
//
//                  A robot is a Scilab mlist with 15 fields. The first field is the string
//                  vector ["robot"] (the type of DS).
//                  The other fields of the robot DS are due to
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
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/robot.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-04-25 13:45:38 +0200(sab, 25 apr 2009) $

    [%nargout,%nargin] = argn(0);

    if %nargin > 4 then
        error(77);  // wrong number of rhs arguments
    end

    if %nargin == 0 then

        //
        // create a default robot
        //
        name = "noname";
        manuf = "";
        comment = "";
        L = list();
        n = 0;
        mdh = 0;
        gravity = [0; 0; 9.81];
        base = eye(4,4);
        tool = eye(4,4);
        handles = [];   // graphics handles
        q = [];         // current joint angles
        plotopt = list();
        lineopt = list("black", 4);
        shadowopt = list("black", 1);
        r = mlist(["robot"], name, manuf, comment, L, n, mdh, gravity,..
                base, tool, handles, q, plotopt, lineopt, shadowopt);  // create robot from these parameters

    else

        if typeof(L) == "robot" then

            //
            // clone passed robot
            //
            if %nargin > 2 then
                error(77);  // wrong number of rhs arguments
            end
            r = L
            if %nargin == 2 then
                if typeof(a1) == "list" & length(a1) == L.n then
                    for i = 1:L.n,
                        if typeof(a1(i)) ~= "link" then
                            error("expecting a list of links");
                        end
                    end
                    setfield(5, a1, r); //r.links = a1;
                                     //WARNING: direct access to robot's internals here!
                else
                    error("2nd argument must be a list of " + sci2exp(L.n) + " links");
                end
            end
        else

            if isdef("a1") & size(a1,"*") ~= 1 |.. // assume arguments are: name, manuf, comment
                isdef("a2") & size(a2,"*") ~= 1 |..
                isdef("a3") & size(a3,"*") ~= 1 then
                error("name, manuf and comment should not be matrices of strings");
            end
            if %nargin > 1 then // processing name, manuf, comment
                name = a1;
            else
                name = "noname";
            end
            if %nargin > 2 then
                manuf = a2;
            else
                manuf = "";
            end
            if %nargin > 3 then
                comment = a3;
            else
                comment = "";
            end
            if type(L) == 1 then

                //
                // legacy matrix
                //
                DH_DYN = L;
                L = list();
                for i = 1:size(DH_DYN,1),
                    L(i) = rt_link(DH_DYN(i,:));
                end
            elseif typeof(L) == "list" then
                //
                // links passed as list
                //
                mdh = [];
                for i = 1:length(L),
                    if typeof(L(i)) ~= "link" then
                        error("unknown type passed to robot");
                    end
                    mdh = [mdh; L(i).mdh];
                end
                if ~(and(mdh == 0) | and(mdh == 1)) then
                    error("robot has mixed D&H link conventions");
                end
            else
                error("unknown type passed to robot");
            end
            n = length(L);
            mdh = L(1).mdh;
            gravity = [0; 0; 9.81];
            base = eye(4,4);
            tool = eye(4,4);
            handles = [];
            q = [];
            plotopt = list();
            lineopt = list("black", 4);
            shadowopt = list("black", 1);
            r = mlist(["robot"], name, manuf, comment, L, n, mdh, gravity,..
                base, tool, handles, q, plotopt, lineopt, shadowopt);  // create robot from these parameters

        end

    end

endfunction
