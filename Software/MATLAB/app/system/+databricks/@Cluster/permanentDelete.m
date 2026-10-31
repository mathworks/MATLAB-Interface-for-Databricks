function permanentDelete(obj)
    % PERMANENTDELETE Method to permanently delete a cluster
    % Permanently delete a cluster. If the cluster is running, it is terminated
    % and its resources are asynchronously removed. If the cluster is terminated,
    % then it is immediately removed.
    %
    % Once permanently deleted, all actions on a permanently deleted cluster
    % are disallowed, including retrieval of the cluster’s
    % permissions.
    %
    % A permanently deleted cluster is also no longer returned in the cluster list.
    %
    % To permanently delete a cluster.
    %
    %   cl = databricks.Cluster;
    %   cl.setClusterId('0619-223319-surfs255');
    %   cl.permanentDelete();


    %  (c) 2019-2026 MathWorks, Inc.
    arguments
        obj databricks.Cluster
    end

    for k=1:numel(obj)
        i_permanentDelete(obj(k));
    end

end

function i_permanentDelete(obj)
    arguments
        obj (1,1) databricks.Cluster
    end
    clusterURI = obj.getURI('clusters', 'permanent-delete');
    request = obj.getRequestMessage('POST');

    request.Body = matlab.net.http.MessageBody;

    % Create the payload with the cluster_id
    clusterData.cluster_id = obj.cluster_id;
    request.Body.Payload = jsonencode(clusterData);

    % Call databricks
    resp = request.send(clusterURI, databricks.internal.getHTTPOptions(convertResponse=true));

    % Process the results
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        % Valid response so package and send back to user
        fprintf('Permanently deleted cluster: %s\n', obj.cluster_id);
    else
        matlab.databricks.internal.responseError(resp, 'Failed to permanently delete cluster: "%s"', obj.cluster_name);
    end

end %function
