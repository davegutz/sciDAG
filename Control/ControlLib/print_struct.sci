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
// Nov 4, 2018 	DA Gutz		Created
// 
// print_struct(st, st_str, fd, sep, titling)
// Recursively write out a scilab structure.   Vectoring assumed and titles
// always at top.   Elements may be row vectors.
// Hint:   package all your data in one st and call with
// st_str='' to squeeze it all in one file tab.
// 17-October-2018  DA Gutz     Written
// 
// Inputs:
//  st          Structure to write, must be provided
//  st_str      Structure name to record in the written output ['blank']
//  fd          File device [stdout], must be open on call
//  sep         Field separator ['']
//  titling     In the act of titling
//
// Outputs:
//  fd          file output stream, not closed
//
// Local:
//  type_element      Data type of a field, for printing correct format
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
function print_struct(st, st_str, fd, sep, titling)
    if argn(2)<5 then
        titling = '';
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
    if isempty(titling) then // Only first call
        titling = %t;
        print_struct(st(1), st_str, fd, sep, titling);
        mfprintf(fd, '\n');
        titling = %f;
    end
    for i_case = 1:n_cases  // Only first call will have n_cases > 1
        field_names = fieldnames(st(i_case));
        [n_fields, m] = size(field_names);
        if n_fields==0 then  // Found the bottom of recursion
            element = st(i_case, :);
            if titling then
                mfprintf(fd, '%s%s', st_str, sep);
            else
                type_element = type(element);
                [n_instance, m_instance] = size(element);
                mult_sep = ' ';
                for instance=1:m_instance
                    if m_instance>1 & instance==1 then
                        mfprintf(fd, '[');
                    end
                    if type_element==1 then
                        if isnan(element(instance)) then
                            mfprintf(fd, '%snan', '%');
                         elseif isinf(element(instance)) then
                             if element(instance)>0 then
                                 mfprintf(fd, '%sinf', '%');
                             else
                                 mfprintf(fd, '-%sinf', '%');
                             end
                         else
                             mfprintf(fd, '%#3.17g', element(instance));
                         end
                    elseif type_element==4 then
                        if element(instance) then
                            mfprintf(fd, '%st', '%');
                        else
                            mfprintf(fd, '%sf', '%');
                        end
                    elseif type_element==8 then
                        mfprintf(fd, '%d', element(instance));
                    elseif type_element==10 then
                        mfprintf(fd, '''%s''', element(instance));
                    else
                        mfprintf(0, 'type %d for %s unknown\n', type_element, st_str);
                    end
                    if m_instance>1 & instance==m_instance then
                        mfprintf(fd, ']');
                    elseif m_instance>1
                        mfprintf(fd, '%s', mult_sep);
                    end
                end
                mfprintf(fd, '%s', sep);
            end  // if titling
        else // Recursion in progress
            if titling, ting = 1; else ting = 0; end
            if n_cases<>1
                print_struct(st(i_case), st_str, fd, sep, titling);
                mfprintf(fd, '\n');
            else
                for i_field=1:n_fields
                    if ~isempty(st_str) then
                        new_name = st_str + '.' + field_names(i_field);
                    else
                        new_name = field_names(i_field);
                    end
                    exec_name = 'st.' + field_names(i_field);
                    new_val = evstr(exec_name);
                    print_struct(evstr(exec_name), new_name, fd, sep, titling);
                end
            end
        end  // if n_fields==0
    end  // for i_case

endfunction
