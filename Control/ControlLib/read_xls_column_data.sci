// function [Mnames, Mvals, C] = read_xls_column_data(in_file, [comment_delim='/\/\//'])
// Read an xls data file with parameters in columns, saving comments too.
// All comments get collected into one blob.
// 17-October-2018  DA Gutz     Written
// 
// Inputs:
//  in_file         xls file with rectangular matrix in rows, columns
//  comment_delim   optional deliminiter for comments to be preserved in out_file header
//
// Outputs:
//   Mnames         Row vector of parameter names
//   Mvals          Matrix of data
//   C              Column vector of comments
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
function [Mnames, Mvals, C] = read_xls_column_data(in_file, comment_delim)
    
    if argn(2)<2 then
        comment_delim = '/\/\//';
    end
    
    // Load some sample data, assuming data columnar
    // Read data
    sheets = readxls(in_file);

    // Strip comments and find data
    // TODO:  combine this function with read_xls_row_data and add "row" and "column" argument list options
    M_in = sheets(1);
    [n_row_in, n_col_in] = size(M_in);
    C = [];
    i_vals = []; n_row = 0;
    for i_row_in = 1:n_row_in
        empty_elements = find(M_in(i_row_in,:)=='');
        if isempty(empty_elements) then
            n_row = n_row + 1;
            i_vals = [i_vals; i_row_in];
        else
            if length(empty_elements)==n_col_in-1 then
                comment = M_in(i_row_in, 1);
                if strspn(comment, '//')==2 then
                    C = [C; comment];
                else
                    mprintf('-->%s\n', comment);
                    error('Incorrect format input .xls file.  Comments beginning with ''//''')
                end
            else
                mprintf('-->%s\n', M_in(i_row_in));
                error('Incorrect format input .xls file.  Comments= one entire cell, one cell on line.')
            end
        end
    end
    Mnames = M_in(i_vals, 1)';
//    Mvals = M_in(i_vals, 2:n_col_in)';
    Mvals = [];
    for j = 2:n_col_in
        new_row = [];
        for i = 1:length(i_vals)
            new_row = [new_row M_in(i_vals(i), j)];
        end
        Mvals = [Mvals; new_row];
    end
    C = C(:, 1);

endfunction
