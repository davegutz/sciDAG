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
C = struct( 'tld1', 0.008, 'tlg1', 0.008,..
            'tld2', 0.008, 'tlg2', 0.008,..
            'tldh', 0.008, 'tlgh', 0.008,..
            'gain', 30);
MU = struct('gm', 9, 'pm', 60, 'pwr', 30,..
            'tr', 0.05, 'Mp', 0.15, 'Mu', 0.15, 'ts', 0.2, 'sum', 0);
W = struct('tr', 0, 'Mp', 0, 'ts', 0);
R = struct('gm', 6, 'pm', 45, 'pwr', 40,..
           'rise', 0.95, 'settle', 0.02,..
           'tr', 0.07, 'Mp', 0.05, 'Mu', 0.05, 'ts', 0.2);
WC = struct('tr', 1, 'Mp', 1, 'Mu', 1, 'ts', 0.2, 'sum', 0);
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
        [pm, gm, gwr, pwr, tr, tp, Mp, tu, Mu, ts] = myPerf(I);
        if verbose>3 then
            mprintf('myObj:  W.tr=%6.3f   W.Mp=%6.3f, W.Mu=%6.3f, W.ts=%6.3f\n',..
                    W.tr, W.Mp, W.Mu, W.ts);
            mprintf('myObj:  tr=%5.3f s Mp100=%6.3f tp=%6.3f Mu100=%6.3f tu=%6.3f ts=%5.3f s\n',..
                    p.tr, p.Mp*100, p.tp, p.Mu*100, p.tu, p.ts);
        end
        f(i) = W.tr*tr + W.Mp*Mp - W.Mu*Mu + W.ts*ts;
        if gm<R.gm then
            f(i)= f(i) + 100;
        end
        if pm<R.pm then
            f(i) = f(i) + 100;
        end
        if Mu<R.rise-1 then
            f(i) = f(i) + 100;
        end
    end
endfunction
function [pm, gm, gwr, pwr, tr, tp, Mp, tu, Mu, ts] = myPerf(I)
    global dT P C p t_step R
    C.gain = I(1);
    C.tld1 = I(2);
    [p.sys_ol, p.sys_cl] = myServo(dT, P, C);
    [p.gm, gfr] = g_margin(p.sys_ol);
    [p.pm, pfr] = p_margin(p.sys_ol);
    p.gwr = gfr*2*%pi;
    p.pwr = pfr*2*%pi;
    p.y_step = csim('step', t_step, p.sys_cl);
    [p.tr, p.tp, p.Mp, p.tu, p.Mu, p.ts] = ..
               stepPerf(p.y_step, t_step, R.rise, R.settle, dT);
    pm = p.pm;
    gm = p.gm;
    gwr = p.gwr;
    pwr = p.pwr;
    tr = p.tr;
    tp = p.tp;
    Mp = p.Mp;
    tu = p.tu;
    Mu = p.Mu;
    ts = p.ts;
endfunction
function [time_rise, time_peak, magnitude_peak, time_us, magnitude_us, time_settle] = ..
    stepPerf(y, t, frac_rise, frac_settle, dT)
    // Unit step response performance
    // Assume regular update interval of unit response y
    // Assume final value y = 1
    global dT t_step verbose

    // Rise time
    r = 1;
    n = length(t);
    while y(r)<frac_rise & r<n
        r = r+1;
    end
    r_rise = r -1 + (frac_rise-y(r-1))/(y(r)-y(r-1));
    time_rise = (r_rise-1)*dT;

    // Settling time
    y_s_max = 1+frac_settle;
    y_s_min = 1-frac_settle;
    r = n;
    while y(r)>y_s_min & y(r)<y_s_max & r>0
        r = r-1;
    end
    if r<n then
        if y(r+1)>y_s_min then
            y_settle = y_s_min;
        else    
            y_settle = y_s_max;
        end
    else
        y_settle = y(r);
        r = r - 1;
    end
    r_settle = r + (y_settle-y(r))/(y(r+1)-y(r));
    time_settle = (r_settle-1)*dT;

    // Peak overshoot = maximum, if > 0
    [y_p, r_p] = max(y);
    // Forgiveness if settled
    if r_p==n & abs(y_p-1)<frac_settle then
        y_p = 1;
    end
    time_peak = (r_p-1)*dT;
    magnitude_peak = max(y_p-1, 0);
    if verbose>3 then
        mprintf('r_p=%ld,y_p=%e,n=%ld\n', r_p, y_p, n);
    end
    
    // Undershoot = minimum, if < 0, after first direction change after rising
    ydiff = [0, diff(y)];
    r = ceil(r_rise);
    while ydiff(r)>0 & r<n
        r = r + 1
    end
    [y_u, r_u] = min(y(r:n));
    r_under = r_u + r;
    time_us = (r_under-1)*dT;
    magnitude_us = min(y_u-1, 0);
    if verbose>3 then
        mprintf('r_under=%ld,y_u=%e, r_rise=%ld\n', r_under, y_u, ceil(r_rise));
    end

endfunction

MU.sum = MU.tr + MU.Mp + MU.Mu + MU.ts;
R.sum = R.tr + R.Mp + R.Mu + R.ts;
W.tr = R.sum/R.tr * MU.sum/MU.tr;
W.Mp = R.sum/R.Mp * MU.sum/MU.Mp;
W.Mu = R.sum/R.Mu * MU.sum/MU.Mu;
W.ts = R.sum/R.ts * MU.sum/MU.ts;

WC.sum = WC.tr + WC.Mp + WC.Mu + WC.ts;
WC.tr = WC.tr/WC.sum;
WC.Mp = WC.Mp/WC.sum;
WC.Mu = WC.Mu/WC.sum;
WC.ts = WC.ts/WC.sum;

MU.sum = 1/MU.tr + 1/MU.Mp + 1/MU.Mu + 1/MU.ts;
W.tr = WC.tr/(MU.tr*MU.sum);
W.Mp = WC.Mp/(MU.Mp*MU.sum);
W.Mu = WC.Mu/(MU.Mu*MU.sum);
W.ts = WC.ts/(MU.ts*MU.sum);


f1 = myObj([C.gain, C.tld1]);
casestr_i = msprintf('Orig %4.1f/%4.3f : %4.1f/%4.0f',..
                   C.gain, C.tld1, p.gm, p.pm)
mprintf('%4.1f/%4.3f:  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        C.gain, C.tld1, p.gm, p.gwr, p.pm, p.pwr)
mprintf('tr=%5.3f s Mp100=%6.3f  Mu100=%6.3f  ts=%5.3f s\n',..
        p.tr, p.Mp*100, p.Mu*100, p.ts)
n_fig = n_fig+1;
n_fig_step = n_fig;
scf(n_fig_step); clf(); 
plot(t_step, p.y_step, 'k')
xgrid(0);
y_step_i = p.y_step;
sys_ol_i = p.sys_ol;


// PSO inputs
wmax = 0.9; // initial weight parameter
wmin = 0.4; // final weight parameter
weights = [wmax; wmin];
itmax = 40; //Maximum iteration number
c1 = 0.7; // knowledge factors for personnal best
c2 = 1.47; // knowledge factors for global best
c = [c1; c2];
N = 10; // problem dimensions: number of particles
D = 2; // problem in R^2
launchp = 0.9; // launch probability, default = 0.9 (?)
speedf = 2*ones(1,D); // speed factor, default = 2
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
    figure(n_fig);
    scf(n_fig);
end
[fopt, xopt]=PSO_bsg_starcraft(myObj, bounds, speed, itmax, N,..
                weights, c, launchp, speedf, nraptor, verbosef, x0);
casestr_f = msprintf('Final %4.1f/%4.3f : %4.1f/%4.0f',..
                   C.gain, C.tld1, p.gm, p.pm)
mprintf('xopt= %4.1f/%4.3f, fopt=%e\n', xopt, fopt);
mprintf('%4.1f/%4.3f:  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        C.gain, C.tld1, p.gm, p.gwr, p.pm, p.pwr)
mprintf('tr=%5.3f s Mp100=%6.3f  Mu100=%6.3f  ts=%5.3f s\n',..
        p.tr, p.Mp*100, p.Mu*100, p.ts)
mprintf('gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        p.gm, p.gwr, p.pm, p.pwr)


// plots
scf(n_fig_step);
plot(t_step, p.y_step, 'b')
title("Step Response","fontsize",3);
xlabel("t, sec","fontsize",4);
ylabel("$y$","fontsize",4);
legend([casestr_i, casestr_f]);

n_fig = n_fig+1;
n_fig_bode = n_fig;
scf(n_fig_bode); clf();
bode([sys_ol_i; p.sys_ol], f_min, f_max, [casestr_i, casestr_f], 'rad')
