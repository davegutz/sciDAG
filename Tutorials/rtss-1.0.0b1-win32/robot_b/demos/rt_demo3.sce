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



// File name:       rt_demo3.sce
//
// Description:     Puma560 with a computed torque control structure
//
// Annotations:     this demo is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/simulink/demo3.mdl
//                  Robotics Toolbox for MATLAB(R), robot7.1/robot.pdf
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-09-09 18:42:46 +0200(mer, 09 set 2009) $

pathDEMO3 = get_absolute_file_path("rt_demo3.sce");
mprintf("Loading Scicos diagram...\n");
scicos(pathDEMO3 + "scs/diag3.cos");

mprintf("Postprocessing Scicos simulation results...\n");
exec(pathDEMO3 + "../models/rt_puma560.sce");
p560nf = rt_nofriction(p560);
t = simout3_a.time;
jerr = simout3_a.values;
tau = simout3_b.values(:,1:6);
q = simout3_b.values(:,7:12);

// plot computed joint trajectory
scf();
drawlater();
plot(t, q); xtitle("Computed Joint Trajectory", "[s]", "[rad]"); xgrid();
legend(["Joint 1"; "Joint 2"; "Joint 3"; "Joint 4"; "Joint 5"; "Joint 6"], 3, %T);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

// plot robot animation
cfh = scf();
a0 = cfh.children; a0.tight_limits = "on"; a0.rotation_angles = [77, 29];
rt_plot(p560nf, q);
