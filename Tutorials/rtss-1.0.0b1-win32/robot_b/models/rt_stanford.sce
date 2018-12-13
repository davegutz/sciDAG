mode(-1);
// Copyright (C) 1990-2002, by Peter I. Corke
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
// Description:     create a Stanford manipulator robot object
//
// Annotations:     this code is a Scilab port of corresponding script in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/stanford.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

// alpha    A    theta  D    sigma  m      rx     ry        rz       Ixx     Iyy    Izz    Ixy Iyz Ixz   Jm     G
stanford_dyn = [..
-%pi/2      0      0   0.412   0   9.29    0    0.0175  -0.1105     0.276   0.255   0.071   0   0   0   0.953   1;..
%pi/2       0      0   0.154   0   5.01    0    -1.054      0       0.108   0.018   0.100   0   0   0   2.193   1;..
0           0   -%pi/2  0      1   4.25    0      0     -6.447      2.51    2.51    0.006   0   0   0   0.782   1;..
-%pi/2      0      0    0      0   1.08    0    0.092   -0.054      0.002   0.001   0.001   0   0   0   0.106   1;..
%pi/2       0      0    0      0   0.63    0      0      0.566      0.003   0.003   0.0004  0   0   0   0.097   1;..
0           0      0   0.263   0   0.51    0      0      1.554      0.013   0.013   0.0003  0   0   0   0.020   1];

qz = [0 0 0 0 0 0];

stanf = rt_robot(stanford_dyn);
stanf.plotopt = list("workspace",[-2 2 -2 2 -2 2]);
stanf.name = "Stanford arm";
