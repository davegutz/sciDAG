// Copyright (C) 1999-2002, by Peter I. Corke
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



function rt_showlink(obj)
// File name:       rt_showlink.sci
//
// Function:        rt_showlink
//
// Description:     show link/robot data in detail
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  The MATLAB(R) function fieldname is missing. made a workaround.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/showlink.m
//                  Robotics Toolbox for MATLAB(R), robot7.1/@robot/showlink.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    if typeof(obj) == "link" then

        link_fieldnames = list("alpha", "A", "theta", "D", "sigma", "mdh", "offset",..
                            "m", "r", "I", "Jm", "G", "B", "Tc", "qlim");
        llab = 6;
        for name = link_fieldnames,
            v = obj(name);
            spaces = char(ascii(" ")*ones(1, llab - length(name)));
            if ~isempty(v) then
                val = string(v);
            else
                val = "";
            end
            label = name + spaces + " = ";
            if size(val,"*") > 1 then
                pad = [label; char(ascii(" ")*ones(size(val,1) - 1, 1))];
                disp([pad, val]);
            else
                disp(label + val);
            end
        end

    elseif typeof(obj) == "robot" then

        l = obj.links;
        for i = 1:obj.n,
            printf("Link %d------------------------\n", i);
            rt_showlink(l(i));
        end

    else

        error("input argument should be a link or a robot");

    end

endfunction
