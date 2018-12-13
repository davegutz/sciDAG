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



// File name:       rt_rtandemo.sce
//
// Description:     demo for Animations
//
// Annotations:     this code is a Scilab port of corresponding demo in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/rtandemo.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

text = [..
"// The trajectory demonstration has shown how a joint coordinate trajectory";..
"// may be generated";..
"-->t = [0:0.056:2];                // generate a time vector";..
" ";..
"-->q = rt_jtraj(qz, qready, t);    // generate joint coordinate trajectory";.. // parag1
"";
"// The overloaded function rt_plot() animates a stick figure robot moving ";..
"// along a trajectory.";..
"-->rt_plot(p560, q);";..
"";..
"// The drawn line segments do not necessarily correspond to robot links, but ";..
"// join the origins of sequential link coordinate frames.";..
"//";..
"// A small right-angle coordinate frame is drawn on the end of the robot to show";..
"// the wrist orientation.";..
"//";..
"// A shadow appears on the ground which helps to give some better idea of the";..
"// 3D object.";..                      // parag2
"";..
"// We can also place additional robots into a figure.";..
"//";..
"// Let''s make a clone of the Puma robot, but change its name and base location";..
"-->p560_2 = rt_robot(p560);                // clone the robot (see rt_robot help page)";..
" ";..
"-->p560_2.name = ""another Puma"";";..
" ";..
"-->p560_2.base = rt_transl(-0.5, 0.5, 0);";..
" ";..
"-->rt_plot(p560_2, q);";..             // parag3
"";..
"// We can also have multiple views of the same robot";..
"-->cfh = gcf(); xdel(cfh.figure_id);";..//32
" ";..
"-->cfh = scf(); a1 = cfh.children; a1.tight_limits = ""on"";";..
" ";..
"-->a1.rotation_angles = [76, 52];";..
" ";..
"-->rt_plot(p560, qz);";..
" ";..
"-->cfh = scf(); a2 = cfh.children; a2.tight_limits = ""on"";";..
" ";..
"-->a2.rotation_angles = [74, -30];";..
" ";..
"-->rt_plot(p560, qz);";..
" ";..
"-->rt_plot(p560, q);";..               // parag4
"";..
"// Sometimes it''s useful to be able to manually drive the robot around to";..
"// get an understanding of how it works.";..
"-->rt_drivebot(p560);";..
"";..
"// use the sliders to control the robot (in fact both views).  Hit the red quit";..
"// button when you are done.";..
"";..
""..
];

mprintf("%s\n%s\n%s\n%s\n%s\n", text(1:5)');
t = [0:0.056:2];
q = rt_jtraj(qz, qready, t);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n", text(6:9)');
rt_plot(p560, q);
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(10:18)');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(19:27)');
p560_2 = rt_robot(p560);                // clone the robot (see rt_robot help page)
p560_2.name = "another Puma";
p560_2.base = rt_transl(-0.5, 0.5, 0);
mprintf("%s\n%s\n", text(28:29)');
rt_plot(p560_2, q);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n", text(30:32)');
cfh = gcf(); xdel(cfh.figure_id);
mprintf("%s\n%s\n%s\n%s\n", text(33:36)');
cfh = scf(); a1 = cfh.children; a1.tight_limits = "on";
a1.rotation_angles = [76, 52];
mprintf("%s\n%s\n", text(37:38)');
rt_plot(p560, qz);
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n", text(39:44)');
cfh = scf(); a2 = cfh.children; a2.tight_limits = "on";
a2.rotation_angles = [74, -30];
rt_plot(p560, qz);
mprintf("%s\n%s\n", text(45:46)');
rt_plot(p560, q);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n", text(47:50)');
rt_drivebot(p560);
mprintf("%s\n%s\n%s\n%s\n%s\n", text(51:55)');
clear text
