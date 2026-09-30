function start(obj, varargin)
% START Method to start a databricks cluster
% Start a terminated Spark cluster. This is similar to create except:
%   * The previous cluster ID and attributes are preserved.
%   * The cluster starts with the last specified cluster size. If the previous 
%     cluster was an autoscaling cluster, the current cluster starts with 
%     the minimum number of nodes.
%   * If the cluster is not in a TERMINATED state, nothing will happen.
% 
% Clusters launched to run a job cannot be started.
% 
% To start a cluster:
%   
%   cl.start();
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
%       'TERMINATED'
% 
%   % Start the cluster
%   cl(1).start();
% 

%  (c) 2019-2026 MathWorks, Inc.

clusterURI = obj.getURI('clusters', 'start');
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
    disp(['Successfully started cluster with id: ',obj.cluster_id]); 
else
    if isstruct(resp.Body.Data)
        error('DATABRICKS:ERROR', 'Failed to start cluster: %s\n%s: %s', obj.cluster_name, resp.Body.Data.error_code, resp.Body.Data.message);
    else
        error('DATABRICKS:ERROR', 'Failed to start cluster: %s\n%s', obj.cluster_name, char(resp.Body.Data));
    end
end

end %function
