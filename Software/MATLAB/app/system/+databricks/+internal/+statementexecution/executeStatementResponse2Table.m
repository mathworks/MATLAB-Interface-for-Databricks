function T = executeStatementResponse2Table(esResponse, resultFile, options)
    % executeStatementResponse2Table Convert an INLINE table response to a MATLAB table

    % (c) 2023-2025 MathWorks Inc.

    arguments
        esResponse (1,1) databricks.statementexecution.models.executeStatement_200_response
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true;
    end

    if ~isprop(esResponse, "manifest")
        error("DATABRICKS:executeStatementResponse2Table", "Expect esResponse.manifest property not found.");
    end
    if ~isprop(esResponse.manifest, "schema")
        error("DATABRICKS:executeStatementResponse2Table", "Expect esResponse.manifest.schema property not found.");
    end
    if ~isprop(esResponse.manifest.schema, "column_count")
        error("DATABRICKS:executeStatementResponse2Table", "Expect esResponse.manifest.schema.column_count property not found.");
    end
    if ~isprop(esResponse.manifest, "format")
        error("DATABRICKS:executeStatementResponse2Table", "Expect esResponse.manifest.format property not found.");
    end
    if ~strcmp(esResponse.manifest.format, "JSON_ARRAY")
        error("DATABRICKS:executeStatementResponse2Table", "Only JSON_ARRAY format responses are supported.");
    end
    if ~isprop(esResponse.manifest, "total_row_count")
        error("DATABRICKS:executeStatementResponse2Table", "Expect esResponse.manifest.total_row_count property not found.");
    end
    if ~isprop(esResponse, "statement_id")
        error("DATABRICKS:executeStatementResponse2Table", "Expect esResponse.statement_id property not found.");
    end

    if esResponse.manifest.total_chunk_count ~= 1
        error("DATABRICKS:executeStatementResponse2Table", "Responses with more than one chunk are not supported.");
    end

    if esResponse.manifest.truncated
        error("DATABRICKS:executeStatementResponse2Table", "Truncated responses are not supported.");
    end

    if isempty(esResponse.manifest.schema.column_count) || esResponse.manifest.schema.column_count < 1 
        if options.verbose; fprintf("column_count empty or less than 1, returning an empty table\n"); end
        T = table;
        return;
    else
        nCols = esResponse.manifest.schema.column_count;
        if options.verbose; fprintf("Number of columns: %d\n", nCols); end
    end

    if numel(esResponse.manifest.schema.columns) ~= nCols
        error("DATABRICKS:executeStatementResponse2Table", "Expected number of Columns and number of schema entries to match");
    end

    if ~isfile(resultFile)
        error("DATABRICKS:executeStatementResponse2Table", "File not found: %s", resultFile);
    end

    variableNames = strings(nCols, 1);
    variableTypes = strings(nCols, 1);
    variableDescriptions = strings(nCols, 1);
    positions = int64(nCols); % positions index from 0
    for n = 1:nCols
        index = esResponse.manifest.schema.columns(n).position + 1;
        positions(n) = index;
        variableNames(index) = esResponse.manifest.schema.columns(n).name;
        variableTypes(index) = mapSchemaType2MATLAB(esResponse.manifest.schema.columns(n).type_name, esResponse.manifest.schema.columns(n).type_precision);
        variableDescriptions(index) = esResponse.manifest.schema.columns(n).type_text;
    end

    sz = [esResponse.manifest.total_row_count, nCols];
    T = table('Size', sz, 'VariableTypes', variableTypes, 'VariableNames', variableNames);
    T.Properties.Description = esResponse.statement_id;
    T.Properties.VariableDescriptions = variableDescriptions;
   
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

    % Return an empty Table only for now
    % TODO implement a GSON based parser for the resultFile contents
    fprintf(2, "Table population not yet implemented, for support contact: databricks@mathworks.com\n");
end


function type = mapSchemaType2MATLAB(schemaType, type_precision) %#ok<INUSD>
    switch (schemaType)
        case "BOOLEAN"
            type = "logical";
        case "BYTE"
            type = "uint8";
        % case "SHORT"
        case "INT"
            type = "int32";
        case "LONG"
            type = "int64";
        case "FLOAT"
            type = "single";
        case "DOUBLE"
            type = "double";
        case "DATE"
            type = datetime;
        case "TIMESTAMP"
            type = datetime;
        case "STRING"
            type = string;
        case "BINARY"
            type = "uint8";
        case "DECIMAL"
            % TODO consider type_precision value
            type = "double";
        case "INTERVAL"
            type = "duration";
        % case "ARRAY"
        % case "STRUCT"
        % case "MAP"
        case "CHAR"
            type = "char";
        %case "NULL"
        % case "USER_DEFINED_TYPE"

        otherwise
            warning("DATABRICKS:executeStatementResponse2Table", "Type not currently support: %s", schemaType)
    end
end
