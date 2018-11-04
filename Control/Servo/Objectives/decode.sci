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
// Oct 18, 2018 	DA Gutz		Created
// 
function [G, C, W, P] = decode(Mnames, Mvals, G, C, W, P)

    global verbose
    [n_cases, n_elements] = size(Mvals);
    // Check for validity
    for i_element = 1:n_elements
        candidate = Mnames(i_element);
        if members(candidate, G)==0 ..
            & members(candidate, C)==0..
            & members(candidate, W)==0..
            & members(candidate, P)==0 then
            mprintf('-->%s \n', candidate);
            error('is not part of declared structure.   Add it.')
        end
    end
        
    // Process
    for i_case = 1:n_cases
        for i_element = 1:n_elements
            execstr(Mnames(i_element)+'='+string(Mvals(i_case, i_element)))
        end
    end

endfunction
