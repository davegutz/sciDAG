mode(-1);
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



// File name:       rt_demo1.sce
//
// Description:     Dynamic simulation of Puma 560 robot collapsing under gravity
//
// Annotations:     this demo is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/simulink/demo1.mdl
//                  Robotics Toolbox for MATLAB(R), robot7.1/robot.pdf
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-09-09 18:42:46 +0200(mer, 09 set 2009) $

pathDEMO1 = get_absolute_file_path("rt_demo1.sce");
mprintf("Loading Scicos diagram...\n");
scicos(pathDEMO1 + "scs/diag1.cos");

mprintf("Postprocessing Scicos simulation results...\n");
exec(pathDEMO1 + "../models/rt_puma560.sce");
p560nf = rt_nofriction(p560);
t = simout1.time;
q = simout1.values(:,1:6);
qd = simout1.values(:,7:12);

// plot robot animation
cfh = scf();
a0 = cfh.children; a0.tight_limits = "on"; a0.rotation_angles = [74, -30];
rt_plot(p560nf, q, "base");
