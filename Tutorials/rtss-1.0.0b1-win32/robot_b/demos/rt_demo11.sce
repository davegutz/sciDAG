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



// File name:       rt_demo11.sce
//
// Description:     Time history of the joint positions, the norm of end-effector error 
//                  position and orientation error with the closed-loop inverse Jacobian
//                  algorithm.
//
// Annotations:     Chapter 3, Figure 3.15.
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

pathDEMO11 = get_absolute_file_path("rt_demo11.sce");
mprintf("Loading Scicos diagram...\n");
scicos(pathDEMO11 + "scs/diag11.cos");

mprintf("Postprocessing Scicos simulation results...\n");
l = rt_link([0, 0.5, 0, 0]);
robot3R = rt_robot(list(l,l,l), "Simple Three link", "", "Sciavicco-Siciliano");
t = simout11_a.time;
ep = simout11_b.values(:,1:2);
eo = simout11_b.values(:,3);
q = simout11_a.values;
nep = (ep(:,1).^2 + ep(:,2).^2).^(1/2);

// joint positions (q)
cfh = scf();
drawlater();
a0 = cfh.children; a0.data_bounds = [0 -5; 5 5]; a0.tight_limits = "on"; a0.auto_ticks = ["off" "off" "off"];
a0.x_ticks = tlist(["ticks", "locations", "labels"], [0 1 2 3 4 5], ["0" "1" "2" "3" "4" "5"]);
a0.y_ticks = tlist(["ticks", "locations", "labels"], [-5 0 5], ["-5" "0" "5"]);
plot(t, q); xtitle("Joints Positions", "[s]", "[rad]"); xgrid();
legend(["Joint 1"; "Joint 2"; "Joint 3"], 4, %F);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

// plot norm of positional error (nep)
cfh = scf();
drawlater();
a1 = cfh.children; a1.data_bounds = [0 0; 5 1e-05]; a1.tight_limits = "on"; a1.auto_ticks = ["off" "off" "off"];
a1.x_ticks = tlist(["ticks", "locations", "labels"], [0 1 2 3 4 5], ["0" "1" "2" "3" "4" "5"]);
a1.y_ticks = tlist(["ticks", "locations", "labels"], 1e-05*[0 0.2 0.4 0.6 0.8 1], ["0" "0.2e-05" "0.4e-05" "0.6e-05" "0.8e-05" "1e-05"]);
plot(t, nep, "b"); xtitle("Norm of Positional Error", "[s]", "[m]"); xgrid();
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

// plot orientation error (eo)
cfh = scf();
drawlater();
a2 = cfh.children; a2.data_bounds = [0 -5e-08; 5 0]; a2.tight_limits = "on"; a2.auto_ticks = ["off" "off" "off"];
a2.x_ticks = tlist(["ticks", "locations", "labels"], [0 1 2 3 4 5], ["0" "1" "2" "3" "4" "5"]);
a2.y_ticks = tlist(["ticks", "locations", "labels"], 1e-08*[-5 -4 -3 -2 -1 0], ["-5e-08" "-4e-08" "-3e-08" "-2e-08" "-1e-08" "0"]);
plot(t, eo, "b"); xtitle("Orientation Error", "[s]", "[rad]"); xgrid();
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

// plot robot animation
cfh = scf(); cfh.auto_clear = "off"; a3 = cfh.children; a3.tight_limits = "on";
x = 0.25*(1 - cos(%pi*t)); y = 0.25*(2 + sin(%pi*t));
z_0 = zeros(size(x,1), size(x,2));
drawlater();
param3d(x, y, z_0, -52, 45); ce = gce(); ce.foreground = color("red");
rt_plot(robot3R, q(1,:), "noname"); zfloor = a3.data_bounds(1,3)*ones(size(x,1), size(x,2));
drawlater();
param3d(x, y, zfloor, -52, 45); ce = gce(); ce.foreground = color("black");
drawnow();
qg = q(1:100:$,:);
rt_plot(robot3R, qg);