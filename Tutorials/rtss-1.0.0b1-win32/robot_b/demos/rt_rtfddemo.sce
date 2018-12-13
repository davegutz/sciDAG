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



// File name:       rt_rttgdemo.sce
//
// Description:     demo for Forward dynamics
//
// Annotations:     this code is a Scilab port of corresponding demo in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/rtfddemo.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

text = [..
"// Forward dynamics is the computation of joint accelerations given position and";..
"// velocity state, and actuator torques.  It is useful in simulation of a robot";..
"// control system.";..
"//";..
"// Consider a Puma 560 at rest in the zero angle pose, with zero applied joint ";..
"// torques. The joint acceleration would be given by";..
"-->rt_accel(p560, qz, zeros(1,6), zeros(1,6)),";..
" ans  =";..                            // parag1//@8
"";..
"// To be useful for simulation this function must be integrated.  rt_fdyn() uses the";..
"// Scilab function ode() to integrate the joint acceleration.  It also allows ";..
"// for a user written function to compute the joint torque as a function of ";..
"// manipulator state.";..
"//";..
"// To simulate the motion of the Puma 560 from rest in the zero angle pose ";..
"// with zero applied joint torques";..
"-->t = [0:0.05:10];                                                ";..
" ";..
"-->tic(); [q, qd] = rt_fdyn(rt_nofriction(p560), 0, t); et = toc(), ";..//@19
" et  =";..//@20
"";..
"// and the resulting motion can be plotted versus time";..
"-->cfh = scf();";..//@23
" ";..
"-->drawlater();";..
" ";..
"-->subplot(3,1,1); plot(t, q(1,:));                                    // J1";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 1 (rad)"");";..
" ";..
"-->a0 = cfh.children(1); a0.data_bounds = [0 -0.5; 10 1];";..
" ";..
"-->a0.tight_limits = ""on""; a0.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a0.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 1 2 3 4 5 6 7 8 9 10], [""0"" ""1"" ""2"" ""3"" ""4"" ""5"" ""6"" ""7"" ""8"" ""9"" ""10""]);";..
" ";..
"-->a0.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-0.5 0 0.5 1], [""-0.5"" ""0"" ""0.5"" ""1""]);";..
" ";..
"-->subplot(3,1,2); plot(t, q(2,:));                                    // J2";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 2 (rad)"");";..
" ";..
"-->a1 = cfh.children(1); a1.data_bounds = [0 -4; 10 2];";..
" ";..
"-->a1.tight_limits = ""on""; a1.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a1.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 1 2 3 4 5 6 7 8 9 10], [""0"" ""1"" ""2"" ""3"" ""4"" ""5"" ""6"" ""7"" ""8"" ""9"" ""10""]);";..
" ";..
"-->a1.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-4 -2 0 2], [""-4"" ""-2"" ""0"" ""2""]);";..
" ";..
"-->subplot(3,1,3); plot(t, q(3,:));                                    // J3";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 3 (rad)"");";..
" ";..
"-->a2 = cfh.children(1); a2.data_bounds = [0 -40; 10 20];";..
" ";..
"-->a2.tight_limits = ""on""; a2.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a2.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 1 2 3 4 5 6 7 8 9 10], [""0"" ""1"" ""2"" ""3"" ""4"" ""5"" ""6"" ""7"" ""8"" ""9"" ""10""]);";..
" ";..
"-->a2.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-40 -20 0 20], [""-40"" ""-20"" ""0"" ""20""]);";..
" ";..
"-->drawnow();";..                      // parag2//@63
"";..
"// Clearly the robot is collapsing under gravity, but it is interesting to ";..
"// note that rotational velocity of the upper and lower arm are exerting ";..
"// centripetal and Coriolis torques on the waist joint, causing it to rotate.";..  // parag3//@67
"//";..
"// This can be shown in animation also";..
"-->cfh = scf(); a3 = cfh.children; a3.tight_limits = ""on"";";..//@70
" ";..
"-->a3.rotation_angles = [74, -30];";..
" ";..
"-->rt_plot(p560, q.'');";..            // parag3//@74
"";..
""..
];




mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(1:8)');
disp(rt_accel(p560, qz, zeros(1,6), zeros(1,6)));
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(9:19)');
t = [0:0.05:10];
tic(); [q, qd] = rt_fdyn(rt_nofriction(p560), 0, t); et = toc();
mprintf("%s\n", text(20:20)');
disp(et);
mprintf("%s\n%s\n%s\n", text(21:23)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(24:63)');
drawlater();
subplot(3,1,1); plot(t, q(1,:));                                    // J1
xgrid(); xtitle("", "Time (s)", "Joint 1 (rad)");
a0 = cfh.children(1); a0.data_bounds = [0 -0.5; 10 1];
a0.tight_limits = "on"; a0.auto_ticks = ["off" "off" "off"];
a0.x_ticks = tlist(["ticks", "locations", "labels"], [0 1 2 3 4 5 6 7 8 9 10], ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]);
a0.y_ticks = tlist(["ticks", "locations", "labels"], [-0.5 0 0.5 1], ["-0.5" "0" "0.5" "1"]);
subplot(3,1,2); plot(t, q(2,:));                                    // J2
xgrid(); xtitle("", "Time (s)", "Joint 2 (rad)");
a1 = cfh.children(1); a1.data_bounds = [0 -4; 10 2];
a1.tight_limits = "on"; a1.auto_ticks = ["off" "off" "off"];
a1.x_ticks = tlist(["ticks", "locations", "labels"], [0 1 2 3 4 5 6 7 8 9 10], ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]);
a1.y_ticks = tlist(["ticks", "locations", "labels"], [-4 -2 0 2], ["-4" "-2" "0" "2"]);
subplot(3,1,3); plot(t, q(3,:));                                    // J3
xgrid(); xtitle("", "Time (s)", "Joint 3 (rad)");
a2 = cfh.children(1); a2.data_bounds = [0 -40; 10 20];
a2.tight_limits = "on"; a2.auto_ticks = ["off" "off" "off"];
a2.x_ticks = tlist(["ticks", "locations", "labels"], [0 1 2 3 4 5 6 7 8 9 10], ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"]);
a2.y_ticks = tlist(["ticks", "locations", "labels"], [-40 -20 0 20], ["-40" "-20" "0" "20"]);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n",text(64:67)');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n",text(68:70)');
cfh = scf(); a3 = cfh.children; a3.tight_limits = "on";
mprintf("%s\n%s\n%s\n%s\n",text(71:74)');
a3.rotation_angles = [74, -30];
rt_plot(p560, q.');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n",text(75:76)');
clear text
