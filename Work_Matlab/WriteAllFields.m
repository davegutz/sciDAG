function fileIdRet = WriteAllFields(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllFields(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically
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
fileIdRet = fileId;
if ~isstruct(StructToWrite)
    [n,~] = size(StructToWrite);
    for i = 1:n  
        if n>1, % multi-dimensioned elements
            fprintf(fileId, '%s(%ld,:),', parent, i);
        else
            fprintf(fileId, '%s,', parent);
        end
        try
        fprintf(fileId, '%f,', StructToWrite(i,:));
        catch ERR
            keyboard
        end
        fprintf(fileId, '\n');
    end
else
    [~,n] = size(StructToWrite);
    for i = 1:n
        if n>1
            Fields = fieldnames(StructToWrite(i));
            for iField = 1:length(Fields)
                WriteAllFields(StructToWrite(i).(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        else
            Fields = fieldnames(StructToWrite);
            for iField = 1:length(Fields)
                WriteAllFields(StructToWrite.(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        end
    end
end

