function fileIdRet = WriteAllValuesArray(StructToWrite, fileRoot, parent, fileId)
% function StructToWrite = WriteAllValuesArray(StructToWrite, fileRoot, parent)
%
% Writes all fieldnames in a structure array alphabetically
% on all levels.
% Recursive function.
% Example of top call:
%   fid= WriteAllFieldsArray(S,'myFileName','S'); fclose(fid);
%
% 24-Feb-2017       DA Gutz     Created
% Revisions

%

if nargin<4
    fileId = fopen([fileRoot '.csv'], 'w');
end
fileIdRet = fileId;
if ~isstruct(StructToWrite)
    [n,m] = size(StructToWrite);
    for i = 1:n
        if n>1, % multi-dimensioned elements
            for j = 1:m
                if m>1,
                    if ischar(StructToWrite(i,j))
                        fprintf(fileId, '%s,', StructToWrite(i,j));
                    else
                        fprintf(fileId, '%f,', StructToWrite(i,j));
                    end
                else
                    if ischar(StructToWrite(i))
                        fprintf(fileId, '%s,', StructToWrite(i));
                    else
                        fprintf(fileId, '%f,', StructToWrite(i));
                    end
                end
            end
        else
            if ischar(StructToWrite)
                fprintf(fileId, '%s,', StructToWrite);
            else
                if iscell(StructToWrite)
                    catStr = StructToWrite{:,1};
                    for j=2:length(StructToWrite)
                        smallS = StructToWrite{:,j};
                        if iscell(smallS)
                            [~, ms] = size(smallS);
                            for k=1:ms
                                catStr = [catStr '_' smallS{:,k}]; %#ok<AGROW>
                            end
                        else
                            catStr = [catStr '_' smallS]; %#ok<AGROW>
                        end
                    end
                    cleanStr = strrep(catStr, ',', ';');
                    fprintf(fileId, '%s,', cleanStr);
                else
                    fprintf(fileId, '%f,', StructToWrite);
                end
            end
        end
    end
else
    [~,n] = size(StructToWrite);
    for i = 1:n
        if n>1
            Fields = fieldnames(StructToWrite(i));
            for iField = 1:length(Fields)
                WriteAllValuesArray(StructToWrite(i).(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        else
            Fields = fieldnames(StructToWrite);
            for iField = 1:length(Fields)
                WriteAllValuesArray(StructToWrite.(Fields{iField}), fileRoot, [parent '.' Fields{iField}], fileId);
            end
        end
    end
end

return
