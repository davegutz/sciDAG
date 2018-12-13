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



function rt_qplot(Q, options)
// File name:       rt_qplot.sci
//
// Function:        rt_qplot
//
// Description:     display a quaternion as a 3D rotation
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  Added support for custom colors of x-y-z axes
//
// To do:           maintain/set a default point of view
//                  maintain auto-clear
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@quaternion/plot.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout,%nargin] = argn(0);

    drawlater();

    // default options for axes plotting
    plotoptions.x.color = "black";
    plotoptions.y.color = "black";
    plotoptions.z.color = "black";

    if %nargin > 1 then

        i = 1;
        while i <= length(options),
            select convstr(options(i),"l")
                case "x" then
                    plotoptions.x.color = options(i+1);
                    i = i+1;
                case "y" then
                    plotoptions.y.color = options(i+1);
                    i = i+1;
                case "z" then
                    plotoptions.z.color = options(i+1);
                    i = i+1;
                else
                    error("unknown option: %s\n",options(i));
            end
            i = i+1;
        end

    end

    currax = gca();
    viewpoint = currax.rotation_angles;
    old_auto_clear = currax.auto_clear;
    currax.data_bounds = [-1 -1 -1;1 1 1];

    // create unit vectors
    o = [0 0 0]';
    x1 = Q*[1 0 0]';
    y1 = Q*[0 1 0]';
    z1 = Q*[0 0 1]';

    currax.auto_clear = "off";
    rt_line(currax.parent, [0;x1(1)], [0;x1(2)], [0;x1(3)], plotoptions.x.color, 1, "copy");
    rt_text(currax.parent, x1(1), x1(2), "X", "copy", x1(3));
    rt_line(currax.parent, [0;y1(1)], [0;y1(2)], [0;y1(3)], plotoptions.y.color, 1, "copy");
    rt_text(currax.parent, y1(1), y1(2), "Y", "copy", y1(3));
    rt_line(currax.parent, [0;z1(1)], [0;z1(2)], [0;z1(3)], plotoptions.z.color, 1, "copy");
    rt_text(currax.parent, z1(1), z1(2), "Z", "copy", z1(3));
    xgrid();
    
    // maintain point of view
    currax.rotation_angles = viewpoint;
    
    currax.x_label.text = "X";
    currax.y_label.text = "Y";
    currax.z_label.text = "Z";
    
    // maintain auto_clear
    currax.auto_clear = old_auto_clear;

    drawnow();

endfunction
