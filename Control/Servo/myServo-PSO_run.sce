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
verbose = 4;

// Frequency range
f_min = 1/2/%pi;
f_max = 1/dT;

// System parameters
P = struct('tehsv1', 0.007, 'tehsv2', 0.01, 'gain', 1);
C = struct( 'tld1', 0.013, 'tlg1', 0.009,..
            'tld2', 0.013, 'tlg2', 0.009,..
            'tldh', 0.015, 'tlgh', 0.008,..
            'gain', 32.6);
MU = struct('gm', 9, 'pm', 60, 'pwr', 30,..
            'tr', 0.05, 'Mp', 0.15, 'Mu', 0.15, 'ts', 0.2, 'sum', 0,..
            'invgain', 1/30);
W = struct('tr', 0, 'Mp', 0, 'ts', 0, 'invgain', 0);
R = struct('gm', 6, 'pm', 45, 'pwr', 40,..
           'rise', 0.95, 'settle', 0.02,..
           'invgain', 1/30,..
           'tr', 0.07, 'Mp', 0.10, 'Mu', 0.05, 'ts', 0.2);
WC = struct('tr', 1, 'Mp', 1, 'Mu', 1, 'ts', 0.2, 'sum', 0. , 'invgain', 2);
// Performance function
function f = myObj(x)
    global W p verbose C
    [n, m] = size(x);
    f = zeros(n,1);
    for i = 1:n
        I = x(i,:);
        if verbose>2 then
            mprintf('myObj:  gain=%6.3f   tld1=%6.3f tlg1 = %6.3f tld2 = %6.3f tlg2 = %6.3f tldh = %6.3f tlgh = %6.3f\n', I);
        end
        [pm, gm, gwr, pwr, tr, tp, Mp, tu, Mu, ts] = myPerf(I);
        if verbose>3 then
            mprintf('myObj:  W.tr=%6.3f   W.Mp=%6.3f, W.Mu=%6.3f, W.ts=%6.3f, W.invgain=%6.3f\n',..
                    W.tr, W.Mp, W.Mu, W.ts, W.invgain);
            mprintf('myObj:  tr=%5.3f s Mp100=%6.3e tp=%6.3f Mu100=%6.3e tu=%6.3f ts=%5.3f s gain=%6.3f\n',..
                    p.tr, p.Mp*100, p.tp, p.Mu*100, p.tu, p.ts, C.gain);
        end
        f(i) = W.tr*tr + W.Mp*Mp - W.Mu*Mu + W.ts*ts + W.invgain/C.gain;
        // "Soft" limit
        if gm<R.gm then
            f(i)= f(i) + 10;
        end
        if pm<R.pm then
            f(i) = f(i) + 10;
        end
        if Mp>R.Mp then
            f(i) = f(i) + 10;
        end
        if Mu<(R.rise-1) then
            f(i) = f(i) + 10;
        end
        if tr>R.tr then
            f(i) = f(i) + 10;
        end
        if 1/C.gain>R.invgain then
            f(i) = f(i) + 10;
        end
        // "Hard" limit - PSO does not respect the input bounds
        if C.raw(2)<0 | C.raw(3)<0.008 | C.raw(4)<0 | C.raw(5)<0.008 | C.raw(6)<0 | C.raw(7)<0.008 then
            f(i) = f(i) + 100;
        end
        
    end
endfunction
function [pm, gm, gwr, pwr, tr, tp, Mp, tu, Mu, ts] = myPerf(I)
    global dT P C p t_step R verbose
    C.raw = I;
    if verbose>2 then
        mprintf('C.raw=%6.3f/%6.3f/%6.3f/%6.3f%6.3f/%6.3f%6.3f\n', C.raw);
    end
    C.gain = max(I(1), 3);
    C.tld1 = max(I(2), 0);
    C.tlg1 = max(I(3), 0.008);
    C.tld2 = max(I(4), 0);
    C.tlg2 = max(I(5), 0.008);
    C.tldh = max(I(6), 0);
    C.tlgh = max(I(7), 0.008);
    [p.sys_ol, p.sys_cl] = myServo(dT, P, C);
    [p.gm, gfr] = g_margin(p.sys_ol);
    [p.pm, pfr] = p_margin(p.sys_ol);
    p.gwr = gfr*2*%pi;
    p.pwr = pfr*2*%pi;
    p.y_step = csim('step', t_step, p.sys_cl);
    [p.tr, p.tp, p.Mp, p.tu, p.Mu, p.ts] = ..
               myStepPerf(p.y_step, t_step, R.rise, R.settle, dT);
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

MU.sum = MU.tr + MU.Mp + MU.Mu + MU.ts + MU.invgain;
R.sum = R.tr + R.Mp + R.Mu + R.ts + R.invgain;
W.tr = R.sum/R.tr * MU.sum/MU.tr;
W.Mp = R.sum/R.Mp * MU.sum/MU.Mp;
W.Mu = R.sum/R.Mu * MU.sum/MU.Mu;
W.ts = R.sum/R.ts * MU.sum/MU.ts;
W.invgain = R.sum/R.invgain * MU.sum/MU.invgain;

WC.sum = WC.tr + WC.Mp + WC.Mu + WC.ts + WC.invgain;
WC.tr = WC.tr/WC.sum;
WC.Mp = WC.Mp/WC.sum;
WC.Mu = WC.Mu/WC.sum;
WC.ts = WC.ts/WC.sum;
WC.invgain = WC.invgain/WC.sum;

MU.sum = 1/MU.tr + 1/MU.Mp + 1/MU.Mu + 1/MU.ts + 1/MU.invgain;
W.tr = WC.tr/(MU.tr*MU.sum);
W.Mp = WC.Mp/(MU.Mp*MU.sum);
W.Mu = WC.Mu/(MU.Mu*MU.sum);
W.ts = WC.ts/(MU.ts*MU.sum);
W.invgain = WC.invgain/(MU.invgain*MU.sum);


f1 = myObj([C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh]);
casestr_i = msprintf('Init    %4.1f*(%4.3f/%4.3f)*(%4.3f/%4.3f)*(%4.3f/%4.3f): %4.1f/%4.0f',..
                   C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, p.gm, p.pm)
mprintf('%4.1f*(%4.3f/%4.3f)*(%4.3f/%4.3f)*(%4.3f/%4.3f):  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, p.gm, p.gwr, p.pm, p.pwr)
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
itmax = 80; //Maximum iteration number
c1 = 0.7; // knowledge factors for personnal best
c2 = 1.47; // knowledge factors for global best
c = [c1; c2];
N = 50; // problem dimensions: number of particles
D = 7; // problem in R^2
launchp = 0.9; // launch probability, default = 0.9 (?)
speedf = 2*ones(1,D); // speed factor, default = 2
nraptor = N;
x0 = [C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh];
boundsmax = x0'*4;
boundsmin = x0'/4;
bounds = [boundsmin,boundsmax];
speed_max = 0.1*boundsmax;
speed_min = 0.1*boundsmin;
speed = [speed_min, speed_max];
verbosef = 1; // 1 to activate autosave and graphics by default
// grand('setsd', getdate('s')); // must initialize random generator
grand('setsd', 0); // must initialize random generator.  Want same result on repeated runs.

// Particle Swarm algorithm
boundsmax = [50; 0.250; 0.025; 0.250; 0.025; 0.250; 0.250];
boundsmin = [25; 0.000; 0.008; 0.000; 0.008; 0.000; 0.125];
bounds = [boundsmin, boundsmax];
verbosef = 1; // 1 to activate autosave and graphics by default
if verbosef>0 then
    n_fig = n_fig+1;
    figure(n_fig);
    scf(n_fig);
end
[fopt, xopt]=PSO_bsg_starcraft(myObj, bounds, speed, itmax, N,..
                weights, c, launchp, speedf, nraptor, verbosef, x0);
casestr_f = msprintf('Final %4.1f*(%4.3f/%4.3f)*(%4.3f/%4.3f)*(%4.3f/%4.3f): %4.1f/%4.0f',..
                   C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, p.gm, p.pm)
mprintf('xopt= %4.1f/%4.3f, fopt=%e\n', xopt, fopt);
mprintf('%4.1f*(%4.3f/%4.3f)*(%4.3f/%4.3f)*(%4.3f/%4.3f):  gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n',..
        C.gain, C.tld1, C.tlg1, C.tld2, C.tlg2, C.tldh, C.tlgh, p.gm, p.gwr, p.pm, p.pwr)
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
