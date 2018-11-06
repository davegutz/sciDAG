// function [V, C, Mnames, Mvals] = load_xls_data(in_file, %type, comment_delim)
// Read an xls data file with parameters in columns, saving comments too.
// All comments get collected into one blob.
// 17-October-2018  DA Gutz     Written
// 
// Inputs:
//  in_file         xls file with rectangular matrix in rows, columns
//  %type           Cases in 'row' or 'col' 
//  comment_delim   Optional deliminiter for comments to be preserved in out_file header
//
// Outputs:
//   V              Vector of structures containing variables 
//   C              Column vector of string comments
//   Mnames         Row string vector of parameter names
//   Mvals          Matrix of strings of data
//
// Local:
//  function V = decode_xls_data(Mnames, Mvals, %type)
//      Turn strings into variables
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
function V = decode_xls_data(Mnames, Mvals, %type)

    global verbose
    if %type=='col' then
        [n_elements, n_cases] = size(Mvals); 
    elseif %type=='row' then
        [n_cases, n_elements] = size(Mvals);  //
    else
        mprintf('%s-->', %type)
        error('unknown type')
    end
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
        if %type=='col' then
            for i_element = 1:n_elements
                execstr(Mnames(i_element)+'='+string(Mvals(i_element, i_case)))
            end
        else
            for i_element = 1:n_elements
                execstr(Mnames(i_element)+'='+string(Mvals(i_case, i_element)))
            end
        end
        for i_name = 1:n_names
            top_struct = names(i_name);
            execstr('v.'+top_struct+'='+top_struct+';');
        end
        V($+1) = v;
    end
    
endfunction

function [V, C, Mnames, Mvals] = load_xls_data(in_file, %type, comment_delim)
    
    if argn(2)<3 then
        comment_delim = '/\/\//';
    end
    
    // Load some sample data, assuming data columnar
    // Read data
    sheets = readxls(in_file);

    // Strip comments and find data
    M_in = sheets(1);
    [n_row_in, n_col_in] = size(M_in);
    C = [];
    i_vals = []; n_row = 0;

    for i_row_in = 1:n_row_in
        empty_elements = find(M_in(i_row_in,:)=='');
        if isempty(empty_elements) then
            n_row = n_row + 1;
            if %type=='row' & n_row==1 then
                Mnames = M_in(i_row_in, :);
            else
                i_vals = [i_vals; i_row_in];
            end
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
    if %type=='col' then
        Mnames = M_in(i_vals, 1)';
        Mvals = M_in(i_vals, 2:$);
    elseif %type=='row' then
        Mvals = M_in(i_vals, :);
    else
        mprintf('%s-->', %type)
        error('unknown type')
    end
    V = decode_xls_data(Mnames, Mvals, %type)
    C = C(:, 1);

endfunction
