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



function [rnew] = rt_rplot(robot, addargs)
// File name:       rt_rplot.sci
//
// Function:        rt_rplot
//
// Description:     create a graphical animation for a robot object
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  Two important MATLAB(R) functions are missing:
//                      findobj,    rt_findtag clone implemented
//                      isfield,    rt_isfield clone implemented
//                  tg is addargs(1)
//                  FULL SUPPORT for:
//                      modified DH based models of robots
//                      fluid animation in current figure
//                      multiple views of a robot
//                      additional robots in a graphic figure
//                      additional options for plotting
//                  KNOWN ISSUES:
//                      slower plots and animations than Robotics Toolbox for MATLAB(R)
//                      flashing animations on others figure (not the current)
//                      names with more than 14 letters not supported (e.g. "SphericalWrist1")
//                      problems whith backward changes of current figure (e.g. scf(1),scf(0))
//                      handles provided, animate just that robot* need to be tested
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/plot.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-03-23 23:14:55 +0100(lun, 23 mar 2009) $

    [%nargout,%nargin] = argn(0);

    // q = PLOT(robot)
    // return joint coordinates from a graphical robot of given name
    if isempty(addargs) then                    // if nargin is 1
        rnew = [];
        rh = rt_findtag(robot.name);
        if ~isempty(rh) then
            userdata = rh(1).user_data;
            r = userdata(2);                    // robot's info are in user_data(2)
            rnew = r.q;
        end
        return

    // robot2 = PLOT(robot, q, addargs)
    else
        // get q
        tg = addargs(1);
        addargs(1) = null();
        // based on standard or modified DH notation?
        rt_animate = "rt_animate_std";
        if robot.mdh then
            rt_animate = "rt_animate_mod";
        end
    end

    old_driver = driver();
    driver("X11");
    rh_computed = %F;
    rh = [];
    point_of_view = [35, 45];
    np = size(tg,1);
    n = robot.n;
    opt.repeat = 1;

    if size(tg,2) ~= n then
        error("insufficient columns in q")
    end

    if rt_isfield(robot, "handles") then
        // handles provided, animate just that robot*
        // * is this case obsolete?
        // * if not: TO DO  pixmap
        //                  point of view
        drawlater();
        for r=1:opt.repeat,
            for p=1:np,
                execstr(rt_animate + "(robot,tg(p,1:$));");
            end
        end

        return;
    end

    // else do the right thing with figure windows.

    // does already exists any figure?
    fh = winsid();

    if isempty(fh)

        // no figures exist at all, create one
        cfh = scf();
        drawlater();
        old_pixmap = "off";
        cfh.pixmap = "on";

        // process options
        opt = rt_plot_options(robot, addargs);

        h = rt_create_new_robot(robot,opt);

        // save the handles in the passed robot object, and
        // attach it to the robot as user data.
        robot.handles = h;
        h.robot.user_data = list(robot.name, rt_robot(robot));  // robot name in user_data(1)
                                                                // robot info in user_data(2)

    else

        // at least a figure exist
        cfh = gcf();

        if typeof(cfh) == "handle" | typeof(cfh) == "h" then
            drawlater();
            old_pixmap = cfh.pixmap;
            cfh.pixmap = "on";

            // save the point of view
            point_of_view = cfh.children.rotation_angles;

            numaxh = size(cfh.children,1);
            numaxhchildren = cfh.children.children;

            if numaxh == 1 & isempty(numaxhchildren) then
                // empty figure, just created, use it

                // process options
                opt = rt_plot_options(robot, addargs);
                cfh.children.data_bounds = opt.dimens;

                h = rt_create_new_robot(robot,opt);

                // save the handles in the passed robot object, and
                // attach it to the robot as user data.
                robot.handles = h;
                h.robot.user_data = list(robot.name, rt_robot(robot));  // robot name in user_data(1)
                                                                        // robot info in user_data(2)

            else
                disp("reusing existing figure");
                rh = rt_findtag(robot.name);
                rh_computed = %T;
                rfigure_id = [];
                for i=1:size(rh,1),
                    rfigure_id = [rfigure_id,rh(i).parent.parent.figure_id];
                end
                if isempty(rh) | ~or(rfigure_id == cfh.figure_id) then  // if no robots with that name exist
                                                                        // or
                                                                        // at least one exists but not in current figure
                                                                        // then
                    // process options
                    opt = rt_plot_options(robot, addargs);
                    cfh.children.data_bounds = opt.dimens;

                    h = rt_create_new_robot(robot,opt);

                    // save the handles in the passed robot object, and
                    // attach it to the robot as user data.
                    robot.handles = h;
                    h.robot.user_data = list(robot.name, rt_robot(robot));  // robot name in user_data(1)
                                                                            // robot info in user_data(2)

                    rh = [rh; robot.handles.robot];
                end
            end
        else
            disp("current figure is an objfigure");
        end

    end

    // now animate all robots tagged with this name

    // maintain the point of view
    cfh.children.rotation_angles = point_of_view;

    // get handle of any existing robot of same name
    if ~rh_computed then
        rh = rt_findtag(robot.name);
    end

    for r=1:opt.repeat,
        for p=1:np,
            for i=1:size(rh,1),
                rh_i = rh(i);
                userdata_i = rh_i.user_data;
                execstr(rt_animate + "(userdata_i(2),tg(p,:));");
            end
        end
    end

    // save the last joint angles away in the graphical robot
    for i=1:size(rh,1),
        userdata_i = rh(i).user_data;
        rr = userdata_i(2);
        rr.q = tg($,:);
        rh(i).user_data = list(userdata_i(1), rr);
    end

    if %nargout > 0 then
        rnew = robot;
    end

    drawnow();
    cfh.immediate_drawing = "on";
    cfh.pixmap = old_pixmap;
    driver(old_driver);

endfunction
