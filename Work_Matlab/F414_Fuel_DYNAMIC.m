%% F414_Fuel_DYNAMIC
% Load dynamic tune parameters
% 13-Sep-2017   DA Gutz     Created


% Tuning file
if ~isempty(Z.strD)
    if iscell(Z.strD)
        strDC = regexprep(Z.strD, '^-', '');
        strDC = regexprep(strDC, '^_', '');
        Z.strD = '';
        for j=1:length(strDC)
            [fl, p]= grep('-i -r', {ssParams{:}}, [strDC{j} '.m']);
            if p.pcount
                error('%s:  a ''ssParam'' element that rebalances initial condition is contained in file %s.\nIt should be in STEADY.m', mfilename, strDC{j});
            end
            eval(sprintf('%s', strDC{j}));
            Z.strD  = [Z.strD '_' strDC{j}];
            if MOD.verbose-MOD.linearizing > 2, fprintf('Loaded DYNAMIC file %s\n', Z.strD{j}); end
        end
        Z.strD = cellstr(Z.strD);
        Z.strD = regexprep(Z.strD, '^_', '');
    else
        [fl, p]= grep('-i -r', {ssParams{:}}, [Z.strD '.m']);
        if p.pcount
            error('%s:  a ''ssParam'' element that rebalances initial condition is contained in file %s.\nIt should be in STEADY.m', mfilename, Z.strD{j});
        end
        eval(sprintf('%s', Z.strD));
        if MOD.verbose-MOD.linearizing > 2,  fprintf('Loaded DYNAMIC file %s\n', Z.strD); end
    end
end
