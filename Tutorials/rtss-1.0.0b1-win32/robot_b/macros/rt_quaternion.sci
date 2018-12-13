// Copyright (C) 1999-2002, by Peter I. Corke
// Copyright (C) 2007, 2008  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function [q] = rt_quaternion(a1, a2)
// File name:       rt_quaternion.sci
//
// Function:        rt_quaternion
//
// Description:     construct/clone a quaternion object
//
// Annotations:     the quaternion data structure is inspired by the one implemented in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
//                  A description of the quaternion data structure (DS) follows.
//
//                  A quaternion is a Scilab mlist with 3 fields. The first field is the string
//                  vector ["quat"] (the type of DS).
//                  The other fields of the link DS are due to
//
//                      scalar component (field 2)
//                      ==========================
//                          s   (2)
//
//                      vector part (field 3)
//                      =====================
//                          v   (3)
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@quaternion/quaternion.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2008-03-26 19:09:34 +0100(mer, 26 mar 2008) $

    [%nargout, %nargin] = argn(0);

    if %nargin > 2 then
        error(77);  // wrong number of rhs arguments
    end

    if %nargin == 0 then

        // create a default quaternion
        s = [];
        v = [];
        q = mlist(["quat"], s, v);

    elseif typeof(a1) == "quat" then

        // clone passed quaternion
        q = a1;

    elseif %nargin == 1 then

        // create quaternion from a 3x3 or 4x4 matrix or from 4-elements row vector
        if and(size(a1) == [3 3]) then
            q = rt_quaternion(rt_tr2q(a1));
        elseif and(size(a1) == [4 4]) then
            q = rt_quaternion(rt_tr2q(a1(1:3,1:3)));
        elseif and(size(a1) == [1 4]) then
            s = a1(1);
            v = a1(2:4);
            q = mlist(["quat"], s, v);
        else
            error("unknown dimension of input");
        end

    elseif %nargin == 2 then

        // create a quaternion from vector plus angle
        q = rt_unit(rt_quaternion([cos(a2/2) sin(a2/2)*rt_unit(a1(:).')]));

    end

endfunction
