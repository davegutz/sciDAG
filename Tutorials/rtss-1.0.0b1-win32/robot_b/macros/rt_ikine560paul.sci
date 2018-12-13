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



function [Q] = rt_ikine560paul(robot, T06)
// File name:       rt_ikine560paul.sci
//
// Function:        rt_ikine560paul
//
// Description:     evaluate ikine for puma 560 like robot arm using Paul's algebraic method
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
    alpha1 = L(1).alpha; alpha2 = L(2).alpha; alpha3 = L(3).alpha; alpha4 = L(4).alpha; alpha5 = L(5).alpha; alpha6 = L(6).alpha;
    signalpha4 = sign(alpha4);

    // check DH parameters
    if robot.mdh then
        error("this function does not work for robot objects that use the modified Denavit-Hartenberg convention");
    end
    if L(1).RP ~= "R" | L(2).RP ~= "R" | L(3).RP ~= "R" | L(4).RP ~= "R" | L(5).RP ~= "R" | L(6).RP ~= "R" then
        error("robot must be a puma 560 like robot arm");
    end
    if a1 ~= 0 | a2 == 0 | a4 ~= 0 | a5 ~= 0 | a6 ~= 0 then
        error("robot must be a puma 560 like robot arm");
    end
    if d1 ~= 0 | d2 ~= 0 | d4 == 0 | d5 ~= 0 then
        error("robot must be a puma 560 like robot arm");
    end
    if alpha1 ~= %pi/2 | alpha2 ~= 0 | abs(alpha3) ~= %pi/2 | abs(alpha4) ~= %pi/2 | abs(alpha5) ~= %pi/2 | alpha6 ~= 0 then
        error("robot must be a puma 560 like robot arm");
    end

    // if robot is a puma 560 like robot arm
    // references:  R.P.Paul. Robot manipulator: mathematics, programming and control.
    //              MIT Press, Cambridge, MA, 1981
    Q = zeros(4,6);
    TB6 = inv(robot.base) * T06;
    RB6 = rt_tr2rot(TB6);
    pB6 = rt_transl(TB6);
    aB6 = RB6(:,3);
    if d6 ~= 0 then
        px = pB6(1) - d6*aB6(1);
        py = pB6(2) - d6*aB6(2);
        pz = pB6(3) - d6*aB6(3);
    else
        px = pB6(1);
        py = pB6(2);
        pz = pB6(3);
    end

    // evaluate t1
    r = (px^2 + py^2)^(1/2);
    if r < tol then
        warning("shoulder singularity, infinitely many solutions for theta1");
        Q(1,1) = 0;
        Q(2,1) = %pi/2;
        Q(3,1) = %pi;
        Q(4,1) = 3/2*%pi;
    else
        Q(1,1) = atan(py,px) + atan(d3,(r^2-d3^2)^(1/2));   // Scilab's atan(x,y) is atan2(x,y)
        Q(2,1) = Q(1,1);
        Q(3,1) = atan(py,px) + atan(d3,-(r^2-d3^2)^(1/2));
        Q(4,1) = Q(3,1);
    end

    // intermediate step to evaluate t2+t3
    if abs(px) < tol & abs(pz) < tol & or(abs(Q(:,1)) < 10*tol) then
        warning("elbow singularity, infinitely many solutions for theta2");
    end
    t23 = zeros(4,1);
    for i=1:2:4,
        c1 = cos(Q(i,1));
        s1 = sin(Q(i,1));
        k1 = signalpha4*2*d4*(py*s1 + px*c1) - 2*a3*pz;
        k2 = -2*a3*(py*s1 + px*c1) - signalpha4*2*d4*pz;
        k3 = a2^2 - a3^2 - d4^2 - pz^2 - (px*c1 + py*s1)^2;

        // case k3 = -k2
        if abs(k3+k2) < tol then

            // when k2 = 0 solutions follow from equation
            // k1*sin(t2+t3) = 0
            if abs(k2) < tol then
                t23(i) = 0;
                t23(i+1) = %pi;

            // when k2 ~= 0 solutions are u1 = u2 = -k2/k1
            else

                // However, when k1 = 0 they follow from equation
                // cos(t2+t3) = -1
                if abs(k1) < tol then
                    t23(i) = %pi;
                    t23(i+1) = -%pi;

                else // k1 ~= 0
                    u = -k2/k1;
                    t23(i) = atan((2*u)/(1+u^2) , (1-u^2)/(1+u^2));
                    t23(i+1) = t23(i);
                end

            end

        // case k3 ~= k2
        else

            k = abs(k1^2 + k2^2 - k3^2);
            if (k > tol) & (k1^2 + k2^2 - k3^2 < 0) then
                error("cant find real solutions for theta2+theta3");
            else
                u = [-((k)^(1/2) - k1)/(k3+k2); ((k)^(1/2) + k1)/(k3+k2)];
                t23(i) = atan((2*u(1))/(1+u(1)^2), (1-u(1)^2)/(1+u(1)^2));
                t23(i+1) = atan((2*u(2))/(1+u(2)^2), (1-u(2)^2)/(1+u(2)^2));
            end

        end
    end

    // evaluate t2, t3
    for i=1:4,
        c1 = cos(Q(i,1));
        s1 = sin(Q(i,1));
        c23 = cos(t23(i));
        s23 = sin(t23(i));
        c2 = (py*s1 + px*c1 + signalpha4*d4*s23 - a3*c23)/a2;
        s2 = (pz - a3*s23 - signalpha4*d4*c23)/a2;
        Q(i,2) = atan(s2,c2);
        Q(i,3) = t23(i) - Q(i,2);
    end

    // evaluate t4, t5 e t6
    // references:  L. Sciavicco, B. Siciliano, "Modelling and Control of Robot Manipulators",
    //              2nd Edition, Springer-Verlag Advanced Textbooks in Control and Signal
    //              Processing Series, London, UK, 2000
    for i=1:4,
        TB1 = L(1)(Q(i,1));
        T12 = L(2)(Q(i,2));
        T23 = L(3)(Q(i,3));
        TB3 = TB1*T12*T23;
        T36 = inv(TB3)*TB6;
        Q(i,5) = atan((T36(1,3)^2+T36(2,3)^2)^(1/2),T36(3,3));

        // when t5 = 0 or t5 = %pi robot configuration is singular
        if Q(i,5) < tol | %pi - Q(i,5) < tol then
            printf("WARNING:wrist singularity in solution %d, infinitely many solutions for theta4 and theta6\n",i);

            // case t5 = 0
            if Q(i,5) < tol then
                t46 = atan(T36(2,1),T36(1,1));      // only t4+t6 is defined. Infinitely many solutions exist
                Q(i,4) = t46/i;
                Q(i,6) = t46 - Q(i,4);

            // case t5 = %pi
            else
                diff64 = atan(T36(2,1),T36(2,2));   // only t6-t4 is defined. Infinitely many solutions exist
                Q(i,4) = diff64/i;
                Q(i,6) = Q(i,4) + diff64;
            end

        // non-singular robot configuration
        else
            Q(i,4) = atan(-signalpha4*T36(2,3),-signalpha4*T36(1,3));
            Q(i,6) = atan(-signalpha4*T36(3,2),signalpha4*T36(3,1));
        end
    end

endfunction
