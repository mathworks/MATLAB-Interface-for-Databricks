classdef secretList < JSONMapper
    % SECRETLIST Lists the secret keys that are stored at a scope
    % This is a metadata-only operation; secret data cannot be retrieved using
    % this API. Users need the READ permission to make this call.

    % Copyright 2024 The MathWorks, Inc.

    properties
        secrets databricks.datastructures.secret.secretListItem {JSONMapper.JSONArray}
    end

    methods
        function obj = secretList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.secret.secretList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end