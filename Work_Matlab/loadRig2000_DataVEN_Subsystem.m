function [D] = loadRig2000_DataVEN_Subsystem(result, startTime, MOD, D)
% Load data to drive model with old rig data from y 2000

%%19-Ma7-2017  DA Gutz         Created from loadSourceDataVEN_Subsystem.m


%%Default
if nargin<3, startTime = 0; end 

%%Load data.   It takes along time to load so remember last load when possible
resultVEN_Fn    = sprintf('DATA/%s', result);
sheet           = strrep(result, '.xlsx', '');
fnData          = sprintf('saves/%s.mat', result);
fnThisFile      = sprintf('CALLBACKS/%s.m', mfilename);
dfnThisFile     = getStamp(fnThisFile);
dfnData         = getStamp(fnData);
dresultVEN_Fn   = getStamp(resultVEN_Fn);
if  ~exist(fnData, 'file') ||...
    dfnThisFile > dfnData  ||...
    dresultVEN_Fn   > dfnData,

    
    if MOD.verbose-MOD.linearizing>0,fprintf('(%s): loading data...', mfilename);end;
    
    %%Load VEN
    [a, b, ~] = xlsread(resultVEN_Fn);
    inpVar = b;
    inpArr = a; 
    [~,nY] = size(inpArr);
    try
    for i=1:nY
        eval(sprintf('%s=a(:,%ld);', b{1,i}, i));
    end
    catch ERR
        fprintf('\nLook for problem with %s in file %s\n', a{1,i}, result);
        keyboard
    end
    pvec = find(time>=startTime);
    if isempty(pvec)
        startTime = 0;
        pvec = find(time>=0);
    end
    timeN = time(pvec)-startTime;
    try
    for i=1:nY,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    catch ERR %#ok<*NASGU>
        fprintf('\nLook for problem with D.V.%s = [timeN %s(pvec)] in file %s\n', var(:), var(:), result);
        keyboard
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;


    %%Postfix
    D.tFinal        = timeN(length(timeN));
    D.DTIME         = timeN(2)-timeN(1);
    D.startTime     = startTime;
    D.V             = orderfields(D.V);
    D               = orderfields(D);
    eval(sprintf('save %s D', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('\n%s:  loaded and saved to %s...\n', mfilename, fnData);end
else
    eval(sprintf('load %s', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('%s:  re-loaded from .mat...\n', mfilename); end
end

clear fnThisFile dfnThisFile
