function rm(obj, path, varargin)
% RM Method to delete a folder or file from DBFS
% Delete the file or directory (optionally recursively delete all files in
% the directory).
%
%   rm(ABSOLUTEPATH, RECURSIVEFLAG);
%
% To delete a folder/file:
%
%   db = databricks.DBFS();
%   db.rm('/Data');
%
% This will delete files and folders as long as they are not empty. To
% delete the entire folder recursively, provide an additional recursive flag
%
%   db.rm('/Data', true);
%
% If the specified file or folder does not exist the operation will still
% complete without error, displaying "Delete complete". If the existence of the
% file or folder is significant it should be first checked using the getStatus()
% method.

%  (c) 2019-2022 MathWorks, Inc.

% Validation functions
validString = @(x) ischar(x) || isstring(x);
validLogical = @(x) islogical(x);

%% Parse the inputs
p = inputParser;
p.addRequired('path', validString);
p.addOptional('recursiveFlag', false, validLogical);
p.addOptional('silent', false, validLogical);
parse(p, path, varargin{:});
silent = p.Results.silent;

%% Create the request to create the tokens
% dbfsURI = matlab.net.URI([dbfsEndpoint, apiMethod]);
dbfsURI = obj.getURI('dbfs', 'delete');
request = obj.getRequestMessage('POST');

% Create the payload
dirData.path = p.Results.path;
dirData.recursive = p.Results.recursiveFlag;

% Call Databricks
request.Body = matlab.net.http.MessageBody;
request.Body.Payload = jsonencode(dirData);
resp = request.send(dbfsURI, databricks.internal.getHTTPOptions(convertResponse=true));

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Package as a response from list
    if ~silent
        disp('Delete complete');
    end
else
    if isstruct(resp.Body.Data)
        if isfield(resp.Body.Data, 'error_code') && isfield(resp.Body.Data, 'message')
            error('DATABRICKS:ERROR','Failed to delete: %s\n  error_code: %s\n  message: %s', ...
              char(dirData.path), char(resp.Body.Data.error_code),  char(resp.Body.Data.message));
        else
            error('DATABRICKS:ERROR', 'Failed to delete: %s\n  unexpected response body data struct', char(dirData.path));
        end
    elseif ischar(resp.Body.Data) ||  isStringScalar(resp.Body.Data)
        error('DATABRICKS:ERROR', 'Failed to delete: %s\n  %s', char(dirData.path), char(resp.Body.Data));
    else
        error('DATABRICKS:ERROR', 'Failed to delete: %s\n  unexpected response body data', char(dirData.path));
    end
end

end %function
