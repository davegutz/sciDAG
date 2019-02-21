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
// Feb 21, 2019    DA Gutz        Created
// 
function ice = iterate(ice, verbose, succCount, enNoSoln)
    // function ice = iterate(ice, verbose)
    // Generic iteration calculation, method of successive approximations for
    // succCount then Newton-Rapheson as needed - works with iterateInit.
    // Inputs: ice.e
    // Outputs: ice.x
    ice.de   = ice.e - ice.ep;
    ice.des  = sign(ice.de)*max(abs(ice.de), 1e-16);
    ice.dx   = ice.x - ice.xp;
    if verbose
        fprintf('%s(%ld): %12.8f/%12.8f/%12.8f ', ice.str, ice.count, ice.xmin, ice.x, ice.xmax);
        fprintf('%12.8f      /%12.8f/%12.8f ', ice.e, ice.des, ice.dx);  fprintf('\n');
    end

    // Check min max sign change
    if ice.count == 2
        ice.noSoln = 0;  // initialize
        if ice.e*ice.ep >= 0  & enNoSoln  // No solution possible
            ice.noSoln = 1;
            if abs(ice.ep) < abs(ice.e)
                ice.x   = ice.xp;
            end
            ice.ep  = ice.e;
            ice.limited = 0;
            if verbose
                fprintf('%s:  No solution.  Leaving x at most likely limit value and recalculating...\n', ice.str);
            end
            return
        else
            ice.noSoln = 0;
        end
    end
    if ice.count==3 & ice.noSoln  // Stop after recalc and noSoln
        ice.e = 0;
        return
    end
    ice.xp  = ice.x;
    ice.ep  = ice.e;
    if ice.count == 1
        ice.x   = ice.xmax;  // Do min and max first
    else
        if ice.count > succCount
            ice.x = max(min(ice.x - ice.e/ice.des*ice.dx, ice.xmax),ice.xmin);
            if ice.e > 0
                ice.xmax    = ice.xp;
            else
                ice.xmin    = ice.xp;
            end
        else
            if ice.e > 0
                ice.xmax    = ice.xp;
                ice.x       = (ice.xmin + ice.x)/2;
            else
                ice.xmin    = ice.xp;
                ice.x       = (ice.xmax + ice.x)/2;
            end
        end
        if ice.x==ice.xmax | ice.x==ice.xmin
            ice.limited = 0;
        else
            ice.limited = 1;
        end
    end 
endfunction
