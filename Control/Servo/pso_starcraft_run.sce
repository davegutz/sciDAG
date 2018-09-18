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
global verbose
verbose = %f;

function f = script(x)
    global verbose
    if verbose then
        mprintf("sizeof x = %ld, %ld", size(x));
    end
    f = sum(x.^2, "c")
    if verbose then
        mprintf(" sizeof f = %ld, %ld\n", size(f));
    end
endfunction

// Rosenbrock vectorial function
function f = rosenbrockV(x)
    [n, m] = size(x);
    f = zeros(n,1);
    for i = 1:n
        f(i) = 100*(x(i,2)-x(i,1)^2)^2+(1-x(i,1))^2;
    end
endfunction

// PSO inputs
wmax = 0.9; // initial weigth parameter
wmin = 0.4; // final weigth parameter
weights = [wmax; wmin];
itmax = 100; //Maximum iteration number
c1 = 0.7; // knowledge factors for personnal best
c2 = 1.47; // knowledge factors for global best
c = [c1;c2];
N = 100; // problem dimensions: number of particles
D = 2; // problem in R^2  number of x's
launchp = 0.9;
speedf = 2*ones(1,D);
nraptor = N;
boundsmax = ones(D,1)*100;
boundsmin = -boundsmax;
bounds = [boundsmin,boundsmax];
speed_max = 0.1*boundsmax;
speed_min = 0.1*boundsmin;
speed = [speed_min, speed_max];
fverbose = 0; // 1 to activate autosave and graphics by default
sol_ini = ones(1, D)*1; // inserting an initial solution (optional)
grand('setsd', getdate('s')); // the random generator must be initialized

// Particle Swarm algorithm
verbose = %f;
[fopt, xopt]=PSO_bsg_starcraft(script, bounds, speed, itmax, N, weights, c,..
    launchp, speedf, nraptor, fverbose, sol_ini);
mprintf("*****PSO starcraft  x = %8.7f %8.7f", xopt(1), xopt(2));
mprintf(";  f = %e\n", fopt);

// Particle Swarm algorithm
verbose = %f;
fverbose = 0; // 1 to activate autosave and graphics by default
sol_ini = ones(1, D)*0.5; // inserting an initial solution (optional)
[fopt, xopt]=PSO_bsg_starcraft(rosenbrockV, bounds, speed, itmax, N, weights,..
    c, launchp, speedf, nraptor, fverbose, sol_ini);
mprintf("*****PSO starcraft  x RosenbrockV = %8.7f %8.7f", xopt(1), xopt(2));
mprintf(";  f = %e\n", fopt);

