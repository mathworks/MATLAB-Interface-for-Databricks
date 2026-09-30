function [result, errorResponse] = initiateUpload(obj, destination, options)
    % initiateUpload Caution - Undocumented Databricks feature
    % The method is not supported may be removed without further notice 

    % Copyright 2026 The MathWorks, Inc.

    arguments
        obj databricks.Files
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.overwrite (1,1) logical = true
    end

    URI = obj.getURI('fs', 'files');
    [~, pathArray] = databricks.Files.escapePath(destination);
    URI.Path = [URI.Path, pathArray];

    URI.Query(end+1) = matlab.net.QueryParameter("action", "initiate-upload");
    URI.Query(end+1) = matlab.net.QueryParameter("overwrite", string(options.overwrite));

    request = obj.getRequestMessage('POST');

    % Perform the actual call
    warning('off', 'MATLAB:http:BodyExpectedFor');
    resp = request.send(URI, obj.HTTPOptions);
    warning('on', 'MATLAB:http:BodyExpectedFor');

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = jsondecode(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = struct.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
