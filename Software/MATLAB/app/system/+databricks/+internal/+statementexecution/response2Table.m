function T = response2Table(esResponse, resultFile, options)
    % RESPONSE2TABLE Convert statement result data to a table
    %
    % Syntax:
    %   T = databricks.internal.statementexecution.response2Table(esResponse, resultFile)
    %   T = databricks.internal.statementexecution.response2Table(__, applySchemaTypes=false)
    %   T = databricks.internal.statementexecution.response2Table(__, verbose=false)
    %
    % Creates a MATLAB table from a local Statement Execution result file
    % using the manifest in esResponse. The manifest supplies the result
    % format, row count, column names, column ordering, and Databricks SQL
    % types. The returned table is annotated with statement execution metadata
    % such as statement ID, result format, result file, row count, chunk count,
    % and truncation state.
    %
    % Supported result formats:
    %   JSON_ARRAY
    %       With applySchemaTypes=true, the JSON_ARRAY file is decoded and
    %       each column is converted using the Databricks schema. This is the
    %       normal path used for INLINE statement results.
    %
    %       With applySchemaTypes=false, values are not decoded with
    %       jsondecode. Instead, this function scans the top-level JSON array
    %       structure and returns one raw JSON row string per table row in a
    %       variable named Result. This preserves value text that jsondecode
    %       could otherwise normalize or alter, while still giving callers a
    %       row-shaped table. Whitespace around each row element is trimmed,
    %       but the JSON text inside each row is preserved as written.
    %
    %   CSV
    %       With applySchemaTypes=true, readtable import options are built from
    %       the Databricks schema so CSV columns use the expected MATLAB table
    %       types where supported.
    %
    %       With applySchemaTypes=false, the CSV file is read using MATLAB's
    %       default text import inference and the manifest is still used for
    %       variable names and table metadata.
    %
    % Unsupported formats, truncated responses, multi-chunk responses passed
    % directly to this helper, and mismatches between manifest row or column
    % counts and the result file raise DATABRICKS:response2Table errors.
    %
    % Inputs:
    %   esResponse
    %       Statement execution response containing manifest schema metadata.
    %
    %   resultFile
    %       Local result file written by databricks.internal.statementexecution.runStatementImpl.
    %
    % Name-Value Inputs:
    %   applySchemaTypes
    %       Description:
    %           Use statement schema metadata to convert JSON_ARRAY and CSV
    %           result data to MATLAB table types. When false, CSV files are
    %           read using MATLAB type inference and JSON_ARRAY rows are
    %           returned as raw row strings in a single table variable without
    %           decoding values.
    %       Type:
    %           logical
    %       Default:
    %           true
    %
    %   verbose
    %       Description:
    %           Show progress output while building the table.
    %       Type:
    %           logical
    %       Default:
    %           false
    %
    % Outputs:
    %   T
    %       MATLAB table created from resultFile and annotated with statement
    %       execution metadata. For JSON_ARRAY with applySchemaTypes=false,
    %       T has one string variable named Result containing one raw JSON row
    %       string per result row.
    %
    % See also: databricks.internal.statementexecution.runStatementImpl, runStatement

    % (c) 2023-2026 MathWorks Inc.

    arguments (Input)
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.applySchemaTypes (1,1) logical = true
        options.verbose (1,1) logical = false
    end
    arguments (Output)
        T table
    end

    validateResultFileForTable(resultFile);
    nCols = validateStatementResponseForTable(esResponse);

    if isempty(esResponse.manifest.schema.columnCount) || esResponse.manifest.schema.columnCount < 1 
        if options.verbose; fprintf("columnCount empty or less than 1, returning an empty table\n"); end
        T = table;
        T = addStatementExecutionMetadata(T, esResponse, resultFile);
        return;
    else
        if options.verbose; fprintf("Number of columns: %d\n", nCols); end
    end

    [variableNames, variableTypes, variableDescriptions] = getTableSchema(esResponse);

    switch esResponse.manifest.format
        case databricks.datastructures.statementexecution.Format.JSON_ARRAY
            if options.applySchemaTypes
                T = createEmptySchemaTable(esResponse, variableNames, variableTypes, ...
                    variableDescriptions, resultFile, verbose=options.verbose);
                T = populateJSONArrayTable(T, esResponse, resultFile, variableNames, variableTypes);
            else
                T = readRawJSONResultFileAsTable(esResponse, resultFile);
            end

        case databricks.datastructures.statementexecution.Format.CSV
            T = readCSVResultFile(esResponse, resultFile, variableNames, variableTypes, ...
                variableDescriptions, applySchemaTypes=options.applySchemaTypes, ...
                verbose=options.verbose);

        otherwise
            error("DATABRICKS:response2Table", ...
                "Table creation is not supported for format: %s.", esResponse.manifest.format);
    end
end


function T = readRawJSONResultFileAsTable(esResponse, resultFile)
    % READRAWJSONRESULTFILEASTABLE Return JSON_ARRAY rows as strings
    %
    % This is the applySchemaTypes=false JSON path. It deliberately keeps the
    % payload values out of jsondecode so that numeric precision, string
    % escaping, null spelling, and other JSON text details are not normalized
    % by MATLAB. The table still has one row per Databricks result row.
    %
    % Example:
    %   resultFile contents:
    %       [["001","42"],[null,"7"]]
    %
    %   T.Result:
    %       "[""001"",""42""]"
    %       "[null,""7""]"

    arguments (Input)
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        T table
    end

    rawJSONRows = readJSONArrayRowsAsStrings(resultFile);
    if numel(rawJSONRows) ~= esResponse.manifest.totalRowCount
        error("DATABRICKS:response2Table", ...
            "Expected JSON_ARRAY row count to match statement manifest totalRowCount.");
    end

    T = table(rawJSONRows, VariableNames="Result");
    T = annotateResultTable(T, esResponse, resultFile, "Raw JSON_ARRAY result row");
end


function rawJSONRows = readJSONArrayRowsAsStrings(resultFile)
    % READJSONARRAYROWSASSTRINGS Split JSON_ARRAY rows without decoding values
    %
    % Databricks JSON_ARRAY results are a top-level JSON array whose elements
    % are result rows. This helper preserves the exact row element text by
    % using a structural scanner rather than jsondecode.

    arguments (Input)
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        rawJSONRows (:,1) string
    end

    rawJSONRows = splitTopLevelJSONArrayElements(fileread(resultFile));
end


function elements = splitTopLevelJSONArrayElements(rawJSON)
    % SPLITTOPLEVELJSONARRAYELEMENTS Return exact top-level array element text
    %
    % This is a small JSON framing scanner, not a value parser. It only needs
    % to find commas and brackets that belong to the top-level JSON array.
    % Commas, brackets, and braces inside strings or nested values are ignored.
    %
    % State tracked while scanning:
    %
    %   depth      Meaning
    %   -----      -----------------------------------------------
    %     0        Before the top-level array, or after it closes
    %     1        Inside the top-level array between result rows
    %     2+       Inside one result row or a nested JSON value
    %
    % Example with row boundaries marked:
    %
    %   [ ["a,b",{"k":[1,null]}] , ["x\"y",[]] ]
    %     ^--------------------^   ^----------^
    %            row 1                row 2
    %
    % The comma in "a,b" is ignored because inString is true. The comma after
    % row 1 is accepted because depth is 1 and inString is false. The nested
    % brackets in {"k":[1,null]} are ignored as row separators because depth
    % is greater than 1.

    arguments (Input)
        rawJSON (1,:) char
    end
    arguments (Output)
        elements (:,1) string
    end

    elements = strings(0, 1);
    inString = false;
    escaped = false;
    depth = 0;
    rowStart = 0;
    topLevelClosed = false;

    for idx = 1:numel(rawJSON)
        ch = rawJSON(idx);

        if topLevelClosed
            if ~isspace(ch)
                error("DATABRICKS:response2Table", ...
                    "Unexpected content after JSON_ARRAY result data.");
            end
            continue
        end

        if inString
            if escaped
                escaped = false;
            elseif ch == '\'
                escaped = true;
            elseif ch == '"'
                inString = false;
            end
            continue
        end

        if ch == '"'
            if depth == 1 && rowStart == 0
                rowStart = idx;
            end
            inString = true;
        elseif ch == '['
            if depth == 0
                depth = 1;
            else
                if depth == 1 && rowStart == 0
                    rowStart = idx;
                end
                depth = depth + 1;
            end
        elseif ch == '{'
            if depth < 1
                error("DATABRICKS:response2Table", ...
                    "Expected JSON_ARRAY result data to start with an array.");
            end
            if depth == 1 && rowStart == 0
                rowStart = idx;
            end
            depth = depth + 1;
        elseif ch == ']'
            if depth == 0
                error("DATABRICKS:response2Table", ...
                    "Unexpected closing bracket in JSON_ARRAY result data.");
            elseif depth == 1
                if rowStart > 0
                    elements(end + 1, 1) = string(extractJSONElement(rawJSON, rowStart, idx - 1)); %#ok<AGROW>
                    rowStart = 0;
                end
                depth = 0;
                topLevelClosed = true;
            else
                depth = depth - 1;
            end
        elseif ch == '}'
            if depth <= 1
                error("DATABRICKS:response2Table", ...
                    "Unexpected closing brace in JSON_ARRAY result data.");
            end
            depth = depth - 1;
        elseif ch == ','
            if depth == 0
                error("DATABRICKS:response2Table", ...
                    "Unexpected comma outside JSON_ARRAY result data.");
            elseif depth == 1
                if rowStart == 0
                    error("DATABRICKS:response2Table", ...
                        "Expected JSON_ARRAY row before comma.");
                end
                elements(end + 1, 1) = string(extractJSONElement(rawJSON, rowStart, idx - 1)); %#ok<AGROW>
                rowStart = 0;
            end
        elseif ~isspace(ch)
            if depth == 0
                error("DATABRICKS:response2Table", ...
                    "Expected JSON_ARRAY result data to start with an array.");
            elseif depth == 1 && rowStart == 0
                rowStart = idx;
            end
        end
    end

    if inString || depth ~= 0 || ~topLevelClosed
        error("DATABRICKS:response2Table", ...
            "Malformed JSON_ARRAY result data.");
    end
end


function element = extractJSONElement(rawJSON, firstIndex, lastIndex)
    % EXTRACTJSONELEMENT Trim JSON framing whitespace from an element
    %
    % The raw row mode preserves JSON text inside each row element, but trims
    % whitespace that belongs to the top-level array framing:
    %
    %   [  ["row",1]  ,  ["row",2]  ]
    %      ^-------^     ^-------^
    %
    % The returned strings are ["row",1] and ["row",2].

    arguments (Input)
        rawJSON (1,:) char
        firstIndex (1,1) double {mustBePositive}
        lastIndex (1,1) double {mustBeNonnegative}
    end
    arguments (Output)
        element (1,:) char
    end

    while firstIndex <= lastIndex && isspace(rawJSON(firstIndex))
        firstIndex = firstIndex + 1;
    end
    while lastIndex >= firstIndex && isspace(rawJSON(lastIndex))
        lastIndex = lastIndex - 1;
    end
    if firstIndex > lastIndex
        error("DATABRICKS:response2Table", "Expected nonempty JSON_ARRAY row.");
    end

    element = rawJSON(firstIndex:lastIndex);
end


function T = populateJSONArrayTable(T, esResponse, resultFile, variableNames, variableTypes)
    % POPULATEJSONARRAYTABLE Populate table variables from a JSON_ARRAY file
    %
    % This is the applySchemaTypes=true JSON path. The table is allocated with
    % manifest-derived names and MATLAB variable types before this helper is
    % called; each decoded result column is then coerced into the corresponding
    % table variable.
    %
    % Data flow:
    %
    %   JSON_ARRAY file -> readJSONArrayValues -> column cells
    %                    -> coerceJSONColumn   -> typed table variables

    arguments (Input)
        T table
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        variableNames (:,1) string
        variableTypes (:,1) string
    end
    arguments (Output)
        T table
    end

    values = readJSONArrayValues(resultFile, numel(variableNames));
    if size(values, 1) ~= esResponse.manifest.totalRowCount
        error("DATABRICKS:response2Table", ...
            "Expected JSON_ARRAY row count to match statement manifest totalRowCount.");
    end

    for idx = 1:numel(variableNames)
        T.(variableNames(idx)) = coerceJSONColumn(values(:, idx), variableTypes(idx));
    end
end


function values = readJSONArrayValues(resultFile, nCols)
    % READJSONARRAYVALUES Decode JSON_ARRAY result data as a row-by-column cell array
    %
    % JSON_ARRAY responses may decode into different MATLAB shapes depending
    % on the values in the payload. This helper normalizes the decoded result
    % to an nRows-by-nCols cell array so later conversion can be column based.
    %
    % Examples:
    %   [["a","1"],["b","2"]]  -> 2-by-2 cell array
    %   [[1,2],[3,4]]          -> 2-by-2 cell array from numeric matrix
    %   []                     -> 0-by-nCols cell array

    arguments (Input)
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        nCols (1,1) double {mustBeNonnegative}
    end
    arguments (Output)
        values cell
    end

    try
        decoded = jsondecode(fileread(resultFile));
    catch exception
        error("DATABRICKS:response2Table", ...
            "Unable to decode JSON_ARRAY result file: %s", exception.message);
    end

    if isempty(decoded)
        values = cell(0, nCols);
        return
    end

    if iscell(decoded)
        values = cell(numel(decoded), nCols);
        for rowIdx = 1:numel(decoded)
            rowValues = normalizeJSONRow(decoded{rowIdx});
            if numel(rowValues) ~= nCols
                error("DATABRICKS:response2Table", ...
                    "Expected every JSON_ARRAY row to match statement schema columnCount.");
            end
            values(rowIdx, :) = rowValues;
        end
        return
    end

    if isnumeric(decoded) || islogical(decoded) || isstring(decoded)
        if size(decoded, 2) ~= nCols
            error("DATABRICKS:response2Table", ...
                "Expected JSON_ARRAY column count to match statement schema columnCount.");
        end
        values = num2cell(decoded);
        return
    end

    error("DATABRICKS:response2Table", ...
        "Unsupported JSON_ARRAY payload decoded as %s.", class(decoded));
end


function rowValues = normalizeJSONRow(row)
    % NORMALIZEJSONROW Convert one decoded JSON_ARRAY row to a row cell array
    %
    % jsondecode returns cell arrays for mixed row values and numeric/logical
    % arrays for homogeneous row values. This helper hides that difference so
    % column conversion always receives cell arrays.

    arguments (Input)
        row
    end
    arguments (Output)
        rowValues (1,:) cell
    end

    if iscell(row)
        rowValues = row(:).';
    elseif isnumeric(row) || islogical(row) || isstring(row)
        rowValues = num2cell(row(:).');
    else
        rowValues = {row};
    end
end


function columnData = coerceJSONColumn(values, variableType)
    % COERCEJSONCOLUMN Convert JSON_ARRAY strings/nulls to a MATLAB column
    %
    % Databricks JSON_ARRAY values are commonly returned as strings, even for
    % numeric SQL types. The manifest type selected by mapSchemaType2MATLAB
    % controls the MATLAB destination type here. JSON null values are left as
    % the default missing value for that destination type:
    %
    %   MATLAB type     Null placeholder
    %   -----------     ----------------
    %   logical/int*    false or zero
    %   single/double   NaN
    %   datetime        NaT
    %   string          <missing>

    arguments (Input)
        values (:,1) cell
        variableType (1,1) string
    end

    switch variableType
        case "logical"
            columnData = false(numel(values), 1);
            for idx = 1:numel(values)
                if ~isJSONNull(values{idx})
                    columnData(idx) = coerceJSONLogical(values{idx});
                end
            end

        case {"int8", "int16", "int32", "int64"}
            columnData = zeros(numel(values), 1, variableType);
            for idx = 1:numel(values)
                if ~isJSONNull(values{idx})
                    columnData(idx) = cast(str2double(string(values{idx})), variableType);
                end
            end

        case {"single", "double"}
            columnData = NaN(numel(values), 1, variableType);
            for idx = 1:numel(values)
                if ~isJSONNull(values{idx})
                    columnData(idx) = cast(str2double(string(values{idx})), variableType);
                end
            end

        case "datetime"
            columnData = NaT(numel(values), 1, TimeZone="UTC");
            for idx = 1:numel(values)
                if ~isJSONNull(values{idx})
                    columnData(idx) = coerceJSONDatetime(values{idx});
                end
            end

        otherwise
            columnData = strings(numel(values), 1);
            columnData(:) = missing;
            for idx = 1:numel(values)
                if ~isJSONNull(values{idx})
                    columnData(idx) = string(values{idx});
                end
            end
    end
end


function tf = isJSONNull(value)
    % ISJSONNULL True for JSON null values produced by jsondecode

    arguments (Input)
        value
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = (isnumeric(value) && isempty(value)) || ...
        (isnumeric(value) && isscalar(value) && isnan(value));
end


function value = coerceJSONLogical(value)
    % COERCEJSONLOGICAL Convert a JSON_ARRAY value to logical

    arguments (Input)
        value
    end
    arguments (Output)
        value (1,1) logical
    end

    if islogical(value)
        return
    end
    if isnumeric(value)
        value = value ~= 0;
        return
    end

    value = lower(string(value));
    value = value == "true" || value == "1";
end


function value = coerceJSONDatetime(value)
    % COERCEJSONDATETIME Convert a JSON_ARRAY value to UTC datetime

    arguments (Input)
        value
    end
    arguments (Output)
        value (1,1) datetime
    end

    value = string(value);
    formats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        "yyyy-MM-dd'T'HH:mm:ssZ"
        "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        "yyyy-MM-dd'T'HH:mm:ssXXX"
        "yyyy-MM-dd HH:mm:ss.SSS"
        "yyyy-MM-dd HH:mm:ss"
        "yyyy-MM-dd"
    ];

    for idx = 1:numel(formats)
        try
            value = datetime(value, InputFormat=formats(idx), TimeZone="UTC");
            if ~ismissing(value)
                value.TimeZone = "UTC";
                return
            end
        catch
        end
    end

    try
        value = datetime(value, TimeZone="UTC");
        value.TimeZone = "UTC";
    catch exception
        error("DATABRICKS:response2Table", ...
            "Unable to convert JSON_ARRAY value to datetime: %s", exception.message);
    end
end


function nCols = validateStatementResponseForTable(esResponse)
    % VALIDATESTATEMENTRESPONSEFORTABLE Validate response metadata for table creation
    %
    % Table conversion trusts the manifest for shape and schema. This helper
    % checks the manifest before any file parsing so downstream errors can
    % assume:
    %
    %   - statementId, manifest, format, schema, and row/chunk metadata exist
    %   - the response is not truncated
    %   - one result chunk is represented by resultFile, except zero-row
    %     results may have zero chunks
    %   - schema column positions are unique, zero-based, and in range
    %   - every schema column has a name and type

    arguments (Input)
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
    end
    arguments (Output)
        nCols (1,1) int32
    end

    errorId = "DATABRICKS:response2Table";

    if ~isprop(esResponse, "statementId") || isempty(esResponse.statementId)
        error(errorId, "Expected esResponse.statementId to be populated.");
    end
    if ~isprop(esResponse, "manifest") || isempty(esResponse.manifest)
        error(errorId, "Expected esResponse.manifest to be populated.");
    end
    if ~isprop(esResponse.manifest, "format") || isempty(esResponse.manifest.format)
        error(errorId, "Expected esResponse.manifest.format to be populated.");
    end
    if ~isprop(esResponse.manifest, "schema") || isempty(esResponse.manifest.schema)
        error(errorId, "Expected esResponse.manifest.schema to be populated.");
    end
    if ~isprop(esResponse.manifest.schema, "columnCount") || isempty(esResponse.manifest.schema.columnCount)
        nCols = int32(0);
        return
    end
    if ~isprop(esResponse.manifest, "totalRowCount") || isempty(esResponse.manifest.totalRowCount)
        error(errorId, "Expected esResponse.manifest.totalRowCount to be populated.");
    end
    if ~isprop(esResponse.manifest, "totalChunkCount") || isempty(esResponse.manifest.totalChunkCount)
        error(errorId, "Expected esResponse.manifest.totalChunkCount to be populated.");
    end
    if ~isprop(esResponse.manifest, "truncated") || isempty(esResponse.manifest.truncated)
        error(errorId, "Expected esResponse.manifest.truncated to be populated.");
    end
    if esResponse.manifest.truncated
        error(errorId, "Truncated responses are not supported.");
    end

    nCols = esResponse.manifest.schema.columnCount;
    if nCols < 0
        error(errorId, "Expected esResponse.manifest.schema.columnCount to be nonnegative.");
    end
    if nCols == 0
        return
    end
    if ~isprop(esResponse.manifest.schema, "columns") || isempty(esResponse.manifest.schema.columns)
        error(errorId, "Expected esResponse.manifest.schema.columns to be populated.");
    end
    if numel(esResponse.manifest.schema.columns) ~= nCols
        error(errorId, "Expected number of schema columns to match columnCount.");
    end

    positions = [esResponse.manifest.schema.columns.position];
    if any(positions < 0) || any(positions >= nCols)
        error(errorId, "Expected schema column positions to be zero-based and within columnCount.");
    end
    if numel(unique(positions)) ~= nCols
        error(errorId, "Expected schema column positions to be unique.");
    end

    for idx = 1:nCols
        column = esResponse.manifest.schema.columns(idx);
        if isempty(column.name) || strlength(column.name) == 0
            error(errorId, "Expected every schema column to have a name.");
        end
        if isempty(column.typeName)
            error(errorId, "Expected every schema column to have a typeName.");
        end
    end
end


function [variableNames, variableTypes, variableDescriptions] = getTableSchema(esResponse)
    % GETTABLESCHEMA Build table schema arrays from statement manifest metadata
    %
    % Databricks returns each schema column with a zero-based position. The
    % columns array is not assumed to be in table order, so each output vector
    % is filled by position:
    %
    %   manifest column position:  1        0        2
    %   manifest column name:      b        a        c
    %
    %   variableNames:             a        b        c

    arguments (Input)
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
    end
    arguments (Output)
        variableNames (:,1) string
        variableTypes (:,1) string
        variableDescriptions (:,1) string
    end

    nCols = esResponse.manifest.schema.columnCount;
    variableNames = strings(nCols, 1);
    variableTypes = strings(nCols, 1);
    variableDescriptions = strings(nCols, 1);
    for n = 1:nCols
        index = esResponse.manifest.schema.columns(n).position + 1;
        variableNames(index) = esResponse.manifest.schema.columns(n).name;
        variableTypes(index) = mapSchemaType2MATLAB(esResponse.manifest.schema.columns(n).typeName, ...
            esResponse.manifest.schema.columns(n).typePrecision);
        variableDescriptions(index) = esResponse.manifest.schema.columns(n).typeText;
    end
end


function T = createEmptySchemaTable(esResponse, variableNames, variableTypes, variableDescriptions, resultFile, options)
    % CREATEEMPTYSCHEMATABLE Create a schema-shaped table without row data

    arguments (Input)
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
        variableNames (:,1) string
        variableTypes (:,1) string
        variableDescriptions (:,1) string
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = false
    end
    arguments (Output)
        T table
    end

    sz = [esResponse.manifest.totalRowCount, esResponse.manifest.schema.columnCount];
    T = table('Size', sz, 'VariableTypes', variableTypes, 'VariableNames', variableNames);
    T = annotateResultTable(T, esResponse, resultFile, variableDescriptions);
    T = setDatetimeTimeZones(T, variableNames, variableTypes, verbose=options.verbose);
end


function T = readCSVResultFile(esResponse, resultFile, variableNames, variableTypes, variableDescriptions, options)
    % READCSVRESULTFILE Read a CSV result file and apply manifest metadata
    %
    % Databricks CSV result chunks do not provide MATLAB table metadata in the
    % file itself. The manifest is the source of truth for variable names,
    % order, and descriptions in both modes:
    %
    %   applySchemaTypes=true
    %       Build readtable import options from the manifest before reading.
    %
    %   applySchemaTypes=false
    %       Let readtable infer types, then replace variable names and attach
    %       manifest metadata after reading.

    arguments (Input)
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        variableNames (:,1) string
        variableTypes (:,1) string
        variableDescriptions (:,1) string
        options.applySchemaTypes (1,1) logical = true
        options.verbose (1,1) logical = false
    end
    arguments (Output)
        T table
    end

    if esResponse.manifest.totalRowCount == 0
        T = createEmptyCSVTable(esResponse, resultFile, variableNames, variableTypes, ...
            variableDescriptions, applySchemaTypes=options.applySchemaTypes, ...
            verbose=options.verbose);
        return
    end

    if options.applySchemaTypes
        importOptions = createCSVImportOptions(resultFile, variableNames, variableTypes, variableDescriptions);
        T = readtable(resultFile, importOptions);
        T = setDatetimeTimeZones(T, variableNames, variableTypes, verbose=options.verbose);
    else
        T = readtable(resultFile, FileType="text", ReadVariableNames=false, ...
            VariableNamingRule="preserve");
    end
    if width(T) ~= numel(variableNames)
        error("DATABRICKS:response2Table", ...
            "Expected CSV column count to match statement schema columnCount.");
    end

    T.Properties.VariableNames = cellstr(variableNames);
    T = annotateResultTable(T, esResponse, resultFile, variableDescriptions);
end


function T = createEmptyCSVTable(esResponse, resultFile, variableNames, variableTypes, variableDescriptions, options)
    % CREATEEMPTYCSVTABLE Create a manifest-shaped table for empty CSV results
    %
    % A zero-row CSV result may be represented by a header-only file or an
    % empty file. Either way, there are no data rows for readtable to convert,
    % so the manifest is used to create the table shape directly.
    %
    % With applySchemaTypes=false there are no values to infer from, so the
    % table uses string variables while preserving manifest column names and
    % metadata.

    arguments (Input)
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        variableNames (:,1) string
        variableTypes (:,1) string
        variableDescriptions (:,1) string
        options.applySchemaTypes (1,1) logical = true
        options.verbose (1,1) logical = false
    end
    arguments (Output)
        T table
    end

    if ~options.applySchemaTypes
        variableTypes = repmat("string", size(variableNames));
    end

    T = createEmptySchemaTable(esResponse, variableNames, variableTypes, ...
        variableDescriptions, resultFile, verbose=options.verbose);
end


function importOptions = createCSVImportOptions(resultFile, variableNames, variableTypes, variableDescriptions)
    % CREATECSVIMPORTOPTIONS Build schema-aware readtable options for CSV results
    %
    % detectImportOptions provides delimiter, quoting, and low-level text
    % handling. The manifest then overrides VariableNames and VariableTypes so
    % readtable imports values into the expected MATLAB table types.

    arguments (Input)
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        variableNames (:,1) string
        variableTypes (:,1) string
        variableDescriptions (:,1) string
    end

    importOptions = detectImportOptions(resultFile, FileType="text", ...
        ReadVariableNames=false, VariableNamingRule="preserve");
    if numel(importOptions.VariableNames) ~= numel(variableNames)
        error("DATABRICKS:response2Table", ...
            "Expected CSV column count to match statement schema columnCount.");
    end

    csvVariableTypes = getCSVVariableTypes(variableTypes);
    importOptions.VariableNames = cellstr(variableNames);
    importOptions.VariableTypes = cellstr(csvVariableTypes);
    importOptions = setCSVDateTimeOptions(importOptions, variableNames, variableDescriptions);
end


function csvVariableTypes = getCSVVariableTypes(variableTypes)
    % GETCSVVARIABLETYPES Select readtable import types for CSV schema conversion

    arguments (Input)
        variableTypes (:,1) string
    end
    arguments (Output)
        csvVariableTypes (:,1) string
    end

    csvVariableTypes = variableTypes;
end


function importOptions = setCSVDateTimeOptions(importOptions, variableNames, variableDescriptions)
    % SETCSVDATETIMEOPTIONS Configure known Databricks date and timestamp formats
    %
    % mapSchemaType2MATLAB maps both DATE and TIMESTAMP to datetime. The
    % manifest type text distinguishes the concrete import format:
    %
    %   DATE       -> yyyy-MM-dd
    %   TIMESTAMP  -> yyyy-MM-dd'T'HH:mm:ss.SSS'Z'

    arguments (Input)
        importOptions
        variableNames (:,1) string
        variableDescriptions (:,1) string
    end

    for idx = 1:numel(variableNames)
        if ~strcmp(importOptions.VariableTypes{idx}, "datetime")
            continue
        end

        typeText = upper(variableDescriptions(idx));
        if startsWith(typeText, "DATE")
            importOptions = setvaropts(importOptions, variableNames(idx), ...
                InputFormat="yyyy-MM-dd");
        else
            importOptions = setvaropts(importOptions, variableNames(idx), ...
                InputFormat="yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        end
    end
end


function T = annotateResultTable(T, esResponse, resultFile, variableDescriptions)
    % ANNOTATERESULTTABLE Attach table description and statement metadata

    arguments (Input)
        T table
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        variableDescriptions (:,1) string
    end
    arguments (Output)
        T table
    end

    T.Properties.Description = esResponse.statementId;
    T.Properties.VariableDescriptions = variableDescriptions;
    T = addStatementExecutionMetadata(T, esResponse, resultFile);
end


function T = setDatetimeTimeZones(T, variableNames, variableTypes, options)
    % SETDATETIMETIMEZONES Set UTC timezone on datetime table variables

    arguments (Input)
        T table
        variableNames (:,1) string
        variableTypes (:,1) string
        options.verbose (1,1) logical = false
    end
    arguments (Output)
        T table
    end

    utcWarned = false;
    for m = 1:width(T)
        if strcmp(variableTypes{m}, "datetime")
            if options.verbose && ~utcWarned
                fprintf("Using UTC as timezone for datetimes\n");
            end
            T.(variableNames{m}).TimeZone = "UTC";
            utcWarned = true;
        end
    end
end


function validateResultFileForTable(resultFile)
    % VALIDATERESULTFILEFORTABLE Validate the local result payload file

    arguments (Input)
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if ~isfile(resultFile)
        error("DATABRICKS:response2Table", "File not found: %s", resultFile);
    end
end


function T = addStatementExecutionMetadata(T, esResponse, resultFile)
    % ADDSTATEMENTEXECUTIONMETADATA Attach response metadata to a table

    arguments (Input)
        T table
        esResponse (1,1) databricks.datastructures.statementexecution.StatementResponse
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        T table
    end

    customPropertyNames = [
        "StatementId"
        "ResultFormat"
        "ResultFile"
        "TotalRowCount"
        "TotalChunkCount"
        "Truncated"
    ];
    customPropertyTypes = repmat("table", size(customPropertyNames));

    T = addprop(T, customPropertyNames, customPropertyTypes);
    T.Properties.CustomProperties.StatementId = esResponse.statementId;
    T.Properties.CustomProperties.ResultFormat = string(esResponse.manifest.format);
    T.Properties.CustomProperties.ResultFile = resultFile;
    T.Properties.CustomProperties.TotalRowCount = esResponse.manifest.totalRowCount;
    T.Properties.CustomProperties.TotalChunkCount = esResponse.manifest.totalChunkCount;
    T.Properties.CustomProperties.Truncated = esResponse.manifest.truncated;
end


function type = mapSchemaType2MATLAB(schemaType, typePrecision)
    % MAPSCHEMATYPE2MATLAB Convert a Databricks column type to a MATLAB type
    %
    % Complex SQL types and values that may lose precision are represented
    % as strings until result parsing can preserve their structure.

    arguments (Input)
        schemaType (1,1) databricks.datastructures.statementexecution.ColumnInfoType
        typePrecision int32
    end
    arguments (Output)
        type string
    end

    switch string(schemaType)
        case "BOOLEAN"
            type = "logical";
        case "BYTE"
            type = "int8";
        case "SHORT"
            type = "int16";
        case "INT"
            type = "int32";
        case "LONG"
            type = "int64";
        case "FLOAT"
            type = "single";
        case "DOUBLE"
            type = "double";
        case "DATE"
            type = "datetime";
        case "TIMESTAMP"
            type = "datetime";
        case "STRING"
            type = "string";
        case "BINARY"
            type = "string";
        case "DECIMAL"
            if isempty(typePrecision) || typePrecision <= 15
                type = "double";
            else
                type = "string";
            end
        case "INTERVAL"
            type = "string";
        case "ARRAY"
            type = "string";
        case "STRUCT"
            type = "string";
        case "MAP"
            type = "string";
        case "CHAR"
            type = "string";
        case "NULL"
            type = "string";
        case "USER_DEFINED_TYPE"
            type = "string";

        otherwise
            warning("DATABRICKS:response2Table", "Type not currently support: %s", schemaType)
            type = "string";
    end
end
