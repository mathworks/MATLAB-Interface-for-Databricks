classdef AWSAttributes < JSONMapper
    % AWSATTRIBUTES Attributes related to instance pools running on Amazon Web Services
    % If not specified at pool creation, a set of default values will be used.

    % Copyright 2025 The MathWorks, Inc.

    properties
        availability databricks.datastructures.instancepools.AvailabilityAWS
        spotBidPricePercent int32 { JSONMapper.fieldName(spotBidPricePercent, "spot_bid_price_percent") } = 100
        zoneId string { JSONMapper.fieldName(zoneId, "zone_id") }
    end

    methods
        function obj = AWSAttributes(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.instancepools.AWSAttributes
            end
            obj@JSONMapper(s, inputs);
        end
    end
end