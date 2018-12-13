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



// File name:       rt_demo10.sce
//
// Description:     Time history of the norm of end-effector position error and orientation
//                  error with the open-loop inverse Jacobian algorithm.
//
// Annotations:     Chapter 3, Figure 3.14.
//
// References:      L. Sciavicco, B. Siciliano, "Modelling and Control of Robot Manipulators",
//                  2nd Edition, Springer-Verlag Advanced Textbooks in Control and Signal
//                  Processing Series, London, UK, 2000.
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-09-09 18:42:46 +0200(mer, 09 set 2009) $

pathDEMO10 = get_absolute_file_path("rt_demo10.sce");
mprintf("Loading Scicos diagram...\n");
scicos(pathDEMO10 + "scs/diag10.cos");

mprintf("Postprocessing Scicos simulation results...\n");
l = rt_link([0, 0.5, 0, 0]);
robot3R = rt_robot(list(l,l,l), "Simple Three link", "", "Sciavicco-Siciliano");
t = simout10_a.time;
q = simout10_a.values;
ep = simout10_b.values(:,1:2);
eo = simout10_b.values(:,3);
nep = (ep(:,1).^2 + ep(:,2).^2).^(1/2);

// plot norm of positional error (nep)
cfh = scf();
drawlater();
a0 = cfh.children; a0.data_bounds = [0 0; 5 2e-03]; a0.tight_limits = "on"; a0.auto_ticks = ["off" "off" "off"];
a0.x_ticks = tlist(["ticks", "locations", "labels"], [0 1 2 3 4 5], ["0" "1" "2" "3" "4" "5"]);
a0.y_ticks = tlist(["ticks", "locations", "labels"], 1e-03*[0 0.5 1 1.5 2], ["0" "0.5e-03" "1e-03" "1.5e-03" "2e-03"]);
plot(t, nep, "b"); xtitle("Norm of Positional Error", "[s]", "[m]"); xgrid();
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

// plot orientation error (eo)
cfh = scf();
drawlater();
a1 = cfh.children; a1.data_bounds = [0 -1e-05; 5 1e-7]; a1.tight_limits = "on"; a1.auto_ticks = ["off" "off" "off"];
a1.x_ticks = tlist(["ticks", "locations", "labels"], [0 1 2 3 4 5], ["0" "1" "2" "3" "4" "5"]);
a1.y_ticks = tlist(["ticks", "locations", "labels"], 1e-05*[-1 -0.8 -0.6 -0.4 -0.2 0], ["-1e-05" "-0.8e-05" "-0.6e-05" "-0.4e-05" "-0.2e-05" "0"]);
plot(t, eo, "b"); xtitle("Orientation Error", "[s]", "[rad]"); xgrid();
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

// plot robot animation
cfh = scf(); cfh.auto_clear = "off"; a2 = cfh.children; a2.tight_limits = "on";
x = 0.25*(1 - cos(%pi*t)); y = 0.25*(2 + sin(%pi*t));
z_0 = zeros(size(x,1), size(x,2));
drawlater();
param3d(x, y, z_0, -52, 45); ce = gce(); ce.foreground = color("red");
rt_plot(robot3R, q(1,:), "noname"); zfloor = a2.data_bounds(1,3)*ones(size(x,1), size(x,2));
drawlater();
param3d(x, y, zfloor, -52, 45); ce = gce(); ce.foreground = color("black");
drawnow();
qg = q(1:100:$,:);
rt_plot(robot3R, qg);
