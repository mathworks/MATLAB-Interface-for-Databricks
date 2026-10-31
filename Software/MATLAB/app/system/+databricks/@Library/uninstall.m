function uninstall(obj, clusterId, varargin)
% UNINSTALL Method to uninstall a library
% Uninstall a library from a Databricks Cluster
%
%   lib = databricks.Library;
%   lib.setType('jar');
%   lib.jar = 'dbfs:/mylibraries/mylibrary.jar';
%
%   clusterId = '0000-000000-demo000'
%   lib.uninstall(clusterId);


%  (c) 2020-2026 MathWorks, Inc.

% Create a new spark cluster on Databricks
libraryURI = obj.getURI('libraries', 'uninstall');
request = obj.getRequestMessage('POST');

request.Body = matlab.net.http.MessageBody;
request.Body.Payload = obj.getPayload(clusterId);

% Call databricks
resp = request.send(libraryURI, databricks.internal.getHTTPOptions(convertResponse=true));

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Valid response so package and send back to user
    disp('Successfully requested uninstall');
else
    error('DATABRICKS:ERROR', 'Failed to uninstall library: %s', char(show(resp.Body)));
end


end %function
