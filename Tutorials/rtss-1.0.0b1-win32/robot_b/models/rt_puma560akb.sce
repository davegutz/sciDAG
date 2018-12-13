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



// File name:       rt_puma560akb.sce
//
// Description:     create a Puma 560 robot object using the Armstrong, Khatib and Burdick
//                  kinematic notation
//
// Annotations:     this code is a Scilab port of corresponding script in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/puma560akb.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

clear L;
L = list();
L(1) = rt_link([0, 0, 0, 0, 0], "mod");
L(2) = rt_link([-%pi/2, 0, 0, 0.2435, 0], "mod");
L(3) = rt_link([0, 0.4318, 0, -0.0934, 0], "mod");
L(4) = rt_link([%pi/2, -0.0203, 0, 0.4331, 0], "mod");
L(5) = rt_link([-%pi/2, 0, 0, 0, 0], "mod");
L(6) = rt_link([%pi/2, 0, 0, 0, 0], "mod");

L(1).m = 0;
L(2).m = 17.4;
L(3).m = 4.8;
L(4).m = 0.82;
L(5).m = 0.34;
L(6).m = 0.09;

L(1).r = [0, 0, 0];
L(2).r = [0.068, 0.006, -0.016];
L(3).r = [0, -0.070, 0.014];
L(4).r = [0, 0, -0.019];
L(5).r = [0, 0, 0];
L(6).r = [0, 0, 0.032];

L(1).I = [0, 0, 0.35, 0, 0, 0];
L(2).I = [0.13, 0.524, 0.539, 0, 0, 0];
L(3).I = [0.066, 0.0125, 0.066, 0, 0, 0];
L(4).I = [1.8e-3, 1.8e-3, 1.3e-3, 0, 0, 0];
L(5).I = [0.3e-3, 0.3e-3, 0.4e-3, 0, 0, 0];
L(6).I = [0.15e-3, 0.15e-3, 0.04e-3, 0, 0, 0];

L(1).Jm = 291e-6;
L(2).Jm = 409e-6;
L(3).Jm = 299e-6;
L(4).Jm = 35e-6;
L(5).Jm = 35e-6;
L(6).Jm = 35e-6;

L(1).G = -62.6111;
L(2).G = 107.815;
L(3).G = -53.7063;
L(4).G = 76.0364;
L(5).G = 71.923;
L(6).G = 76.686;

// viscous friction (motor referenced)
// unknown

// Coulomb friction (motor referenced)
// unknown

// some useful poses
qz = [0, 0, 0, 0, 0, 0];                // zero angles, L shaped pose
qready = [0, -%pi/2, %pi/2, 0, 0, 0];   // ready pose, arm up
qstretch = [0, 0, %pi/2, 0, 0, 0];      // horizontal along x-axis

p560m = rt_robot(L, "Puma560-AKB", "Unimation", "AK&B");
clear L
