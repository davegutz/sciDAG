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
// Jul 20, 2019    DA Gutz  	Have to load subfolders in getd separately for v6
// 

//getd('../Lib/Pipes')  load this separately

function [dwdc] = DWDC(sg)
    dwdc = 129.93948*sg;
endfunction
function [avis] = AVIS(sg, kvis)
    avis   = 9.312e-5 * .00155 * sg * kvis;
endfunction

vol_default = tlist(["vol", "vol"], 1e6);
mom_default = tlist(["mom", "area", "length", "min_flow", "max_flow"], 1e6, 1e6, -1e6, 1e6);
pipeVV_default = tlist(["pVV", "l", "a", "vol", "n", "c", "lti", "A", "B", "C", "D", "ltis"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 0, 0, [], [], [], [], [], []);
pipeMV_default = tlist(["pMV", "l", "a", "vol", "n", "c", "lti", "A", "B", "C", "D", "ltis"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 0, 0, [], [], [], [], [], []);
pipeMM_default = tlist(["pMM", "l", "a", "vol", "n", "c", "lti", "A", "B", "C", "D", "ltis"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 0, 0, [], [], [], [], [], []);
pipeVM_default = tlist(["pVM", "l", "a", "vol", "n", "c", "lti", "A", "B", "C", "D", "ltis"],..
        18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 0, 0, [], [], [], [], [], []);
FP_default = tlist(["FP", "sg", "beta", "dwdc", "tvp"],..
        0.8, 135000, DWDC(0.8), 7);
        
function [vs] = %vol_string(v)
    vs = msprintf('type,''%s'',vol=%f', typeof(v), v.vol);
endfunction
function [vs] = vol_fstring(v)
    vs = msprintf('type,''%s'',\nvol,%f,\n', typeof(v), v.vol);
endfunction
function [ms] = %mom_string(m)
    ms = msprintf('''%s'' type:  area=%f, length=%f, min_flow=%f, max_flow=%f', typeof(m), m.area, m.length, m.min_flow,  m.max_flow);
endfunction
function [ms] = mom_fstring(m)
    ms = msprintf('type,''%s'',\narea,%f,\nlength,%f,\nmin_flow,%f,\nmax_flow,%f,\n', typeof(m), m.area, m.length, m.min_flow,  m.max_flow);
endfunction
function [fs] = %FP_string(fp)
    fs = msprintf('''%s'' type:  sg=%f, beta=%f, dwdc=%f, tvp=%f', typeof(fp), fp.sg, fp.beta, fp.dwdc, fp.tvp);
endfunction
function [ps] = pipe_string(p)
    ps = msprintf('''%s'' type:  l=%f, a=%f, vol=%f, n=%d, c=%f', typeof(p), p.l, p.a, p.vol, p.n, p.c);
endfunction
function [ps] = pipe_fstring(p)
    ps = msprintf('type,''%s'',\nl,%f,\na,%f,\nvol,%f,\nn,%d,\nc,%f,\n', typeof(p), p.l, p.a, p.vol, p.n, p.c);
endfunction
function str = %pVV_string(p)
    // Display pipe type
    str = pipe_string(p);
endfunction
function str = %pMV_string(p)
    // Display pipe type
    str = pipe_string(p);
endfunction
function str = %pMM_string(p)
    // Display pipe type
    str = pipe_string(p);
endfunction
function str = %pVM_string(p)
    // Display pipe type
    str = pipe_string(p);
endfunction
function str = %pVV_p(p)
    // Display pipe type
    str = pipe_string(p);
    disp(str)
endfunction
function str = %pMV_p(p)
    // Display pipe type
    str = pipe_string(p);
    disp(str)
endfunction
function str = %pMM_p(p)
    // Display pipe type
    str = pipe_string(p);
    disp(str)
endfunction
function str = %pVM_p(p)
    // Display pipe type
    str = pipe_string(p);
    disp(str)
endfunction
function str = %vol_p(v)
    // Display vol type
    str = string(v);
    disp(str)
endfunction
function str = %mom_p(m)
    // Display mom type
    str = string(m);
    disp(str)
endfunction
function str = %FP_p(fp)
    // Display pipe type
    str = string(fp);
    disp(str)
endfunction
function lis = lsx_pipe(p)
    lis = list(p.l, p.a, p.vol, p.n, p.spgr, p.beta, p.c);
endfunction
function str = %pipe_p(p)
    // Display pipe type
    str = string(p);
    disp(str)
endfunction
