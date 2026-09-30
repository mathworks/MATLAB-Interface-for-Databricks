function restart(obj, varargin)
% RESTART Method to restart a running databricks cluster
% Restart a running Spark cluster. If the cluster is not in a RUNNING
% state, nothing will happen.
% 
% To start a cluster:
%   
%   cl.restart();
% 
% For example,
%   
%   % List all available clusters
%   cl = databricks.Cluster.list();
%   
%   % Check the state to ensure that it is terminated
%   cl(1).state
%       
%   ans =
% 
%       'RUNNING'    
% 
%   % Start the cluster
%   cl(1).restart();
% 

% (c) 2019-2026 MathWorks, Inc.

clusterURI = obj.getURI('clusters', 'restart');
request = obj.getRequestMessage('POST');

request.Body = matlab.net.http.MessageBody;

% Create the payload with the cluster_id
clusterData.cluster_id = obj.cluster_id;
request.Body.Payload = jsonencode(clusterData);

% Call databricks
resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    disp(['Successfully restarted cluster with id: ', char(obj.cluster_id)]); 
elseif resp.StatusCode == matlab.net.http.StatusCode.BadRequest
    error('DATABRICKS:ERROR', 'Failed to restart cluster: %s\nerror_code: %s\nmessage: %s',...
        obj.cluster_name, resp.Body.Data.error_code, resp.Body.Data.message);
else
    error('DATABRICKS:ERROR', 'Failed to restart cluster: %s\nStatus code: %s', obj.cluster_name, char(resp.StatusCode));
end

end %function
