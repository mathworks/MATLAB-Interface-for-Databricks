function mkdir(obj, path, varargin)
% MKDIR Method to make a directory on DBFS
% Create the given directory and necessary parent directories if they do 
% not exist. This method will not work if there exists a file (not a 
% directory) at any prefix of the input path.
% 
%   db = databricks.DBFS();
%   db.mkdir('/MATLAB');
% 

%  (c) 2019-2026 MathWorks, Inc.

% Validation functions
validString = @(x) ischar(x) || isstring(x);

%% Parse the inputs
p = inputParser;
p.addRequired('path',validString);
parse(p, path, varargin{:});

%% Create the request to create the tokens
% dbfsURI = matlab.net.URI([dbfsEndpoint, apiMethod]);
dbfsURI = obj.getURI('dbfs', 'mkdirs');
request = obj.getRequestMessage('POST');

% Create the payload
dirData.path = p.Results.path;

% Call databricks
request.Body = matlab.net.http.MessageBody;
request.Body.Payload = jsonencode(dirData);
resp = request.send(dbfsURI, databricks.internal.getHTTPOptions(convertResponse=true));

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Package as a response from list
    fprintf(1,'Created folder: %s\n', dirData.path);
else
    error('DATABRICKS:ERROR', 'Failed to create folder: %s',dirData.path);
end


end %function
