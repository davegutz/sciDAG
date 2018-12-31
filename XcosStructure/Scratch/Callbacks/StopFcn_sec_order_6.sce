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
// Dec 3, 2018 	DA Gutz		Created
// 
global m c k LINCOS_OVERRIDE
mprintf('In %s\n', sfilename())  

// bode of top level
LINCOS_OVERRIDE = 1;
mprintf('In %s before lincos top level\n', sfilename())
sys_f = lincos(scs_m);
mprintf('In %s after lincos top_level\n', sfilename())
try
    figure()
    myBodePlot(sys_f, 'rad');
   // bode(sys_f, 'rad');
    legend('Closed Loop sec_order_6')
catch
    if lasterror(%f) == 'Singularity of log or tan function.' then
        warning('Linear response of ""scs_m"" is undefined...showing small DC response')
        myBodePlot(syslin('c',0,0,0,1e-12), [1,10], 'rad')
        legend('default system')
    else
        disp(lasterror())
    end
end
LINCOS_OVERRIDE = 0;

// bode of top level using open loop
LINCOS_OVERRIDE = 1;
LINCOS_OPEN_LOOP = 1;
mprintf('In %s before lincos top level\n', sfilename())
sys_f = lincos(scs_m);
mprintf('In %s after lincos top_level\n', sfilename())
try
    figure()
    myBodePlot(sys_f, 'rad');
    [gm, frg] = g_margin(sys_f);
    [pm, frp] = p_margin(sys_f);
    show_margins(sys_f)
    legend(['Open Loop sec_order_6' 'gm' msprintf('pm= %f deg @ %f r/s', pm, frp)])
catch
    if lasterror(%f) == 'Singularity of log or tan function.' then
        warning('Linear response of ""scs_m"" is undefined...showing small DC response')
        myBodePlot(syslin('c',0,0,0,1e-12), [1,10], 'rad')
        legend('default system')
    else
        disp(lasterror())
    end
end
LINCOS_OPEN_LOOP = 0;
LINCOS_OVERRIDE = 0;

mprintf('Completed %s\n', sfilename())  