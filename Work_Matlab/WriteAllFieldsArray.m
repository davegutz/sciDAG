function WriteAllFieldsArray(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllFieldsArray(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically,
% multi-dimensional array
% on all levels.
% Recursive function.
% Example of top call:
%   fid= WriteAllFields(S,'myFileName','S'); fclose(fid);
%
% 24-Feb-2017       DA Gutz     Created
% Revisions

%

if nargin<4
    fileId = fopen([fileRoot '.csv'], 'w');
end
if nargin<3
    parent = 'emptyParent';
end

try
    WriteAllTitlesArray(StructToWrite, fileRoot, parent, fileId);
catch ERR
    fprintf('IS THE EXCEL FILE %s.csv STILL OPEN?   CLOSE IT\n', fileRoot);
    rethrow(ERR)
end
fprintf(fileId, '\n');
[~,m]=size(StructToWrite);
for i = 1:m
    WriteAllValuesArray(StructToWrite(i), fileRoot, parent, fileId);
    fprintf(fileId, '\n');
end
fclose(fileId);
