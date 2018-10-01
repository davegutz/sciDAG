function timeStamp = getStamp(fp)
% function timeStamp = getStamp(fp)
% Get time stamp of a file path; return 0 if non-existant

dfp = dir(fp);
if isempty(dfp),
    timeStamp = 0;
else
    timeStamp = dfp.datenum;
end
