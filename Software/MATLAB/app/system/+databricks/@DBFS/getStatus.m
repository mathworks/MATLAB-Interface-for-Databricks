function fileList = getStatus(obj, varargin)
    % GETSTATUS Method to get the file information for a file or directory
    % Get the file information of a file or directory. An array of
    % databricks.datastructures.FileInfo objects is returned. If the file or directory does
    % not exist, this method will return an empty databricks.datastructures.FileInfo array.
    %
    %   db = databricks.DBFS();
    %   info = db.getStatus('/MATLAB/sample.mat');
    %
    % The path argument must be provided as a character vector or scalar
    % string. By default '/' is used.

    %  (c) 2019-2026 MathWorks, Inc.

    % Validation functions
    validString = @(x) ischar(x) || isStringScalar(x);

    %% Parse the inputs
    p = inputParser;
    p.addOptional('path','/',validString);
    parse(p,varargin{:});

    %% Create the request to create the tokens
    tokenURI = obj.getURI('dbfs', 'get-status');
    qp = matlab.net.QueryParameter();
    qp.Name = "path";
    qp.Value = p.Results.path;
    tokenURI.Query(end+1) = qp;
    request = obj.getRequestMessage('GET');

    % Call databricks, expect int64s in response
    resp = request.send(tokenURI, databricks.internal.getHTTPOptions(convertResponse=false));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        fileList = databricks.datastructures.FileInfo.fromJSON(resp.Body.Data);
    elseif resp.StatusCode == matlab.net.http.StatusCode.NotFound % 404
        fileList = databricks.datastructures.FileInfo.empty;
    else
        error('DATABRICKS:INVALIDRESPONSE',char(resp));
    end

end %function
