function setInstancePoolId(obj, poolId)
    % SETINSTANCEPOOLID The optional ID of the instance pool to which the cluster belongs

    % (c) 2025 MathWorks, Inc.

    arguments
        obj databricks.Cluster
        poolId string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    % set the property if one does not exist
    if ~isprop(obj,'instance_pool_id')
        addprop(obj,'instance_pool_id');
    end
    obj.instance_pool_id = char(poolId);
end