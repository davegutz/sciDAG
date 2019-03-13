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
// Jsn 1, 2019      DA Gutz     Created
// 
global LINCOS_OVERRIDE figs
global pact_fext
mprintf('In %s\n', sfilename())  
try close(figs); end
LINCOS_OVERRIDE = 0;
INI.vsv.x = start_x.values(1,:);
INI.reg.x = tri_x.values(1,:);
INI.mv.x = mv_x.values(1,:);
INI.hs.x = hs_x.values(1,:);
INI.pact.x = pact_x.values(1,:);
FP.sg = fp_sg.values(1,:);
FP.beta = fp_beta.values(1,:);

pact_fext = pact_fextr;
pact_fext.values(:,1) = pact_fextr.values(:,1)+GEO.pact.c_*pact_v.values(:,1);

mprintf('Completed %s\n', sfilename())  
