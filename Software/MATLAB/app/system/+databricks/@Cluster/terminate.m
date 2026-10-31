function terminate(obj, varargin)
% TERMINATE Method to delete (terminate) a given cluster
% Terminate a running cluster. For this method to work, the cluster object
% should have a valid cluster_id.
% 
%   % Fetch the a list of existing databricks clusters
%   cl = databricks.Cluster.list();
%   
%   % Terminate the first cluster
%   cl(1).terminate();
% 
% This method will not check for the validity of the cluster_id. It is left
% to the user to ensure that a valid cluster_id is specified.
% 
% The cluster is removed asynchronously. Once the termination has completed, 
% the cluster will be in a TERMINATED state. If the cluster is already in a 
% TERMINATING or TERMINATED state, nothing will happen.
% 
% 30 days after a cluster is terminated, it is permanently deleted.


%  (c) 2019-2026 MathWorks, Inc.

clusterURI = obj.getURI('clusters', 'delete');
request = obj.getRequestMessage('POST');

request.Body = matlab.net.http.MessageBody;

% Create the payload with the cluster_id
clusterData.cluster_id = obj.cluster_id;
request.Body.Payload = jsonencode(clusterData);

% Call databricks
resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

%% Process the results
if resp.StatusCode == matlab.net.http.StatusCode.OK
    % Valid response so package and send back to user
    disp(['Successfully deleted (terminated) cluster with id: ',obj.cluster_id]); 
else 
    error('DATABRICKS:ERROR','Failed to terminate cluster: %s\n%s', obj.cluster_name, char(resp.Body.Data));
end


end %function
