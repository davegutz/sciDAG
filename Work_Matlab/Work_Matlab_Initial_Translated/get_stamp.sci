function [timeStamp] = getStamp(fp)

// Output variables initialisation (not found in input variables)
timeStamp=[];

// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// function timeStamp = getStamp(fp)
// Get time stamp of a file path; return 0 if non-existant

dfp = mtlb_dir(fp);
if isempty(dfp) then
  timeStamp = 0;
else
  timeStamp = dfp.datenum;
end;
endfunction
