// sorted_struct = order_all_fields(struct_to_sort)
// Recursively sort the fields of a structure.  Will not do 
// arrays of structures.
// 17-October-2018  DA Gutz     Written
// 
// Inputs:
//  struct_to_sort   Structure to sort
//
// Outputs:
//  sorted_struct    Sorted structure
//
// Local:
//  fields     Fields of struct, empty if at bottom
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
function sorted_struct = order_all_fields(struct_to_sort)

    [n_cases, mc] = size(struct_to_sort);
    if n_cases>1 then
        error('**** Just plain struct, not array*****');
    end

    // 
    fields = fieldnames(struct_to_sort);
    if isempty(fields) then  // Found the bottom of recursion
        sorted_struct = struct_to_sort;
    else // Recursion in progress
        [n, m] = size(fields);
        sorted_fields = gsort(fields, 'g', 'i');
        for i=1:n
            field = sorted_fields(i);
            execstr('sorted_struct.' + field +..
             '= order_all_fields(struct_to_sort.' + field + ');');
        end
    end

endfunction
