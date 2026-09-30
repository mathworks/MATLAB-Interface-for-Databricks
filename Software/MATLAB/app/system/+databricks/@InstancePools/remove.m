function [result, errorResponse] = remove(obj, id)
    % REMOVE Deletes the instance pool permanently
    % The idle instances in the pool are terminated asynchronously.
    %
    % Example:
    %   ip = databricks.InstancePools;
    %   [result, errorResponse] = ip.remove('0826-134312-fops10-pool-qndpush3');
    %
    % See also: https://docs.databricks.com/api/workspace/instancepools/delete

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments
        obj databricks.InstancePools
        id string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('instance-pools', 'delete');
   
    % Start a DELETE request
    request = obj.getRequestMessage('POST');

    request.Body(1).Payload = ['{"instance_pool_id": "', char(id), '"}'];

    % Perform the actual call
    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = true;
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = false;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end