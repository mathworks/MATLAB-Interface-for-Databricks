function move(obj, source, destination)
% MOVE Move a file from one location to another location within DBFS
% If the source file does not exist, errors with RESOURCE_DOES_NOT_EXIST.
% If there already exists a file in the destination path, error with
% RESOURCE_ALREADY_EXISTS. If the given source path is a directory, the call
% recursively moves all files.
%
% When moving a large number of files the underlying API call will time out
% after approximately 60s, potentially resulting in partially moved data.
% Therefore, for operations that move more than 10k files, Databricks strongly
% discourage using the DBFS REST API. Databricks recommend that such operations
% are performed in the context of a cluster, using File system utilities from a
% notebook, which provides the same functionality without timing out.
%
% The source path of the file or directory may be given as a scalar string or
% character vector. The path should be the absolute DBFS path (e.g. /mnt/foo/) 
% The destination path of the file or directory may be given as a scalar string
% or character vector. The path should be the absolute DBFS path (e.g. /mnt/bar/).
%
% This method is not vectorized.

% Copyright 2020-2022 The MathWorks, Inc.

if ~(ischar(source) || isStringScalar(source))
    error('DATABRICKS:ERROR','source must be of type scalar string or character vector');
end

if ~(ischar(destination) || isStringScalar(destination))
    error('DATABRICKS:ERROR','destination must be of type scalar string or character vector');
end

if isempty(source)
    error('DATABRICKS:ERROR','source must not be empty');
end

if isempty(destination)
    error('DATABRICKS:ERROR','destination must not be empty');
end

source = char(source);
destination = char(destination);
if ~strcmp(source(1), '/')
    error('DATABRICKS:ERROR','Expected source path to being with /');
end

if ~strcmp(destination(1), '/')
    error('DATABRICKS:ERROR','Expected destination path to being with /');
end

% Initializations
curAPI = 'dbfs';
apiMethod = 'move';
curURI = obj.getURI(curAPI, apiMethod);

 % Create a request to create a secret scope
 request = obj.getRequestMessage;
 request.Method = matlab.net.http.RequestMethod.POST;
 request.Body = matlab.net.http.MessageBody;
 s = struct;
 s.source_path = source;
 s.destination_path = destination;
 request.Body.Payload = jsonencode(s);

% Call Databricks
resp = request.send(curURI, databricks.internal.getHTTPOptions(convertResponse=true));
% Process the response
if resp.StatusCode == matlab.net.http.StatusCode.OK
    disp(['Moved:  ', source, ' to ', destination]);
else
    matlab.databricks.internal.responseError(resp, sprintf('Failed to move: %s : %s', source, destination));
end

end
    