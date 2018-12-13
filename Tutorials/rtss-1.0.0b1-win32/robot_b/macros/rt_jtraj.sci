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



function [qt, qdt, qddt] = rt_jtraj(q0, q1, tv, qd0, qd1)
// File name:       rt_jtraj.sci
//
// Function:        rt_jtraj
//
// Description:     compute a joint space trajectory between two joint coordinates poses
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/jtraj.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout, %nargin] = argn(0);

    [mtv, ntv] = size(tv);
    if mtv ~= 1 & ntv ~= 1 then
        error("third argument should be a real scalar or vector");
    end

    if mtv*ntv > 1 then
        // tv is a vector
        tscal = max(tv);
        t = tv(:)/tscal;
    else
        // tv is a scalar
        tscal = 1;
        t = [0:(tv-1)].'/(tv-1);        // normalized time from 0 -> 1
    end

    q0 = q0(:);
    q1 = q1(:);

    if %nargin == 3 then
        qd0 = zeros(size(q0,1), size(q0,2));
        qd1 = qd0;
    end

    // compute the polynomial coefficients
    A = 6*(q1 - q0) - 3*(qd1 + qd0)*tscal;
    B = -15*(q1 - q0) + (8*qd0 + 7*qd1)*tscal;
    C = 10*(q1 - q0) - (6*qd0 + 4*qd1)*tscal;
    E = qd0*tscal;                      // as the t vector has been normalized
    F = q0;

    tt = [t.^5, t.^4, t.^3, t.^2, t, ones(size(t,1),size(t,2))];
    c = [A, B, C, zeros(size(A,1),size(A,2)), E, F].';

    qt = tt*c;

    // compute optional velocity
    if %nargout >= 2 then
        c = [zeros(size(A,1),size(A,2)), 5*A, 4*B, 3*C, zeros(size(A,1),size(A,2)), E].';
        qdt = tt*c/tscal;
    end

    // compute optional acceleration
    if %nargout == 3 then
        c = [zeros(size(A,1),size(A,2)), zeros(size(A,1),size(A,2)), 20*A, 12*B, 6*C, zeros(size(A,1),size(A,2))].';
        qddt = tt*c/tscal^2;
    end

endfunction
