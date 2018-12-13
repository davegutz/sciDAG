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



function [qt] = rt_ikine(robot, tr, q, m)
// File name:       rt_ikine.sci
//
// Functions:       rt_ikine
//
// Description:     compute the inverse kinematics for a generic serial n-link manipulator
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/ikine.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout, %nargin] = argn(0);

    //  solution control parameters
    ilimit = 1000;
    stol = 1e-11;

    n = robot.n;

    if %nargin == 2 then
        q = zeros(n, 1);
    else
        q = q(:);
    end

    if %nargin == 4 then
        m = m(:);
        if length(m) ~= 6 then
            error("mask matrix should have 6 elements");
        end
        if length(find(m)) ~= n then
            error("mask matrix must have same number of 1s as robot DOF");
        end
    else
        if n < 6 then
            disp("for a manipulator with fewer than 6DOF a mask matrix argument should be specified");
        end
        m = ones(6, 1);
    end

    tcount = 0;

    // single xform case
    if rt_ishomog(tr) then
        nm = 1;
        count = 0;
        while nm > stol,
            e = rt_tr2diff(rt_fkine(robot, q'), tr) .* m;
            dq = pinv( rt_jacob0(robot, q) ) * e;
            q = q + dq;
            nm = norm(dq);
            count = count+1;
            if count > ilimit then
                error("solution wouldn''t converge");
            end
        end
        qt = q';

    // trajectory case
    else
        np = size(tr, 3);
        qt = [];
        for i=1:np,
            nm = 1;
            T = tr(:,:,i);
            count = 0;
            while nm > stol,
                e = rt_tr2diff(rt_fkine(robot, q'), T) .* m;
                dq = pinv( rt_jacob0(robot, q) ) * e;
                q = q + dq;
                nm = norm(dq);
                count = count+1;
                if count > ilimit then
                    printf("i=%d, nm=%f\n", i, nm);
                    error("solution wouldn''t converge")
                end
            end
            qt = [qt; q'];
            tcount = tcount + count;
        end
    end

endfunction
