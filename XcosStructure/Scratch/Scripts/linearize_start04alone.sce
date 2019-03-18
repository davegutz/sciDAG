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
// Mar 17, 2019    DA Gutz        Created
// 
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
global LINCOS_OVERRIDE figs sys_f cpr scs_m LIN INI Tf GEO
mprintf('In %s\n', sfilename())  

// Generate steady-state lti systems
Tf_sav = Tf; batch_sav = INI.batch;
try
    mprintf('In %s:  generating steadycos...\n', sfilename())
    Tf = 0; INI.batch = %t;
    LIN.open_tv = 1;
    Info = xcos_simulate(scs_m, 4);  LIN.X = cpr.state.x;
    mprintf('completed xcos_simulate in %s\n', sfilename())  
    //[LIN.Xs, LIN.U, LIN.Y, LIN.XP] = steadycos(scs_m, cpr.state.x, [],[],1:$, [], []);
    LIN.sys_f = lincos(scs_m, LIN.X, 0, [1e-9, 0]);
    //LIN.sys_fs = lincos(scs_m, LIN.Xs, 0, [1e-9, 0]);
catch
    mprintf('ERROR xcos_simulate or lincos in %s\n', sfilename())  
    Tf = Tf_sav; INI.batch = batch_sav;
    LIN.open_tv = 0;
end
Tf = Tf_sav; INI.batch = batch_sav;
LIN.open_tv = 0;

mprintf('Before Plot result in %s\n', sfilename())  

// Plot result
try
//    figs($+1) = figure("Figure_name", 'FREQ_RESPs', "Position", [10,110,610,600]);
//    myBodePlot(LIN.sys_fs, 1, 1000);
    figs($+1) = figure("Figure_name", 'FREQ_RESP', "Position", [10,110,610,600]);
    myBodePlot(LIN.sys_f, 1, 1000);
    [LIN.gm, LIN.frg] = g_margin(LIN.sys_f);
    [LIN.pm, LIN.frp] = p_margin(LIN.sys_f);
    //show_margins(sys_f)
    legend(['Open Loop TV' 'gm' msprintf('pm= %f deg @ %f r/s', LIN.pm, LIN.frp)])
catch
    if lasterror(%f) == 'Singularity of log or tan function.' then
        warning('Linear response of ""scs_m"" is undefined...showing small DC response')
        myBodePlot(syslin('c',0,0,0,1e-12), [1,10], 'rad')
        legend('default system')
    else
        disp(lasterror())
    end
end

mprintf('Completed %s\n', sfilename())  
