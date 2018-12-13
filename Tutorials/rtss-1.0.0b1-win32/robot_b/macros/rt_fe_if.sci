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



function [x, y, typ] = rt_fe_if(job, arg1, arg2)
// File name:       rt_fe_if.sci
//
// Function:        rt_fe_if
//
// Description:     handle the user interface of the Scicos block named "rt_fe_if"
//
// Annotations:     none
//
// References:      A. Layec, "Modnum": Scilab toolbox for the communication systems -
//                  Reference Guide, Draft Version, February 2006, pp. 158-159
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-08-08 11:29:41 +0200(sab, 08 ago 2009) $

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
            while %T do
                [ok, step, x0, exprs] = getvalue(..
                    ["Set discrete integral parameters"; "(Forward Euler method)"],..
                    ["Step"; "Initial state"],..
                    list("vec", 1,"vec", -1),..
                    exprs);
                if ~ok then
                    break;
                end
                nu = [length(x0), 1];
                [model, graphics, ok] = set_io(model, graphics, list(nu, 1), list(nu, 1), 1, []);
                if ok then
                    graphics.exprs = exprs;
                    model.rpar = step;
                    model.dstate = x0(:);
                    x.graphics = graphics;
                    x.model = model;
                    break;
                end
            end

        case "define" then
            x0 = 0;
            step = 1;
            model = scicos_model();
            model.sim = list("rtss_scs_fe_cf4",4);
            model.in = 1;
            model.in2 = 1;
            model.intyp = 1;
            model.out = 1;
            model.out2 = 1;
            model.outtyp = 1;
            model.evtin = 1;
            model.evtout = [];
            model.rpar = step;
            model.dstate = x0;
            model.blocktype = "d";
            model.dep_ut = [%F %F];
            exprs=[string(step);strcat(sci2exp(x0))];
            gr_i=['thick=xget(''thickness'')'
                  'pat=xget(''pattern'')'
                  'fnt=xget(''font'')'
                  'xpoly(orig(1)+[0.7;0.62;0.549;0.44;0.364;0.291]*sz(1),orig(2)+[0.947;0.947;0.884;0.321;0.255;0.255]*sz(2),"'lines"')'
                  'xset(''font'',5,1)'
                  'txt=[''Forward'';''Euler''];'
                  'style=5;'
                  'rectstr=stringbox(txt,orig(1),orig(2),0,style,1);'
                  'w=(rectstr(1,3)-rectstr(1,2))*%zoom;'
                  'h=(rectstr(2,2)-rectstr(2,4))*%zoom;'
                  'xstringb(orig(1)+sz(1)/2-w/2,orig(2)-h-4,txt,w,h,''fill'');'
                  'e=gce();'
                  'e.font_style=style;'
                  'xset(''thickness'',thick)'
                  'xset(''pattern'',pat)'
                  'xset(''font'',fnt(1),fnt(2))'
                 ]
            x=standard_define([2 2],model,exprs,gr_i)

    end

endfunction
