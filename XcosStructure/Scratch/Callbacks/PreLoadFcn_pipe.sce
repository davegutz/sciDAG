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
// Jan 1, 2019  DA Gutz     Created
// 

global loaded_scratch
global A B C D start_line lt8_start_line
mprintf('In %s\n', sfilename())
start_line = tlist(["pipe", "l", "a", "vol", "n", "spgr", "beta", "c"],18, 0.3^2*%pi/4, 18*0.3^2*%pi/4, 3, 0.8, 135000, 0);
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
//lti_start_line = lti_man_n_vv(l,a,vol,n,spgr,%beta,c)
lti_start_line = lti_man_n_mv(start_line.l, start_line.a, start_line.vol, start_line.n, start_line.spgr, start_line.beta, start_line.c);
[A, B, C, D] = unpack_ss(lti_start_line);
mprintf('Completed %s\n', sfilename())  
