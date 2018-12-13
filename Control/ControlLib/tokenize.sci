// function [nTok, tokens, ctokens] = tokenize(targ, delims)
// tokenize using optional delims (default is Matlab default:  ''help strtok'').
//  Return number, cell array result, and the ctokens
// stripped (the first ctokens elemement preceeds the first tokens element
// on reconstruction
// Called By:
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
function [n_tokens, %tokens, ctokens] = tokenize(target, delims)

    // For debugging    
    verbosep = %f;

    // Number of arguments in function call
    [%nargout, %nargin] = argn(0)

    // Display mode
    mode(0);

    // Display warning for floating point exception
    ieee(1);

    // Do it
    if isempty(delims) then
        places = [];
    else
        places = tokenpos(target, delims);
    end
    [n_tokens, dummy] = size(places);
    for i_token = 1:n_tokens
        %tokens(i_token) = part(target, places(i_token,1):places(i_token,2));
    end
    n_ctokens = n_tokens-1;
    ctokens = '';
    for i_token = 1:n_ctokens
        ctokens(i_token) = part(target, places(i_token,2)+1:places(i_token+1,1)-1);
    end

    if  places(1,1)>=1 then
        ctokens = [part(target, 1:places(1,1)-1); ctokens];
    else
        ctokens = [''; ctokens];
    end
    if n_tokens>0 & places(n_tokens,2)+1<=length(target) then
        ctokens = [ctokens; part(target, places(n_tokens,2)+1:length(target))];
    else
        ctokens = [ctokens; ''];
    end
    n_ctokens = n_ctokens + 2;


    if verbosep == %t then
        for k=1:n_tokens
            mprintf('<%s>|', ctokens(k));
            mprintf('<%s>|', %tokens(k));
        end
        mprintf('<%s>\n', ctokens(n_tokens+1));
    end

endfunction
