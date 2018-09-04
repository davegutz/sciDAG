%% F414_Fuel_STEADY_1
% Load Steady tune parameters
% 13-Sep-2017   DA Gutz     Created

% Tuning file
if ~isempty(Z.strV)
    if iscell(Z.strV)
        for j=1:length(Z.strV)
            [fl, p]= grep('-i -r', {ssParams{:}}, [Z.strV{j} '.m']);
            if p.pcount
                error('%s:  a ''ssParam'' element that rebalances initial condition is contained in file %s.\nIt should be in STEADY.m', mfilename, Z.strV{j});
            end
            eval(sprintf('%s', Z.strV{j}));
            if ~MOD.linearizing, fprintf('Loaded VECTORS file %s\n', Z.strV{j}); end
        end
    else
        [fl, p]= grep('-i -r', {ssParams{:}}, [Z.strV '.m']);
        if p.pcount
            error('%s:  a ''ssParam'' element that rebalances initial condition is contained in file %s.\nIt should be in STEADY.m', mfilename, Z.strV{j});
        end
        eval(sprintf('%s', Z.strV));
        if ~MOD.linearizing, fprintf('Loaded VECTORS file %s\n', Z.strV); end
    end
else
    if ~MOD.linearizing,fprintf('Not loading VECTORS file\n');end
end


