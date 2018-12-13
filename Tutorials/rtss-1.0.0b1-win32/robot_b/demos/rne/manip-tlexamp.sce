mode(-1);
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



// File name:       manip-tlexamp.sce
//
// Description:     Dynamic model of a two-link planar arm.
//
// Annotations:     Chapter 4, Example 4.2.
//
// References:      L. Sciavicco, B. Siciliano, "Modelling and Control of Robot Manipulators",
//                  2nd Edition, Springer-Verlag Advanced Textbooks in Control and Signal
//                  Processing Series, London, UK, 2000.
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

// structural parameters
a1 = 1; a2 = 1;
l1 = 0.5; l2 = 0.5;
ml1 = 50; ml2 = 50;
Il1 = 10; Il2 = 10;
kr1 = 100; kr2 = 100;
mm1 = 5; mm2 = 5;
Im1 = 0.01; Im2 = 0.01;

// link 1/motor 2 system
m1 = ml1 + mm2;
lc1 = ml1*(l1-a1)/m1;
I1zz = Il1 + ml1*(l1-a1)^2 + Im2 - m1*lc1^2;

// link 2 system
m2 = ml2;
lc2 = ml2*(l2-a2)/m2;
I2zz = Il2 + ml2*(l2-a2)^2 - m2*lc2^2;

manip_tlexamp_dh = [..

// alpha    A  theta    D   sigma   m   rx  ry  rz  Ixx Iyy Izz     Ixy Iyz Ixz Jm  G
0           1   0       0   0       m1  lc1 0   0   0   0   I1zz    0   0   0   Im1 kr1;..
0           1   0       0   0       m2  lc2 0   0   0   0   I2zz    0   0   0   Im2 kr2..

];

manip_tlexamp = rt_robot(manip_tlexamp_dh);
manip_tlexamp.gravity = [0;9.81;0];
manip_tlexamp.name = "Modified two link";

clear manip_tlexamp_dh a1 a2 l1 l2 ml1 ml2 Il1 Il2 kr1 kr2 mm1 mm2 Im1 Im2 m1 lc1 I1zz m2 lc2 I2zz
