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

clear
funcprot(0)
getd('../ControlLib')
mclose('all')
xdel(winsid())

// Read text from file and assign values.  Assumed row format
testInFile = 'testIn.csv';
commentDelim = '/\/\//';
[M, comments] = csvRead(testInFile, [], [], 'string', [], commentDelim);
[n_elements, ncol] = size(M);
Mnames = M(:, 1);
// Assume data lines have trailing comma at end of line e.g. 'input=2,2,3,'
// Trailing comma requires '-1' in next line.
Mvals =  M(:, 2:ncol-1);
n_cases = size(Mvals, 'c');
// Assign values
for i_case = 1:n_cases
    for i_element = 1:n_elements
        execstr(Mnames(i_element)+'='+Mvals(i_element, i_case))
    end
end

// Output file
// First print out in row format (cases in rows)
tempOutFile = 'tempOut.csv';
[fdt, err] = mopen(tempOutFile, 'wt');
if err<>0 then
    mprintf('testIn.sce: error %d opening %s...', err, tempOutFile);
end
for i_case = 1:n_cases
    for i_element = 1:n_elements
        execstr("D("+string(i_case)+")."+Mnames(i_element)+'='+Mvals(i_element, i_case))
    end
end
print_struct(D, '', fdt,',');
mclose(fdt);

// Convert to column format (cases in columns)
// Read text from file and assign values.  Assumed colum format
tempInFile = 'tempOut.csv';
M_t = csvRead(tempInFile, [], [], 'string', [], commentDelim);
[n_rows_t, n_elements_t] = size(M_t);
testOutFile = 'testOut.csv';
[fdo, err] = mopen(testOutFile, 'wt');
[n_comments, m_comments] = size(comments);
for i_comment = 1:n_comments
    mfprintf(fdo, '%s\n', comments(i_comment))
end
for i_t = 1:n_elements_t
    if ~isempty(M_t(1, i_t)) then // Strip blanks
        for j_t = 1:n_rows_t
            mfprintf(fdo, '%s,', M_t(j_t, i_t));
        end
    end
    mfprintf(fdo, '\n');
end
mclose(fdo);
