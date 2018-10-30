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
// Sep 26, 2018 	DA Gutz		Created
// 
clear
funcprot(0);
getd('../ControlLib')
mclose('all')

// Load some sample data, assuming data columnar
// Read data
sheets = readxls('tests/nonreg_tests/order_all_fields_tst.xls');
// Strip comments and find data
M_in = sheets(1);
[n_row_in, n_elements_in] = size(M_in);
C = [];
i_vals = []; n_row = 0;
for i_row_in = 1:n_row_in
    empty_cells = find(M_in(i_row_in,:)=='');
    if isempty(empty_cells) then
        n_row = n_row + 1;
        if n_row==1 then
            Mnames = M_in(i_row_in, :);
        else
            i_vals = [i_vals; i_row_in];
        end
    else
        if length(empty_cells)==n_elements_in-1 then
            C = [C; M_in(i_row_in, :)];
        else
            error('incorrect format input .xls file.  Comments one field')
        end
    end
end
Mvals = M_in(i_vals, :);
n_vals = length(i_vals);
comments = C(:, 1);
n_cases = size(Mvals, 'r');
// Assign values
//for i_case = 1:n_cases
//    for i_element = 1:n_elements
//        execstr(Mnames(i_element)+'='+string(Mvals(i_case, i_element)))
//    end
//end
//
// Write to output file in row format (cases in rows)
tempOutFile = 'tempOut.csv';
[fdt, err] = mopen(tempOutFile, 'wt');
if err<>0 then
    mprintf('testIn.sce: error %d opening %s...', err, tempOutFile);
end
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

// Finally rotate the file
rotate_file('tempOut.csv', 'testOut.csv', commentDelim);
mgetl('testOut.csv')
