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
function p_struct(st_str, st)
    F = fieldnames(st);
    [n, m] = size(F);
    if n==0 then
        ty = type(st);
        [nst, mst] = size(st);
        mprintf('%s = ', st_str);
        for j=1:mst
            if mst>1 & j==1 then
               mprintf(' [');
           end
            if ty==1 then
                mprintf('%f', st(j));
            elseif ty==4 then
                if st(j) then
                mprintf('T');
             else
                mprintf('F');
            end
            elseif ty==10 then
                mprintf('''%s''', st(j));
            else
                mprintf('type %d for %s unknown\n', ty, st_str);
            end
            if mst>1 & j==mst then
               mprintf(']');
            elseif mst>1
               mprintf(', ');
            end
        end
        mprintf('\n');
    else
        for i=1:n
            new_name = st_str + '.' + F(i);
            // mprintf('new_name=%s\n', new_name);
            p_struct(new_name, evstr(new_name));
        end
    end
endfunction
