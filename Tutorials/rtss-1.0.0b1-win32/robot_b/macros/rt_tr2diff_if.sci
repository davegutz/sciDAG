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



function [x, y, typ] = rt_tr2diff_if(job, arg1, arg2)
// File name:       rt_tr2diff_if.sci
//
// Function:        rt_tr2diff_if
//
// Description:     handle the user interface of the Scicos block named "rt_tr2diff_if"
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
// $LastChangedDate: 2009-07-28 14:23:41 +0200(mar, 28 lug 2009) $

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
            model.sim = list("rtss_scs_tr2diff_cf4", 4);
            model.in = [4; 4];
            model.in2 = [4; 4];
            model.intyp = [1; 1];
            model.out = 6;
            model.out2 = 1;
            model.outtyp = 1;
            model.blocktype = "d";
            model.dep_ut = [%T %F];
            gr_i = ["xstringb(orig(1), orig(2), [""RTSS"";"" ""; ""Tr2Diff""], sz(1), sz(2), ""fill"");"];
            x = standard_define([3 2], model, "", gr_i);

    end

endfunction
