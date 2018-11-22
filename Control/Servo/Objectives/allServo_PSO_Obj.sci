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
// Function called by PSO to determine cost (obj_score) of potential
// design (particle in particles)
// function obj_score = allServo_PSO_Obj(particles)
function obj_score = allServo_PSO_Obj(particles)
    global G C W P X
    global verbose
    [n_particles, m] = size(particles);
    obj_score = zeros(n_particles,1);
    for i = 1:n_particles
        particle = particles(i,:);
        if verbose>2 then
            mprintf('allServo_PSO_Obj:  gain=%6.3f   tld1=%6.4f tlg1 = %6.4f tld2 = %6.4f tlg2 = %6.4f tldh = %6.4f tlgh = %6.4f\ n_particles', particle);
        end
        [P, C, X] = allServo_PSO_Perf(G, C, R, particle, P, X);
        P.minlag = C.dT*0.8;
        P.invgain = 1/C.gain;
        if verbose>3 then
            mprintf('allServo_PSO_Obj:  W.tr=%6.3f   W.Mp=%6.3f, W.Mu=%6.3f, W.ts=%6.3f, W.invgain=%6.3f\ n_particles',..
                    W.tr, W.Mp, W.Mu, W.ts, W.invgain);
            mprintf('allServo_PSO_Obj:  tr=%5.3f s Mp100=%6.3e tp=%6.3f Mu100=%6.3e tu=%6.3f ts=%5.3f s gain=%6.3f\ n_particles',..
                    P.tr, P.Mp*100, P.tp, P.Mu*100, P.tu, P.ts, C.gain);
        end
        X.Score.tr = W.tr*P.tr;
        X.Score.Mp = W.Mp*P.Mp;
        X.Score.Mu = W.Mu*P.Mu;
        X.Score.ts = W.ts*P.ts;
        X.Score.invgain = W.invgain/C.gain;
        X.Score.gm = 0;
        X.Score.pm = 0;
        X.Score.hard = 0;
                
        // Soft Limits
        if P.tr>R.tr then
            X.Score.tr = X.Score.tr + 10;
        end
        if P.gm<R.gm then
            X.Score.gm = X.Score.gm + 10;
        end
        if P.pm<R.pm then
            X.Score.pm = X.Score.pm + 10;
        end
        if P.Mp>R.Mp then
            X.Score.Mp = X.Score.Mp + 100;
        end
        if P.Mu>R.Mu then
            X.Score.Mu = X.Score.Mu + 10;
        end
        if P.tr>R.tr then
            X.Score.tr = X.Score.tr + 10;
        end
        if P.invgain>R.invgain then
            X.Score.invgain = X.Score.invgain + 10;
        end

        // "Hard" limit - PSO does not respect the input bounds
        if C.raw(2)<0 | C.raw(3)<P.minlag | C.raw(4)<0 |..
             C.raw(5)<P.minlag | C.raw(6)<0 | C.raw(7)<P.minlag then
            X.Score.hard = X.Score.hard + 100;
        end
        
        obj_score(i) = X.Score.tr + X.Score.Mp + X.Score.Mu +..
         X.Score.ts + X.Score.invgain + X.Score.gm + X.Score.pm +..
         X.Score.hard;
        X.Score.total = obj_score(i);
        P.ScoreN.tr = X.Score.tr/X.Score.total;
        P.ScoreN.Mp = X.Score.Mp/X.Score.total;
        P.ScoreN.Mu = X.Score.Mu/X.Score.total;
        P.ScoreN.ts = X.Score.ts/X.Score.total;
        P.ScoreN.invgain = X.Score.invgain/X.Score.total;
        P.ScoreN.gm = X.Score.gm/X.Score.total;
        P.ScoreN.pm = X.Score.pm/X.Score.total;
        P.ScoreN.hard = X.Score.hard/X.Score.total;

    end
    
endfunction
