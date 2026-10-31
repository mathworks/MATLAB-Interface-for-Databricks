function [mlTable, status, statementId] = runStatement(obj, statement, warehouseId, options)
    % RUNSTATEMENT Execute SQL and return a MATLAB table plus status
    %
    % Executes a SQL statement on a Databricks SQL warehouse and returns only
    % the converted MATLAB table and final statement status. Temporary result
    % data is written under tempdir and deleted after conversion.
    %
    % By default, this high-level wrapper uses INLINE disposition with
    % JSON_ARRAY format. If disposition is EXTERNAL_LINKS and format is not
    % specified, CSV format is used.
    %
    % If the statement does not reach SUCCEEDED state, mlTable is returned as
    % an empty MATLAB table.
    %
    % Examples:
    %
    %   statementExecution = databricks.StatementExecution;
    %   [mlTable, status, statementId] = statementExecution.runStatement( ...
    %       "SELECT * FROM samples.nyctaxi.trips LIMIT 10", warehouseId);
    %
    %   % If DATABRICKS_SQL_WAREHOUSE_ID is set, warehouseId can be omitted.
    %   [mlTable, status, statementId] = statementExecution.runStatement( ...
    %       "SELECT * FROM samples.nyctaxi.trips LIMIT 10");
    %
    %   statementExecution = databricks.StatementExecution;
    %   disposition = databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS;
    %   format = databricks.datastructures.statementexecution.Format.CSV;
    %   [mlTable, status, statementId] = statementExecution.runStatement( ...
    %       "SELECT * FROM samples.bakehouse.media_customer_reviews LIMIT 10", ...
    %       warehouseId, disposition=disposition, format=format, ...
    %       timeout=120, applySchemaTypes=true);
    %
    %   parameter = databricks.datastructures.statementexecution.Parameter( ...
    %       name="my_id", value="7", type="INT");
    %   queryTag = databricks.datastructures.statementexecution.QueryTag( ...
    %       key="client", value="matlab");
    %   [mlTable, status, statementId] = statementExecution.runStatement( ...
    %       "SELECT CAST(:my_id AS INT) AS int_col", warehouseId, ...
    %       parameters=parameter, queryTags=queryTag);
    %
    % Required Inputs:
    %   statement
    %       Description:
    %           SQL statement to execute.
    %       Type:
    %           string
    %
    % Optional Inputs:
    %   warehouseId
    %       Description:
    %           SQL warehouse ID to execute the statement on. If omitted or
    %           empty, runStatement uses the DATABRICKS_SQL_WAREHOUSE_ID
    %           environment variable.
    %       Type:
    %           string
    %
    % Name-Value Inputs:
    %   disposition
    %       Description:
    %           Result fetch disposition. When omitted, INLINE is used unless
    %           format implies EXTERNAL_LINKS.
    %       Type:
    %           databricks.datastructures.statementexecution.Disposition
    %       Default:
    %           databricks.datastructures.statementexecution.Disposition.INLINE
    %
    %   format
    %       Description:
    %           Result data format. When omitted, JSON_ARRAY is used with
    %           INLINE disposition and CSV is used with EXTERNAL_LINKS
    %           disposition.
    %       Type:
    %           databricks.datastructures.statementexecution.Format
    %       Default:
    %           databricks.datastructures.statementexecution.Format.JSON_ARRAY
    %           with INLINE; databricks.datastructures.statementexecution.Format.CSV
    %           with EXTERNAL_LINKS
    %
    %   timeout
    %       Description:
    %           Maximum total time in seconds for this function to
    %           wait while executing, polling, downloading, and converting the
    %           statement result. When the timeout is exceeded, runStatement
    %           attempts to cancel the remote Databricks statement when a
    %           statement ID is available and then errors.
    %       Type:
    %           double
    %       Default:
    %           Inf
    %
    %   parameters
    %       Description:
    %           SQL statement parameters for named parameter markers in the
    %           statement.
    %       Type:
    %           databricks.datastructures.statementexecution.Parameter
    %
    %   queryTags
    %       Description:
    %           Query tags used to annotate the SQL statement.
    %       Type:
    %           databricks.datastructures.statementexecution.QueryTag
    %
    %   applySchemaTypes
    %       Description:
    %           Use statement schema metadata to convert JSON_ARRAY and CSV
    %           result data to MATLAB table types. When false, CSV results use
    %           MATLAB type inference and JSON_ARRAY rows are returned as raw
    %           row strings in a single table variable without decoding values.
    %       Type:
    %           logical
    %       Default:
    %           true
    %
    %   verbose
    %       Description:
    %           Show progress output from statement execution.
    %       Type:
    %           logical
    %       Default:
    %           true
    %
    % Outputs:
    %   mlTable
    %       Description:
    %           MATLAB table created from the statement result when the
    %           statement succeeds; otherwise an empty table.
    %       Type:
    %           table
    %
    %   status
    %       Description:
    %           Final statement execution status.
    %       Type:
    %           databricks.datastructures.statementexecution.Status
    %
    %   statementId
    %       Description:
    %           Id of the statement, can be used for diagnostics.
    %       Type:
    %           Scalar string
    %
    % See also: execute

    % Copyright 2026, The MathWorks, Inc.
    
    arguments (Input)
        obj databricks.StatementExecution
        statement string {mustBeTextScalar, mustBeNonzeroLengthText}
        warehouseId string = string.empty
        options.disposition (1,1) databricks.datastructures.statementexecution.Disposition
        options.format (1,1) databricks.datastructures.statementexecution.Format
        options.timeout (1,1) double {mustBeReal, mustBeNonnegative} = Inf
        options.parameters databricks.datastructures.statementexecution.Parameter
        options.queryTags databricks.datastructures.statementexecution.QueryTag
        options.applySchemaTypes (1,1) logical = true
        options.verbose (1,1) logical = true
        options.debug (1,1) logical = false
    end
    arguments (Output)
        mlTable table
        status databricks.datastructures.statementexecution.Status
        statementId string
    end

    assert(~isempty(obj.HTTPOptions), "DATABRICKS:StatementExecution:runStatement", ...
        "StatementExecution HTTP options are not configured.");

    warehouseId = resolveWarehouseId(warehouseId);
    [disposition, format] = resolveResultMode(options);

    resultFileArg = string(tempname(tempdir)) + getResultFileExtension(format);
    cleanup = onCleanup(@() deleteResultFile(resultFileArg));

    args = { ...
        "disposition", disposition, ...
        "format", format, ...
        "resultFile", resultFileArg, ...
        "overWrite", true, ...
        "timeout", options.timeout, ...
        "applySchemaTypes", options.applySchemaTypes, ...
        "debug", options.debug, ...
        "verbose", options.verbose};
    args = matlab.utils.addArgs(options, ["parameters", "queryTags"], args);

    [~, status, statementId, mlTable] = databricks.internal.statementexecution.runStatementImpl( ...
        statement, warehouseId, args{:});

    if isempty(status) || status.state ~= databricks.datastructures.statementexecution.State.SUCCEEDED
        mlTable = table;
    end

    clear cleanup
end


function warehouseId = resolveWarehouseId(warehouseId)
    % RESOLVEWAREHOUSEID Use explicit warehouse ID or environment fallback

    arguments (Input)
        warehouseId string = string.empty
    end
    arguments (Output)
        warehouseId (1,1) string
    end

    if isempty(warehouseId) || strlength(strtrim(warehouseId)) == 0
        warehouseId = string(getenv("DATABRICKS_SQL_WAREHOUSE_ID"));
    end
    warehouseId = strtrim(warehouseId);
    assert(strlength(warehouseId) > 0, "DATABRICKS:StatementExecution:runStatement", ...
        "Specify warehouseId or set the DATABRICKS_SQL_WAREHOUSE_ID environment variable.");
end


function [disposition, format] = resolveResultMode(options)
    % RESOLVERESULTMODE Select disposition and format defaults

    arguments (Input)
        options (1,1) struct
    end
    arguments (Output)
        disposition (1,1) databricks.datastructures.statementexecution.Disposition
        format (1,1) databricks.datastructures.statementexecution.Format
    end

    hasDisposition = isfield(options, "disposition");
    hasFormat = isfield(options, "format");

    if hasDisposition
        disposition = options.disposition;
    elseif hasFormat
        disposition = getDefaultDisposition(options.format);
    else
        disposition = databricks.datastructures.statementexecution.Disposition.INLINE;
    end

    if hasFormat
        format = options.format;
    else
        format = getDefaultFormat(disposition);
    end
end


function disposition = getDefaultDisposition(format)
    % GETDEFAULTDISPOSITION Select a disposition for a requested format

    arguments (Input)
        format (1,1) databricks.datastructures.statementexecution.Format
    end
    arguments (Output)
        disposition (1,1) databricks.datastructures.statementexecution.Disposition
    end

    if format == databricks.datastructures.statementexecution.Format.JSON_ARRAY
        disposition = databricks.datastructures.statementexecution.Disposition.INLINE;
    else
        disposition = databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS;
    end
end


function format = getDefaultFormat(disposition)
    % GETDEFAULTFORMAT Select the default result format for a disposition

    arguments (Input)
        disposition (1,1) databricks.datastructures.statementexecution.Disposition
    end
    arguments (Output)
        format (1,1) databricks.datastructures.statementexecution.Format
    end

    if disposition == databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS
        format = databricks.datastructures.statementexecution.Format.CSV;
    else
        format = databricks.datastructures.statementexecution.Format.JSON_ARRAY;
    end
end


function extension = getResultFileExtension(format)
    % GETRESULTFILEEXTENSION Select a temporary result file extension

    arguments (Input)
        format (1,1) databricks.datastructures.statementexecution.Format
    end
    arguments (Output)
        extension (1,1) string
    end

    switch format
        case databricks.datastructures.statementexecution.Format.CSV
            extension = ".csv";
        case databricks.datastructures.statementexecution.Format.JSON_ARRAY
            extension = ".json";
        case databricks.datastructures.statementexecution.Format.ARROW_STREAM
            extension = ".arrow";
        otherwise
            extension = ".result";
    end
end


function deleteResultFile(resultFile)
    % DELETERESULTFILE Delete the temporary statement result file if present

    arguments (Input)
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if isfile(resultFile)
        delete(resultFile);
    end
end
