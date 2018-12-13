mode(-1);
// Copyright (C) 2002  Peter I. Corke
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



// File name:       rt_stanford.sce
//
// Description:     create a Stanford manipulator robot object.
//                  Only rt_stanfcheck.tst should use this script.
//
// Annotations:     this code is a Scilab port of corresponding script in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/mex/stanford.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

L = list();

L(1) = rt_link([-%pi/2, 0, 0, 0, 0, 1, 0,  1 , 0, 1,   1,  1, 0,  0,  0, 291e-6, -62.6111]);
L(2) = rt_link([ %pi/2, 0, 0, 1, 0, 1, 0, -1,  0, 1,   1,  1, 0,  0,  0, 409e-6,  107.815]);
L(3) = rt_link([     0, 0, 0, 0, 1, 1, 0,  0, -1, 1,   1,  1, 0,  0,  0, 299e-6, -53.7063]);
L(4) = rt_link([-%pi/2, 0, 0, 0, 0, 1, 0,  1,  0, 7, 0.5, 11, 9,  3,  2, 291e-6, -62.6111]);
L(5) = rt_link([ %pi/2, 0, 0, 0, 0, 1, 0,  1,  0, 3,   2,  4, 5, -3, -6, 409e-6,  107.815]);
L(6) = rt_link([     0, 0, 0, 1, 0, 1, 0,  0, -1, 1,   1,  1, 0,  0,  0, 299e-6, -53.7063]);

stan = rt_robot(L, "Stanford (T)", "", "simple test model");

clear L
