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



function [x, y, typ] = rt_square_if(job, arg1, arg2)
// File name:       rt_square_if.sci
//
// Function:        rt_square_if
//
// Description:     handle the user interface of the Scicos block named "rt_square_if"
//
// Annotations:     Inspired to square wave generator provided with RTAI-Lab by Roberto Bucher,
//                  SUPSI (roberto.bucher@supsi.ch).
//
// References:      RTAI-Lab, rtai-3.7.1/rtai-lab/scicoslab/macros/RTAI/rtai4_square.sci
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
            while %T do
                [ok, A, prd, pulse, bias, delay, exprs] = getvalue(..
                    "Set RTSS square wave generator block parameters",..
                    ["Amplitude:";..
                    "Period:";..
                    "Impulse width:";..
                    "Bias:";..
                    "Delay:"],..
                    list("vec", 1, "vec", 1, "vec", 1, "vec", 1, "vec", 1),..
                    exprs);
                if ~ok then
                    break;
                end
                [model, graphics, ok] = set_io(model, graphics, list(), list([1, 1], 1), 1, []);
                if ok then
                    graphics.exprs = exprs;
                    model.rpar = [A; prd; pulse; bias; delay];
                    model.ipar = [];
                    x.graphics = graphics;
                    x.model = model;
                    break;
                end
            end

        case "define" then
            A = 1;
            prd = 4;
            pulse = 2;
            bias = 0;
            delay = 0;
            model = scicos_model();
            model.sim = list("rtss_scs_square_cf4", 4);
            model.in = [];
            model.in2 = [];
            model.intyp = [];
            model.out = 1;
            model.out2 = 1;
            model.outtyp = 1;
            model.evtin = 1;
            model.rpar = [A; prd; pulse; bias; delay];
            model.ipar = [];
            model.blocktype = "d";
            model.dep_ut = [%F %F];
            exprs = [sci2exp(A), sci2exp(prd), sci2exp(pulse), sci2exp(bias), sci2exp(delay)];
            gr_i = ["xstringb(orig(1), orig(2), [""RTSS""; ""Square""; ""Wave""], sz(1), sz(2), ""fill"");"];
            x = standard_define([3 2], model, exprs, gr_i);

    end

endfunction
