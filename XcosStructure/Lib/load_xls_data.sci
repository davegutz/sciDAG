// function [V, C, Mnames, Mvals] = load_xls_data(in_file, %type, comment_delim)
// Read an xls data file with parameters in rows or columns (select using %type,
// saving comments too.
// All comments get collected into one blob.
// 29-January-2019  DA Gutz     Written from load_xls_data
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
//  function V_decode_xls_data = decode_xls_data(Mnames, Mvals, %type)
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
// Jan 29, 2019     DA Gutz     Created
//******************************************************************************
function V_decode_xls_data = decode_xls_data(Mnames, Mvals, %type)
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
    if %type=='col' then
        for i_case = 1:n_cases
            for i_element = 1:n_elements
                execstr(Mnames(i_element)+'='+string(Mvals(i_element, i_case)))
            end
            for i_name = 1:n_names
                top_struct = names(i_name);
                execstr('v_decode_xls_data.'+top_struct+'='+top_struct+';');
            end
            V_decode_xls_data($+1) = v_decode_xls_data;
        end
    else
        for i_name = 1:n_names
            execstr(names(i_name)+'=Mvals(:, i_element)')
            top_struct = names(i_name);
            execstr('v_decode_xls_data.'+top_struct+'='+top_struct+';');
        end
        V_decode_xls_data($+1) = v_decode_xls_data;
    end
endfunction

function [V, C, Mnames, Mvals] = load_xls_data(in_file, %type, sheet, comment_delim)
    
    if argn(2)<5 then
        DEFAULT = struct();
    end
    if argn(2)<4 then
        comment_delim = '/\/\//';
    end
    if argn(2)<3 then
        sheet = '';
    end
    
    // Load some sample data, assuming data columnar
    // Read data
    sheets = readxls(in_file);
    [fd, SST, Sheetnames, Sheetpos] = xls_open(in_file);
    mclose(fd);
    if isempty(sheet) then
        sheet_index = 1;
    else
        sheet_index = find(Sheetnames==sheet);
    end
    M_in = sheets(sheet_index);

    // Strip comments and find data
    [n_row_in, n_col_in] = size(M_in);
    C = [];
    i_vals = []; n_row = 0;

    for i_row_in = 1:n_row_in
        if type(M_in(i_row_in,1)) == 10 then
            [n_tok, tok, ctok] = tokenize(M_in(i_row_in,1), ' ');
            is_comment = strcmp(tok(1), '//') == 0;
        else
            is_comment = %f;
        end
        if ~is_comment then
            n_row = n_row + 1;
            if %type=='row' & n_row==1 then
                Mnames = M_in(i_row_in, :);
            else
                i_vals = [i_vals; i_row_in];
            end
        else
            empty_elements = find(M_in(i_row_in,:)=='');
            if length(empty_elements)==n_col_in-1 then
                comment = M_in(i_row_in, 1);
                if strspn(comment, '//')==2 then
                    comment_csv = strsubst(comment, '""', '""""');
                    comment_csv = msprintf('""%s""', comment_csv);
                    C = [C; comment_csv];
                else
                    mprintf('-->%s\n', comment);
                    error('Incorrect format input .xls file.  Comments beginning with ''//''')
                end
            else
                mprintf('-->%s\n', M_in(i_row_in));
                error('Incorrect format input .xls file.  Comments= one entire cell, in first cell, begins with ''// ''.')
            end
        end
    end
    if %type=='col' then
        Mnames = M_in(i_vals, 1)';
        MvalsX = M_in(i_vals, 2:$);
    elseif %type=='row' then
        MvalsX = M_in(i_vals, :);
    else
        mprintf('%s-->', %type)
        error('unknown type')
    end

    // Cull empties
    [n_row_x, n_col_x] = size(MvalsX);
    j_vals = [];
    for j_col_x = 1:n_col_x
        if ~isempty(MvalsX(:,j_col_x)) then
            j_vals = [j_vals; j_col_x];
        end
    end
    Mvals = MvalsX(:, j_vals);
    V = decode_xls_data(Mnames, Mvals, %type);
    C = C(:, 1);

endfunction
