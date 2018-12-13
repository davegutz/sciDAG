// Copyright (C) 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function [x, y, typ] = rt_gravload_if(job, arg1, arg2)
// File name:       rt_gravload_if.sci
//
// Function:        rt_gravload_if
//
// Description:     handle the user interface of the Scicos block named "rt_gravload_if"
//
// Annotations:     none
//
// References:      none
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            June 2009
//
// $LastChangedDate: 2009-07-25 19:18:50 +0200(sab, 25 lug 2009) $

    x = [];
    y = [];
    typ = [];
    select job,

        case "plot" then
            standard_draw(arg1);

        case "getinputs" then
            [x, y, typ] = standard_inputs(arg1);

        case "getoutputs" then
            [x, y, typ] = standard_outputs(arg1);

        case "getorigin" then
            [x, y] = standard_origin(arg1);

        case "set" then
            x = arg1;
            graphics = arg1.graphics;
            exprs = graphics.exprs;
            model = arg1.model;
            while %T do,
                [ok, robot, grav, exprs] = getvalue(..
                    "Manipulator gravity torque components",..
                    ["Robot object";..
                    "Gravity"],..
                    list("lis", -1, "vec", 3),..
                    exprs);
                if ok & typeof(robot) ~= "robot" then
                    // not a robot
                    message("invalid block parameter: required a robot object");
                    ok = %F;
                elseif ok & robot.n == 0 then
                    // a robot model to be simulated still must be specified
                    ok = %F;
                end
                if ~ok then
                    break;
                end
                [model, graphics, ok] = set_io(model, graphics, list([robot.n, 1], 1), list([robot.n, 1], 1), [], []);
                if ok then
                    model.opar = list();
                    robot.gravity = grav;
                    ierr = execstr('model.rtss_dyn = robot;', 'errcatch'); //(pos. 1--7 in opar)
                    if ierr ~= 0 then
                        message(lasterror());
                        break;
                    end
                    graphics.exprs = exprs;
                    graphics.gr_i(1) = "xstringb(orig(1), orig(2), [""RTSS""; ""Gravload""; """ + robot.name + """], sz(1), sz(2), ""fill"");";
                    x.graphics = graphics;
                    x.model = model;
                    break
                end
            end

        case "define" then
            model = scicos_model();
            model.sim = list("rtss_scs_gravload_cf4", 4);
            model.in = [-1];
            model.in2 = [1];
            model.intyp = [1];
            model.out = -1;
            model.out2 = 1;
            model.outtyp = 1;
            model.opar = list();
            model.blocktype = "d";
            model.dep_ut = [%T %F];
            exprs = ["rt_robot()"; sci2exp([0; 0; 9.81])];
            gr_i = ["xstringb(orig(1), orig(2), [""RTSS""; ""Gravload""; ""noname""], sz(1), sz(2), ""fill"");"];
            x = standard_define([3 2], model, exprs, gr_i);

    end

endfunction
