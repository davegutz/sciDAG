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



function [rp] = %robot_m_robot(r1, r2)
// File name:       %robot_m_robot.sci
//
// Functions:       %robot_m_robot, * (star)
//
// Description:     construct a robot which is the series connection of the multiplicands
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  The name of returned robot object is the name the first robot in the
//                  series connection modified with a suffix.
//                  All the other properties of returned robot object are inherited from
//                  the first robot in the chain.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/mtimes.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-04-30 11:04:15 +0200(gio, 30 apr 2009) $

    L = lstcat(r1.links, r2.links);
    rp = rt_robot(L, r1.name + " " + sci2exp(r1.n + r2.n) + "axs", "", "");
    rp.gravity = r1.gravity;        // inherit from r1
    rp.base = r1.base;
    rp.tool = r1.tool;
    rp.plotopt = r1.plotopt;
    rp.lineopt = r1.lineopt;
    rp.shadowopt = r1.shadowopt;

endfunction
