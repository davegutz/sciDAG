%% F414_Fuel_STEADY_2
% Load Steady tune parameters
% 13-Sep-2017   DA Gutz     Created


% Tuning file
if ~isempty(Z.strC)
    if iscell(Z.strC)
        strCC = regexprep(Z.strC, '^-', '');
        strCC = regexprep(strCC, '^_', '');
        Z.strC = '';
        for j=1:length(Z.strC)
            eval(sprintf('%s', Z.strC{j}));
            Z.strC  = [Z.strC '_' strCC{j}];
            if MOD.verbose-MOD.linearizing > 2, fprintf('Loaded CONDITION file %s\n', Z.strC{j});end
        end
        Z.strC = cellstr(Z.strC);
        Z.strC = regexprep(Z.strC, '^_', '');
    else
        eval(sprintf('%s', Z.strC));
        if MOD.verbose-MOD.linearizing > 2, fprintf('Loaded CONDITION file %s\n', Z.strC);end
    end
else
    if MOD.verbose-MOD.linearizing > 2, fprintf('Not loading CONDITION file\n');end
end
if ~isempty(Z.strS)
    if iscell(Z.strS)
        strSC = regexprep(Z.strS, '^-', '');
        strSC = regexprep(strSC, '^_', '');
        Z.strS = '';
        for j=1:length(strSC)
            eval(sprintf('%s', strSC{j}));
            Z.strS  = [Z.strS '_' strSC{j}];
            if MOD.verbose-MOD.linearizing > 2,  fprintf('Loaded STEADY file %s\n', strSC{j}); end
        end
        Z.strS = cellstr(Z.strS);
        Z.strS = regexprep(Z.strS, '^_', '');
    else
        eval(sprintf('%s', Z.strS));
        if MOD.verbose-MOD.linearizing > 2,  fprintf('Loaded STEADY file %s\n', Z.strS); end
    end
else
    Z.strS = 'sNone';
    if MOD.verbose-MOD.linearizing > 2,  fprintf('Not loading STEADY file\n');end
end
