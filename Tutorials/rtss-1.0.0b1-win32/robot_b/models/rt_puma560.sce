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



// File name:       rt_puma560.sce
//
// Description:     create a Puma 560 robot object
//
// Annotations:     this code is a Scilab port of corresponding script in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/puma560.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

clear L;
L = list();
L(1) = rt_link([%pi/2 0 0 0 0], "standard");
L(2) = rt_link([0 0.4318 0 0 0], "standard");
L(3) = rt_link([-%pi/2 0.0203 0 0.15005 0], "standard");
L(4) = rt_link([%pi/2 0 0 0.4318 0], "standard");
L(5) = rt_link([-%pi/2 0 0 0 0], "standard");
L(6) = rt_link([0 0 0 0 0], "standard");

L(1).m = 0;
L(2).m = 17.4;
L(3).m = 4.8;
L(4).m = 0.82;
L(5).m = 0.34;
L(6).m = 0.09;

L(1).r = [0 0 0];
L(2).r = [-0.3638 0.006 0.2275];
L(3).r = [-0.0203 -0.0141 0.070];
L(4).r = [0 0.019 0];
L(5).r = [0 0 0];
L(6).r = [0 0 0.032];

L(1).I = [0 0.35 0 0 0 0];
L(2).I = [0.13 0.524 0.539 0 0 0];
L(3).I = [0.066 0.086 0.0125 0 0 0];
L(4).I = [1.8e-3 1.3e-3 1.8e-3 0 0 0];
L(5).I = [0.3e-3 0.4e-3 0.3e-3 0 0 0];
L(6).I = [0.15e-3 0.15e-3 0.04e-3 0 0 0];

L(1).Jm = 200e-6;
L(2).Jm = 200e-6;
L(3).Jm = 200e-6;
L(4).Jm = 33e-6;
L(5).Jm = 33e-6;
L(6).Jm = 33e-6;

L(1).G = -62.6111;
L(2).G = 107.815;
L(3).G = -53.7063;
L(4).G = 76.0364;
L(5).G = 71.923;
L(6).G = 76.686;

// viscous friction (motor referenced)
L(1).B = 1.48e-3;
L(2).B = 0.817e-3;
L(3).B = 1.38e-3;
L(4).B = 71.2e-6;
L(5).B = 82.6e-6;
L(6).B = 36.7e-6;

// Coulomb friction (motor referenced)
L(1).Tc = [0.395 -0.435];
L(2).Tc = [0.126 -0.071];
L(3).Tc = [0.132 -0.105];
L(4).Tc = [11.2e-3 -16.9e-3];
L(5).Tc = [9.26e-3 -14.5e-3];
L(6).Tc = [3.96e-3 -10.5e-3];


// some useful poses
qz = [0 0 0 0 0 0];                 // zero angles, L shaped pose
qready = [0 %pi/2 -%pi/2 0 0 0];    // ready pose, arm up
qstretch = [0 0 -%pi/2 0 0 0];

p560 = rt_robot(L, "Puma 560", "Unimation", "params of 8/95");
clear L
