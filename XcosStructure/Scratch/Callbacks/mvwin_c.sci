// Copyright (C) 2019 - Dave Gutz
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
// Apr 24, 2019    DA Gutz        Created from simulink
// 
function [x, a] = mvwin_c()
    table = [   0.000352    0.001322;..
                0.00141     0.001417;..
                0.003172    0.001575;..
                0.005638    0.001797;..
                0.00881     0.002083;..
                0.012686    0.002432;..
                0.017268    0.002844;..
                0.022554    0.00332;..
                0.028544    0.003859;..
                0.03524     0.004462;..
                0.04264     0.005128;..
                0.050746    0.005857;..
                0.059556    0.00665;..
                0.06907     0.007541;..
                0.07929     0.008605;..
                0.090214    0.009866;..
                0.101844    0.011348;..
                0.114178    0.013079;..
                0.127216    0.015085;..
                0.14096     0.017397;..
                0.155408    0.020045;..
                0.170561    0.023063;..
                0.186419    0.026483;..
                0.202982    0.030343;..
                0.22025     0.03468;..
                0.238222    0.039533;..
                0.256899    0.044942;..
                0.276281    0.051186;..
                0.296368    0.058861;..
                0.31716     0.068115;..
                0.338656    0.079085;..
                0.360857    0.091911;..
                0.383763    0.106737;..
                0.407374    0.123712;..
                0.43169     0.14299;..
                0.45671     0.164731;..
                0.482435    0.189097;..
                0.508865    0.216256;..
                0.536       0.24638;..
                0.56384     0.25484];
    x = table(:,1);
    a = table(:,2);
endfunction
