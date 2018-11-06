// function write_csv_row_data(out_file, Mnames, Mvals, C)
// Write a csv data file with parameters in rows, saving comments too.
// All comments get collected into one blob.
// 17-October-2018  DA Gutz     Written
// 
// Inputs:
//   out_file        csv file name
//   Mnames         Row vector of parameter names
//   Mvals          Matrix of data
//   C              Column vector of comments
//
// Outputs:
//
// Local:
//  
//// Copyright (C) 2018 - Dave Gutz
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
// Oct 31, 2018 	DA Gutz		Created
//******************************************************************************
function write_csv_row_data(out_file, Mnames, Mvals, comments)

    [fdt, err] = mopen(out_file, 'wt');
    if err<>0 then
        msg = msprintf('could not open %s;  is it open in excel?', out_file);
        error(msg)
    end
    [n_cases, n_elements] = size(Mvals);
    for i_case = 1:n_cases
        for i_element = 1:n_elements
            execstr("D("+string(i_case)+")."+Mnames(i_element)+'='+string(Mvals(i_case, i_element)))
        end
    end
    [n_comments, m_comments] = size(comments);
    for i_comment = 1:n_comments
        mfprintf(fdt, '%s\n', comments(i_comment))
    end
    print_struct(D, '', fdt, ',');
    mclose(fdt);

endfunction
