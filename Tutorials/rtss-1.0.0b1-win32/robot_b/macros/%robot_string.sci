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



function [res] = %robot_string(r)
// File name:       %robot_string.sci
//
// Functions:       string(r)
//
// Description:     converts a robot to string.
//
// Annotations:     Required by CodeGeneration_
//
// References:      none
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            May 2008
//
// $LastChangedDate: 2008-05-16 21:49:34 +0200(ven, 16 mag 2008) $

    res = sci2exp(r);

endfunction
