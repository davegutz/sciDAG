// Copyright (C) 1995-2002, by Peter I. Corke
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



function [tau] = rt_rne_mdh(robot, a1, a2, a3, a4, a5)
// File name:       rt_rne_mdh.sci
//
// Function:        rt_rne_mdh
//
// Description:     compute inverse dynamics via recursive Newton-Euler formulation.
//                  Based on the modified Denavit and Hartenberg notation.
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  MATLAB(R) function cross is missing, rt_cross clone implemented.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/@robot/rne_mdh.m
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
        Pm = [];
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
            Pm(:,j) = [linkj.A; -D*sin(alpha); D*cos(alpha)];   // (i-1) P i
        end

        //
        // the forward recursion
        //
        for j = 1:n,
            linkj = robot.links(j);

            R = Rm(j).';
            P = Pm(:,j);
            Pc = linkj.r;

            if linkj.RP == 'R' then                 // trailing underscore means new value
                // revolute axis
                w_ = R*w + z0*qd(j);
                wd_ = R*wd + rt_cross(R*w, z0*qd(j)) + z0*qdd(j);
                vd_ = R * (rt_cross(wd,P) + rt_cross(w, rt_cross(w,P)) + vd);

            else
                // prismatic axis
                w_ = R*w;
                wd_ = R*wd;
                vd_ = R*(rt_cross(wd,P) + rt_cross(w, rt_cross(w,P)) + vd) + 2*rt_cross(R*w, z0*qd(j)) + z0*qdd(j);
            end

            // update variables
            w = w_;
            wd = wd_;
            vd = vd_;

            vdC = rt_cross(wd,Pc) + rt_cross(w, rt_cross(w,Pc)) + vd;
            F = linkj.m*vdC;
            N = linkj.I*wd + rt_cross(w,linkj.I*w);
            Fm = [Fm F];
            Nm = [Nm N];
        end

        //
        // the backward recursion
        //
        for j = n:-1:1,
            linkj = robot.links(j);
            if j == n then
                R = eye(3,3);
                P = [0;0;0];
            else
                R = Rm(j+1);
                P = Pm(:,j+1);  // i/P/(i+1)
            end
            Pc = linkj.r;                           // order of these statements is important,
                                                    // since both nn and f are functions of previous f!
            f_ = R*f + Fm(:,j);
            nn_ = Nm(:,j) + R*nn + rt_cross(Pc,Fm(:,j)) + rt_cross(P,R*f);

            f = f_;
            nn = nn_;

            // computes tau(p,j)
            if linkj.RP == "R" then

                // revolute
                tau(p,j) = nn.'*z0 + linkj.G^2 * linkj.Jm*qdd(j) + linkj.G * rt_friction(linkj, qd(j));

            else

                // prismatic
                tau(p,j) = f.'*z0 + linkj.G^2 * linkj.Jm*qdd(j) + linkj.G * rt_friction(linkj, qd(j));

            end
        end
    end

endfunction
