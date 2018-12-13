// Copyright (C) 1999-2002, by Peter I. Corke
// Copyright (C) 2007, 2008, 2009  Interdepartmental Research Center "E. Piaggio", University of Pisa
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



function  [res] = rt_nofriction(obj, varargin)
// File name:       rt_nofriction.sci
//
// Function:        rt_nofriction
//
// Description:     remove friction from a link or robot object
//
// Annotations:     this code is a Scilab port of corresponding functions in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@link/nofriction.m
//                  Robotics Toolbox for MATLAB(R), robot7.1/@robot/nofriction.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2009-07-04 20:17:57 +0200(sab, 04 lug 2009) $

    [%nargout, %nargin] = argn(0);

    if typeof(obj) == "link" then

        res = obj;
        if ~isempty(varargin) then
            only = varargin(1);
            if convstr(part(only, [1,2,3])) == "all" then
                res.B = 0;
            end
        end
        res.Tc = [0, 0];

    elseif typeof(obj) == "robot" then

        if %nargin == 1 then
            varargin = list();
        end
        L = list();
        for i = 1:obj.n,
            L($ + 1) = rt_nofriction(obj.links(i), varargin(:));
        end
        res = rt_robot(obj, L);
        res.name = "NF/" + obj.name;

    else

        error("first argument should be a link or a robot");

    end

endfunction
