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
// Aug 25, 2018 	DA Gutz		Created
// 
getd('../ControlLib')

pade1 = pade(.01, 2);
pade10 = pade(.1, 2);
f_min = 1;
f_max = 1000;
n_fig = 0;

// Bode plot.
// With gainplot and phaseplot can only use Hz but can manually scale
// With bode can use rad/s but cannot scale phase plot
n_fig = n_fig+1;
figure(n_fig); clf(); 
subplot(2,1,1)
gainplot([pade1; pade10], f_min, f_max,  ["0.01 sec"; "0.1 sec"])
a1 = gca();
a1.auto_scale="off";
a1.tight_limits = "on";
a1.data_bounds = [f_min, -6; f_max, 6];
subplot(2,1,2)
phaseplot([pade1; pade10], f_min, f_max,  ["0.01 sec"; "0.1 sec"])
a2 = gca();
a2.auto_scale="off";
a2.tight_limits = "on";
a2.data_bounds = [f_min, -360; f_max, 0];
a2.y_ticks.labels = ["-360";"-270";"-180";"-90"];
a2.y_ticks.locations = [-360;-270;-180;-90];

