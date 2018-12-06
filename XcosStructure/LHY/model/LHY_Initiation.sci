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
// Dec 6, 2018 	DA Gutz		Created
// 
function I=LHY_Initiation(L, H, Y, param)
    // It returns the initiation for the LHY model.
    //
    // Input:
    // L = number of light users,
    // H = number of heavy users,
    // Y = decaying heavy user years,
    // param is a structure with the model parameters:
    // param.tau = number of innovators per year,
    // param.s = annual rate at which light users
    // attract non-users,
    // param.q = deterrent effect of heavy users constant,
    // param.smax = maximum feedback rate.
    //
    // Output:
    // I = initiation.
    //
    // Description:
    // The initiation function.
    // Fetching
    tau = param.tau;
    s = param.s;
    q = param.q;
    smax = param.smax;
    // Compute s effective
    seff = s*exp(-q*Y./L);
    seff = max(smax,seff);
    // Compute initiation (vectorized formula)
    I = tau + seff.*L;
endfunction 
    
