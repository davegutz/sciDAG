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
// Feb 20, 2019    DA Gutz        Created
// 
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
// Feb 20, 2019  DA Gutz  Created
// 
// PSO verbose
function stop =  OutFcn_start04selfinit(i, fopt, xopt)
    global PSO X
    PSO.iters = i;
    execstr('fopt= ' + X.obj_function + '(xopt)');  // To recalculate P, X at solution particle
    if i==0 | PSO.verbose>0 then
        mprintf('PSO(%03d): %14.9f<--- %6.3f*(%6.4f/%6.4f)(%6.4f/%6.4f)(%6.4f/%6.4f)\n', PSO.iters, fopt, xopt);
    end
    if i==0 | PSO.verbose>1 then
        mprintf('PSO(%03d):  tr=%5.3f s Mp100=%6.3e tp=%6.3f Mu100=%6.3e tu=%6.3f ts=%5.3f s gain=%6.3f\n',..
        PSO.iters, P.tr, P.Mp*100, P.tp, P.Mu*100, P.tu, P.ts, xopt(1));
    end
//    if i>0 & PSO.verbose==1 then
//        scf(X.n_fig_step); clf();
//        plot(X.t_step, X.y_step_init, 'k')
//        plot(X.t_step, X.y_step, 'r')
//        X.gcf.auto_scale = "off";
//        X.gcf.tight_limits = "on";
//        replot([0, 0.8, 5*R.ts, 1+2*R.Mp]);
//        xgrid(0);
//        X.gcf_step.visible="on";
//        title(P.case_title,"fontsize",3);
//        xlabel("t, sec","fontsize",4);
//        ylabel("$y$","fontsize",4);
//        casestr = msprintf('iteration=%d, score=%f', i, fopt);
//        legend([P.casestr_i, casestr]);
//    end
    stop = %f;
endfunction
