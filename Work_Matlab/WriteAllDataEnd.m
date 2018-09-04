function WriteAllDataEnd(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllDataEnd(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically
% on all levels.
% Recursive function.
% Example of top call:
%   fid = WriteAllDataEnd(S,'myFileName','S'); fclose(fid);
%
if nargin<4
    fileId = fopen([fileRoot '.csv'], 'w');
end
if ~isstruct(StructToWrite)
    fprintf(fileId, '%s,%f,\n', parent, StructToWrite.Data(end));
else
    Fields = fieldnames(StructToWrite);
    for iField = 1:length(Fields)
        WriteAllDataEnd(StructToWrite.(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
    end
end

