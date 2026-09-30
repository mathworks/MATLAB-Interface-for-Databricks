classdef AzureAttributes < JSONMapper
    % AZUREATTRIBUTES Attributes related to instance pools running on Azure
    % If not specified at pool creation, a set of default values will be used.

    % Copyright 2025 The MathWorks, Inc.

    properties
        availability databricks.datastructures.instancepools.AvailabilityAzure
        spotBidMaxPrice double { JSONMapper.fieldName(spotBidMaxPrice, "spot_bid_max_price") } = -1
    end

    methods
        function obj = AzureAttributes(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.AzureAttributes
            end
            obj@JSONMapper(s, inputs);
        end
    end
end