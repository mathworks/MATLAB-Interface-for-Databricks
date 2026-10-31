function content = export(obj, pathArg, formatArg, directDownload)
% EXPORT Export a notebook or contents of an entire directory
% If path does not exist, errors with RESOURCE_DOES_NOT_EXIST. A directory can
% only be exported in DBC format. If the exported data exceeds the size
% limit, errors with MAX_NOTEBOOK_SIZE_EXCEEDED. Exporting a library is not
% supported. 
%
% Example:
%   ws = databricks.Workspace;
%   result = ws.export('/Users/joe@example.com/myPythonWS', 'SOURCE', false);
%   result.content
%   ans =
%     '# Databricks notebook source
%      print("Hello World")'

%   (c) 2020-2026 The MathWorks, Inc.

% Initializations
curAPI = 'workspace';
apiMethod = 'export';

if ~(ischar(pathArg) || isStringScalar(pathArg))
    error('DATABRICKS:ERROR','path must be of type scalar string or character vector');
end

if ischar(formatArg) || isStringScalar(formatArg)
    formatArg = upper(formatArg);
    formatArg = char(formatArg);
    if ~any(strcmp(formatArg, {'SOURCE', 'HTML', 'JUPYTER', 'DBC', 'R_MARKDOWN', 'RAW', 'AUTO'}))
        error('DATABRICKS:ERROR','format must be of type scalar string or character vector and equal to SOURCE, HTML, JUPYTER, DBC, R_MARKDOWN, RAW or AUTO');
    end
else
    error('DATABRICKS:ERROR','format must be of type scalar string or character vector');
end

if ~islogical(directDownload)
    error('DATABRICKS:ERROR','overwrite must be of type logical');
else
    if directDownload
        directDownloadStr = 'true';
    else
        directDownloadStr = 'false';
    end
end

curURI = obj.getURI(curAPI, apiMethod);
curURI.Query(end+1) = matlab.net.QueryParameter("path", char(pathArg));
curURI.Query(end+1) = matlab.net.QueryParameter("format", formatArg);
curURI.Query(end+1) = matlab.net.QueryParameter("direct_download", directDownloadStr);

% Create a request to create a secret scope
request = obj.getRequestMessage;
request.Method = matlab.net.http.RequestMethod.GET;

% Call Databricks
resp = request.send(curURI, databricks.internal.getHTTPOptions(convertResponse=true));
% Process the response
if resp.StatusCode == matlab.net.http.StatusCode.OK
    content = resp.Body.Data;
    if ~directDownload
        content.content = matlab.net.base64('decode', content.content);
        % If the file type field exists and it doesn't indicate DBC then convert
        % to a character vector otherwise leave as uint8
        if isfield(content, 'file_type')
            if ~strcmpi(content.file_type, 'DBC')
                content.content = cast(content.content, 'char');
            end
        end
    end
else
    matlab.databricks.internal.responseError(resp, 'Failed to get status');
end

end %function
