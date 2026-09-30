function tf = mkdirs(obj, pathArg, options)
    % MKDIRS Create a directory and necessary parent directories
    % Create a directory and necessary parent directories if they do not exist.
    % If there exists an object (not a directory) at any prefix of the input
    % Errors with RESOURCE_ALREADY_EXISTS. If this operation fails it may have
    % succeeded in creating some of the necessary parent directories.
    %
    % Before creating a directory, the status will be checked. If this path
    % is already a directory, it will not be `re-created'.
    %
    % Example
    %    ws = databricks.Workspace;
    %    pathArg = '/Users/joe@example.com/myproject';
    %    tf = ws.mkdirs(pathArg);
    %
    %  Adding verbose option will produce some output
    %
    %    ws.mkdirs(pathArg, verbose=true);
    
    %   (c) 2020-2026 The MathWorks, Inc.
    
    arguments 
        obj (1,1) databricks.Workspace
        pathArg (1,1) string
        options.verbose (1,1) logical = false
    end

    % Don't try to create an existing directory
    if obj.directoryExists(pathArg)
        if options.verbose
             fprintf('Directory already exists: %s\n', pathArg);
        end
        tf = true;
        return;
    end

    s = struct('path', pathArg);
    
    curAPI = 'workspace';
    apiMethod = 'mkdirs';
    curURI = obj.getURI(curAPI, apiMethod);
    
    % Create a request to create a secret scope
    request = obj.getRequestMessage;
    request.Method = matlab.net.http.RequestMethod.POST;
    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = jsonencode(s);
    
    % Call Databricks
    resp = request.send(curURI, databricks.internal.getHTTPOptions(convertResponse=true));
    % Process the response
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        if options.verbose
            fprintf('Created directory: %s\n', char(s.path));
        end
        tf = true;
    else
        matlab.databricks.internal.responseError(resp, sprintf('Failed to create directory: %s', char(s.path)));
        tf = false;
    end
end
