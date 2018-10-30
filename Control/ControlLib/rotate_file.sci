// function rotate_file(in_file, out_file, comment_delim)
// Read in a text file, rotate it and write it out.
// 17-October-2018  DA Gutz     Written
// 
// Inputs:
//  in_file         csv text file with rectangular matrix in rows, columns
//  out_file        csv text file with rotated rectangular matrix
//  comment_delim   deliminiter for comments to be preserved in out_file header
//
// Outputs:
//  none
//
// Local:
//  
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
function rotate_file(in_file, out_file, comment_delim)
    
    // Rotate string file, saving header comment block
    // Assumes all rows have same number of columns
    [M, comments] = csvRead(in_file, [], [], 'string', [], commentDelim);
    [n_rows, n_elements] = size(M);
    [fdo, err] = mopen(out_file, 'wt');
    [n_comments, m_comments] = size(comments);
    for i_comment = 1:n_comments
        mfprintf(fdo, '%s\n', comments(i_comment))
    end
    for i = 1:n_elements
        if ~isempty(M(1, i)) then // Strip blanks
            for j = 1:n_rows
                mfprintf(fdo, '%s,', M(j, i));
            end
        end
        mfprintf(fdo, '\n');
    end
    mclose(fdo);

endfunction
