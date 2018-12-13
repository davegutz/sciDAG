// Copyright (c) 2002  Peter I. Corke
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



function rt_check2(robot, n, args)
// File name:       rt_check2.sci
//
// Functions:       rt_check2
//
// Description:     compare sci-coded and C-coded versions of rt_rne()
//
// Annotations:     this code is a Scilab port of corresponding function in the
//                  Robotics Toolbox for MATLAB(R) written by Peter I. Corke.
//                  Random points in state space belong to the [-%pi, %pi] interval.
//
// References:      Robotics Toolbox for MATLAB(R), robot7.1/mex/check2.m
//
// Author:          Matteo Morelli, I.R.C. "E. Piaggio", University of Pisa
//
// Date:            April 2007
//
// $LastChangedDate: 2007-10-05 23:28:34 +0200(ven, 05 ott 2007) $

    // create random points in state space
    q = 2*%pi*rand(n, 6) - %pi;
    qd = 2*%pi*rand(n, 6) - %pi;
    qdd = 2*%pi*rand(n, 6) - %pi;

    // test Sci-file
    if ~with_pvm() then
        tic(); tau = rt_rne(robot, q, qd, qdd, args(:)); t = toc();
        mprintf("Scilab has NOT been built with the ""Parallel Virtual Machine"" interface: results may be inaccurate!");
    else
        pvm_set_timer(); tau = rt_rne(robot, q, qd, qdd, args(:)); t = pvm_get_timer()*1E-6;
    end

    // test C-file
    if ~with_pvm() then
        tic(); tau_f = rt_frne(robot, q, qd, qdd, args(:)); t_f = toc();
        mprintf("Scilab has NOT been built with the ""Parallel Virtual Machine"" interface: results may be inaccurate!");
    else
        pvm_set_timer(); tau_f = rt_frne(robot, q, qd, qdd, args(:)); t_f = pvm_get_timer()*1E-6;
    end

    // speedup
    try,
        speedup = t/t_f;
    catch
        // division by zero
        // may occur when Scilab has not been built with the PVM interface
        // assumed 0.5ms as execution time for rt_frne()
        speedup = t/0.0005;
    end

    // print comparative results
    mprintf("Speedup is %10.0f, worst case error is %f\n", speedup, max(max(abs(tau-tau_f), "r")));

endfunction
