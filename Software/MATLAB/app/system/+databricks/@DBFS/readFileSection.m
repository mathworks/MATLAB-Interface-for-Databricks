function [rawBytes, numBytes] = readFileSection(obj, pathStr, offset, length)
    % READFILESECTION Internal method to read a chunk from a DBFS file
    %
    % For example:
    %
    %   db = databricks.DBFS;
    %   data = db.read('/example/sample.mat');
    %
    %   % Create a file and save it.
    %   fid = fopen('sample.mat');
    %   fwrite(fid, data);
    %   fclose(fid);
    %

    %  (c) 2019-2024 MathWorks, Inc.

    offsetStr = num2str(offset);
    lenStr = num2str(length);

    %% Create the request to read the file
    dbfsURI = obj.getURI('dbfs', 'read');
    dbfsURI.Query(end+1) = matlab.net.QueryParameter("path", pathStr);
    dbfsURI.Query(end+1) = matlab.net.QueryParameter("offset", offsetStr);
    dbfsURI.Query(end+1) = matlab.net.QueryParameter("length", lenStr);

    request = obj.getRequestMessage('GET');
    % Call databricks
    resp = request.send(dbfsURI, databricks.internal.getHTTPOptions(convertResponse=true));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Valid response so package and send back to user
        rawBytes = matlab.net.base64('decode', resp.Body.Data.data);
        numBytes = resp.Body.Data.bytes_read;

    else
        if isstruct(resp.Body.Data)
            if isfield(resp.Body.Data, 'error_code') && isfield(resp.Body.Data, 'message')
                error('DATABRICKS:ERROR', 'Failed to read data: %s\n  error_code: %s\n  message: %s', ...
                       char(pathStr), char(resp.Body.Data.error_code), char(resp.Body.Data.message));
            else
                error('DATABRICKS:ERROR', 'Failed to read data: %s\n  unexpected response body data struct', char(pathStr));
            end
        elseif ischar(resp.Body.Data) ||  isStringScalar(resp.Body.Data)
            error('DATABRICKS:ERROR', 'Failed to read data: %s\n  %s', char(pathStr), char(resp.Body.Data));
        else
            error('DATABRICKS:ERROR', 'Failed to read data: %s\n  unexpected response body data', char(pathStr));
        end
    end

end %function
