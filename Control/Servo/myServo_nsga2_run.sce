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

// ZDT1 multiobjective function
function f=zdt1(x)
    f1 = x(1);
    g = 1 + 9 * sum(x(2:$)) / (length(x)-1);
    h = 1 - sqrt(f1 ./ g);
    f = [f1, g.*h];
endfunction

// Min boundary function
function Res=min_bd_zdt1(n)
    Res = zeros(n,1);
endfunction

// Max boundary function
function Res=max_bd_zdt1(n)
    Res = ones(n,1);
endfunction

// Problem dimension
dim = 2;
// Example of use of the genetic algorithm
funcname = 'zdt1';
PopSize = 500;
Proba_cross = 0.7;
Proba_mut = 0.1;
NbGen = 10;
NbCouples = 110;
Log = %T;
pressure = 0.1;

// Setting parameters of optim_nsga2 function
ga_params = init_param();
// Parameters to adapt to the shape of the optimization problem
ga_params = add_param(ga_params,'minbound',min_bd_zdt1(dim));
ga_params = add_param(ga_params,'maxbound',max_bd_zdt1(dim));
ga_params = add_param(ga_params,'dimension',dim);
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
deff('y=fobjs(x)','y = zdt1(x);');

// Performing optimization
printf("Performing optimization:");
[pop_opt, fobj_pop_opt, pop_init, fobj_pop_init] = optim_nsga2(fobjs, PopSize, NbGen, Proba_mut, Proba_cross, Log, ga_params);

// Compute Pareto front and filter
[f_pareto,pop_pareto] = pareto_filter(fobj_pop_opt,pop_opt);
// Optimal front function definition
f1_opt = linspace(0,1);
f2_opt = 1 - sqrt(f1_opt);
// Plot solution: Pareto front
scf(1);
// Plotting final population
plot(fobj_pop_opt(:,1),fobj_pop_opt(:,2),'g.');
// Plotting Pareto population
plot(f_pareto(:,1),f_pareto(:,2),'k.');
plot(f1_opt, f2_opt, 'k-');
title("Pareto front","fontsize",3);
xlabel("$f_1$","fontsize",4);
ylabel("$f_2$","fontsize",4);
legend(['Final pop.','Pareto pop.','Pareto front.']);
// Transform list to vector for plotting Pareto set
npop = length(pop_opt);
pop_opt = matrix(list2vec(pop_opt),dim,npop)';
nfpop = length(pop_pareto);
pop_pareto = matrix(list2vec(pop_pareto),dim,nfpop)';
// Plot the Pareto set
scf(2);
// Plotting final population
plot(pop_opt(:,1),pop_opt(:,2),'g.');
// Plotting Pareto population
plot(pop_pareto(:,1),pop_pareto(:,2),'k.');
title("Pareto Set","fontsize",3);
xlabel("$x_1$","fontsize",4);
ylabel("$x_2$","fontsize",4);
legend(['Final pop.','Pareto pop.']);
