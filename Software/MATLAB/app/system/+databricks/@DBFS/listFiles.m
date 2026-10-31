function fileObjs = listFiles(obj, varargin)
    % LISTFILES Method to return a list of files on DBFS
    % List the files on DBFS.
    %
    %   % Create an interface and view all files in the root workspace
    %   db = databricks.DBFS();
    %   fileList = db.listFiles();
    %
    % Optionally, a target path will list the files in a particular folder.
    %
    %   % With an optional directory listing
    %   fileList = db.listFiles('/MATLAB');
    %
    % The returned list of FileInfo objects can be viewed as a table.
    %
    %   table(db.listFiles());
    %

    %  (c) 2019-2024 MathWorks, Inc.

    % Validation functions
    validString = @(x) ischar(x) || isstring(x);

    %% Parse the inputs
    p = inputParser;
    p.addOptional('path','/',validString);
    parse(p,varargin{:});

    %% Create the request to create the tokens
    dbfsURI = obj.getURI('dbfs', 'list');
    qp = matlab.net.QueryParameter();
    qp.Name = "path";
    qp.Value = p.Results.path;
    dbfsURI.Query(end+1) = qp;

    request = obj.getRequestMessage('GET');

    % Don't convert the response JSON to prevent int64s being converted to
    % doubles
    % Call databricks
    resp = request.send(dbfsURI, databricks.internal.getHTTPOptions(convertResponse=false));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Valid response so package and send back to user
        fileObjs = databricks.datastructures.FileInfo.fromJSON(resp.Body.Data);
    else
        error('DATABRICKS:INVALIDRESPONSE',char(resp));
    end

end %function
