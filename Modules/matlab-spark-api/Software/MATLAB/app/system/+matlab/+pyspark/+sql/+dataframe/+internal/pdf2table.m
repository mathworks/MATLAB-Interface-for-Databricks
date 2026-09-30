function t = pdf2table(pdf, sparkSchema)
%PDF2TABLE Converts a Pandas DataFrame to a MATLAB table.

% Copyright 2026 The MathWorks, Inc.

   % Store the original column names before they are renamed to Var1,...,VarN.
    columnNames = string(py.list(pdf.columns));
    numColumns = numel(columnNames);

    % Rename the column names to Var1,...,VarN. Renaming the columns will 
    % make it easier to assemble the final MATLAB table with the variables
    % in the correct order.
    newColumnNames = compose("Var%d", 1:numColumns);
    pdfRenamedColumns = pdf.set_axis(cellstr(newColumnNames), pyargs("axis", "columns"));

    % Create a Pandas DataFrame that just contains datetime64[ns] columns.
    datetimePDF = pdfRenamedColumns.select_dtypes(pyargs("include", "datetime64[ns]"));
    % Create a MATLAB table that just contains datetime variables.
    datetimeTable = datetimePDF2table(datetimePDF); 

    % Create a Pandas DataFrame that does not contain datetime64[ns] columns.
    notDatetimePDF = pdfRenamedColumns.select_dtypes(pyargs("exclude", "datetime64[ns]"));
    % Create a MATLAB table that does not contain any datetime variables.
    notDatetimeTable = notDatetimesPDF2table(notDatetimePDF);

    % Concatenate the two tables together.
    t = [notDatetimeTable, datetimeTable];
    % Reorder the variables to match the original order.
    t = movevars(t, newColumnNames);

    t = typeConversions(t, sparkSchema);

    % Normalize the column names to make them valid table VariableNames.
    reservedNames = ["Properties" "RowNames" ":"];
    [varNames, modified] = matlab.lang.makeUniqueStrings(columnNames, reservedNames, namelengthmax);
    t.Properties.VariableNames = varNames;

    if any(modified)
        warning("sparkapi:ModifiedColumnNames", ...
            "Modified DataFrame column names to be valid table variable names.");
    end

end

function t = datetimePDF2table(pdf)    
    nanoseconds = int64(pdf.values.astype("int64", pyargs("copy", "false")));
    nulls = logical(pdf.isnull().values);

    epoch = datetime(1970, 1, 1, TimeZone="UTC");
    numColumns = size(nanoseconds, 2);
    c = cell(1, size(nanoseconds, 2));
    for ii = 1:numColumns
        dates = datetime(nanoseconds(:, ii), ConvertFrom="epochtime", Epoch=epoch, TicksPerSecond=1e9);
        dates(nulls(:, ii)) = NaT;
        c{ii} = dates;
    end

    variableNames = string(py.list(pdf.columns));
    t = table(c{:}, VariableNames=variableNames);
end

function t = notDatetimesPDF2table(pdf)
    numColumns = py.len(pdf.columns);

    % Don't pass a zero-column DataFrame to the table function to prevent
    % MATLAB from crashing!
    if numColumns == 0
        t = table;
        return;
    end

    t = table(pdf);
end

function T = typeConversions(T, schema)
    D = compiler.build.spark.data.fromSchema(schema);
    N = D.NumFields;
    for k=1:N
        elem = D.fields(k).dataType;
        col = T.(k);
        newCol = elem.col_MATLABTable(col);
        T.(k) = newCol;
    end
end