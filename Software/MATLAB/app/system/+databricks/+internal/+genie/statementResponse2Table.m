function T = statementResponse2Table(sr, options)
    % STATEMENTRESPONSE2TABLE
    %
    % Example:
    %   [result, errorResponse] = g.getMsgAttachmentSQLQueryResult(spaceId, conversationId, messageId, attachmentId)
    %   MATLABTable = databricks.internal.genie.statementResponse2Table(result.StatementResponse);


    % Copyright 2025 The MathWorks, Inc.

    arguments
        sr (1,1) databricks.datastructures.genie.StatementResponse
        options.datetimeInputFormat string {mustBeTextScalar, mustBeNonzeroLengthText} = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        options.timeZone string {mustBeTextScalar, mustBeNonzeroLengthText} = "UTC";
    end

    sanityCheck(sr);

    T = createTable(sr);

    args = matlab.utils.addArgs(options, ["datetimeInputFormat", "timeZone"]);
    T = populateTable(sr, T, args{:});
end


function T = populateTable(sr, T, options)
    arguments
        sr databricks.datastructures.genie.StatementResponse
        T table
        options.datetimeInputFormat string {mustBeTextScalar, mustBeNonzeroLengthText} = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        options.timeZone string {mustBeTextScalar, mustBeNonzeroLengthText} = "UTC";
    end

    strArray = jsondecode(sr.result.dataArray);
    if numel(strArray) ~= height(T)
        error("DATABRICKS:GENIE:POPULATETABLE","Row count mismatch expected: %d, found: %d", height(T), numel(strArray));
    end

    for n = 1:numel(strArray)
        % strCell = jsondecode(strArray(n));
        
        if width(T) ~= numel(strArray{n})
            error("DATABRICKS:GENIE:POPULATETABLE","Column count mismatch, expect: %d, found %d", width(T), numel(strCell));
        end
        
        convertedCell = cell(1, width(T));
        rowCell = strArray{n};
        for m = 1:width(T)
            if T.Properties.VariableTypes(m) == "datetime"
                convertedCell{m} = convValue(rowCell{m}, T.Properties.VariableTypes(m), datetimeInputFormat=options.datetimeInputFormat, timeZone=options.timeZone);
            else
                convertedCell{m} = convValue(rowCell{m}, T.Properties.VariableTypes(m));
            end
        end

        % On the first pass set the timezone if set
        if n == 1
            for m = 1:width(T)
                if T.Properties.VariableTypes(m) == "datetime"
                    if isfield(options, "timeZone")
                        T.(T.Properties.VariableNames{m}).TimeZone = options.timeZone;
                    end
                end
            end
        end

        % Insert a row at a time
        T(n,:) = convertedCell;
    end
end


function result = convValue(input, type, options)
    arguments
        input char
        type string
        options.datetimeInputFormat string  = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        options.timeZone string {mustBeTextScalar, mustBeNonzeroLengthText} = "UTC"
    end

    switch type
        case "double"
            if ~isempty(input)
               result = double(string(input));
            else
                result = NaN;
            end

        case "logical"
            if strcmp(input, "0") || strcmpi(input, "false")
                result = false;
            elseif strcmp(input, "1") || strcmpi(input, "true")
                result = true;
            else
                error("Unable to convert: %s to a logical", input);
            end
            
        case "string"
            if ~isempty(input)
                result = string(input);
            else
                result = missing;
            end

        case "char"
            if ~isempty(input)
                result = char(input);
            else
                result = '';
            end

        case "single"
            if ~isempty(input)
                result = single(string(input));
            else
                result = NaN;
            end

        case "int64"
            if ~isempty(input)
                result = sscanf(input,'%ld');
            else
                result = intmin("int64");
            end

        case "int32"
            if ~isempty(input)
                result = sscanf(input,'%d');
            else
                result = intmin("int64");
            end

        case "datetime"
            if ~isempty(input)
                result = datetime(input, 'InputFormat', options.datetimeInputFormat, 'TimeZone', options.timeZone);
            else
                result = NaT;
            end

        otherwise
            error("Currently unsupported conversion type: %s", type);
    end
end


function T = createTable(sr)
    arguments
        sr (1,1) databricks.datastructures.genie.StatementResponse
    end

    ncols = sr.manifest.schema.columnCount;
    nrows = sr.manifest.totalRowCount;
    sz = [nrows, ncols];

    varNames = strings(ncols, 1);
    varTypes = strings(ncols, 1);
    varDescriptions = strings(ncols, 1);

    for n = 1:ncols
        % Column position is given position field no the natural index & is offset from 0
        position = sr.manifest.schema.columns(n).position + 1;

        % Populate varNames, these are the column names, must be valid variable names
        [varNames(position), modified] = matlab.lang.makeValidName(sr.manifest.schema.columns(n).name);
        if modified
            fprintf("Renamed column: %s to: %s\n", sr.manifest.schema.columns(n).name, varNames(position));
        end

        % Populate descriptions, this is metadata using the SQL names, generally not used
        varDescriptions(position) = sr.manifest.schema.columns(n).typeText;
        
        % Populate the MATLAB table types, this becomes the schema to target
        matlabTypeName = conv2MATLABType(sr.manifest.schema.columns(n).typeName, 0, 0);
        if matlabTypeName == "UNSUPPORTED"
            fprintf('Currently unsupported type: %s, using: "string"\n', sr.manifest.schema.columns(n).typeName);
            varTypes(position) = "string";
        else
            varTypes(position) = matlabTypeName;
        end
    end

    T = table('Size', sz, 'VariableTypes', varTypes, 'VariableNames', varNames);
    T.Properties.VariableDescriptions = varDescriptions;
end


function sanityCheck(sr)
    arguments
        sr (1,1) databricks.datastructures.genie.StatementResponse
    end

    if sr.status.state ~= "SUCCEEDED"
        fprintf("Warning Response state is not: SUCCEEDED, found: %s\n", sr.status.state);
    end

    if sr.manifest.truncated
        fprintf("Warning Response truncated.\n");
    end

    if sr.manifest.format ~= "JSON_ARRAY"
        error("DATABRICKS:RESULT2TABLE", "Only JSON_ARRAY format data is supported, found: %s", sr.manifest.format);
    end
end


function result = conv2MATLABType(name, typePrecision, typeScale)
    arguments
        name (1,1) databricks.datastructures.genie.TypeName
        typePrecision int32 %#ok<INUSA>
        typeScale int32 %#ok<INUSA>
    end

    switch name
        case "BOOLEAN"
            result = "logical";

        case "BYTE"
            result = "int8";

        case {"SHORT", "INT"}
            result = "int32";

        case "LONG"
            result = "int64";

        case "FLOAT"
            result = "single";

        case {"DOUBLE", "DECIMAL"}
            result = "double";

        case "DATE"
            result = "datetime";

        case "TIMESTAMP"
            result = "datetime";            

        case {"STRING", "CHAR"}
            result = "string";

        case {"BINARY", "INTERVAL", "ARRAY", "STRUCT", "MAP", "NULL", "USER_DEFINED_TYPE"}
            result = "UNSUPPORTED";

        otherwise
            error("Unexpected type: %s", name);
    end
end