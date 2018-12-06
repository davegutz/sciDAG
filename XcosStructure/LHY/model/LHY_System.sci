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
function LHYdot=LHY_System(t, LHY, param)
    // The LHY system
    // Fetching LHY system parameters
    a = param.a;
    b = param.b;
    g = param.g;
    delta = param.delta;
    // Fetching solution
    L = LHY(1,:);
    H = LHY(2,:);
    Y = LHY(3,:);
    // Evaluation of initiation
    I = LHY_Initiation(L, H, Y, param);
    // Compute Ldot
    Ldot = I - (a+b)*L;
    Hdot = b*L - g*H;
    Ydot = H - delta*Y;
    LHYdot = [Ldot; Hdot; Ydot];
endfunction 
