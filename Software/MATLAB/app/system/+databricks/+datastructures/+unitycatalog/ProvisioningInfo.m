classdef ProvisioningInfo < JSONMapper
    % ProvisioningInfo Databricks Data Structure
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        % The provisioning state of the resource.
        state databricks.datastructures.unitycatalog.ProvisioningState
    end

    methods
        function obj = ProvisioningInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ProvisioningInfo
            end
            obj@JSONMapper(s, inputs);
        end
    end
end