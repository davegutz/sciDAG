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
// Aug 30, 2018 	DA Gutz		Created
// 
function [sys_ol, sys_cl] = allServo_lti(dT, G, C)
    s = %s;
    ff1 = syslin('c', (C.tld1*s+1)/(C.tlg1*s+1));
    ff2 = syslin('c', (C.tld2*s+1)/(C.tlg2*s+1));
    fb = syslin('c', (C.tldh*s+1)/(C.tlgh*s+1));
    pade1 = pade(dT/2, 2);
    cg = ff1*ff2*C.gain*pade1;
    ch = fb*pade1;
    plant = syslin('c', 1/(G.tehsv1*s+1))*syslin('c', ..
                    1/(G.tehsv2*s+1))*syslin('c', G.gain/(s));
    sys_ol = cg*plant*ch;
    sys_cl = cg*plant/(1 + cg*plant*ch);
endfunction
