function [resultFile, status, statementId, mlTable] = executeStatement(statement, warehouseId, options)
    % executeStatement High-level interface to the statement execution API
    %
    % Example:
    %   statement = "SELECT * FROM main.default.mytable LIMIT 1000";
    %   disposition = databricks.statementexecution.models.Disposition.EXTERNAL_LINKS;
    %   [result, status, statementId, T] = databricks.internal.statementexecution.executeStatement(statement, warehouseId, disposition=disposition, format="CSV")
    %
    % Note: MATLAB Table population not yet implemented for format type: JSON_ARRAY or ARROW_   STREAM.
    %       Contact: databricks@mathworks.com
    %
    % See also: https://docs.databricks.com/api/workspace/statementexecution

    % (c) 2023-2025 MathWorks Inc.

    arguments
        % Required
        statement string {mustBeTextScalar, mustBeNonzeroLengthText}
        warehouseId string {mustBeTextScalar, mustBeNonzeroLengthText}
        % ESR Optional
        options.disposition (1,1) databricks.statementexecution.models.Disposition = "INLINE"
        options.rowLimit (1,1) int64
        options.byteLimit (1,1) int64
        options.catalog string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.format databricks.statementexecution.models.Format = databricks.statementexecution.models.Format.JSON_ARRAY
        options.onWaitTimeout (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText} = "CONTINUE"
        options.schema string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.waitTimeout (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText} = "0s"
        % TODO parameters
        options.resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overWrite (1,1) logical = true
        options.verbose (1,1) logical = true
        options.debug (1,1) logical = false
    end

    statementId = string.empty;
    mlTable = table;
    resultFile = string.empty;
    status = databricks.statementexecution.models.StatementStatus.empty;

    se = databricks.statementexecution.api.StatementExecution;

    esr = databricks.statementexecution.models.ExecuteStatementRequest;
    % Required or have defaults
    esr.warehouse_id = warehouseId;
    esr.statement = statement;
    esr.disposition = options.disposition;
    esr.format = options.format;
    esr.on_wait_timeout = options.onWaitTimeout;
    esr.wait_timeout = options.waitTimeout;

    if isfield(options, 'byteLimit')
        esr.byte_limit = options.byteLimit;
    end
    if isfield(options, 'catalog')
        esr.catalog = options.catalog;
    end   
    if isfield(options, 'schema')
        esr.schema = options.schema;
    end
    if isfield(options, 'rowLimit')
        esr.row_limit = options.rowLimit;
    end
    
    if options.disposition == "INLINE" && options.format ~= "JSON_ARRAY"
        fprintf("Inline disposition can only be used with JSON_ARRAY formatted data.\n");
        return;
    end
    
    if isfield(options, 'resultFile')
        resultFile = options.resultFile;
    else
        if options.format == "JSON_ARRAY"
            ext = ".json";
        elseif options.format == "CSV"
            ext = ".csv";
        elseif options.format == "ARROW_STREAM"
            ext = ".arrow";
        else
            ext = ".unknown";
        end
        resultFile = "ExecuteStatementResult" + ext;
    end
    if (isfile(resultFile) || isfolder(resultFile)) && ~options.overWrite
        fprintf("resultFiles exists, not overwriting: %s\n", resultFile);
        return;
    end
    
    if options.verbose
        fprintf("Executing.\n");
    end
    [execCode, execResult, ~] = se.executeStatement(esr);

    if execCode ~= matlab.net.http.StatusCode.OK
        % The query failed some who report the result
        disp(execResult);
        error("DATABRICKS:executeStatement", "Error executing: %s", statement);
    else
        % The query worked there should be a statement Id that may be needed for
        % follow up queries
        if isprop(execResult, "statement_id")
            statementId = execResult.statement_id;
        else
            disp(execResult);
            error("DATABRICKS:executeStatement", "Expected statement_id property not found in response.")
        end

        % Create MLTable based on the Manifest
        while true
            if isprop(execResult, "status") && isprop(execResult.status, "state")
                state = execResult.status.state;
            else
                error("DATABRICKS:executeStatement", "Expected state property not found.");
            end

            switch state
                case "FAILED"
                    % execution failed; reason for failure described in accompanying error message
                    fprintf("\nExecution failed: %s, %s\n", execResult.status.error.error_code, execResult.status.error.message);
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
                    fprintf("\n");
                    truncated = writeChunks(se, execResult, resultFile, options.overWrite, options.disposition, options.format, verbose=options.verbose, debug=options.debug);
                    if nargout > 3
                        if truncated
                            fprintf("Response was truncated, returning an empty MATLAB table, for raw data see: %\n", resultFile);
                        else
                            if options.format == databricks.statementexecution.models.Format.JSON_ARRAY
                                mlTable = databricks.internal.statementexecution.executeStatementResponse2Table(execResult, resultFile, verbose=options.verbose);
                            elseif options.format == databricks.statementexecution.models.Format.CSV
                                % TODO populate a delimitedTextImportOptions from the execResult information
                                % Table population not yet implemented
                                mlTable = readtable(resultFile);
                            else
                                fprintf("Table creation is not supported for format: %s, returning an empty MATLAB table.\n", options.format)
                            end
                        end
                    end
                    status = execResult.status;
                    return;

                case {"PENDING", "RUNNING"}
                    % waiting for cluster/warehouse or running
                    if state == "RUNNING"
                        pause(1); % If the query is running be more impatient
                    else
                        pause(3);
                    end
                    if options.verbose
                        fprintf(".");
                    end
                    [gsCode, gsResult, ~] = se.getStatement(statementId);
                    if gsCode == 200
                        execResult = gsResult;
                    else
                        disp(gsResult);
                        error("DATABRICKS:executeStatement", "getStatement failed Id: %s", statementId);
                    end

                otherwise
                    error("DATABRICKS:executeStatement", "Unexpected state: %s", state);
            end
        end
    end
end


function [truncated, resultFile] = writeChunks(se, result, resultFile, overWrite, disposition, format, options)
    arguments
        se (1,1) databricks.statementexecution.api.StatementExecution
        result (1,1) databricks.statementexecution.models.executeStatement_200_response
        resultFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        overWrite (1,1) logical
        disposition (1,1) databricks.statementexecution.models.Disposition
        format (1,1) databricks.statementexecution.models.Format
        options.downloadTime (1,1) int32 = 1
        options.verbose (1,1) logical = true
        options.debug (1,1) logical = false
    end

    baseError = "DATABRICKS:executeStatement:writeChunks";

    % If in debug also make sure verbose is on
    if options.debug
        options.verbose = true;
    end

    if result.manifest.truncated
        truncated = true;
        if options.verbose
            fprintf("Returned data is truncated.\n");
        end
    else
        truncated = false;
    end

    if (isfile(resultFile) || isfolder(resultFile)) && ~overWrite
        error("File or folder exists, not overwriting: %s", resultFile);
    end

    if options.verbose
        fprintf("Downloading results.\n");
    end

    % Open the file that will hold the final results
    [fileID, errmsg] = fopen(resultFile, "w");
    if fileID == -1
        error(baseError, "Unable to open file for writing: %s, Message: %s", resultFile, errmsg);
    end
    onclcloseAfter = onCleanup(@() fclose(fileID));

    for n = 1:result.manifest.total_chunk_count
        % The first response includes results
        if n == 1
            resultData = result.result;
        else
            % Get the remaining chunks
            if options.debug
                fprintf("Getting chunk: %d of %d\n", n, result.manifest.total_chunk_count);
            end
            [ncCode, resultData, ncResponse] = getStatementResultChunkN(se, result.statement_id, n-1); %#ok<ASGLU>
            if ncCode ~= 200
                disp(ncResult);
                error(baseError, "Failed to get chunk: %d of %d", n, result.manifest.total_chunk_count);
            end
        end

        % Check for expired external links, allow 1 minute margin for the download by default
        if disposition == databricks.statementexecution.models.Disposition.EXTERNAL_LINKS
            dt = parseExpiryDate(resultData.external_links.expiration);
            if dt < datetime("now", TimeZone="UTC") + minutes(options.downloadTime)
                error(baseError, "Expired external link, chunk: %d of %d", n, result.manifest.total_chunk_count);
            end
        end

        if options.verbose
            if mod(n,40) == 0 || n == result.manifest.total_chunk_count
                fprintf(".\n");
            else
                fprintf(".");
            end
        end
        if disposition == databricks.statementexecution.models.Disposition.EXTERNAL_LINKS
            tmpName = [tempname,'.executeStatement'];
            tmpFile = websave(tmpName, resultData.external_links.external_link);
            [tmpFileID, errmsg] = fopen(tmpFile, "r");
            if tmpFileID == -1
                error(baseError, "Unable to open file for reading: %s, Message: %s", tmpFile, errmsg);
            end
            chunkData = fread(tmpFileID, '*char');
            fclose(tmpFileID);
            delete(tmpFile);
        else
            chunkData = resultData.data_array;
        end

        if options.debug
            fprintf("\nWriting chunk: %d of %d\n", n, result.manifest.total_chunk_count);
        end

        % If reading JSON_ARRAY chunks concatenate the chunks
        if format == databricks.statementexecution.models.Format.JSON_ARRAY
            if result.manifest.total_chunk_count > 1
                if n < result.manifest.total_chunk_count
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


function dt = parseExpiryDate(expDate)
    % Expects format: 23-Dec-2023 00:49:43
    arguments
        expDate string {mustBeTextScalar, mustBeNonzeroLengthText}
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
        warning("DATABRICKS:executeStatement", "Unmatched expiry date string: %s", expDate)
        newStr = expString;
    end

    dt = datetime(newStr, "InputFormat", "dd-MM-yyyy HH:mm:ss", "TimeZone", "UTC");
end