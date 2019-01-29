// function [target, delims] = untokenize(n_tokens, %tokens, ctokens)
// reconstruct from tokenize result
//  Return target and original delims (may be out of order)
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
//**********************************************************************
function [target, delims] = untokenize(n_tokens, %tokens, ctokens)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Reconstruct
    target = '';
    for i_token = 1:n_tokens
        target = target + ctokens(i_token) + %tokens(i_token);
    end
    target = target + ctokens(n_tokens+1);

    // Determine the delimiters
    [n, m] = size(ctokens);
    d_ascii = [];
    for i = 1:n
        d_ascii = [d_ascii asciimat(ctokens(i))];
    end
    [N, k] = unique(d_ascii, 'c');
    delims = ascii(N);

endfunction
