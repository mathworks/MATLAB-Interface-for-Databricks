function create(obj, varargin)
    % CREATE Method to create a new Spark cluster
    % Create a new Spark cluster. This method acquires new instances from the
    % cloud provider if necessary. This method is asynchronous; the returned
    % cluster_id can be used to poll the cluster state.
    %
    % When this method returns, the cluster is in a PENDING state. The cluster
    % is usable once it enters a RUNNING state.
    %
    %   cl = databricks.Cluster();
    %   cl.cluster_name = 'Test Cluster';
    %   cl.setNumWorkers([2 10]); % autoscaling cluster
    %   cl.create();

    %  (c) 2019-2026 MathWorks, Inc.

    %% Create a new spark cluster on Databricks
    clusterURI = obj.getURI('clusters', 'create');
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;
    request.Body.Payload = obj.getPayload;

    % Call Databricks
    resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

    %% Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Valid response so package and send back to user
        setClusterId(obj, resp.Body.Data.cluster_id);
    else
        error('DATABRICKS:ERROR','Failed to create cluster: %s\n%s', obj.cluster_name, char(resp));
    end

end %function
