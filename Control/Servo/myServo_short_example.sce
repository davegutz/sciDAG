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

global dT P C p
dT = 0.01;

// Frequency range
f_min = 1/2/%pi;
f_max = 1/dT;

// System parameters
P = struct('tehsv1', 0.007, 'tehsv2', 0.01, 'gain', 1);
C = struct( 'tld1', 0.064, 'tlg1', 0.008,..
                    'tld2', 0.008, 'tlg2', 0.008,..
                    'tldh', 0.008, 'tlgh', 0.008,..
                    'gain', 9.844);
R = struct('gm', 6, 'pm', 45, 'pwr', 40);
// Performance function
function f = myObj(I)
    O = myPerf(I);
    pm = O(1); gm = O(2); pwr = O(3);
    egm = R.gm - gm;
    epm = R.pm -pm;
    epwr = R.pwr - pwr;
    f = [(epm/8)^2, epwr/5, egm^2];
endfunction
function o = myPerf(I)
    global dT P C p
    C.gain = I(1);
    C.tld1 = I(2);
    [p.sys_ol, p.sys_cl] = myServo(dT, P, C);
    [p.gm, gfr] = g_margin(p.sys_ol);
    [p.pm, pfr] = p_margin(p.sys_ol);
    p.gwr = gfr*2*%pi;
    p.pwr = pfr*2*%pi;
    o = [p.pm, p.gm, p.pwr];
endfunction


f1 = myObj([C.gain, C.tld1]);
casestr = msprintf('%4.1f/%4.3f : %4.1f/%4.0f', C.gain, C.tld1, p.gm, p.pm)
mprintf('gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n', p.gm, p.gwr, p.pm, p.pwr)


// Bode plot.
// With gainplot and phaseplot can only use Hz but can manually scale
// With bode can use rad/s but cannot scale phase plot
n_fig = n_fig+1;
figure(n_fig); clf(); 
bode(p.sys_ol, f_min, f_max,  [casestr], 'rad')


// Example of use of the genetic algorithm
funcname = 'myObj';
PopSize = 100;
Proba_cross = 0.7;
Proba_mut = 0.1;
NbGen = 50;
NbCouples = 110;
Log = %T;
pressure = 0.1;
// Setting parameters of optim_nsga2 function
ga_params = init_param();
// Parameters to adapt to the shape of the optimization problem
ga_params = add_param(ga_params,'minbound', [4, 0.008]);
ga_params = add_param(ga_params,'maxbound', [40, 0.2]);
ga_params = add_param(ga_params,'dimension', 2);
ga_params = add_param(ga_params,'beta',0);
ga_params = add_param(ga_params,'delta',0.1);
// Parameters to fine tune the Genetic algorithm.
// All these parameters are optional for continuous optimization.
// If you need to adapt the GA to a special problem.
ga_params = add_param(ga_params,'init_func',init_ga_default);
ga_params = add_param(ga_params,'crossover_func',crossover_ga_default);
ga_params = add_param(ga_params,'mutation_func',mutation_ga_default);
ga_params = add_param(ga_params,'codage_func',coding_ga_identity);
ga_params = add_param(ga_params,'nb_couples',NbCouples);
ga_params = add_param(ga_params,'pressure',pressure);
// Define s function shortcut
deff('y=fobjs(x)','y = myObj(x);');

// Performing optimization
printf("Performing optimization:");
[pop_opt, fobj_pop_opt, pop_init, fobj_pop_init] = optim_nsga2(fobjs, PopSize, NbGen, Proba_mut, Proba_cross, Log, ga_params);
mprintf('gm=%4.2f dB @ %4.1f r/s.  pm=%4.0f deg @ %4.1f r/s\n', p.gm, p.gwr, p.pm, p.pwr)

// Compute Pareto front and filter
//[m, n] = size(fobj_pop_opt);
//obj_pop_opt(:,1) = -fobj_pop_opt(:,1) + R.pm*ones(m,1);
//obj_pop_opt(:,2) = -fobj_pop_opt(:,2) + R.gm*ones(m,1);
obj_pop_opt = fobj_pop_opt;
[f_pareto, pop_pareto] = pareto_filter(fobj_pop_opt, pop_opt);
//[m, n] = size(f_pareto);
//o_pareto(:,1) = -f_pareto(:,1) + R.pm*ones(m,1);
//o_pareto(:,2) = -f_pareto(:,2) + R.gm*ones(m,1);
o_pareto = f_pareto;

// Plot solution: Pareto front
n_fig = n_fig + 1;
figure(n_fig); clf(); 
scf(n_fig);
// Plotting final population
plot(obj_pop_opt(:,1), obj_pop_opt(:,2),'g.');
// Plotting Pareto population
plot(o_pareto(:,1), o_pareto(:,2),'k.');
title("Pareto front","fontsize",3);
xlabel("$f_1$","fontsize",4);
ylabel("$f_2$","fontsize",4);
legend(['Final pop','Pareto pop']);


// Transform list to vector for plotting Pareto set
npop = length(pop_opt);
pop_opt = matrix(list2vec(pop_opt), 2, npop)';
nfpop = length(pop_pareto);
pop_pareto = matrix(list2vec(pop_pareto), 2, nfpop)';
// Plot the Pareto set
n_fig = n_fig + 1;
figure(n_fig); clf(); 
scf(n_fig);
// Plotting final population
plot(pop_opt(:,1),pop_opt(:,2),'g.');
// Plotting Pareto population
plot(pop_pareto(:,1),pop_pareto(:,2),'k.');
title("Pareto Set","fontsize",3);
xlabel("$x_1$","fontsize",4);
ylabel("$x_2$","fontsize",4);
legend(['Final pop.','Pareto pop.']);

