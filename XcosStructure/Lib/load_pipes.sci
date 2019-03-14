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
// Jan 17, 2019    DA Gutz        Created
// 
getd('../Lib/Pipes')

function [dwdc] = DWDC(sg)
    dwdc = 129.93948*sg;
endfunction
function [avis] = AVIS(sg, kvis)
    avis   = 9.312e-5 * .00155 * sg * kvis;
endfunction

vol_default = tlist(["vol", "beta", "dwdc", "vol", "tvp"], 135000, 129.93948*0.8, 0, 7);
mom_default = tlist(["mom", "area", "length", "min_flow", "max_flow"], 0, 1, -1e6, 1e6);
pipeVV_default = tlist(["pipeVV", "l", "a", "vol", "n", "c", "lti", "A", "B", "C", "D", "ltis"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 0, 0, [], [], [], [], [], []);
pipeMV_default = tlist(["pipeMV", "l", "a", "vol", "n", "c", "lti", "A", "B", "C", "D", "ltis"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 0, 0, [], [], [], [], [], []);
pipeMM_default = tlist(["pipeMM", "l", "a", "vol", "n", "c", "lti", "A", "B", "C", "D", "ltis"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 0, 0, [], [], [], [], [], []);
pipeVM_default = tlist(["pipeVM", "l", "a", "vol", "n", "c", "lti", "A", "B", "C", "D", "ltis"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 0, 0, [], [], [], [], [], []);
FP_default = tlist(["FP", "sg", "beta", "dwdc", "tvp"],..
        0.8, 135000, DWDC(0.8), 7);
        
// TODO:  make the following functions work and do useful things.
function [ps] = %pipe_string(p)
    // Start
    ps = msprintf('list(');
    // Scalars
    ps = ps + msprintf('%f,%f,%f,%d,%f,%f,%f', p.l, p.a, p.vol, p.n, p.spgr, p.beta, p.c);
    // End
    ps = ps + msprintf(')');
endfunction

function lis = lsx_pipe(p)
    lis = list(p.l, p.a, p.vol, p.n, p.spgr, p.beta, p.c);
endfunction

function str = %pipe_p(p)
    // Display pipe type
    str = string(p);
    disp(str)
endfunction
