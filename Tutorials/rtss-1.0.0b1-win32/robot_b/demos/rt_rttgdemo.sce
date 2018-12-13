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
// Description:     demo for Trajectories
//
// Annotations:     this code is a Scilab port of corresponding demo in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/rttgdemo.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

text = [..
"// The path will move the robot from its zero angle pose to the upright (or ";..
"// READY) pose.";..
"";..
"// First create a time vector, completing the motion in 2 seconds with a";..
"// sample interval of 56ms.";..
"-->t = [0:0.056:2];";..                // parag1
"";..
"// A polynomial trajectory between the 2 poses is computed using rt_jtraj()";..
"-->q = rt_jtraj(qz, qready, t);";..    // parag2
"";..
" // For this particular trajectory most of the motion is done by joints 2 and 3,";..
" // and this can be conveniently plotted using standard Scilab plotting commands";..
"-->cfh = scf();";..
" ";..
"-->drawlater();";..
" ";..
"-->subplot(2,1,1); plot(t, q(:,2));                             // JOINT 2";..
" ";..
"-->xgrid(); xtitle(""Theta"", ""Time (s)"", ""Joint 2 (rad)"");";..
" ";..
"-->a0 = cfh.children(1); a0.data_bounds = [0 0; t($) 2];";..
" ";..
"-->a0.tight_limits = ""on""; a0.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a0.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a0.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.5 1 1.5 2], [""0"" ""0.5"" ""1"" ""1.5"" ""2""]);";..
" ";..
"-->subplot(2,1,2); plot(t, q(:,3));                             // JOINT 3";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 3 (rad)"");";..
" ";..
"-->a1 = cfh.children(1); a1.data_bounds = [0 -2; t($) 0];";..
" ";..
"-->a1.tight_limits = ""on""; a1.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a1.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a1.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 -0.5 -1 -1.5 -2], [""0"" ""-0.5"" ""-1"" ""-1.5"" ""-2""]);";..
" ";..
"-->drawnow();";..                      // parag3
"";
"// We can also look at the velocity and acceleration profiles.  We could ";..
"// differentiate the angle trajectory using diff(), but more accurate results ";..
"// can be obtained by requesting that rt_jtraj() return angular velocity and ";..
"// acceleration as follows";..
"-->[q, qd, qdd] = rt_jtraj(qz, qready, t);";..
"";..
"// which can then be plotted as before";..
"-->xdel(cfh.figure_id);";..
" ";..
"-->cfh = scf();";..
" ";..
"-->drawlater();";..
" ";..
"-->subplot(2,1,1); plot(t, qd(:,2));                           // VEL J2";..
" ";..
"-->xgrid(); xtitle(""Velocity"", ""Time (s)"", ""Joint 2 vel (rad/s)"");";..
" ";..
"-->a2 = cfh.children(1); a2.data_bounds = [0 0; t($) 2];";..
" ";..
"-->a2.tight_limits = ""on""; a2.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a2.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a2.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.5 1 1.5 2], [""0"" ""0.5"" ""1"" ""1.5"" ""2""]);";..
" ";..
"-->subplot(2,1,2); plot(t, qd(:,3));                           // VEL J3";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 3 vel (rad/s)"");";..
" ";..
"-->a3 = cfh.children(1); a3.data_bounds = [0 -2; t($) 0];";..
" ";..
"-->a3.tight_limits = ""on""; a3.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a3.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a3.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-2 -1.5 -1 -0.5 0], [""-2"" ""-1.5"" ""-1"" ""-0.5"" ""0""]);";..
" ";..
"-->drawnow();";..                      // parag4
"";..
"// and the joint acceleration profiles";..
"-->xdel(cfh.figure_id);";..
" ";..
"-->cfh = scf();";..
" ";..
"-->drawlater();";..
" ";..
"-->subplot(2,1,1); plot(t, qdd(:,2));                           // ACCEL J2";..
" ";..
"-->xgrid(); xtitle(""Acceleration"", ""Time (s)"", ""Joint 2 accel (rad/s^2)"");";..
" ";..
"-->a4 = cfh.children(1); a4.data_bounds = [0 -4; t($) 4];";..
" ";..
"-->a4.tight_limits = ""on""; a4.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a4.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a4.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-4 -2 0 2 4], [""-4"" ""-2"" ""0"" ""2"" ""4""]);";..
" ";..
"-->subplot(2,1,2); plot(t, qdd(:,3));                           // ACCEL J3";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 3 accel (rad/s^2)"");";..
" ";..
"-->a5 = cfh.children(1); a5.data_bounds = [0 -4; t($) 4];";..
" ";..
"-->a5.tight_limits = ""on""; a5.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a5.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a5.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-4 -2 0 2 4], [""-4"" ""-2"" ""0"" ""2"" ""4""]);";..
" ";..
"-->drawnow();";..                      // parag5
"";..
""..
];

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n", text(1:6)');
t = [0:0.056:2];
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n", text(7:9)');
q = rt_jtraj(qz, qready, t);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n", text(10:14)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(15:41)');
drawlater();
subplot(2,1,1); plot(t, q(:,2));                             // JOINT 2
xgrid(); xtitle("Theta", "Time (s)", "Joint 2 (rad)");
a0 = cfh.children(1); a0.data_bounds = [0 0; t($) 2];
a0.tight_limits = "on"; a0.auto_ticks = ["off" "off" "off"];
a0.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a0.y_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.5 1 1.5 2], ["0" "0.5" "1" "1.5" "2"]);

subplot(2,1,2); plot(t, q(:,3));                             // JOINT 3
xgrid(); xtitle("", "Time (s)", "Joint 3 (rad)");
a1 = cfh.children(1); a1.data_bounds = [0 -2; t($) 0];
a1.tight_limits = "on"; a1.auto_ticks = ["off" "off" "off"];
a1.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a1.y_ticks = tlist(["ticks", "locations", "labels"],..
    [0 -0.5 -1 -1.5 -2], ["0" "-0.5" "-1" "-1.5" "-2"]);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(42:48)');
[q, qd, qdd] = rt_jtraj(qz, qready, t);
mprintf("%s\n%s\n%s\n", text(49:51)');
xdel(cfh.figure_id);
mprintf("%s\n%s\n", text(52:53)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(54:80)');
drawlater();
subplot(2,1,1); plot(t, qd(:,2));                           // VEL J2
xgrid(); xtitle("Velocity", "Time (s)", "Joint 2 vel (rad/s)");
a2 = cfh.children(1); a2.data_bounds = [0 0; t($) 2];
a2.tight_limits = "on"; a2.auto_ticks = ["off" "off" "off"];
a2.x_ticks = tlist(["ticks", "locations", "labels"], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a2.y_ticks = tlist(["ticks", "locations", "labels"], [0 0.5 1 1.5 2], ["0" "0.5" "1" "1.5" "2"]);
subplot(2,1,2); plot(t, qd(:,3));                           // VEL J3
xgrid(); xtitle("", "Time (s)", "Joint 3 vel (rad/s)");
a3 = cfh.children(1); a3.data_bounds = [0 -2; t($) 0];
a3.tight_limits = "on"; a3.auto_ticks = ["off" "off" "off"];
a3.x_ticks = tlist(["ticks", "locations", "labels"], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a3.y_ticks = tlist(["ticks", "locations", "labels"], [-2 -1.5 -1 -0.5 0], ["-2" "-1.5" "-1" "-0.5" "0"]);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n", text(81:84)');
xdel(cfh.figure_id);
mprintf("%s\n%s\n", text(85:86)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(87:113)');
drawlater();
subplot(2,1,1); plot(t, qdd(:,2));                           // ACCEL J2
xgrid(); xtitle("Acceleration", "Time (s)", "Joint 2 accel (rad/s^2)");
a4 = cfh.children(1); a4.data_bounds = [0 -4; t($) 4];
a4.tight_limits = "on"; a4.auto_ticks = ["off" "off" "off"];
a4.x_ticks = tlist(["ticks", "locations", "labels"], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a4.y_ticks = tlist(["ticks", "locations", "labels"], [-4 -2 0 2 4], ["-4" "-2" "0" "2" "4"]);
subplot(2,1,2); plot(t, qdd(:,3));                           // ACCEL J3
xgrid(); xtitle("", "Time (s)", "Joint 3 accel (rad/s^2)");
a5 = cfh.children(1); a5.data_bounds = [0 -4; t($) 4];
a5.tight_limits = "on"; a5.auto_ticks = ["off" "off" "off"];
a5.x_ticks = tlist(["ticks", "locations", "labels"], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a5.y_ticks = tlist(["ticks", "locations", "labels"], [-4 -2 0 2 4], ["-4" "-2" "0" "2" "4"]);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n", text(114:115)');
clear text
