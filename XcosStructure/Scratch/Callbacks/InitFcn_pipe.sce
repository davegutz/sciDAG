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
global pipe_vv pipe_mv pipe_mm pipe_vm FP ori root Press INI

mprintf('In %s\n', sfilename())

if scs_m.props.title ~= root then
    mprintf("Re-init %s first\n", root);
    error('Re-init correct file first')
end

LINCOS_OVERRIDE = 0;
pipe_vv = lti_man_n_vv(pipe_vv, FP.sg, FP.beta);
pipe_mv = lti_man_n_mv(pipe_mv, FP.sg, FP.beta);
pipe_mm = lti_man_n_mm(pipe_mm, FP.sg, FP.beta);
pipe_vm = lti_man_n_vm(pipe_vm, FP.sg, FP.beta);

pi=Press/2;
wfi = or_aptow(ori.a, pi, 0, ori.cd, FP.sg);
INI.pipe_vv = ini_man_n_vv(pipe_vv, pi, wfi);
INI.pipe_mv = ini_man_n_mv(pipe_mv, pi, wfi);
INI.pipe_mm = ini_man_n_mm(pipe_mm, pi, wfi);
INI.pipe_vm = ini_man_n_vm(pipe_vm, pi, wfi);

mprintf('Completed %s\n', sfilename())  
