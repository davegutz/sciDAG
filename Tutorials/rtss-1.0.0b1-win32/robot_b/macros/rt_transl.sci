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



function [r] = rt_transl(x,y,z)
// File name:       rt_transl.sci
//
// Function:        rt_transl
//
// Description:     set or extract the translational component of a homogeneous transform
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/transl.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout,%nargin] = argn(0);

    if %nargin == 1 then
    
        if rt_ishomog(x) then
            r = x(1:3,4);
        elseif ndims(x) == 3 then   // if x is a trajectory (i.e. 4-by-4-by-m multidimensional array) 
            P = x(1:3,4,:);         // position vectors of all trajectories
            m = size(P,3);          // number of trajectories 
            r = matrix(P,3,m).';    // reshape of P as m-by-3 matrix
        else
            t = x(:);
            r = [eye(3,3) t;0 0 0 1];
        end
        
    elseif %nargin == 3 then
    
        t = [x; y; z];
        r = [eye(3,3) t;0 0 0 1];
    
    end

endfunction
