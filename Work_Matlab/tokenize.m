function [nTok, tokens, cTokens] = tokenize(targ, delims)
% function [nTok, tokens, ctokens] = tokenize(targ, delims)
% tokenize using optional delims (default is Matlab default:  'help strtok').  Return number, cell array result, and the ctokens
% stripped (the first ctokens elemement preceeds the first tokens element
% on reconstruction
tokens  = {}; 
nTok    = 0;
ncTok   = 0;
rem     = targ;
cTokens = {};
while true
    oldRem      = rem;
    oldLen      = length(oldRem);
    col1        = strfind(oldRem, rem);
    if nargin == 2,
        [str, rem]  = strtok(oldRem, delims);
    else
        [str, rem]  = strtok(oldRem);
    end
    cLen        = length(rem)-1;
    col2        = strfind(oldRem, rem);
    col3        = strfind(oldRem, str);
%     fprintf('oldRem=%s| rem=%s| str=%s| col1=%ld| col2=%ld| cLen=%ld| col3=%ld|\n', oldRem, rem, str, col1, col2, cLen, col3);
    if ncTok == 0,
        if col3>1,
            cTokens = {oldRem(1:col3-1)};
        else
            if ~isempty(oldRem),
                cTokens = oldRem(1:col3-1);
                if isempty(cTokens), cTokens = {''}; end
            else
                cTokens = {''};
            end
        end
        ncTok   = ncTok+1;
    else
        if ~isempty(oldRem),
            ncTok = ncTok+1;
            if isempty(col3),
                cTokens{ncTok} = oldRem;
            else
                cTokens{ncTok} = oldRem(1:col3-1);
            end
        end
    end
%     fprintf('ncTok= %ld:', ncTok);
%     for k=1:length(cTokens(:)), fprintf('(%ld)%s|', k, cTokens{k}); end
%     fprintf('\n');
    if isempty(str),  break;  end
    nTok            = nTok + 1;
    tokens{nTok}    =   str;
