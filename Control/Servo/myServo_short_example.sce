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
clear
getd('../ControlLib')
exec('myServo.sci', -1)
n_fig = -1;
xdel(winsid())

global dT P C W p t_step verbose
dT = 0.01;
t_step = 0:dT:2;
verbose = 0;

// Frequency range
f_min = 1/2/%pi;
f_max = 1/dT;

// System parameters
P = struct('tehsv1', 0.007, 'tehsv2', 0.01, 'gain', 1);
C = struct( 'tld1', 0.064, 'tlg1', 0.008,..
                    'tld2', 0.008, 'tlg2', 0.008,..
                    'tldh', 0.008, 'tlgh', 0.008,..
                    'gain', 16);
MU = struct('gm', 9, 'pm', 60, 'pwr', 30,..
             'tr', 0.2, 'Mp', 0.15, 'ts', 1, 'sum', 0);
W = struct('tr', 0, 'Mp', 0, 'ts', 0);
R = struct('gm', 6, 'pm', 45, 'pwr', 40,..
             'tr', 0.2, 'Mp', 0.05, 'ts', 2);
// Performance function
function f = myObj(x)
    global W p verbose
    [n, m] = size(x);
    f = zeros(n,1);
    for i = 1:n
        I = [max(x(i,1), 3), max(x(i,2), 0.008)];
        if verbose>2 then
            mprintf('myObj:  gain=%6.3f   tld1=%6.3f\n', I(1), I(2));
        end
        [pm, gm, gwr, pwr, tr, tp, Mp, ts] = myPerf(I);
        if verbose>3 then
            mprintf('myObj:  W.tr=%6.3f   W.Mp=%6.3f, W.ts=%6.3f\n', W.tr, W.Mp, W.ts);
            mprintf('myObj:  tr=%5.3f s   Mp=%6.3f    ts=%5.3f s\n', p.tr, p.Mp*100, p.ts);
        end
        f(i) = W.tr*tr + W.Mp*Mp + W.ts*ts;
    end
endfunction
function [pm, gm, gwr, pwr, tr, tp, Mp, ts] = myPerf(I)
    global dT P C p t_step
    C.gain = I(1);
    C.tld1 = I(2);
    [p.sys_ol, p.sys_cl] = myServo(dT, P, C);
    [p.gm, gfr] = g_margin(p.sys_ol);
    [p.pm, pfr] = p_margin(p.sys_ol);
    p.gwr = gfr*2*%pi;
    p.pwr = pfr*2*%pi;
    p.y_step = csim('step', t_step, p.sys_cl);
    [p.tr, p.tp, p.Mp, p.ts] = stepPerf(p.y_step, t_step,..
                                        0.95, 0.02, dT);
    pm = p.pm;
    gm = p.gm;
    gwr = p.gwr;
    pwr = p.pwr;
    tr = p.tr;
    tp = p.tp;
    Mp = p.Mp;
    ts = p.ts;
endfunction
function [time_rise, time_peak, magnitude_peak, time_settle] = ..
    stepPerf(y, t, frac_rise, frac_settle, dT)
    // Unit step response performance
    // Assume regular update interval of unit response y
    // Assume final value y = 1
    global dT t_step
    r = 1;
    rx = length(t);
    while y(r)<frac_rise & r<rx
        r = r+1;
    end
    time_rise = (r-1)*dT;
    [y_p, r_p] = max(y);
    time_peak = (r_p-1)*dT;
    magnitude_peak = y_p-1;
    y_s_max = 1+frac_settle;
    y_s_min = 1-frac_settle;
    r = rx;
    while y(r)>y_s_min & y(r)<y_s_max & r>0
        r = r-1;
    end
    time_settle = (r-1)*dT;
endfunction

MU.sum = MU.tr + MU.Mp + MU.ts;
R.sum = R.tr + R.Mp + R.ts;
W.tr = R.sum/R.tr * MU.sum/MU.tr;
W.Mp = R.sum/R.Mp * MU.sum/MU.Mp;
W.ts = R.sum/R.ts * MU.sum/MU.ts;

f1 = myObj([C.gain, C.tld1]);
casestr = msprintf('%4.1f/%4.3f : %4.1f/%4.0f',..
                   C.gain, C.tld1, p.gm, p.pm)
mprintf('%4.1f/%4.3f:  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        C.gain, C.tld1, p.gm, p.gwr, p.pm, p.pwr)
mprintf('tr=%5.3f s   Mp=%6.3f  ts=%5.3f s\n', p.tr, p.Mp*100, p.ts)


// Bode plot.
// With gainplot and phaseplot can only use Hz but can manually scale
// With bode can use rad/s but cannot scale phase plot
n_fig = n_fig+1;
figure(n_fig); clf(); 
bode(p.sys_ol, f_min, f_max,  [casestr], 'rad')


// PSO inputs
wmax = 0.9; // initial weight parameter
wmin = 0.4; // final weight parameter
weights = [wmax; wmin];
itmax = 30; //Maximum iteration number
c1 = 0.7; // knowledge factors for personnal best
c2 = 1.47; // knowledge factors for global best
c = [c1; c2];
N = 100; // problem dimensions: number of particles
D = 2; // problem in R^2
launchp = 0.9;
speedf = 2*ones(1,D);
nraptor = N;
x0 = [30, 0.008];
boundsmax = x0'*4;
boundsmin = x0'/4;
bounds = [boundsmin,boundsmax];
speed_max = 0.1*boundsmax;
speed_min = 0.1*boundsmin;
speed = [speed_min, speed_max];
verbosef = 1; // 1 to activate autosave and graphics by default
grand('setsd', getdate('s')); // must initialize random generator

// Particle Swarm algorithm
x0 = [20, 0.008];
boundsmax = [35; 0.25];
boundsmin = [3; 0.008];
bounds = [boundsmin, boundsmax];
verbosef = 1; // 1 to activate autosave and graphics by default
if verbosef>0 then
    n_fig = n_fig+1;
end
[fopt, xopt]=PSO_bsg_starcraft(myObj, bounds, speed, itmax, N,..
                weights, c, launchp, speedf, nraptor, verbosef, x0);
mprintf('xopt= %4.1f/%4.3f, fopt=%e\n', xopt, fopt);
mprintf('%4.1f/%4.3f:  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        C.gain, C.tld1, p.gm, p.gwr, p.pm, p.pwr)
mprintf('tr=%5.3f s   Mp=%6.3f  ts=%5.3f s\n', p.tr, p.Mp*100, p.ts)
mprintf('gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        p.gm, p.gwr, p.pm, p.pwr)
n_fig = n_fig+1;
figure(n_fig); clf(); 
plot(t_step, p.y_step)        
