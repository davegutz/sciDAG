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



// File name:       rt_rtidemo.sce
//
// Description:     demo for Inverse dynamics
//
// Annotations:     this code is a Scilab port of corresponding demo in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/rtidemo.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

text = [..
"//  Inverse dynamics computes the joint torques required to achieve the specified";..
"//  state of joint position, velocity and acceleration.  ";..
"//  The recursive Newton-Euler formulation is an efficient matrix oriented";..
"//  algorithm for computing the inverse dynamics, and is implemented in the ";..
"//  function rt_frne().";..
"//";..
"//  Inverse dynamics requires inertial and mass parameters of each link, as well";..
"//  as the kinematic parameters.  This is achieved by augmenting the kinematic ";..
"//  description matrix with additional columns for the inertial and mass ";..
"//  parameters for each link.";..
"//";..
"//  For example, for a Puma 560 in the zero angle pose, with all joint velocities";..
"//  of 5rad/s and accelerations of 1rad/s^2, the joint torques required are";..
"-->tau = rt_frne(p560, qz, 5*ones(1,6), ones(1,6)),";..//@14
" tau  =";..                            // parag1//@15
"";..
"// As with other functions the inverse dynamics can be computed for each point ";..
"// on a trajectory.  Create a joint coordinate trajectory and compute velocity ";..
"// and acceleration as well";..
"-->t = [0:0.056:2];                            // create time vector";..
" ";..
"-->[q, qd, qdd] = rt_jtraj(qz, qready, t);     // compute joint coordinate trajectory";..//@22
" ";..
"-->tau = rt_frne(p560, q, qd, qdd);            // compute inverse dynamics";..//@24
"";..
"// Now the joint torques can be plotted as a function of time";..
"-->cfh = scf();";..//@27
" ";..
"-->drawlater();";..
" ";..
"-->plot(t, tau(:,1:3));                                        // J2, J3 TORQUE";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint torque (Nm)"");";..
" ";..
"-->a0 = cfh.children; a0.data_bounds = [0 -10; t($) 70];";..
" ";..
"-->a0.tight_limits = ""on""; a0.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a0.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a0.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-10 0 10 20 30 40 50 60 70], [""-10"" ""0"" ""10"" ""20"" ""30"" ""40"" ""50"" ""60"" ""70""]);";..
" ";..
"-->drawnow()";..                       // parag2//@43
"";..
"// Much of the torque on joints 2 and 3 of a Puma 560 (mounted conventionally) is";..
"// due to gravity.  That component can be computed using rt_gravload()";..
"-->taug = rt_gravload(p560, q);";..//@47
" ";..
"-->xdel(cfh.figure_id);";..//@49
" ";..
"-->cfh = scf();";..//@51
" ";..
"-->drawlater();";..
" ";..
"-->plot(t, taug(:,1:3));                                        // J2, J3 GRAVITY TORQUE";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Gravity torque (Nm)"");";..
" ";..
"-->a1 = cfh.children; a1.data_bounds = [0 -5; t($) 40];";..
" ";..
"-->a1.tight_limits = ""on""; a1.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a1.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a1.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-5 0 5 10 15 20 25 30 35 40], [""-5"" ""0"" ""5"" ""10"" ""15"" ""20"" ""25"" ""30"" ""35"" ""40""]);";..
" ";..
"-->drawnow();";..                      // parag3//@67
"";..
"// Now lets plot that as a fraction of the total torque required over the ";..
"// trajectory";..
"-->xdel(cfh.figure_id);";..//@71
" ";..
"-->cfh = scf();";..//@73
" ";..
"-->drawlater();";..
" ";..
"-->subplot(2,1,1); plot(t, [tau(:,2), taug(:,2)]);                     // J2";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Torque on joint 2 (Nm)"");";..
" ";..
"-->a2 = cfh.children(1); a2.data_bounds = [0 -20; t($) 80];";..
" ";..
"-->a2.tight_limits = ""on""; a2.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a2.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a2.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-20 0 20 40 60 80], [""-20"" ""0"" ""20"" ""40"" ""60"" ""80""]);";..
" ";..
"-->subplot(2,1,2); plot(t, [tau(:,3), taug(:,3)]);                     // J3";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Torque on joint 3 (Nm)"");";..
" ";..
"-->a3 = cfh.children(1); a3.data_bounds = [0 0; t($) 8];";..
" ";..
"-->a3.tight_limits = ""on""; a3.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a3.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a3.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 2 4 6 8], [""0"" ""2"" ""4"" ""6"" ""8""]);";..
" ";..
"-->drawnow();";..                      // parag4//@101
"";..
"// The inertia seen by the waist (joint 1) motor changes markedly with robot ";..
"// configuration.  The function rt_inertia() computes the manipulator inertia matrix";..
"// for any given configuration.";..
"//";..
"// Let''s compute the variation in joint 1 inertia, that is M(1,1), as the ";..
"// manipulator moves along the trajectory (this may take a few minutes)";..
"-->M = rt_inertia(p560, q);";..//@109
" ";..
"-->M11 = matrix(M(1,1,:), 1, size(q,1));";..
" ";..
"-->xdel(cfh.figure_id);";..//@113
" ";..
"-->cfh = scf();";..//@115
" ";..
"-->drawlater();";..
" ";..
"-->plot(t, M11);                                           // J1 INERTIA";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Inertia on joint 1 (kgms^2)"");";..
" ";..
"-->a4 = cfh.children; a4.data_bounds = [0 2; t($) 4];";..
" ";..
"-->a4.tight_limits = ""on""; a4.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a4.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a4.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [2 2.5 3 3.5 4], [""2"" ""2.5"" ""3"" ""3.5"" ""4""]);";..
" ";..
"-->drawnow();";..//@131
"";..
"// Clearly the inertia seen by joint 1 varies considerably over this path.";..
"// This is one of many challenges to control design in robotics, achieving ";..
"// stability and high-performance in the face of plant variation.  In fact ";..
"// for this example the inertia varies by a factor of";..
"-->max(M11) / min(M11),";..
" ans  =";..                            // parag6//@138
"";..
""..//@140
];

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",text(1:14)');
tau = rt_frne(p560, qz, 5*ones(1,6), ones(1,6));
mprintf("%s\n",text(15:15)');
disp(tau);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n",text(16:22)');
t = [0:0.056:2];
[q, qd, qdd] = rt_jtraj(qz, qready, t);
mprintf("%s\n%s\n",text(23:24)');
tau = rt_frne(p560, q, qd, qdd);
mprintf("%s\n%s\n%s\n",text(25:27)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",text(28:43)');
drawlater();
plot(t, tau(:,1:3));                                        // J2, J3 TORQUE
xgrid(); xtitle("", "Time (s)", "Joint torque (Nm)");
a0 = cfh.children; a0.data_bounds = [0 -10; t($) 70];
a0.tight_limits = "on"; a0.auto_ticks = ["off" "off" "off"];
a0.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a0.y_ticks = tlist(["ticks", "locations", "labels"],..
    [-10 0 10 20 30 40 50 60 70], ["-10" "0" "10" "20" "30" "40" "50" "60" "70"]);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n",text(44:47)');
taug = rt_gravload(p560, q);
mprintf("%s\n%s\n",text(48:49)');
xdel(cfh.figure_id);
mprintf("%s\n%s\n",text(50:51)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",text(52:67)');
drawlater();
plot(t, taug(:,1:3));                                        // J2, J3 GRAVITY TORQUE
xgrid(); xtitle("", "Time (s)", "Gravity torque (Nm)");
a1 = cfh.children; a1.data_bounds = [0 -5; t($) 40];
a1.tight_limits = "on"; a1.auto_ticks = ["off" "off" "off"];
a1.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a1.y_ticks = tlist(["ticks", "locations", "labels"],..
    [-5 0 5 10 15 20 25 30 35 40], ["-5" "0" "5" "10" "15" "20" "25" "30" "35" "40"]);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n",text(68:71)');
xdel(cfh.figure_id);
mprintf("%s\n%s\n",text(72:73)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",text(74:101)');
drawlater();
subplot(2,1,1); plot(t, [tau(:,2), taug(:,2)]);                     // J2
xgrid(); xtitle("", "Time (s)", "Torque on joint 2 (Nm)");
a2 = cfh.children(1); a2.data_bounds = [0 -20; t($) 80];
a2.tight_limits = "on"; a2.auto_ticks = ["off" "off" "off"];
a2.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a2.y_ticks = tlist(["ticks", "locations", "labels"],..
    [-20 0 20 40 60 80], ["-20" "0" "20" "40" "60" "80"]);
subplot(2,1,2); plot(t, [tau(:,3), taug(:,3)]);                     // J3
xgrid(); xtitle("", "Time (s)", "Torque on joint 3 (Nm)");
a3 = cfh.children(1); a3.data_bounds = [0 0; t($) 8];
a3.tight_limits = "on"; a3.auto_ticks = ["off" "off" "off"];
a3.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a3.y_ticks = tlist(["ticks", "locations", "labels"], [0 2 4 6 8], ["0" "2" "4" "6" "8"]);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",text(102:109)');
M = rt_inertia(p560, q);
mprintf("%s\n%s\n%s\n%s\n",text(110:113)');
M11 = matrix(M(1,1,:), 1, size(q,1));
xdel(cfh.figure_id);
mprintf("%s\n%s\n",text(114:115)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n",text(116:131)');
drawlater();
plot(t, M11);                                           // J1 INERTIA
xgrid(); xtitle("", "Time (s)", "Inertia on joint 1 (kgms^2)");
a4 = cfh.children; a4.data_bounds = [0 2; t($) 4];
a4.tight_limits = "on"; a4.auto_ticks = ["off" "off" "off"];
a4.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a4.y_ticks = tlist(["ticks", "locations", "labels"],..
    [2 2.5 3 3.5 4], ["2" "2.5" "3" "3.5" "4"]);
drawnow();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n",text(132:138)');
disp(max(M11) / min(M11));
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n",text(139:140)');
clear text
