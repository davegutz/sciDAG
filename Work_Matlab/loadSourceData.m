function [D] = loadSourceData(result, startTime, MOD, D)
% Load data to drive model with old source/f414 data

%%31-Mar-2016  DA Gutz         Created from loadFltData


%%Default
if nargin<3, startTime = 0; end 

%%Load data.   It takes along time to load so remember last load when possible
resultIFC_Fn    = sprintf('../f414_source_legacy/f414/%s.ifc.dat', result);
resultVEN_Fn    = sprintf('../f414_source_legacy/f414/%s.ven.dat', result);
resultMVSV_Fn   = sprintf('../f414_source_legacy/f414/%s.mvsv.dat', result);
resultHS_Fn     = sprintf('../f414_source_legacy/f414/%s.hs.dat', result);
fnData          = sprintf('saves/%s.mat', result);
fnThisFile      = sprintf('CALLBACKS/%s.m', mfilename);
dfnThisFile     = getStamp(fnThisFile);
dfnData         = getStamp(fnData);
dresultIFC_Fn   = getStamp(resultIFC_Fn);
dresultVEN_Fn   = getStamp(resultVEN_Fn);
dresultMVSV_Fn  = getStamp(resultMVSV_Fn);
dresultHS_Fn    = getStamp(resultHS_Fn);
if  ~exist(fnData, 'file') ||...
    dfnThisFile > dfnData  ||...
    dresultIFC_Fn   > dfnData ||...
    dresultVEN_Fn   > dfnData ||...
    dresultMVSV_Fn  > dfnData ||...
    dresultHS_Fn    > dfnData,

    
    if MOD.verbose-MOD.linearizing>0,fprintf('(%s): loading data...', mfilename);end;
    %%Load IFC
    [a, ~, nV] = importdata(resultIFC_Fn);
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;
    for i=1:nV
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i}, i));
    end
    inpVar = a.textdata;
    inpArr = a.data; %#ok<NASGU>
    pvec = find(timex>=startTime);
    if isempty(pvec)
        startTime = 0;
        pvec = find(timex>=0);
    end
    timeN = timex(pvec)-startTime;
    for i=1:nV,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.');end;
        end
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;
    
    %%Load VEN
    [a, ~, nY] = importdata(resultVEN_Fn);
    for i=1:nY
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i}, i));
    end
    inpVar = a.textdata;
    inpArr = a.data; %#ok<NASGU>
    for i=1:nY,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;

    %%Load MVSV
    [a, ~, nV] = importdata(resultMVSV_Fn);
    for i=1:nV
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i}, i));
    end
    inpVar = a.textdata;
    inpArr = a.data; %#ok<NASGU>
    pvec = find(timex>=startTime);
    timeN = timex(pvec)-startTime;
    for i=1:nV,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;
    
    %%Load HS
    [a, ~, nV] = importdata(resultHS_Fn);
    for i=1:nV
        eval(sprintf('%s=a.data(:,%ld);', a.textdata{i}, i));
    end
    inpVar = a.textdata;
    inpArr = a.data; %#ok<NASGU>
    pvec = find(timex>=startTime);
    timeN = timex(pvec)-startTime;
    for i=1:nV,
        if ~strcmp(inpVar{i}, '')
            var = strrep(inpVar{i}, '.', '_');
            var = strrep(var, ' ', '');
            eval(sprintf('D.V.%s = [timeN %s(pvec)];',  var(:), var(:)))
            eval(sprintf('clear %s;',  var(:)))
            if MOD.verbose-MOD.linearizing>0,fprintf('.'),end;
        end
    end
    if MOD.verbose-MOD.linearizing>0,fprintf('\n');end;

    %%Postfix
    D.tFinal        = timeN(length(timeN));
    D.DTIME         = timeN(5)-timeN(4);
    D.startTime     = startTime;
    D.sg            = D.V.sg(1, 2);
    D.kvis          = D.V.kvis(1, 2);
    D.beta          = D.V.beta(1, 2);
    D.dwdc          = D.sg*129.93948;
    D.V             = orderfields(D.V);
    D               = orderfields(D);
    eval(sprintf('save %s D', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('\n%s:  loaded and saved to %s...', mfilename, fnData);end
else
    eval(sprintf('load %s', fnData))
    if MOD.verbose-MOD.linearizing>0, fprintf('%s:  re-loaded from .mat...', mfilename); end
end

