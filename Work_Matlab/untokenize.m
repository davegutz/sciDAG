function [result] = untokenize(ctokens, tokens)
% function [result] = untokenize(ctokens, tokens)
% reconstruct result of tokenize; useful for after changing tokens or
% ctokens
result  = [];
nTok    = length(tokens);
nC_Tok  = length(ctokens);
if nC_Tok-nTok > 1 || nC_Tok<nTok,
    fprintf(1, 'WARNING(untokenize):  bad correspondence of ctokens and tokens');
end

% Reconstruct
for i=1:nC_Tok,
    result = sprintf('%s%s', result, ctokens{i});
    if nTok>=i, result = sprintf('%s%s', result, tokens{i});end
end
