mode(-1);
// Copyright (C) 2008  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            February 2008
//
// $LastChangedDate: 2008-03-29 12:29:17 +0100(sab, 29 mar 2008) $
//
// DO NOT MODIFY BELOW
pathL = get_absolute_file_path("loadmacros.sce");
disp("Loading macros  in " + pathL);
rtsslib = lib(pathL);
clear pathL
