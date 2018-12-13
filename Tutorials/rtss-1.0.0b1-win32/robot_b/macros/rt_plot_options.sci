// Copyright (C) 1993-2002, by Peter I. Corke
// Copyright (C) 2007  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function [o] = rt_plot_options(robot,optin)
// File name:       rt_plot_options.sci
//
// Function:        rt_plot_options
//
// Description:     return an options structure
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  KNOWN ISSUES:
//                      erase mode "none" not implemented in Scilab. Option "noerase" gives
//                          an error.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/plot.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    // process options
    o.erasemode = "copy";
    o.joints = 1;
    o.wrist = 1;
    o.repeat = 1;
    o.shadow = 1;
    o.dimens = [];
    o.base = 0;
    o.wristlabel = "xyz";
    o.projection = "orthographic";
    o.magscale = 1;
    o.name = 1;

    // read options string in the order
    //  1. robot.plotopt
    //  2. the SCI-file plotbotopt if it exists
    //  3. command line arguments
    [file_parameters,err] = fileinfo("rt_plotbotopt.sci");
    if err == 0 then
        getf("rt_plotbotopt.sci");
        options = rt_plotbotopt();
        options = lstcat(options, robot.plotopt, optin);
    else
        options = lstcat(robot.plotopt, optin);
    end
    i = 1;
    while i <= length(options),
        select convstr(options(i), "l")
            case "workspace" then
                o.dimens = matrix(options(i+1), 2, 3);
                i = i+1;
            case "mag" then
                o.magscale = options(i+1);
                i = i+1;
            case "perspective" then
                o.projection = "perspective";
            case "ortho" then
                o.projection = "orthographic";
            case "erase" then
                o.erasemode = "copy";
            case "noerase" then
                o.erasemode = "none";
            case "base" then
                o.base = 1;
            case "nobase" then
                o.base = 0;
            case "loop" then
                o.repeat = options(i+1);
                i = i+1;
            case "noloop" then
                o.repeat = 1;
            case "name" then
                o.name = 1;
            case "noname" then
                o.name = 0;
            case "wrist" then
                o.wrist = 1;
            case "nowrist" then
                o.wrist = 0;
            case "shadow" then
                o.shadow = 1;
            case "noshadow" then
                o.shadow = 0;
            case "xyz" then
                o.wristlabel = "XYZ";
            case "noa" then
                o.wristlabel = "NOA";
            case "joints" then
                o.joints = 1;
            case "nojoints" then
                o.joints = 0;
            else
                printf("unknown option: %s\n", options(i));
                abort;
        end
        i = i+1;
    end

    if isempty(o.dimens) then
        // simple heuristic to figure the maximum reach of the robot
        L = robot.links;
        reach = 0;
        for i = 1:robot.n,
            reach = reach + abs(L(i).A) + abs(L(i).D);
        end
        o.dimens = [-reach -reach -reach; reach reach reach];
        o.mag = reach/10;
    else
        //reach = min(abs(o.dimens));
        reach = abs(min(o.dimens));
    end
    o.mag = o.magscale * reach/10;

endfunction
