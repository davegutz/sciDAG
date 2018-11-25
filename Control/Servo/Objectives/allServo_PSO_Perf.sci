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
// Nov 22, 2018 	DA Gutz		Created
// 
// Performance function called by objective function
function [P, C, X, S] = allServo_PSO_Perf(G, C, R, swarm, P, X)
    global verbose
    C.raw = swarm;
    if verbose>2 then
        mprintf('C.raw=%6.3f/%6.3f/%6.3f/%6.3f%6.3f/%6.3f%6.3f\n', C.raw);
    end
    if X.D>0 then
        C.gain = max(swarm(1), 3);
        if X.D>1 then
            C.tld1 = max(swarm(2), 0);
            if X.D>2 then
                C.tlg1 = max(swarm(3), P.minlag);
                if X.D>3 then
                    C.tld2 = max(swarm(4), 0);
                    if X.D>4 then
                        C.tlg2 = max(swarm(5), P.minlag);
                        if X.D>5 then
                            C.tldh = max(swarm(6), 0);
                            if X.D>6 then
                                C.tlgh = max(swarm(7), P.minlag);
                            else
                                msg = msprintf('PSO.N not compatible with myPerf function in %s', this);
                                error(msg)
                            end
                        end
                    end
                end
            end
        end
    end
    [S.sys_ol, S.sys_cl] = allServo_PSO_lti(C.dT, G, C);
    [P.gm, gfr] = g_margin(S.sys_ol);
    [P.pm, pfr] = p_margin(S.sys_ol);
    P.gwr = gfr*2*%pi;
    P.pwr = pfr*2*%pi;
    X.y_step = csim('step', X.t_step, S.sys_cl);
    [P.tr, P.tp, P.Mp, P.tu, P.Mu, P.ts] = ..
        myStepPerf(X.y_step, X.t_step, R.rise, R.settle, C.dT);
endfunction
