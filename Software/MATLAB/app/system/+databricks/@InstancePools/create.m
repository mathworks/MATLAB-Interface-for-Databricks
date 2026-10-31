function [result, errorResponse] = create(obj, createRequest)
    % CREATE Creates an instance pool
    %
    % Example:
    %   %% Create a pool:
    %   ip = databricks.InstancePools;
    %   settings = databricks.internal.settings.Settings.getSettingsStruct();
    %   cr = databricks.datastructures.instancepools.CreateRequest();
    %   cr.nodeTypeId = settings.(settings.vendor).node_type_id;
    %   cr.instancePoolName = "my pool name";
    %   [result, errorResponse] = ip.create(cr);
    %
    %   %% Create a MATLAB cluster from a pool using a docker image:
    %   ip = databricks.InstancePools;
    %   cr = databricks.datastructures.instancepools.CreateRequest();
    %   cr.instancePoolName = "MATLAB Web Desktop Pool";
    %   settings = databricks.internal.settings.Settings.getSettingsStruct();
    %   cr.nodeTypeId = settings.(settings.vendor).node_type_id;
    %   cr.minIdleInstances = 2;
    %   di = databricks.datastructures.instancepools.DockerImage(fileread(databricksRoot("config", "dockerAuth.json")));
    %   cr.preloadedDockerImages = di;
    %   %% Make sure the Spark version coincides with the Databricks Runtime
    %   %% version in the docker image
    %   cr.preloadedSparkVersions = "16.4.x-scala2.12";
    %   poolId = ip.create(cr);
    %
    %   % Check pool state
    %   s = ip.get(poolId)
    %   s.state
    %
    %   % Create the cluster
    %   % Explicitly specifying docker auth data
    %   c = createDatabricksCluster("pool cluster", 0, instancePoolId=poolId, dockerURL=di.url, dockerPassword=di.basicAuth.password, dockerUsername=di.basicAuth.username)
    %
    %     % Using docker auth data from JSON file
    %   c = createDatabricksCluster("pool cluster", 0, instancePoolId=poolId, dockerAuth=databricksRoot("config", "dockerAuth.json"))
    
    % (c) 2025-2026 MathWorks Inc.

    arguments
        obj databricks.InstancePools
        createRequest (1,1) databricks.datastructures.instancepools.CreateRequest
    end

    % Get URI
    URI = obj.getURI('instance-pools', 'create');

    % Create the request object
    request = obj.getRequestMessage('POST');

    requiredProperties = ["instancePoolName", "nodeTypeId"];
    optionalProperties = [...
        "awsAttributes",...
        "azureAttributes",...
        "customTags",...
        "diskSpec",...
        "enableElasticDisk",...
        "idleInstanceAutoterminationMinutes",...
        "maxCapacity",...
        "minIdleInstances",...
        "preloadedDockerImages",...
        "preloadedSparkVersions"];

    request.Body(1).Payload = createRequest.getPayload(requiredProperties, optionalProperties);

    resp = request.send(URI, obj.HTTPOptions);

    if resp.StatusCode == matlab.net.http.StatusCode.OK
        tmp = jsondecode(resp.Body.Data);
        if isfield(tmp, "instance_pool_id")
            result = string(tmp.instance_pool_id);
        else
            error("DATABRICKS:INSTANCEPOOLS:LIST", "instance_pool_id field not found.");
        end
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        result = string.empty;
        errorResponse = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end