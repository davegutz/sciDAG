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



// File name:       rt_rtjademo.sce
//
// Description:     demo for Jacobians
//
// Annotations:     this code is a Scilab port of corresponding demo in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/rtjademo.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

text = [..
"// Jacobian and differential motion demonstration.";..
"//";..
"// A differential motion can be represented by a 6-element vector with elements";..
"// [dx dy dz drx dry drz]";..
"//";..
"// where the first 3 elements are a differential translation, and the last 3 ";..
"// are a differential rotation.  When dealing with infinitisimal rotations, ";..
"// the order becomes unimportant.  The differential motion could be written ";..
"// in terms of compounded transforms";..
"//";..
"// rt_transl(dx,dy,dz) * rt_rotx(drx) * rt_roty(dry) * rt_rotz(drz)";..
"//";..
"// but a more direct approach is to use the function rt_diff2tr()";..
"-->D = [0.1, 0.2, 0, -0.2, 0.1, 0.1].'';";..
" ";..
"-->rt_diff2tr(D),                    ";..
" ans  =";..                                // parag1//@17
"";..
"// More commonly it is useful to know how a differential motion in one ";..
"// coordinate frame appears in another frame.  If the second frame is ";..
"// represented by the transform";..
"-->T = rt_transl(100, 200, 300) * rt_roty(%pi/8) * rt_rotz(-%pi/4);";..
"";..
"// then the differential motion in the second frame would be given by";..
"-->DT = rt_tr2jac(T) * D;";..
" ";..
"-->DT.'',";..
" ans  =";..//@28
"";..
"// rt_tr2jac() has computed a 6x6 Jacobian matrix which transforms the differential ";..
"// changes from the first frame to the next.";..   // parag2//@31
"";..
"// The manipulator''s Jacobian matrix relates differential joint coordinate ";..
"// motion to differential Cartesian motion;";..
"//";..
"//     dX = J(q) dQ";..
"//";..
"// For an n-joint manipulator the manipulator Jacobian is a 6 x n matrix and";..
"// is used in many manipulator control schemes.  For a 6-axis manipulator like";..
"// the Puma 560 the Jacobian is square";..
"//";..
"// Two Jacobians are frequently used, which express the Cartesian velocity in";..
"// the world coordinate frame,";..
"-->q = [0.1, 0.75, -2.25, 0 .75, 0],";..
" q  =";..//@45
" ";..
"-->J = rt_jacob0(p560, q),";..
" J  =";..//@48
"";..
"// or the T6 coordinate frame";..
"-->J = rt_jacobn(p560, q),";..
" J  =";..//@52
"";..
"// Note the top right 3x3 block is all zero.  This indicates, correctly, that";..
"// motion of joints 4-6 does not cause any translational motion of the robot''s";..
"// end-effector.";..                   // parag3//@56
"";..
"// Many control schemes require the inverse of the Jacobian.  The Jacobian";..
"// in this example is not singular";..
"-->det(J),";..
" ans  =";..//@61
"";..
"// and may be inverted";..
"-->Ji = inv(J),";..
" Ji  =";..                             // parag4//@65
"";..
"// A classic control technique is Whitney''s resolved rate motion control";..
"//";..
"// dQ/dt = J(q)^-1 dX/dt";..
"//";..
"// where dX/dt is the desired Cartesian velocity, and dQ/dt is the required";..
"// joint velocity to achieve this.";..
"-->vel = [1, 0, 0, 0, 0, 0].'';     // translational motion in the X direction";..
" ";..
"-->qvel = Ji * vel;";..//@75
" ";..
"-->qvel.'',";..
" ans  =";..//@78
"";..
"// This is an alternative strategy to computing a Cartesian trajectory ";..
"// and solving the inverse kinematics.  However like that other scheme, this";..
"// strategy also runs into difficulty at a manipulator singularity where";..
"// the Jacobian is singular.";..       // parag5//@83
"";..
"// As already stated this Jacobian relates joint velocity to end-effector ";..
"// velocity expressed in the end-effector reference frame.  We may wish ";..
"// instead to specify the velocity in base or world coordinates.";..
"//";..
"// We have already seen how differential motions in one frame can be translated ";..
"// to another.  Consider the velocity as a differential in the world frame, that";..
"// is, d0X.  We can write";..
"//     d6X = Jac(T6) d0X";..
"-->T6 = rt_fkine(p560, q);     // compute the end-effector transform";..//@93
" ";..
"-->d6X = rt_tr2jac(T6) * vel;  // translate world frame velocity to T6 frame";..//@95
" ";..
"-->qvel = Ji * d6X;            // compute required joint velocity as before";..
" ";..
"-->qvel.'',";..
" ans  =";..//@100
"";..
"// Note that this value of joint velocity is quite different to that calculated";..
"// above, which was for motion in the T6 X-axis direction.";..     // parag6//@103
"";..
"// At a manipulator singularity or degeneracy the Jacobian becomes singular.";..
"// At the Puma''s ''ready'' position for instance, two of the wrist joints are";..
"// aligned resulting in the loss of one degree of freedom.  This is revealed by";..
"// the rank of the Jacobian";..
"-->rank( rt_jacobn(p560, qready) ),";..//@109
" ans  =";..//@110
"";..
"// and the singular values are";..
"-->svd( rt_jacobn(p560, qready) ),";..//@113
" ans  =";..                            // parag7//@114
"";
"// When not actually at a singularity the Jacobian can provide information ";..
"// about how ''well-conditioned'' the manipulator is for making certain motions,";..
"// and is referred to as ''manipulability''.";..
"//";..
"// A number of scalar manipulability measures have been proposed.  One by";..
"// Yoshikawa";..
"-->rt_maniplty(p560, q, ""yoshikawa""),";..
" ans  =";..//@123
"";..
"// is based purely on kinematic parameters of the manipulator.";..
"//";..
"// Another by Asada takes into account the inertia of the manipulator which ";..
"// affects the acceleration achievable in different directions.  This measure ";..
"// varies from 0 to 1, where 1 indicates uniformity of acceleration in all ";..
"// directions";..
"-->rt_maniplty(p560, q, ""asada""),";..
" ans  =";..//@132
"";..
"// Both of these measures would indicate that this particular pose is not well";..
"// conditioned.";..                    // parag8//@135
"";..
"// An interesting class of manipulators are those that are redundant, that is,";..
"// they have more than 6 degrees of freedom.  Computing the joint motion for";..
"// such a manipulator is not straightforward.  Approaches have been suggested";..
"// based on the pseudo-inverse of the Jacobian (which will not be square) or";..
"// singular value decomposition of the Jacobian.";..
"";..
""..//@143
];

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(1:17)');
D = [0.1, 0.2, 0, -0.2, 0.1, 0.1].';
disp(rt_diff2tr(D));
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(18:28)');
T = rt_transl(100, 200, 300) * rt_roty(%pi/8) * rt_rotz(-%pi/4);
DT = rt_tr2jac(T) * D;
disp(DT.');
mprintf("%s\n%s\n%s\n", text(29:31)');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(32:45)');
q = [0.1, 0.75, -2.25, 0 .75, 0];
disp(q);
mprintf("%s\n%s\n%s\n", text(46:48)');
J = rt_jacob0(p560, q);
disp(J);
mprintf("%s\n%s\n%s\n%s\n", text(49:52)');
J = rt_jacobn(p560, q);
disp(J);
mprintf("%s\n%s\n%s\n%s\n", text(53:56)');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n", text(57:61)');
disp(det(J));
mprintf("%s\n%s\n%s\n%s\n", text(62:65)');
Ji = inv(J);
disp(Ji);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(66:75)');
vel = [1, 0, 0, 0, 0, 0].';     // translational motion in the X direction
qvel = Ji * vel;
mprintf("%s\n%s\n%s\n", text(76:78)');
disp(qvel.');
mprintf("%s\n%s\n%s\n%s\n%s\n", text(79:83)');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(84:93)');
T6 = rt_fkine(p560, q);     // compute the end-effector transform
mprintf("%s\n%s\n", text(94:95)');
d6X = rt_tr2jac(T6) * vel;  // translate world frame velocity to T6 frame
mprintf("%s\n%s\n%s\n%s\n%s\n", text(96:100)');
qvel = Ji * d6X;            // compute required joint velocity as before
disp(qvel.');
mprintf("%s\n%s\n%s\n", text(101:103)');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n", text(104:109)');
rJn = rank( rt_jacobn(p560, qready) );
mprintf("%s\n", text(110:110)');
disp(rJn);
mprintf("%s\n%s\n%s\n", text(111:113)');
svdJn = svd( rt_jacobn(p560, qready) );
mprintf("%s\n", text(114:114)');
disp(svdJn);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(115:123)');
myoshi = rt_maniplty(p560, q, "yoshikawa");
mprintf("%s\n", text(124:124)');
disp(myoshi);
mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(124:131)');
masa = rt_maniplty(p560, q, "asada");
mprintf("%s\n", text(132:132)');
disp(masa);
mprintf("%s\n%s\n%s\n", text(133:135)');
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(136:143)');
clear text
