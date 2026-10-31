function t = arrow2table(arrowTable, opts)
%ARROW2TABLE Converts an arrow table to a MATLAB table.
%
% NOTE: The column names in the arrowTable are normalized in the output
% table to be valid MATLAB identifiers and unique to each other.
%
% Input Arguments:
%  arrowTable - PyArrow table to convert
%
% Name-Value Arguments:
%  CastToDouble - Convert arrow integer and boolean columns containing null
%   elements into MATLAB double arrays with NaN representing null 
%   elements. Defaults to true. If false, null elements are imported as 0 
%   (for integer arrays) or false (for boolean arrays).

% Copyright 2026 The MathWorks, Inc.

    arguments(Input)
        arrowTable
        opts.CastToDouble (1, 1) logical = true
    end

    arguments(Output)
        t(:, :) table
    end
    names = string(arrowTable.column_names);
    numvars = numel(names);
    vardata = cell([1 numvars]);

    for ii = 1:numvars
        column = arrowTable.column(int32(ii) - 1);
        converter = matlab.internal.arrow.makeConverter(column.type, CastToDouble=opts.CastToDouble);
        vardata{ii} = converter.convert(column);
    end

    reservedNames = ["Properties" "RowNames" ":"];
    [validNames, modified] = matlab.lang.makeUniqueStrings(names, reservedNames, namelengthmax);

    if any(modified)
        warning("sparkapi:ModifiedColumnNames", ...
            "Modified DataFrame column names to be valid table variable names.");
    end

    t = table(vardata{:}, VariableNames=validNames);
end