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



function [x, y, typ] = rt_rpy2tr_if(job, arg1, arg2)
// File name:       rt_rpy2tr_if.sci
//
// Function:        rt_rpy2tr_if
//
// Description:     handle the user interface of the Scicos block named "rt_rpy2tr_if"
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
// $LastChangedDate: 2009-08-05 19:16:21 +0200(mer, 05 ago 2009) $

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

        case "define" then
            model = scicos_model();
            model.sim = list("rtss_scs_rpy2tr_cf4", 4);
            model.in = [1; 1; 1];
            model.in2 = [1; 1; 1];
            model.intyp = [1; 1; 1];
            model.out = 4;
            model.out2 = 4;
            model.outtyp = 1;
            model.blocktype = "d";
            model.dep_ut = [%T %F];
            gr_i = ["xstringb(orig(1), orig(2), [""RTSS"";"" ""; ""RPY2Tr""], sz(1), sz(2), ""fill"");"];
            x = standard_define([3 2], model, "", gr_i);

    end

endfunction
