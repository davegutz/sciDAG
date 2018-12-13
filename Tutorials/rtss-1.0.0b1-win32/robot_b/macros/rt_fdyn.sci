// Copyright (C) 1993, 1999  Peter Corke
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



function [q, qd] = rt_fdyn(robot, t0, t1, torqfun, q0, qd0, varargin)
// File name:       rt_fdyn.sci
//
// Functions:       rt_fdyn
//
// Description:     integrate the forward dynamics
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/fdyn.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout, %nargin] = argn(0);

    n = robot.n;
    if %nargin == 3 then

        torqfun = "";
        varargin = list();
        y0 = zeros(2*n,1);

    elseif %nargin == 4 then

        if typeof(torqfun) ~= "string" then
            error("torqfun should be a function name");
        end
        varargin = list();
        y0 = zeros(2*n,1);

    elseif %nargin >= 6 then

        y0 = [q0(:); qd0(:)];

    else

        error("wrong number of input arguments");

    end

    y = ode(y0, t0, t1, list(rt_fdyn2, robot, torqfun, varargin(:)));

    q = y(1:n,:);
    qd = y(n+1:2*n,:);

endfunction
