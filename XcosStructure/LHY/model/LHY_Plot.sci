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
function LHY_Plot(t, LHY)
    // Nice plot data for the LHY model
    // Fetching solution
    L = LHY(1,:);
    H = LHY(2,:);
    Y = LHY(3,:);
    // Evaluate initiation
    I = LHY_Initiation(L,H,Y, param);
    // maximum values for nice plot
    [Lmax, Lindmax] = max(L); tL = t(Lindmax);
    [Hmax, Hindmax] = max(H); tH = t(Hindmax);
    [Ymax, Yindmax] = max(Y); tY = t(Yindmax);
    [Imax, Iindmax] = max(I); tI = t(Iindmax);
    // Text of the maximum point
    Ltext = msprintf(' ( %4.1f , %7.0f)',tL,Lmax);
    Htext = msprintf(' ( %4.1f , %7.0f)',tH,Hmax);
    Ytext = msprintf(' ( %4.1f , %7.0f)',tY,Ymax);
    Itext = msprintf(' ( %4.1f , %7.0f)',tI,Imax);
    // Plotting of model data
    plot(t,[LHY;I]);
    legend(['Light Users';'Heavy users';'Memory';'Initiation']);
    // Vertical line
    set(gca(),"auto_clear","off");
    xpolys([tL,tH,tY,tI;tL,tH,tY,tI],[0,0,0,0;Lmax,Hmax,Ymax,Imax]);
    // Text of maximum point
    xstring(tL,Lmax,Ltext);
    xstring(tH,Hmax,Htext);
    xstring(tY,Ymax,Ytext);
    xstring(tI,Imax,Itext);
    xlabel('Year');
    set(gca(),"auto_clear","on");
endfunction
