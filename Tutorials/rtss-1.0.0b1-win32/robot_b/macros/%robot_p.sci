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



function %robot_p(r)
// File name:       %robot_p.sci
//
// Functions:       %robot_p, disp
//
// Description:     multi-line summary of the robot's kinematic parameters
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  MATLAB(R) equivalent "inputname" function is not implemented
//                  in Scilab.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/display.m
//                  Robotics Toolbox for MATLAB(R), robot7.1/@robot/char.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    // build a configuration string
    rp = [];
    for i = 1:r.n,
        rp = [rp r.links(i).RP];
    end

    printf("%s (%d axis, %s)", r.name, r.n, strcat(rp));

    if ~isempty(r.manuf) then
        printf(" [%s]", r.manuf);
    end

    if ~isempty(r.comment) then
        printf(" <%s>", r.comment);
    end

    mprintf("\n\t\tgrav = [%.2f %.2f %.2f]",r.gravity');

    if r.mdh == 0 then
        printf("\t\tstandard D&H parameters\n");
    else
        printf("\t\tmodified D&H parameters\n");
    end

    printf("\n\n  alpha\t\tA\t\ttheta\t\tD\t\tR/P\n");
    for i = 1:r.n,
        disp(r.links(i));
    end

endfunction
