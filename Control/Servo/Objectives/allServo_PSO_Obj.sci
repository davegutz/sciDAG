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
// Oct 18, 2018 	DA Gutz		Created
// 
function f = allServo_PSO_Obj(x)
    global W p verbose C
    [n, m] = size(x);
    f = zeros(n,1);
    for i = 1:n
        I = x(i,:);
        if verbose>2 then
            mprintf('allServo_PSO_Obj:  gain=%6.3f   tld1=%6.3f tlg1 = %6.3f tld2 = %6.3f tlg2 = %6.3f tldh = %6.3f tlgh = %6.3f\n', I);
        end
        [pm, gm, gwr, pwr, tr, tp, Mp, tu, Mu, ts] = myPerf(I);
        if verbose>3 then
            mprintf('allServo_PSO_Obj:  W.tr=%6.3f   W.Mp=%6.3f, W.Mu=%6.3f, W.ts=%6.3f, W.invgain=%6.3f\n',..
                    W.tr, W.Mp, W.Mu, W.ts, W.invgain);
            mprintf('allServo_PSO_Obj:  tr=%5.3f s Mp100=%6.3e tp=%6.3f Mu100=%6.3e tu=%6.3f ts=%5.3f s gain=%6.3f\n',..
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
