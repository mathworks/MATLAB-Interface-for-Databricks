function zoneList = getZones(obj, varargin)
% GETZONES Method to get the available zones
% Return a list of availability zones where clusters can be created in 
% (ex: us-west-2a). These zones can be used to launch a cluster.
% 
% For example:
% 
%   cl = databricks.Cluster();
%   zoneList = cl.getZones;
% 
%   zoneList = 
% 
%       2x1 table
% 
%            Zones    
%         ____________
% 
%         'us-west-1a'
%         'us-west-1c'

%                 (c) 2019-2026 MathWorks, Inc.

%% Get information about nodes
clusterURI = obj.getURI('clusters', 'list-zones');
request = obj.getRequestMessage('GET');

% Call databricks
resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Valid response so package and send back to user
    zoneList = cell2table(resp.Body.Data.zones);
    zoneList.Properties.VariableNames = {'Zones'};
else
    error('DATABRICKS:INVALIDRESPONSE',char(resp));
end


end %function
