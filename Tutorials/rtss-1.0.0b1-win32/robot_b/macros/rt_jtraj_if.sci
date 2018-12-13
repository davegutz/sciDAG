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



function [x, y, typ] = rt_jtraj_if(job, arg1, arg2)
// File name:       rt_jtraj_if.sci
//
// Function:        rt_jtraj_if
//
// Description:     handle the user interface of the Scicos block named "rt_jtraj_if"
//
// Annotations:     It is used to define, initialize and draw a Scicos block for the
//                  corresponding Simulink(R) block in the "roblock" library. The
//                  "roblock" library is part of the Robotics Toolbox for MATLAB(R)
//                  and is Copyright (C) 2002, by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/simulink/roblock.mdl
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-09-14 18:12:54 +0200(lun, 14 set 2009) $

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
            [x,y]=standard_origin(arg1);

        case "set" then
            x = arg1;
            graphics = arg1.graphics;
            exprs = graphics.exprs;
            model = arg1.model;
            while %T do,
                [ok, q0, qf, tmax, exprs] = getvalue(..
                    ["Joint interpolated trajectory"],..
                    ["q0";..
                    "qf";..
                    "tmax"],..
                    list("vec", -1,"vec", -1,"vec", 1),..
                    exprs);
                if length(q0) ~= length(qf) then
                    message("q0 and qf must be same length");
                    ok = %F;
                elseif (length(q0) ~= 0) &..
                        ((size(q0,1) ~= 1 & size(q0,2) ~= 1) | (size(qf,1) ~= 1 & size(qf,2) ~= 1)) then
                    message("q0 and qf must be vectors");
                    ok = %F;
                end
                if ~ok then
                    break;
                end
                n = length(q0);
                [model, graphics, ok] = set_io(model, graphics, list(), list([n, 1; n, 1; n, 1], [1; 1; 1]), [], []);
                if ok then
                    t = [0:100].' / 100 * tmax;
                    [q, qd, qdd] = rt_jtraj(q0, qf, t);
                    graphics.exprs = exprs;
                    model.rpar = [q, qd, qdd, t];
                    model.ipar=n;
                    x.graphics=graphics;
                    x.model=model;
                    break;
                end
            end

        case "define" then
            q0 = [0, 0, 0, 0, 0, 0];
            qf = [%pi/4, %pi/2, -%pi/2, 0, 0, 0];
            tmax = 10;
            t = [0:100].' / 100 * tmax;
            [q, qd, qdd] = rt_jtraj(q0, qf, t);
            model = scicos_model();
            model.sim = list("rtss_scs_jtraj_cf4",4);
            model.in = [];
            model.in2 = [];
            model.intyp = [];
            model.out = [6; 6; 6];
            model.out2 = [1; 1; 1];
            model.outtyp = [1; 1; 1];
            model.evtin = [];
            model.evtout = [];
            model.rpar = [q, qd, qdd, t];
            model.ipar = 6;
            model.blocktype = "d";
            model.dep_ut = [%F %T];
            exprs = [sci2exp(q0); sci2exp(qf); sci2exp(tmax)];
            gr_i = ["xstringb(orig(1), orig(2), [""RTSS"";"" "";""JTraj""], sz(1), sz(2), ""fill"");"];
            x = standard_define([3 2], model, exprs, gr_i);

    end

endfunction
