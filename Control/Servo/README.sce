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
exec('myServo.sci', -1)
n_fig = 0;

// Plant, fixed
tehsv1 = 0.007;
tehsv2 = 0.01;
dT = 0.01;

// Frequency range
f_min = 1/2/%pi;
f_max = 1/dT;

// Control, being optimized
tld1 = 0.100;
tlg1 = 0.008;
tld2 = 0.008;
tlg2 = 0.008;
tldh = 0.008;
tlgh = 0.008;
gain = 10;

[sys_ol, sys_cl] = myServo(tld1, tlg1, tld2, tlg2, tldh, tlgh, dT, tehsv1, tehsv2, gain);
[gm,gfr] = g_margin(sys_ol);
[pm,pfr] = p_margin(sys_ol);
gwr = gfr*2*%pi;
pwr = pfr*2*%pi;
casestr = msprintf('%4.1f/%4.3f : %4.1f/%4.0f', gain, tld1, gm, pm)
mprintf('gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n', gm, gwr, pm, pwr)


// Bode plot.
// With gainplot and phaseplot can only use Hz but can manually scale
// With bode can use rad/s but cannot scale phase plot

n_fig = n_fig+1;
figure(n_fig); clf(); 
bode(sys_ol, f_min, f_max,  [casestr], 'rad')

//subplot(2,1,1)
//gainplot(sys_ol, f_min, f_max,  [casestr])
//a1 = gca();
//a1.auto_scale="off";
//a1.tight_limits = "on";
//a1.data_bounds = [f_min, -12; f_max, 6];
//subplot(2,1,2)
//phaseplot(sys_ol, f_min, f_max,  [casestr])
//a2 = gca();
//a2.auto_scale="off";
//a2.tight_limits = "on";
//a2.data_bounds = [f_min, -270; f_max, 90];
//a2.y_ticks.labels = ["-180";"-90";"0"];
//a2.y_ticks.locations = [-180;-90;0];
//
