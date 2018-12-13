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



function [Q] = rt_ikinestanfpaul(robot, TW6)
// File name:       rt_ikine560paul.sci
//
// Function:        rt_ikine560paul
//
// Description:     evaluate ikine for stanford robot arm using Paul's algebraic method
//
// Annotations:     based on the standard Denavit and Hartenberg notation.
//
// References:      see below
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    // tolerance
    tol = 1e-8;

    // retrieve robot parameters
    L = robot.links;
    a1 = L(1).A; a2 = L(2).A; a3 = L(3).A; a4 = L(4).A; a5 = L(5).A; a6 = L(6).A;
    d1 = L(1).D; d2 = L(2).D; d3 = L(3).D; d4 = L(4).D; d5 = L(5).D; d6 = L(6).D;
    theta3 = L(3).theta;
    alpha1 = L(1).alpha; alpha2 = L(2).alpha; alpha3 = L(3).alpha; alpha4 = L(4).alpha; alpha5 = L(5).alpha; alpha6 = L(6).alpha;

    // check DH parameters
    if robot.mdh then
        error("this function does not work for robot objects that use the modified Denavit-Hartenberg convention");
    end
    if L(1).RP ~= 'R' | L(2).RP ~= 'R' | L(3).RP ~= 'P' | L(4).RP ~= 'R' | L(5).RP ~= 'R' | L(6).RP ~= 'R' then
        error("robot must be a stanford robot arm");
    end
    if a1 ~= 0 | a2 ~= 0 | a3 ~= 0 | a4 ~= 0 | a5 ~= 0 | a6 ~= 0 then
        error("robot must be a stanford robot arm");
    end
    if ~(theta3 == 0 | theta3 == -%pi/2) then
        error("robot must be a stanford robot arm");
    end
    if alpha1 ~= -%pi/2 | alpha2 ~= %pi/2 | alpha3 ~= 0 | alpha4 ~= -%pi/2 | alpha5 ~= %pi/2 | alpha6 ~= 0 then
        error("robot must be a stanford robot arm");
    end
    if d2 == 0 | d4 ~= 0 | d5 ~= 0 | d6 == 0 then
        error("robot must be a stanford robot arm");
    end

    // if robot is a stanford robot arm
    // references:  R.P.Paul. Robot manipulator: mathematics, programming and control.
    //              MIT Press, Cambridge, MA, 1981
    // preparing output
    Q = zeros(2,6);

    // T06 = T0W * TW6, with T0W = inv(TW0)
    if d1 ~= 0 then
        // TW0 = robot.base * rt_transl(0, 0, d1)
        T06 = inv(robot.base * rt_transl(0, 0, d1)) * TW6;
    else
        // TW0 = robot.base
        T06 = inv(robot.base) * TW6;
    end

    // extraction of useful quantities
    R06 = rt_tr2rot(T06);
    p06 = rt_transl(T06);
    a06 = R06(:,3);
    p0w = p06 - d6*a06;
    pwx = p0w(1); pwy = p0w(2); pwz = p0w(3);

    // evaluate t1
    r = (pwx^2 + pwy^2)^(1/2);
    // d2 ~= 0 implies pwx^2 + pwy^2 ~= 0
    Q(1,1) = atan(pwy, pwx) - atan(d2, (r^2-d2^2)^(1/2)); // Scilab's atan(x,y) is atan2(x,y)
    Q(2,1) = atan(pwy, pwx) - atan(d2, -(r^2-d2^2)^(1/2));

    // evaluate t2
    for i=1:2,
        c1 = cos(Q(i,1));
        s1 = sin(Q(i,1));
        // d3 is always assumed greater than 0
        Q(i,2) = atan(pwx*c1+pwy*s1, pwz);
    end

    // evaluate d3
    for i=1:2,
        c1 = cos(Q(i,1));
        s1 = sin(Q(i,1));
        c2 = cos(Q(i,2));
        s2 = sin(Q(i,2));
        Q(i,3) = s2*(c1*pwx+s1*pwy) + c2*pwz;
    end

    // evaluate t4, t5 e t6
    // references:  L. Sciavicco, B. Siciliano, "Modelling and Control of Robot Manipulators",
    //              2nd Edition, Springer-Verlag Advanced Textbooks in Control and Signal
    //              Processing Series, London, UK, 2000
    for i=1:2,
        T01 = L(1)(Q(i,1));
        T12 = L(2)(Q(i,2));
        T23 = L(3)(Q(i,3));
        T03 = T01*T12*T23;
        T36 = inv(T03)*T06;
        euler = rt_tr2eul(T36);
        Q(i,4) = euler(1);
        Q(i,5) = euler(2);
        Q(i,6) = euler(3);
        if Q(i,5) < tol | %pi - Q(i,5) < tol then
            printf("WARNING:wrist singularity in solution %d, infinitely many solutions for theta4 and theta6\n",i);
        end
    end

endfunction
