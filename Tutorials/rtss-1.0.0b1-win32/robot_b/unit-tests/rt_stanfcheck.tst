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



// File name:       rt_stanfcheck.tst
//
// Description:     check script to compare Sci-file and C-file versions of RNE
//                  on a Stanford robot arm
//
// Annotations:     this code is a Scilab port of corresponding script in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/mex/check.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

pathSC = get_absolute_file_path("rt_stanfcheck.tst");

mprintf("***************************************************************\n");
mprintf("********************** Stanford arm ***************************\n");
mprintf("***************************************************************\n");

exec(pathSC + "rt_stanford.sce");   // test model
exec(pathSC + "rt_stanfordm.sce");  // test model

rdh = stan;
rmdh = stanm;

exec(pathSC + "rt_check1.sce");

clear rdh rmdh stan stanm
