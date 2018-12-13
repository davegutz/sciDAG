mode(-1);
// Copyright (C) 1993-2002, by Peter I. Corke
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



// File name:       rt_rtdemo.sce
//
// Description:     Robotics Toolbox demonstrations
//
// Annotations:     this code is a Scilab port of corresponding demonstration script
//                  in the Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/rtdemo.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

pathD = get_absolute_file_path("rt_rtdemo.sce");
rtdemolist = [..
            "Transformations",      pathD + "rt_rttrdemo.sce";..
            "Trajectory",           pathD + "rt_rttgdemo.sce";..
            "Forward kinematics",   pathD + "rt_rtfkdemo.sce";..
            "Animation",            pathD + "rt_rtandemo.sce";..
            "Inverse kinematics",   pathD + "rt_rtikdemo.sce";..
            "Jacobians",            pathD + "rt_rtjademo.sce";..
            "Inverse dynamics",     pathD + "rt_rtidemo.sce";..
            "Forward dynamics",     pathD + "rt_rtfddemo.sce"];

if ~isdef("p560") then
    exec(pathD + "../models/rt_puma560.sce");
end

while %T then

    num = tk_choose(rtdemolist(:,1), ["Robotics Toolbox demonstrations"; "Click to choose a demo"]);
    if num == 0 then
        clear num tk_choose rtdemolist pathD get_absolute_file_path
        return
    else
        exec(rtdemolist(num, 2), -1);
    end

end
