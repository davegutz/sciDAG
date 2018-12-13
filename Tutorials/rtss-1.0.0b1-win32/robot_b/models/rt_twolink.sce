mode(-1);
// Copyright (C) 2000-2002, by Peter I. Corke
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



// File name:       rt_twolink.sce
//
// Description:     load kinematic and dynamic data for a simple 2-link RR planar
//
// Annotations:     this code is a Scilab port of corresponding script in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/twolink.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

twolink_dh = [..

// alpha    A  theta    D   sigma   m   rx  ry  rz  Ixx Iyy Izz Ixy Iyz Ixz Jm  G
0           1   0       0   0       1   1   0   0   0   0   0   0   0   0   0   1;..
0           1   0       0   0       1   1   0   0   0   0   0   0   0   0   0   1..

];

tl = rt_robot(twolink_dh);
tl.name = "Simple two link";
qz = [0 0];

clear twolink_dh
