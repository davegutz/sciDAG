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

global LINCOS_OVERRIDE
global loaded_scratch
global GEO
global start02_x start02_v
global start02_ph start02_prs start02_pxr start02_ps
global start02_wfs start02_wfh start02_wfvr start02_wfvx
mprintf('In %s\n', sfilename())  

GEO.valve_scratch.m = 5000;

// Load c-model reference data
stacksize('max');
[M, comments] = csvRead('./Data/start02.ven.csv',',',[],"double",[],[],[],[1]);
start02_x = struct("time", M(:,1), "values", M(:,2));
start02_v = struct("time", M(:,1), "values", M(:,3));
start02_ph = struct("time", M(:,1), "values", M(:,4));
start02_prs = struct("time", M(:,1), "values", M(:,5));
start02_pxr = struct("time", M(:,1), "values", M(:,6));
start02_ps = struct("time", M(:,1), "values", M(:,7));
start02_wfs = struct("time", M(:,1), "values", M(:,8));
start02_wfh = struct("time", M(:,1), "values", M(:,9));
start02_wfvr = struct("time", M(:,1), "values", M(:,10));
start02_wfvx = struct("time", M(:,1), "values", M(:,11));
clear M comments

mprintf('Completed %s\n', sfilename())  
