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
// Jsn 16, 2019      DA Gutz     Created
// 
global INI start_line A B C D lti_start_line FP ori root Press

mprintf('In %s\n', sfilename())

if scs_m.props.title ~= root then
    mprintf("Re-init %s first\n", root);
    error('Re-init correct file first')
end

LINCOS_OVERRIDE = 0;

start_line.lti = lti_man_n_vv(start_line.l, start_line.a, start_line.vol, start_line.n, start_line.spgr, start_line.beta, start_line.c);
[start_line.A, start_line.B, start_line.C, start_line.D] = unpack_ss(start_line.lti);

pi=Press/2;
wfi = or_aptow(ori.a, pi, 0, ori.cd, FP.sg);
INI.start_line = ini_man_n_vv(start_line, pi, wfi);

mprintf('Completed %s\n', sfilename())  
