function [result, errorResponse] = list(varargin)
    % LIST Gets a list of instance pools with their statistics

    % (c) 2025-2026 The MathWorks Inc

    obj = databricks.InstancePools(varargin{:});

    % Get URI
    URI = obj.getURI('instance-pools', 'list');

    request = obj.getRequestMessage('GET');

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        tmp = databricks.datastructures.instancepools.InstancePools().fromJSON(resp.Body.Data);
        if isprop(tmp, "instancePools")
            result = tmp.instancePools;
            errorResponse = databricks.datastructures.ErrorResponse.empty;
        else
            error("DATABRICKS:INSTANCEPOOLS:LIST", "instancePools field not found.");
        end
    else
        result = databricks.datastructures.instancepools.InstancePools.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end