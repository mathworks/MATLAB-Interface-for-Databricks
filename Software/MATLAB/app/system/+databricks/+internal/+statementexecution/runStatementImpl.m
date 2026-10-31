function [resultFile, status, statementId, mlTable] = runStatementImpl(statement, warehouseId, options)
    % RUNSTATEMENTIMPL Execute SQL through the Databricks Statement Execution API
    %
    % Executes a SQL statement on the specified SQL warehouse, polls until the
    % statement reaches a terminal state, and writes the returned result chunks
    % to a local result file.
    %
    % Required Inputs:
    %   statement
    %       SQL statement to execute.
    %
    % Optional Inputs:
    %   warehouseId
    %       SQL warehouse ID to execute the statement on. If omitted or empty,
    %       runStatementImpl uses the DATABRICKS_SQL_WAREHOUSE_ID environment
    %       variable.
    %
    % Name-Value Inputs:
    %   disposition
    %       Result fetch disposition. Defaults to INLINE.
    %
    %   format
    %       Result format. Defaults to JSON_ARRAY.
    %
    %   resultFile
    %       Local file path used to write result data. If omitted, a file name
    %       is selected from the requested result format.
    %
    %   waitTimeout
    %       Time for Databricks to wait before returning the initial statement
    %       response. If omitted, wait_timeout is not set in the request and
    %       the Databricks API default applies.
    %
    %   timeout
    %       Maximum total time in seconds for this blocking helper to spend
    %       executing, polling, downloading, and converting the statement
    %       result. When the timeout is exceeded after a statement ID has
    %       been returned, runStatementImpl attempts to cancel the remote
    %       Databricks statement before erroring. Defaults to Inf.
    %
    %   parameters
    %       SQL statement parameters for named parameter markers in the
    %       statement.
    %
    %   queryTags
    %       Query tags used to annotate the SQL statement.
    %
    %   applySchemaTypes
    %       Use statement schema metadata to convert JSON_ARRAY and CSV result
    %       data to MATLAB table types. When false, CSV results use MATLAB type
    %       inference and JSON_ARRAY rows are returned as raw row strings in a
    %       single table variable without decoding values. Defaults to true.
    %
    % Outputs:
    %   resultFile
    %       Local result file path.
    %
    %   status
    %       Final statement execution status.
    %
    %   statementId
    %       Databricks statement ID returned by the API.
    %
    %   mlTable
    %       MATLAB table created from the result file when supported.
    %       Otherwise an empty table may be returned.
    %
    % Example:
    %   statement = "SELECT * FROM main.default.mytable LIMIT 1000";
    %   disposition = databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS;
    %   [resultFile, status, statementId, T] = databricks.internal.statementexecution.runStatementImpl( ...
    %       statement, warehouseId, disposition=disposition, ...
    %       format=databricks.datastructures.statementexecution.Format.CSV);
    %
    % Note: MATLAB table creation is supported for JSON_ARRAY and CSV
    % result formats.
    %
    % Sample query to require a multi chunk download:
    %   statementExecution = databricks.StatementExecution;
    %   statement = "SELECT * FROM samples.tpcds_sf1000.customer LIMIT 100000";
    %   [mlTable, status, statementId] = statementExecution.runStatement(statement, debug =true)
    %
    % See also: runStatement, databricks.internal.statementexecution.response2Table,
    % https://docs.databricks.com/api/workspace/statementexecution

    % (c) 2023-2026 MathWorks Inc.

    arguments (Input)
        % Required
        statement string {mustBeTextScalar, mustBeNonzeroLengthText}
        warehouseId string = string.empty
        % ESR Optional
        options.disposition (1,1) databricks.datastructures.statementexecution.Disposition = "INLINE"
        options.rowLimit (1,1) int64
        options.byteLimit (1,1) int64
        options.catalog string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.format databricks.datastructures.statementexecution.Format = databricks.datastructures.statementexecution.Format.JSON_ARRAY
        options.onWaitTimeout (1,1) databricks.datastructures.statementexecution.TimeoutAction = "CONTINUE"
        options.schema string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.waitTimeout (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.timeout (1,1) double {mustBeReal, mustBeNonnegative} = Inf
        options.parameters databricks.datastructures.statementexecution.Parameter
        options.queryTags databricks.datastructures.statementexecution.QueryTag
        options.resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overWrite (1,1) logical = true
        options.applySchemaTypes (1,1) logical = true
        options.verbose (1,1) logical = true
        options.debug (1,1) logical = false
    end
    arguments (Output)
        resultFile string
        status databricks.datastructures.statementexecution.Status
        statementId string
        mlTable table
    end

    mlTable = table;
    se = databricks.StatementExecution;
    warehouseId = resolveWarehouseId(warehouseId);

    esr = databricks.datastructures.statementexecution.ExecuteStatementRequest;
    % Required or have defaults
    esr.warehouseId = warehouseId;
    esr.statement = statement;
    esr.disposition = options.disposition;
    esr.format = options.format;
    esr.onWaitTimeout = options.onWaitTimeout;

    if isfield(options, 'waitTimeout')
        esr.waitTimeout = options.waitTimeout;
    end
    if isfield(options, 'byteLimit')
        esr.byteLimit = options.byteLimit;
    end
    if isfield(options, 'catalog')
        esr.catalog = options.catalog;
    end   
    if isfield(options, 'schema')
        esr.schema = options.schema;
    end
    if isfield(options, 'rowLimit')
        esr.rowLimit = options.rowLimit;
    end
    if isfield(options, 'parameters')
        esr.parameters = options.parameters;
    end
    if isfield(options, 'queryTags')
        esr.queryTags = options.queryTags;
    end
    % If enabling debug output, enable verbose output
    if options.debug
        verbose = true;
    else
        verbose = options.verbose;
    end
    
    if options.disposition == databricks.datastructures.statementexecution.Disposition.INLINE && ...
            options.format ~= databricks.datastructures.statementexecution.Format.JSON_ARRAY
        error("DATABRICKS:runStatementImpl:InvalidResultMode", ...
            "Inline disposition can only be used with JSON_ARRAY formatted data.");
    end

    if options.debug
        fprintf("Disposition: %s\n", options.disposition);
        fprintf("Format: %s\n", options.format);
    end

    startTime = tic;
    assertNotTimedOut(startTime, options.timeout);
    
    if isfield(options, 'resultFile')
        resultFile = options.resultFile;
    else
        switch options.format
            case databricks.datastructures.statementexecution.Format.JSON_ARRAY
                ext = ".json";
            case databricks.datastructures.statementexecution.Format.CSV
                ext = ".csv";
            case databricks.datastructures.statementexecution.Format.ARROW_STREAM
                ext = ".arrow";
            otherwise
                ext = ".unknown";
        end
        resultFile = string(tempname) + ext;
    end
    if verbose
        fprintf("Executing.\n");
    end
    assertNotTimedOut(startTime, options.timeout);
    [execResult, errorResponse] = se.execute(esr);

    if ~isempty(errorResponse)
        % The query failed some who report the result
        disp(errorResponse);
        error("DATABRICKS:runStatementImpl:ExecuteFailed", "Error executing: %s", statement);
    else
        % The query worked there should be a statement Id that may be needed for
        % follow up queries
        if isprop(execResult, "statementId")
            statementId = execResult.statementId;
            assertNotTimedOut(startTime, options.timeout, se, statementId, getStatusState(execResult), verbose);
        else
            disp(execResult);
            error("DATABRICKS:runStatementImpl:MissingStatementId", "Expected statement_id property not found in response.")
        end

        % Create mlTable based on the Manifest
        progressDotCount = 0;
        while true
            if isprop(execResult, "status") && isprop(execResult.status, "state")
                state = execResult.status.state;
            else
                error("DATABRICKS:runStatementImpl:MissingState", "Expected state property not found.");
            end

            switch state
                case "FAILED"
                    % execution failed; reason for failure described in accompanying error message
                    fprintf("\nExecution failed: %s, %s\n", execResult.status.error.errorCode, execResult.status.error.message);
                    status = execResult.status;
                    return;

                case "CANCELED"
                    % user canceled; can come from explicit cancel call, or timeout with on_wait_timeout=CANCEL
                    fprintf("\nExecution cancelled.\n");
                    status = execResult.status;
                    return;

                case "CLOSED"
                    % execution successful, and statement closed; result no longer available for fetch
                    fprintf("\nExecution successful, statement closed.\n");
                    status = execResult.status;
                    return;

                case "SUCCEEDED"
                    % write it to result file and optional mlTable
                    if verbose
                        fprintf("\n");
                    end
                    assertNotTimedOut(startTime, options.timeout, se, statementId, state, verbose);
                    truncated = writeChunks(se, execResult, resultFile, options.overWrite, options.disposition, options.format, verbose=verbose, debug=options.debug);
                    assertNotTimedOut(startTime, options.timeout, se, statementId, state, verbose);
                    if nargout > 3
                        if truncated
                            mlTable = table;
                            fprintf("Response was truncated, returning an empty MATLAB table, for raw data see: %s\n", resultFile);
                        elseif supportsTableConversion(options.format)
                            assertNotTimedOut(startTime, options.timeout, se, statementId, state, verbose);
                            if options.debug
                                fprintf("Converting response to a MATLAB table.\n");
                            end
                            mlTable = databricks.internal.statementexecution.response2Table( ...
                                execResult, resultFile, ...
                                applySchemaTypes=options.applySchemaTypes, ...
                                verbose=verbose);
                            assertNotTimedOut(startTime, options.timeout, se, statementId, state, verbose);
                        else
                            mlTable = table;
                            if verbose
                                fprintf("Table creation is not supported for format: %s, returning an empty MATLAB table.\n", options.format)
                            end
                        end
                    end
                    status = execResult.status;
                    return;

                case {"PENDING", "RUNNING"}
                    if state == "RUNNING"
                        % If the query is running be more impatient
                        pause(getPauseDuration(startTime, options.timeout, 4, se, statementId, state, verbose));
                    else
                        % Wait a bit longer if pending
                        pause(getPauseDuration(startTime, options.timeout, 8, se, statementId, state, verbose));
                    end
                    assertNotTimedOut(startTime, options.timeout, se, statementId, state, verbose);
                    if verbose
                        progressDotCount = progressDotCount + 1;
                        if mod(progressDotCount, 40) == 0
                            fprintf(".\n");
                        else
                            fprintf(".");
                        end
                    end
                    [gsResult, getStatementError] = se.getStatement(statementId);
                    if isempty(getStatementError)
                        execResult = gsResult;
                        assertNotTimedOut(startTime, options.timeout, se, statementId, getStatusState(execResult), verbose);
                    else
                        disp(getStatementError);
                        error("DATABRICKS:runStatementImpl:GetStatementFailed", "getStatement failed Id: %s", statementId);
                    end

                otherwise
                    error("DATABRICKS:runStatementImpl:UnexpectedState", "Unexpected state: %s", state);
            end
        end
    end
end


function pauseDuration = getPauseDuration(startTime, timeout, requestedPause, se, statementId, state, verbose)
    % GETPAUSEDURATION Bound polling sleep by the total timeout

    arguments (Input)
        startTime (1,1) uint64
        timeout (1,1) double {mustBeReal, mustBeNonnegative}
        requestedPause (1,1) double {mustBeReal, mustBeNonnegative}
        se = []
        statementId string = string.empty
        state string = string.empty
        verbose (1,1) logical = true
    end
    arguments (Output)
        pauseDuration (1,1) double
    end

    if isinf(timeout)
        pauseDuration = requestedPause;
        return
    end

    remainingTime = timeout - toc(startTime);
    if remainingTime <= 0
        assertNotTimedOut(startTime, timeout, se, statementId, state, verbose);
    end
    pauseDuration = min(requestedPause, remainingTime);
end


function assertNotTimedOut(startTime, timeout, se, statementId, state, verbose)
    % ASSERTNOTTIMEDOUT Error when the total statement timeout is exceeded

    arguments (Input)
        startTime (1,1) uint64
        timeout (1,1) double {mustBeReal, mustBeNonnegative}
        se = []
        statementId string = string.empty
        state string = string.empty
        verbose (1,1) logical = true
    end

    if ~isinf(timeout) && toc(startTime) >= timeout
        if isscalar(state) && (state == "PENDING" || state == "RUNNING")
            cancelTimedOutStatement(se, statementId, verbose);
        end
        error("DATABRICKS:runStatementImpl:Timeout", ...
            "Statement execution exceeded the timeout of %.3g seconds.", timeout);
    end
end


function state = getStatusState(execResult)
    % GETSTATUSSTATE Return statement state when it is available

    arguments (Input)
        execResult
    end
    arguments (Output)
        state string
    end

    if isprop(execResult, "status") && isprop(execResult.status, "state")
        state = string(execResult.status.state);
    else
        state = string.empty;
    end
end


function cancelTimedOutStatement(se, statementId, verbose)
    % CANCELTIMEDOUTSTATEMENT Best-effort remote cancellation

    arguments (Input)
        se
        statementId string
        verbose (1,1) logical
    end

    if isempty(se) || isempty(statementId) || strlength(statementId) == 0
        return
    end

    try
        [cancelResult, cancelError] = se.cancelExecution(statementId);
        if verbose
            if cancelResult
                fprintf("\nStatement timed out; cancellation requested for statement ID: %s\n", statementId);
            elseif ~isempty(cancelError)
                fprintf("\nStatement timed out; cancellation failed for statement ID: %s\n", statementId);
                disp(cancelError);
            end
        end
    catch ME
        if verbose
            fprintf("\nStatement timed out; cancellation attempt failed for statement ID: %s\n%s\n", ...
                statementId, ME.message);
        end
    end
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
    assert(strlength(warehouseId) > 0, "DATABRICKS:runStatementImpl:MissingWarehouseId", ...
        "Specify warehouseId or set the DATABRICKS_SQL_WAREHOUSE_ID environment variable.");
end


function tf = supportsTableConversion(format)
    % SUPPORTSTABLECONVERSION True when result format can produce mlTable

    arguments (Input)
        format (1,1) databricks.datastructures.statementexecution.Format
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = format == databricks.datastructures.statementexecution.Format.JSON_ARRAY || ...
        format == databricks.datastructures.statementexecution.Format.CSV;
end


function [truncated, resultFile] = writeChunks(se, result, resultFile, overWrite, disposition, format, options)
    % WRITECHUNKS Write statement result chunks to a local file
    %
    % Downloads EXTERNAL_LINKS chunks or serializes INLINE JSON_ARRAY chunks,
    % concatenating multi-chunk JSON_ARRAY responses when needed.
    %
    % Outputs:
    %   truncated
    %       True when the result manifest indicates truncated results.
    %
    %   resultFile
    %       Local result file path written by this helper.

    arguments (Input)
        se (1,1) databricks.StatementExecution
        result (1,1) databricks.datastructures.statementexecution.StatementResponse
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        overWrite (1,1) logical
        disposition (1,1) databricks.datastructures.statementexecution.Disposition
        format (1,1) databricks.datastructures.statementexecution.Format
        options.downloadTime (1,1) int32 = 1
        options.verbose (1,1) logical = true
        options.debug (1,1) logical = false
    end
    arguments (Output)
        truncated (1,1) logical
        resultFile string
    end

    baseError = "DATABRICKS:runStatementImpl:writeChunks";

    % If in debug also make sure verbose is on
    if options.debug
        verbose = true;
    else
        verbose = options.verbose;
    end

    if result.manifest.truncated
        truncated = true;
        if verbose
            fprintf("Returned data is truncated.\n");
        end
    else
        truncated = false;
    end

    if (isfile(resultFile) || isfolder(resultFile)) && ~overWrite
        error(baseError + ":ResultFileExists", ...
            "Result file or folder exists, not overwriting: %s", resultFile);
    end

    if verbose
        fprintf("Downloading results.\n");
    end

    % Open the file that will hold the final results
    [fileID, errmsg] = fopen(resultFile, "w");
    if fileID == -1
        error(baseError + ":OpenResultFileFailed", ...
            "Unable to open file for writing: %s, Message: %s", resultFile, errmsg);
    end
    onclcloseAfter = onCleanup(@() fclose(fileID));

    if result.manifest.totalChunkCount == 0
        if result.manifest.totalRowCount ~= 0
            error(baseError + ":InvalidZeroChunkManifest", ...
                "Expected zero chunks only for zero-row results.");
        end
        if format == databricks.datastructures.statementexecution.Format.JSON_ARRAY
            fwrite(fileID, "[]", 'char');
        end
        return
    end

    for n = 1:result.manifest.totalChunkCount
        % The first response includes results
        if n == 1
            resultData = result.result;
        else
            % Get the remaining chunks
            if options.debug
                fprintf("Getting chunk: %d of %d\n", n, result.manifest.totalChunkCount);
            end
            [resultData, resultChunkError] = se.getResultChunkN(result.statementId, int32(n-1));
            if ~isempty(resultChunkError)
                disp(resultChunkError);
                error(baseError + ":GetResultChunkFailed", ...
                    "Failed to get chunk: %d of %d", n, result.manifest.totalChunkCount);
            end
        end

        % Check for expired external links, allow 1 minute margin for the download by default
        if disposition == databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS
            externalLink = resultData.externalLinks(1);
            dt = normalizeExpiryDate(externalLink.expiration);
            if dt < datetime("now", TimeZone="UTC") + minutes(options.downloadTime)
                error(baseError + ":ExpiredExternalLink", ...
                    "Expired external link, chunk: %d of %d", n, result.manifest.totalChunkCount);
            end
        end

        if verbose
            if mod(n,40) == 0 || n == result.manifest.totalChunkCount
                fprintf(".\n");
            else
                fprintf(".");
            end
        end
        if disposition == databricks.datastructures.statementexecution.Disposition.EXTERNAL_LINKS
            tmpName = [tempname,'.runStatement'];
            tmpFile = websave(tmpName, externalLink.externalLink);
            [tmpFileID, errmsg] = fopen(tmpFile, "r");
            if tmpFileID == -1
                error(baseError + ":OpenChunkFileFailed", ...
                    "Unable to open file for reading: %s, Message: %s", tmpFile, errmsg);
            end
            chunkData = fread(tmpFileID, '*char');
            fclose(tmpFileID);
            delete(tmpFile);
        else
            chunkData = char(jsonencode(resultData.dataArray));
        end

        if options.debug
            fprintf("\nWriting chunk: %d of %d\n", n, result.manifest.totalChunkCount);
        end

        % If reading JSON_ARRAY chunks concatenate the chunks
        if format == databricks.datastructures.statementexecution.Format.JSON_ARRAY
            if result.manifest.totalChunkCount > 1
                if n < result.manifest.totalChunkCount
                    if chunkData(end-2) == '"' && chunkData(end-1) == ']' && chunkData(end) == ']'
                        chunkData(end) = ',';
                    end
                end
                if n > 1
                    if chunkData(1) == '[' && chunkData(2) == '[' && chunkData(3) == '"'
                        chunkData(1) = [];
                    end
                end
            end
        end
        fwrite(fileID, chunkData, 'char');
    end
end


function dt = normalizeExpiryDate(expDate)
    % NORMALIZEEXPIRYDATE Convert an external-link expiration to UTC datetime
    %
    % Datetime inputs are normalized to UTC before comparison. Naive datetime
    % inputs are interpreted as UTC. ISO/RFC3339 strings and legacy generated
    % client strings, for example "23-Dec-2023 00:49:43", are supported.

    arguments (Input)
        expDate
    end
    arguments (Output)
        dt (1,1) datetime
    end

    errorId = "DATABRICKS:runStatementImpl:normalizeExpiryDate";

    if isdatetime(expDate)
        if ~isscalar(expDate)
            error(errorId + ":NonScalarDatetime", "Expected expiry date to be a scalar datetime.");
        end
        if ismissing(expDate)
            error(errorId + ":MissingDatetime", "Expected expiry date to be a valid datetime, not NaT.");
        end
        dt = expDate;
        if isempty(dt.TimeZone)
            dt.TimeZone = "UTC";
            return
        end
        dt.TimeZone = "UTC";
        return
    end

    expDate = string(expDate);
    if ~isscalar(expDate) || ismissing(expDate) || strlength(expDate) == 0
        error(errorId + ":InvalidText", "Expected expiry date to be scalar non-missing text.");
    end

    isoFormats = [
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        "yyyy-MM-dd'T'HH:mm:ssZ"
        "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        "yyyy-MM-dd'T'HH:mm:ssXXX"
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        "yyyy-MM-dd'T'HH:mm:ss'Z'"
    ];
    for idx = 1:numel(isoFormats)
        try
            dt = datetime(expDate, InputFormat=isoFormats(idx), TimeZone="UTC");
            if ~ismissing(dt)
                dt.TimeZone = "UTC";
                return
            end
        catch
        end
    end

    if contains(expDate, "-Jan-")
        newStr = strrep(expDate, "-Jan-", "-01-");
    elseif contains(expDate, "-Feb-")
        newStr = strrep(expDate, "-Feb-", "-02-");
    elseif contains(expDate, "-Mar-")
        newStr = strrep(expDate, "-Mar-", "-03-");
    elseif contains(expDate, "-Apr-")
        newStr = strrep(expDate, "-Apr-", "-04-");
    elseif contains(expDate, "-May-")
        newStr = strrep(expDate, "-May-", "-05-");
    elseif contains(expDate, "-Jun-")
        newStr = strrep(expDate, "-Jun-", "-06-");
    elseif contains(expDate, "-Jul-")
        newStr = strrep(expDate, "-Jul-", "-07-");
    elseif contains(expDate, "-Aug-")
        newStr = strrep(expDate, "-Aug-", "-08-");
    elseif contains(expDate, "-Sep-")
        newStr = strrep(expDate, "-Sep-", "-09-");
    elseif contains(expDate, "-Oct-")
        newStr = strrep(expDate, "-Oct-", "-10-");
    elseif contains(expDate, "-Nov-")
        newStr = strrep(expDate, "-Nov-", "-11-");
    elseif contains(expDate, "-Dec-")
        newStr = strrep(expDate, "-Dec-", "-12-");
    else
        error(errorId + ":UnsupportedMonth", "Unsupported expiry date string format: %s", expDate);
    end

    try
        dt = datetime(newStr, "InputFormat", "dd-MM-yyyy HH:mm:ss", "TimeZone", "UTC");
    catch
        error(errorId + ":ParseFailed", "Unsupported expiry date string format: %s", expDate);
    end

    if ismissing(dt)
        error(errorId + ":ParsedMissing", "Unsupported expiry date string format: %s", expDate);
    end
end
