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
mprintf('In %s before lincos top level\n', sfilename())
sys_f = lincos(scs_m);
mprintf('In %s after lincos top_level\n', sfilename())
try
    figure()
    bode(sys_f, 'rad');
catch
    if lasterror() == 'Singularity of log or tan function.' then
        warning('Linear response of ""scs_m"" is undefined...showing small DC response')
        bode(syslin('c',0,0,0,1e-12), [1,10], 'rad')
    end
end

// bode of SEC_ORDER
LINCOS_OVERRIDE = 1;
for i=1:length(scs_m.objs)
    if (typeof(scs_m.objs(i))=="Block"..
         & (scs_m.objs(i).gui=="DSUPER" | scs_m.objs(i).gui=="SUPER_f")..
          & scs_m.objs(i).model.label=="SEC_ORDER_SUPER") then
          scs_m_lin_f = scs_m.objs(i).model.rpar;
        break;
    end
end
mprintf('In %s before lincos f\n', sfilename())
sys_f = lincos(scs_m_lin_f);
mprintf('In %s after lincos f\n', sfilename())
try
    figure()
    bode(sys_f, 'rad');
catch
    if lasterror() == 'Singularity of log or tan function.' then
        warning('Linear response of ""SEC_ORDER_SUPER"" is undefined...showing small DC response')
        bode(syslin('c',0,0,0,1e-12), [1,10], 'rad')
    end
end
LINCOS_OVERRIDE = 0;

mprintf('Completed %s\n', sfilename())  
