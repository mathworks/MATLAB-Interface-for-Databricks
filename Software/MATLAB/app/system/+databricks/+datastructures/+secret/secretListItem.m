classdef secretListItem < JSONMapper
    % SECRETLISTITEM List entry of the secret keys that are stored at a scope
    % This is a metadata-only operation; secret data cannot be retrieved using
    % this API. Users need the READ permission to make this call.

    % Copyright 2024 The MathWorks, Inc.

    properties
        key string
        last_updated_timestamp datetime {JSONMapper.epochDatetime(last_updated_timestamp,'TicksPerSecond',1000,'TimeZone','UTC')}
    end

    methods
        function obj = secretListItem(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.secret.secretListItem
            end
            obj@JSONMapper(s, inputs);
        end
    end
end