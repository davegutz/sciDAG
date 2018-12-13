// Copyright (C) 1992-2002, by Peter I. Corke
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



function [tau] = rt_rne_dh(robot, a1, a2, a3, a4, a5)
// File name:       rt_rne_dh.sci
//
// Function:        rt_rne_dh
//
// Description:     compute inverse dynamics via recursive Newton-Euler formulation.
//                  Based on the standard Denavit and Hartenberg notation.
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  MATLAB(R) function cross is missing, rt_cross clone implemented.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/rne_dh.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    [%nargout, %nargin] = argn(0);

    // parameters setting
    z0 = [0; 0; 1];
    grav = robot.gravity;
    fext = zeros(6, 1);
    n = robot.n;
    if size(a1,2) == 3*n then
        Q = a1(:, 1:n);
        Qd = a1(:, n+1:2*n);
        Qdd = a1(:, 2*n+1:3*n);
        np = size(Q,1);
        if %nargin >= 3 then
            grav = a2;
        end
        if %nargin == 4 then
            fext = a3;
        end
    else
        np = size(a1,1);
        Q = a1;
        Qd = a2;
        Qdd = a3;
        if size(a1,2) ~= n | size(Qd,2) ~= n | size(Qdd,2) ~= n | size(Qd,1) ~= np | size(Qdd,1) ~= np then
            error("bad data");
        end
        if %nargin >= 5 then
            grav = a4;
        end
        if %nargin == 6 then
            fext = a5;
        end
    end
    tau = zeros(np,n);

    // computes the rne
    for p = 1:np,

        //
        // init some variables, compute the link rotation matrices
        //
        q = Q(p,:);
        qd = Qd(p,:);
        qdd = Qdd(p,:);

        Fm = [];
        Nm = [];
        pstarm = [];
        Rm = list();
        w = zeros(3,1);
        wd = zeros(3,1);
        v = zeros(3,1);
        vd = grav;
        f = fext(1:3);
        nn = fext(4:6);

        for j = 1:n,
            linkj = robot.links(j);
            Tj = linkj(q(j));
            Rm(j) = rt_tr2rot(Tj);
            if linkj.RP == "R" then
                D = linkj.D;
            else
                D = q(j);
            end
            alpha = linkj.alpha;
            pstarm(:,j) = [linkj.A; D*sin(alpha); D*cos(alpha)];
        end

        //
        // the forward recursion
        //
        for j = 1:n,
            linkj = robot.links(j);

            R = Rm(j).';
            pstar = pstarm(:,j);
            r = linkj.r;

            if linkj.RP == "R" then                 // statement order is important here!
                // revolute axis
                wd = R*(wd + z0*qdd(j) + rt_cross(w,z0*qd(j)));
                w = R*(w + z0*qd(j));
                vd = rt_cross(wd,pstar) + rt_cross(w, rt_cross(w,pstar)) +R*vd;

            else
                // prismatic axis
                w = R*w;
                wd = R*wd;
                vd = R*(z0*qdd(j)+vd) + rt_cross(wd,pstar) + 2*rt_cross(w,R*z0*qd(j)) + rt_cross(w, rt_cross(w,pstar));
            end

            vhat = rt_cross(wd,r) + rt_cross(w,rt_cross(w,r)) + vd;
            F = linkj.m*vhat;
            N = linkj.I*wd + rt_cross(w, linkj.I*w);
            Fm = [Fm F];
            Nm = [Nm N];
        end

        //
        // the backward recursion
        //
        for j = n:-1:1,
            linkj = robot.links(j);
            pstar = pstarm(:,j);
            if j == n then
                R = eye(3,3);
            else
                R = Rm(j+1);
            end

            r = linkj.r;                            // order of these statements is important,
                                                    // since both nn and f are functions of previous f!
            nn = R*(nn + rt_cross(R.'*pstar, f)) + rt_cross(pstar+r, Fm(:,j)) + Nm(:,j);
            f = R*f + Fm(:,j);
            R = Rm(j);

            // computes tau(p,j)
            if linkj.RP == "R" then

                // revolute
                tau(p,j) = nn.'*(R.'*z0) + linkj.G^2 * linkj.Jm*qdd(j) + linkj.G * rt_friction(linkj, qd(j));

            else

                // prismatic
                tau(p,j) = f.'*(R.'*z0) + linkj.G^2 * linkj.Jm*qdd(j) + linkj.G * rt_friction(linkj, qd(j));

            end
        end

    end

endfunction
