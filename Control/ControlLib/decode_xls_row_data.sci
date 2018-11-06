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
function V = decode_xls_row_data(Mnames, Mvals)

    global verbose
    [n_cases, n_elements] = size(Mvals);  //
    // Find names
    for i_element = 1:n_elements
        candidate = Mnames(i_element);
        els = strsplit(candidate, '.');
        names_raw($+1) = els(1);
    end
    names = unique(gsort(names_raw));
    [n_names, m_names] = size(names);

    // Process
    for i_case = 1:n_cases
        for i_element = 1:n_elements
            execstr(Mnames(i_element)+'='+string(Mvals(i_case, i_element))) //
        end
        for i_name = 1:n_names
            top_struct = names(i_name);
            execstr('v.'+top_struct+'='+top_struct+';');
        end
        V($+1) = v;
    end
    
endfunction
