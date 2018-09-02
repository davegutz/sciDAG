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

// Frequency range
f_min = 1/2/%pi;
f_max = 1/dT;

// System parameters
tehsv1 = 0.007;
tehsv2 = 0.01;
dT = 0.01;
myPlant = struct('tehsv1', 0.007, 'tehsv2', 0.01, 'gain', 1);
myControl = struct( 'tld1', 0.100, 'tlg1', 0.008,..
                    'tld2', 0.008, 'tlg2', 0.008,..
                    'tldh', 0.008, 'tlgh', 0.008,..
                    'gain', 10.00);

// Performance function
function p = myPerf(dT, P, C, gain)
    C.gain = gain;
    [sys_ol, sys_cl] = myServo(dT, P, C);
    [p.gm, gfr] = g_margin(sys_ol);
    [p.pm, pfr] = p_margin(sys_ol);
    p.gwr = gfr*2*%pi;
    p.pwr = pfr*2*%pi;
endfunction


p = myPerf(dT, myPlant, myControl, myControl.gain);
casestr = msprintf('%4.1f/%4.3f : %4.1f/%4.0f', myControl.gain, myControl.tld1, p.gm, p.pm)
mprintf('gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n', p.gm, p.gwr, p.pm, p.gwr)


// Bode plot.
// With gainplot and phaseplot can only use Hz but can manually scale
// With bode can use rad/s but cannot scale phase plot
n_fig = n_fig+1;
figure(n_fig); clf(); 
bode(sys_ol, f_min, f_max,  [casestr], 'rad')
