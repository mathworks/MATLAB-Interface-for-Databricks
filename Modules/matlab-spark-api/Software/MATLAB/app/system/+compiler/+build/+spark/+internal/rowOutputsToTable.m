function T = rowOutputsToTable(rows, columnNames)
    % rowOutputsToTable Internal helper function.
    %
    % This is an internal function, and not part of the API.

    % Copyright 2023 MathWorks, Inc.

    % The function takes the output rows from a Spark operation (e.g
    % foo_mapPartitions) and convert this to a MATLAB table.
    % This is only used to facilitate development and debugging.

    % Copyright 2023 The MathWorks, Inc.

    arguments
        rows cell
        columnNames string = string.empty
    end

    nRows = numel(rows);
   
    T = table();
    for k=1:nRows
        T = [T; cell2table(rows{k})]; %#ok<AGROW>
    end

    if nargin > 1
        T.Properties.VariableNames = columnNames;
    end

    T = fixColumnTypes(T);
end

function T = fixColumnTypes(T)
 columnNames = string(T.Properties.VariableNames);
 for name = columnNames
     COL = T.(name);
     TYPE = class(COL);
     SIZE = size(COL);
     if SIZE(2) > 1
         fprintf("Fixing column %s: %s, [%dx%d]\n", name, TYPE, SIZE(1), SIZE(2));
         T.(name) = mat2cell(COL, ones(1, SIZE(1)), SIZE(2));
     end
 end

end


