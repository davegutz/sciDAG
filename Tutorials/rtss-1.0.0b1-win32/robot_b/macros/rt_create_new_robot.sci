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



function [h] = rt_create_new_robot(robot, opt)
// File name:       rt_create_new_robot.sci
//
// Functions:       rt_create_new_robot
//
// Description:     using data from robot object and options create a graphical robot
//                  in the current figure
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  Several important MATLAB(R) functions are missing:
//                      line,       rt_line clone implemented
//                      text,       rt_text clone implemented
//                      cylinder,   rt_cylinder clone implemented
//                  KNOWN ISSUES:
//                      Erase mode "xor" gives very poor quality drawings. Changed to "copy".
//                      As far as I know, Scilab equivalent of MATLAB(R) call set(gca, 'drawmode', 'fast') is missing.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/plot.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    cfh = gcf();

    h = [];

    h.mag = opt.mag;

    // setup an axis in which to animate the robot
    //
    // handles not provided, create graphics
    currax = cfh.children;
    if currax.auto_clear == "off" then
        // if current figure has hold on, then draw robot here
        // otherwise, create a new figure
        //disp('not hold')
        //disp('Create new figure')
        currax.data_bounds = opt.dimens;
    end
    currax.x_label.text = "X";
    currax.y_label.text = "Y";
    currax.z_label.text = "Z";
    //set(gca, 'drawmode', 'fast');*
    xgrid();

    zlim = currax.data_bounds(:,$);
    h.zmin = zlim(1);

    if opt.base then
        b = rt_transl(robot.base);
        rt_line(cfh, [b(1);b(1)], [b(2);b(2)], [h.zmin;b(3)], "red", 4, "copy");
    end
    if opt.name then
        b = rt_transl(robot.base);
        rt_text(cfh, b(1), b(2)-opt.mag, [' ' robot.name], "copy", b(3));
    end

    // create a line which we will
    // subsequently modify. Set erase mode to copy
    // Setting erase mode to xor causes bad plots
    h.robot = rt_line(cfh, robot.lineopt(1), robot.lineopt(2), opt.erasemode);
    h.robot.user_data = list();
    if opt.shadow == 1 then
        h.shadow = rt_line(cfh, robot.shadowopt(1), robot.shadowopt(2), opt.erasemode);
    end

    if opt.wrist == 1 then
        h.x = rt_line(cfh, [0;0], [0;0], [0;0], "red", 1, "copy");
        h.y = rt_line(cfh, [0;0], [0;0], [0;0], "green", 1, "copy");
        h.z = rt_line(cfh, [0;0], [0;0], [0;0], "blue", 1, "copy");
        h.xt = rt_text(cfh, 0, 0, part(opt.wristlabel,1), "copy");
        h.yt = rt_text(cfh, 0, 0, part(opt.wristlabel,2), "copy");
        h.zt = rt_text(cfh, 0, 0, part(opt.wristlabel,3), "copy");

    end

    // display cylinders (revolute) or boxes (pristmatic) at
    // each joint, as well as axis centerline.
    if opt.joints == 1 then
        L = robot.links;
        h.joint = [];
        h.jointaxis = [];
        for i=1:robot.n

            // cylinder or box to represent the joint
            if L(i).sigma == 0 then
                N = 8;
            else
                N = 4;
            end
            [xc,yc,zc] = rt_cylinder(opt.mag/4, N);
            zc(zc==0) = -opt.mag/2;
            zc(zc==1) = opt.mag/2;

            // add the surface object
            surf(xc,yc,zc);
            h.joint = [h.joint; gce()]; 

            // and color it
            h.joint(i).thickness = 1;
            h.joint(i).foreground = color("black");
            h.joint(i).color_mode = color("blue");
            h.joint(i).color_flag = 0;

            // build a matrix of coordinates so we
            // can transform the cylinder in rt_animate()
            // and hang it off the cylinder
            datax = getfield(2, h.joint(i).data);
            datay = getfield(3, h.joint(i).data);
            dataz = getfield(4, h.joint(i).data);
            h.joint(i).user_data = [datax(:)'; datay(:)'; dataz(:)'; ones(1,4*N)];

            // add a dashed line along the axis
            h.jointaxis = [h.jointaxis; rt_line(cfh, [0;0], [0;0], [0;0], "blue", 1, "copy")];
            h.jointaxis(i).line_style = 4;
        end
    end

endfunction
