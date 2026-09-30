function [result, errorResponse] = changeOwner(obj, ownerUsername)
    % CHANGEOWNER Change the owner of the cluster.
    % 
    % You must be an admin and the cluster must be terminated to perform this
    % operation. The service principal application ID can be supplied as an 
    % argument to changeOwner.
    %
    % Updates the cluster creator_user_name to the assigned name.
    % The single_user_name and assigned_principal values are not updated.
    % 
    % Example:
    %   
    %   % Change a cluster owner's name
    %   c = databricks.Cluster.findByName('myClusterName');
    %   [result, errorResponse] = c.changeOwner("joe@example.com");

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj (1,1) databricks.Cluster
        ownerUsername string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    initVersion = obj.Version;
    obj.Version = "2.1";
    URI = obj.getURI('clusters', 'change-owner');
    obj.Version = initVersion;

    % Start a POST request
    request = obj.getRequestMessage('POST');
    
    % Assign the body data
    s = struct;
    s.cluster_id = obj.cluster_id;
    s.owner_username = ownerUsername;
    request.Body = matlab.net.http.MessageBody(jsonencode(s));

    % Perform the actual call
    [resp, request, history] = request.send(URI, obj.HTTPOptions); %#ok<ASGLU> 

     if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end
