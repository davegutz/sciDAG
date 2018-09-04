function WriteAllTitlesArray(StructToWrite, fileRoot, parent, fileId)
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



if ~isstruct(StructToWrite)
    [n,m] = size(StructToWrite);
    for i = 1:n
        if n>1, % multi-dimensioned elements
            for j = 1:m
                if m>1,
                    fprintf(fileId, '%s(%ld | %ld),', strrep(parent, 'emptyParent.', ''), i, j);
                else
                    fprintf(fileId, '%s(%ld),', strrep(parent, 'emptyParent.', ''), i);
                end
            end
        else
            fprintf(fileId, '%s,', strrep(parent, 'emptyParent.', ''));
        end
    end
else
    [~,n] = size(StructToWrite);
    for i = 1:1  % Title row just once
        if n>1
            Fields = fieldnames(StructToWrite(i));
            for iField = 1:length(Fields)
                WriteAllTitlesArray(StructToWrite(i).(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        else
            Fields = fieldnames(StructToWrite);
            for iField = 1:length(Fields)
                WriteAllTitlesArray(StructToWrite.(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        end
    end
end

