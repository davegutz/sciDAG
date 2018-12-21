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
global plant A B C D
mprintf('In StopFcn_scratch\n')  
for i=1:length(scs_m.objs)
    if typeof(scs_m.objs(i))=="Block" & (scs_m.objs(i).gui=="DSUPER" | scs_m.objs(i).gui=="SUPER_f") then
        scs_m_lin = scs_m.objs(i).model.rpar;
        break;
    end
end
mprintf('In StopFcn_scratch before lincos\n')  
sys = lincos(scs_m_lin);
mprintf('In StopFcn_scratch after lincos\n')  
figure()
bode(sys, 'rad');
//disp(B)
//disp(plant.b)
mprintf('Completed StopFcn_scratch.sce\n')  
