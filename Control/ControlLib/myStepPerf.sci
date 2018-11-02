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
// Sep 22, 2018 	DA Gutz		Created
// 
function [time_rise, time_peak, magnitude_peak, time_us, magnitude_us, time_settle] = myStepPerf(y, t, frac_rise, frac_settle, dT)
    // Unit step response performance
    // Assume regular update interval of unit response y
    // Assume final value y = 1
    global verbose

    // Rise time
    r = 1;
    n = length(t);
    while y(r)<frac_rise & r<n
        r = r+1;
    end
    if verbose>3 then
        mprintf('myStepPerf: r=%ld,', r);
    end
    r_rise = min(r -1 + (frac_rise-y(r-1))/(y(r)-y(r-1)), n);
    time_rise = (r_rise-1)*dT;
    if verbose>3 then
        mprintf('r_rise=%ld, time_rise=%6.3f\n', r_rise, time_rise);
    end

    // Settling time
    y_s_max = 1+frac_settle;
    y_s_min = 1-frac_settle;
    r = n;
    while y(r)>y_s_min & y(r)<y_s_max & r>0
        r = r-1;
    end
    if verbose>3 then
        mprintf('myStepPerf:  r=%ld,', r);
    end
    if r<n then
        if y(r+1)>y_s_min then
            y_settle = y_s_min;
        else    
            y_settle = y_s_max;
        end
    else
        y_settle = y(r);
        r = r - 1;
    end
    r_settle = min(r + (y_settle-y(r))/(y(r+1)-y(r)), n);
    time_settle = (r_settle-1)*dT;
    if verbose>3 then
        mprintf('r_settle=%ld, time_settle=%6.3f\n', r_settle, time_settle);
    end

    // Peak overshoot = maximum, if > 0
    [y_p, r_p] = max(y);
    if verbose>3 then
        mprintf('myStepPerf:  r_p=%ld,', r_p);
    end
    // Forgiveness if settled
    if r_p==n & abs(y_p-1)<frac_settle then
        y_p = 1;
    end
    if verbose>3 then
        mprintf('y_p=%e,n=%ld\n', y_p, n);
    end
    time_peak = (r_p-1)*dT;
    magnitude_peak = max(y_p-1, 0);
    
    // Undershoot = minimum, if < 0, after first direction change after rising
    ydiff = [0, diff(y)];
    r = ceil(r_rise);
    while ydiff(r)>0 & r<n
        r = r + 1
    end
    [y_u, r_u] = min(y(r:n));
    r_under = r_u + r;
    time_us = (r_under-1)*dT;
    magnitude_us = min(y_u-1, 0);
    if verbose>3 then
        mprintf('r_under=%ld,y_u=%e, r_rise=%ld\n', r_under, y_u, ceil(r_rise));
    end

endfunction
