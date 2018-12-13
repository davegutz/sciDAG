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



// File name:       rt_rtikdemo.sce
//
// Description:     demo for Inverse kinematics
//
// Annotations:     this code is a Scilab port of corresponding demo in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/rtikdemo.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

text = [..
"// Inverse kinematics is the problem of finding the robot joint coordinates,";..
"// given a homogeneous transform representing the last link of the manipulator.";..
"// It is very useful when the path is planned in Cartesian space, for instance ";..
"// a straight line path as shown in the trajectory demonstration.";..
"//";..
"// First generate the transform corresponding to a particular joint coordinate,";..
"-->q = [0, -%pi/4, -%pi/4, 0, %pi/8, 0],";..
" q  =";..//@8
"";..
"-->T = rt_fkine(p560, q);";..
"";..
"// Now the inverse kinematic procedure for any specific robot can be derived ";..
"// symbolically and in general an efficient closed-form solution can be ";..
"// obtained.  However we are given only a generalized description of the ";..
"// manipulator in terms of kinematic parameters so an iterative solution will";.. 
"// be used. The procedure is slow, and the choice of starting value affects ";..
"// search time and the solution found, since in general a manipulator may ";..
"// have several poses which result in the same transform for the last";..
"// link. The starting point for the first point may be specified, or else it";..
"// defaults to zero (which is not a particularly good choice in this case)";..
"-->qi = rt_ikine(p560, T);";//@21
" ";..
"-->qi,";..
" qi  =";..//@24
"";..
"// Compared with the original value";..
"-->q,";..
" q  =";..//@28
"";..
"// A solution is not always possible, for instance if the specified transform ";..
"// describes a point out of reach of the manipulator.  As mentioned above ";..
"// the solutions are not necessarily unique, and there are singularities ";..
"// at which the manipulator loses degrees of freedom and joint coordinates ";..
"// become linearly dependent.";..      // parag1//@34
"";..
"// To examine the effect at a singularity lets repeat the last example but for a";..
"// different pose.  At the ''ready'' position two of the Puma''s wrist axes are ";..
"// aligned resulting in the loss of one degree of freedom.";..
"-->T = rt_fkine(p560, qready);";..
" ";..
"-->qi = rt_ikine(p560, T);";..//@41
" ";..
"-->qi,";..
" qi  =";..//@44
"";..
"// which is not the same as the original joint angle";..
"-->qready,";..
" qready  =";..                         // parag2//@48
"";..
"// However both result in the same end-effector position";..
"-->rt_fkine(p560, qi) - rt_fkine(p560, qready),";..
" ans  =";..                            // parag3//@52
"";..
"// Inverse kinematics may also be computed for a trajectory.";..
"// If we take a Cartesian straight line path";..
"-->t = [0:0.056:2];                    // create a time vector";..
" ";..
"-->T1 = rt_transl(0.6, -0.5, 0.0),     // define the start point";..
" T1  =";..//@59
" ";..
"-->T2 = rt_transl(0.4, 0.5, 0.2),      // and destination";..
" T2  =";..//@62
" ";..
"-->T = rt_ctraj(T1, T2, length(t));    // compute a Cartesian path";..//@64
"";..
"// now solve the inverse kinematics.  When solving for a trajectory, the ";..
"// starting joint coordinates for each point is taken as the result of the ";..
"// previous inverse solution.";..
"-->tic(); q = rt_ikine(p560, T); et = toc(),";..//@69
" et  =";..//@70
"";..
"// Clearly this approach is slow, and not suitable for a real robot controller ";..
"// where an inverse kinematic solution would be required in a few milliseconds.";..
"//";..
"// Let''s examine the joint space trajectory that results in straightline ";..
"// Cartesian motion";..
"-->cfh = scf();";..//@77
" ";..
"-->drawlater();";..
" ";..
"-->subplot(3,1,1); plot(t, q(:,1));                            // JOINT 1";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 1 (rad)"");";..
" ";..
"-->a0 = cfh.children(1); a0.data_bounds = [0 -1; t($) 2];";..
" ";..
"-->a0.tight_limits = ""on""; a0.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a0.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a0.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-1 0 1 2], [""-1"" ""0"" ""1"" ""2""]);";..
" ";..
"-->subplot(3,1,2); plot(t, q(:,2));                            // JOINT 2";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 2 (rad)"");";..
" ";..
"-->a1 = cfh.children(1); a1.data_bounds = [0 -0.8; t($) -0.4];";..
" ";..
"-->a1.tight_limits = ""on""; a1.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a1.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a1.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-0.8 -0.6 -0.4], [""-0.8"" ""-0.6"" ""-0.4""]);";..
" ";..
"-->subplot(3,1,3); plot(t, q(:,3));                            // JOINT 3";..
" ";..
"-->xgrid(); xtitle("""", ""Time (s)"", ""Joint 3 (rad)"");";..
" ";..
"-->a2 = cfh.children(1); a2.data_bounds = [0 -1; t($) 0.5];";..
" ";..
"-->a2.tight_limits = ""on""; a2.auto_ticks = [""off"" ""off"" ""off""];";..
" ";..
"-->a2.x_ticks = tlist([""ticks"", ""locations"", ""labels""], [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8], [""0"" ""0.2"" ""0.4"" ""0.6"" ""0.8"" ""1"" ""1.2"" ""1.4"" ""1.6"" ""1.8""]);";..
" ";..
"-->a2.y_ticks = tlist([""ticks"", ""locations"", ""labels""], [-1 -0.5 0 0.5], [""-1"" ""-0.5"" ""0"" ""0.5""]);";..
" ";..
"-->drawnow();";..                      // parag4//@117
"";..
"// This joint space trajectory can now be animated";..
"-->cfh = scf(); a3 = cfh.children; a3.tight_limits = ""on"";";..
" ";..
"-->a3.rotation_angles = [74, -30];";..
" ";..
"-->rt_plot(p560, q);";..               // parag5//@124
"";..
""..
];

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(1:8)');
q = [0, -%pi/4, -%pi/4, 0, %pi/8, 0];
disp(q);
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(9:21)');
T = rt_fkine(p560, q);
qi = rt_ikine(p560, T);
mprintf("%s\n%s\n%s\n", text(22:24)');
disp(qi);
mprintf("%s\n%s\n%s\n%s\n", text(25:28)');
disp(q);
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n", text(29:34)');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(35:41)');
T = rt_fkine(p560, qready);
qi = rt_ikine(p560, T);
mprintf("%s\n%s\n%s\n", text(42:44)');
disp(qi);
mprintf("%s\n%s\n%s\n%s\n", text(45:48)');
disp(qready);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n", text(49:52)');
disp(rt_fkine(p560, qi) - rt_fkine(p560, qready));
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(53:59)');
t = [0:0.056:2];                    // create a time vector
T1 = rt_transl(0.6, -0.5, 0.0);     // define the start point
disp(T1);
mprintf("%s\n%s\n%s\n", text(60:62)');
T2 = rt_transl(0.4, 0.5, 0.2);
disp(T2);
mprintf("%s\n%s\n", text(63:64)');
T = rt_ctraj(T1, T2, length(t));
mprintf("%s\n%s\n%s\n%s\n%s\n", text(65:69)');
tic(); q = rt_ikine(p560, T); et = toc();
mprintf("%s\n", text(70:70)');
disp(et);
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(71:77)');
cfh = scf();
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(78:117)');
drawlater();
subplot(3,1,1); plot(t, q(:,1));                            // JOINT 1
xgrid(); xtitle("", "Time (s)", "Joint 1 (rad)");
a0 = cfh.children(1); a0.data_bounds = [0 -1; t($) 2];
a0.tight_limits = "on"; a0.auto_ticks = ["off" "off" "off"];
a0.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a0.y_ticks = tlist(["ticks", "locations", "labels"],..
    [-1 0 1 2], ["-1" "0" "1" "2"]);

subplot(3,1,2); plot(t, q(:,2));                            // JOINT 2
xgrid(); xtitle("", "Time (s)", "Joint 2 (rad)");
a1 = cfh.children(1); a1.data_bounds = [0 -0.8; t($) -0.4];
a1.tight_limits = "on"; a1.auto_ticks = ["off" "off" "off"];
a1.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a1.y_ticks = tlist(["ticks", "locations", "labels"],..
    [-0.8 -0.6 -0.4], ["-0.8" "-0.6" "-0.4"]);

subplot(3,1,3); plot(t, q(:,3));                            // JOINT 3
xgrid(); xtitle("", "Time (s)", "Joint 3 (rad)");
a2 = cfh.children(1); a2.data_bounds = [0 -1; t($) 0.5];
a2.tight_limits = "on"; a2.auto_ticks = ["off" "off" "off"];
a2.x_ticks = tlist(["ticks", "locations", "labels"],..
    [0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],..
    ["0" "0.2" "0.4" "0.6" "0.8" "1" "1.2" "1.4" "1.6" "1.8"]);
a2.y_ticks = tlist(["ticks", "locations", "labels"],..
    [-1 -0.5 0 0.5], ["-1" "-0.5" "0" "0.5"]);
drawnow();
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(118:124)');
cfh = scf(); a3 = cfh.children; a3.tight_limits = "on";
a3.rotation_angles = [74, -30];
rt_plot(p560, q);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n", text(125:126)');
clear text
