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
// Sep 2, 2018 	DA Gutz		Created
// 

clear
n_fig = -1;
xdel(winsid())

// Rosenbrock  function
function f = rosenbrock(x)
    f = 100*(x(2)-x(1)^2)^2+(1-x(1))^2;
endfunction
function f = rosenbrockM(x)  // Fake multiobjective
    f(1) = 100*(x(2)-x(1)^2)^2+(1-x(1))^2;
    f(2) = f(1);
endfunction
function [f, g, ind] = rosenbrockGrad(x, ind)
    f = 100*(x(2)-x(1)^2)^2+(1-x(1))^2;
    g(1) = -400.*(x(2)-x(1)^2)*x(1)-2.*(1.-x(1))
    g(2) = 200.*(x(2)-x(1)^2)
endfunction
function [f, g, ind] = rosenbrockND(x, ind)
    [f] = rosenbrock(x);
    g = numderivative(rosenbrock, x)
endfunction
// Rosenbrock vectorial function
function f = rosenbrockV(x)
    [n, m] = size(x);
    f = zeros(n,1);
    for i = 1:n
        f(i) = rosenbrock(x(i,:));
    end
endfunction
// Rosenbrock vectorial function
function f = rosenbrockVM(x)
    [n, m] = size(x);
    mprintf("sizeof x = %ld, %ld   ", size(x));
    f = zeros(n,m);
    for i = 1:n
        f(i, :) = rosenbrockM(x(i,:));
    end
    mprintf("sizeof f = %ld, %ld   ", size(f));
endfunction


// Example of use of the genetic algorithm
funcname = 'rosenbrockM';
PopSize = 10;
Proba_cross = 0.7;
Proba_mut = 0.1;
NbGen = 20;
NbCouples = 110;
Log = %F;
pressure = 0.1;
// Setting parameters of optim_nsga2 function
ga_params = init_param();
// Parameters to adapt to the shape of the optimization problem
ga_params = add_param(ga_params,'minbound', [-2, -2]);
ga_params = add_param(ga_params,'maxbound', [2, 2]);
ga_params = add_param(ga_params,'dimension', 2);
ga_params = add_param(ga_params,'beta', 0);
ga_params = add_param(ga_params,'delta', 0.1);
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
deff('y=fobjs(x)','y = rosenbrockM(x);');

// PSO inputs
wmax = 0.9; // initial weigth parameter
wmin = 0.4; // final weigth parameter
weights = [wmax; wmin];
itmax = 100; //Maximum iteration number
c1 = 0.7; // knowledge factors for personnal best
c2 = 1.47; // knowledge factors for global best
c = [c1;c2];
N = 100; // problem dimensions: number of particles
D = 2; // problem in R^2
launchp = 0.9;
speedf = 2*ones(1,D);
nraptor = N;
boundsmax = ones(D,1)*100;
boundsmin = -boundsmax;
bounds = [boundsmin,boundsmax];
speed_max = 0.1*boundsmax;
speed_min = 0.1*boundsmin;
speed = [speed_min, speed_max];
verbose = 1; // 1 to activate autosave and graphics by default
sol_ini = ones(1, D)*1; // inserting an initial solution (optional)
grand('setsd', getdate('s')); // the random generator must be initialized


// Basic optim
x0 = [-1.2 1];
[f, x] = optim(rosenbrockGrad, x0);
mprintf("*****optim Grad        x = %8.7f %8.7f", x(1), x(2));
mprintf(";  f = %e\n", f);

// Basic optim gradient unknown - use numderivative(ND)
x0 = [-1.2 1];
opt = optimset("PlotFcns", optimplotfval);
[f, x] = optim(rosenbrockND, x0);
mprintf("*****optim ND          x = %8.7f %8.7f", x(1), x(2));
mprintf(";  f = %e\n", f);

// fminsearch Nelder-Mead Simplex
x0 = [-1.2 1];
[x, f] = fminsearch(rosenbrock, x0);
mprintf("*****fminsearch        x = %8.7f %8.7f", x(1), x(2));
mprintf(";  f = %e\n", f);
opt = optimset("PlotFcns", optimplotfval);
try
    xdel(0)
catch
    continue
end
[x, f] = fminsearch(rosenbrock, x0, opt);
mprintf("*****fminsearch +plot  x = %8.7f %8.7f", x(1), x(2));
mprintf(";  f = %e\n", f);

// Particle Swarm algorithm
x0 = [-1.2 1];
verbose = 0; // 1 to activate autosave and graphics by default
[fopt, xopt]=PSO_bsg_starcraft(rosenbrockV, bounds, speed, itmax, N, weights, c,..
    launchp, speedf, nraptor, verbose, x0);
mprintf("*****PSO starcraft  x = %8.7f %8.7f", xopt(1), xopt(2));
mprintf(";  f = %e\n", fopt);

// Particle Swarm MIMO algorithm
x0 = [-1.2 1];
verbose = 0; // 1 to activate autosave and graphics by default
[fopt, xopt]=PSO_bsg_starcraft(rosenbrockVM, bounds, speed, itmax, N, weights, c,..
    launchp, speedf, nraptor, verbose, x0);
mprintf("*****PSO starcraft MIMO  x = %8.7f %8.7f", xopt(1), xopt(2));
mprintf(";  f = %e\n", fopt);

// Genetic algorithm
[pop_opt, fobj_pop_opt, pop_init, fobj_pop_init] = optim_nsga2(fobjs, PopSize, NbGen, Proba_mut, Proba_cross, Log, ga_params);
mprintf("*****optim_nsga2       x = %8.7f %8.7f", pop_opt(10)(1), pop_opt(10)(2));
mprintf(";  f = %e\n", fobj_pop_opt(10)(1));
//// Compute Pareto front and filter
//[f_pareto,pop_pareto] = pareto_filter(fobj_pop_opt,pop_opt);
//// Plot solution: Pareto front
//scf(1);
//// Plotting final population
//plot(fobj_pop_opt(2:10,1),fobj_pop_opt(2:10,2),'g.');
//// Plotting Pareto population
//plot(f_pareto(:,1),f_pareto(:,2),'k.');
//title("Pareto front","fontsize",3);
//xlabel("$f_1$","fontsize",4);
//ylabel("$f_2$","fontsize",4);
//legend(['Final pop.','Pareto pop.','Pareto front.']);
//// Transform list to vector for plotting Pareto set
//npop = length(pop_opt);
//pop_opt = matrix(list2vec(pop_opt),2,npop)';
//nfpop = length(pop_pareto);
//pop_pareto = matrix(list2vec(pop_pareto),2,nfpop)';
//// Plot the Pareto set
//scf(2);
//// Plotting final population
//plot(pop_opt(2:10,1),pop_opt(2:10,2),'g.');
//// Plotting Pareto population
//plot(pop_pareto(:,1),pop_pareto(:,2),'k.');
//title("Pareto Set","fontsize",3);
//xlabel("$x_1$","fontsize",4);
//ylabel("$x_2$","fontsize",4);
//legend(['Final pop.','Pareto pop.']);
//
