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



// File name:       rt_rttrdemo.sce
//
// Description:     demo for Transformations
//
// Annotations:     this code is a Scilab port of corresponding demo in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/rttrdemo.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

text = [..
"// In the field of robotics there are many possible ways of representing ";..
"// positions and orientations, but the homogeneous transformation is well ";..
"// matched to Scilab''s powerful tools for matrix manipulation.";..
"//";..
"// Homogeneous transformations describe the relationships between Cartesian ";..
"// coordinate frames in terms of translation and orientation.  ";..
"";..
"// A pure translation of 0.5m in the X direction is represented by";..
"-->rt_transl(0.5, 0.0, 0.0),";..
" ans  =";..
"";..
"// a rotation of 90degrees about the Y axis by";..
"-->rt_roty(%pi/2),";..
" ans  =";..
"";..
"// and a rotation of -90degrees about the Z axis by";..
"-->rt_rotz(-%pi/2),";..
" ans  =";..
"";..
"//  These may be concatenated by multiplication";..
"-->t = rt_transl(0.5, 0.0, 0.0) * rt_roty(%pi/2) * rt_rotz(-%pi/2),";..
" t  =";..                          // parag1
"";..
"// If this transformation represented the origin of a new coordinate frame with respect";..
"// to the world frame origin (0, 0, 0), that new origin would be given by";..
"-->t * [0, 0, 0, 1].'',";..
" ans  =";..
"";..
"// the orientation of the new coordinate frame may be expressed in terms of";..
"// Euler angles";..
"-->rt_tr2eul(t),";..
" ans  =";..
"";..
"// or roll/pitch/yaw angles";..
"-->rt_tr2rpy(t),";..
" ans  =";..                        // parag2
"";..
"// It is important to note that tranform multiplication is in general not ";..
"// commutative as shown by the following example";..
"-->rt_rotx(%pi/2) * rt_rotz(-%pi/8),";..
" ans  =";..
" ";..
"-->rt_rotz(-%pi/8) * rt_rotx(%pi/2),";..
" ans  =";..                        // parag3
"";..
""..
];

mprintf("%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n", text(1:10)');
disp(rt_transl(0.5, 0.0, 0.0));
mprintf("%s\n%s\n%s\n%s\n", text(11:14)');
disp(rt_roty(%pi/2));
mprintf("%s\n%s\n%s\n%s\n",text(15:18)');
disp(rt_rotz(-%pi/2));
mprintf("%s\n%s\n%s\n%s\n",text(19:22)');
t = rt_transl(0.5, 0.0, 0.0) * rt_roty(%pi/2) * rt_rotz(-%pi/2);
disp(t);
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n",text(23:27)');
disp(t * [0, 0, 0, 1].');
mprintf("%s\n%s\n%s\n%s\n%s\n",text(28:32)');
disp(rt_tr2eul(t));
mprintf("%s\n%s\n%s\n%s\n",text(33:36)');
disp(rt_tr2rpy(t));
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n%s\n%s\n%s\n",text(37:41)');
disp(rt_rotx(%pi/2) * rt_rotz(-%pi/8));
mprintf("%s\n%s\n%s\n",text(42:44)');
disp(rt_rotz(-%pi/8) * rt_rotx(%pi/2));
disp("");
mprintf("halt mode: enter empty lines to continue.");
mscanf("%c");

mprintf("%s\n%s\n",text(45:46)');
clear text
