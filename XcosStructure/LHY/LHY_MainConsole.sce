// Copyright (C) 2018 - Dave Gutz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// Dec 6, 2018 	DA Gutz		Created
// 
// Testing the model using US drug data
clc
// Import LHY functions
getd('model');
// Setting LHY model parameter
param = [];
param.tau = 5e4; // Number of innovators per year (initiation)
param.s = 0.61; // Annual rate at which light users attract
// non-users (initiation)
param.q = 3.443; // Constant which measures the deterrent
// effect of heavy users (initiation)
param.smax = 0.1;// Upper bound for s effective (initiation)
param.a = 0.163; // Annual rate at which light users quit
param.b = 0.024; // Annual rate at which light users escalate
// to heavy use
param.g = 0.062; // Annual rate at which heavy users quit
param.delta = 0.291; // Forgetting rate
// Setting initial conditions
Tbegin = 1970; // Initial time
Tend = 2020; // Final time
Tstep = 1/12 // Time step (one month)
L0 = 1.4e6; // Light users at the initial time
H0 = 0.13e6; // Heavy users at the initial time
Y0 = 0.11e6; // Decaying heavy user at the initial time
// Assigning ODE solver data
y0 = [L0;H0;Y0];
t0 = Tbegin;
t = Tbegin:Tstep:(Tend+100*%eps);
f = LHY_System;
// Solving the system
LHY = ode(y0, t0, t, f);
// Plotting of model data
LHY_Plot(t, LHY); 
