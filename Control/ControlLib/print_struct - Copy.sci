// print_struct(st, st_str, fd, sep, vectoring, titling)
// Recursively write out a scilab structure.
// 17-October-2018  DA Gutz     Written
// 
// Inputs:
//  st          Structure to write, must be provided
//  st_str      Structure name to record in the written output ['blank']
//  fd          File device [stdout], must be open on call
//  sep         Field separator ['']
//  vectoring   A multi-dimensional structure array is being de-coded
//  titling     In the act of titling
//
// Outputs:
//  fd          file output stream, not closed
//
// Local:
//  type_instance      Data type of a field, for printing correct format
//
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
// Sep 24, 2018 	DA Gutz		Created
// 
function print_struct_copy(st, st_str, fd, sep, vectoring, titling)
    verbosep = %t;
    if argn(2)<6 then
        titling = %f;
    end
    if argn(2)<5 then
        vectoring = %f;
    end
    if argn(2)<4 then
        sep = '';
    end
    if argn(2)<3 then
        fd = 6;   // stdout
    end
    if argn(2)<2 then
        st_str = '<blank>';
    end
    [n_cases, mc] = size(st);
    vectoring = n_cases > 1;
    if vectoring & ~titling then // Only first call will have n_cases > 1
        titling = %t;
        print_struct(st(1), st_str, fd, sep, vectoring, titling);
        titling = %f;
    end
    for i_case = 1:n_cases
        field_names = fieldnames(st(i_case));
        [n_fields, m] = size(field_names);
        if n_fields==0 then  // Found the bottom of recursion
            type_instance = type(st(i_case));
            [n_instance, m_instance] = size(st(i_case));
            if i_case==1
                if titling
                    mfprintf(fd, '%s%s', st_str, sep);
                elseif ~vectoring
                    mfprintf(fd, '%s = ', st_str);
                end
            end
            if ~titling then
                for instance=1:m_instance
                    if m_instance>1 & instance==1 then
                        mfprintf(fd, ' [');
                    end
                    if type_instance==1 then
                        mfprintf(fd, '%f', st(i_case, instance));
                    elseif type_instance==4 then
                        if st(i_case, instance) then
                            mfprintf(fd, 'T');
                        else
                            mfprintf(fd, 'field_names');
                        end
                    elseif type_instance==10 then
                        mfprintf(fd, '''%s''', st(i_case,instance));
                    else
                        mfprintf(fd, 'type %d for %s unknown\n', type_instance, st_str);
                    end
                    if m_instance>1 & instance==m_instance then
                        mfprintf(fd, ']');
                    elseif m_instance>1
                        mfprintf(fd, ', ');
                    end
                end
                if i_case==n_cases
                    mfprintf(fd, '%s\n', sep);
                end
            end
        else // Recursion in progress
            if vectoring, ving=1; else ving = 0; end
            if titling, ting=1; else ting = 0; end
            if n_cases<>1
                if verbosep then, mfprintf(fd, 'calling print_struct(st(i_case), st_str, fd, sep, %d, %d)\n', ving, ting); end
                print_struct(st(i_case), st_str, fd, sep, vectoring, titling);
            else
                for i_field=1:n_fields
                    new_name = st_str + '.' + field_names(i_field);
                    exec_name = 'st.' + field_names(i_field);
                    if verbosep then
                        mfprintf(fd, 'calling print_struct(''%s'', ''%s'', %d, ''%s'', %d, %d)\n',..
                                 exec_name, new_name, fd, sep, ving, ting);
                    end
                    print_struct(evstr(exec_name), new_name, fd, sep, vectoring, titling);
                end
            end
        end
    end

endfunction
