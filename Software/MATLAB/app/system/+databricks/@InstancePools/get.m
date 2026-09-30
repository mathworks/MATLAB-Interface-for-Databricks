function [result, errorResponse] = get(obj, id)
    % GET Retrieve the information for an instance pool based on its identifier
    %
    % Example:
    %   ip = databricks.InstancePools;
    %   instancePoolId="1234-567890-fetch12-pool-A3BcdEFg";
    %   pool = ip.get(instancePoolId)
    %
    %   InstancePool with properties:
    %
    %                          awsAttributes: [0×0 databricks.datastructures.instancepools.AWSAttributes]
    %                        azureAttributes: [1x1 databricks.datastructures.instancepools.AzureAttributes]
    %                             customTags: [0x0 JSONMapperMap]
    %                            defaultTags: [1x1 JSONMapperMap]
    %                               diskSpec: [0x0 databricks.datastructures.instancepools.DiskSpec]
    %                      enableElasticDisk: 1
    %     idleInstanceAutoterminationMinutes: 60
    %                         instancePoolId: "0826-084204-pots8-pool-7jdm3sfb"
    %                       instancePoolName: "test pool"
    %                            maxCapacity: 1
    %                       minIdleInstances: 1
    %                             nodeTypeId: "Standard_D4ds_v5"
    %                  preloadedDockerImages: [0x0 databricks.datastructures.DockerImage]
    %                 preloadedSparkVersions: "15.4.x-scala2.12"
    %                                  state: ACTIVE
    %                                  stats: [1x1 databricks.datastructures.instancepools.Stats]
    %                                 status: [1x1 databricks.datastructures.instancepools.Status]

    % (c) 2025-2026 The MathWorks Inc

    arguments
        obj databricks.InstancePools
        id string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % Get URI
    URI = obj.getURI('instance-pools', 'get');

    URI.Query(end+1) = matlab.net.QueryParameter("instance_pool_id", id);
    
    request = obj.getRequestMessage('GET');

    resp = request.send(URI, obj.HTTPOptions);
    if resp.StatusCode == matlab.net.http.StatusCode.OK
        result = databricks.datastructures.instancepools.InstancePool().fromJSON(resp.Body.Data);
        errorResponse = databricks.datastructures.ErrorResponse.empty;
    else
        errorResponse = databricks.datastructures.instancepools.InstancePool.empty;
        result = databricks.datastructures.ErrorResponse().fromJSON(resp.Body.Data);
    end
end