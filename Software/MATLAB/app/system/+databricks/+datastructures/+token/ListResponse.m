classdef ListResponse < JSONMapper
    % ListResponse Token list response
    %
    % See also: https://docs.databricks.com/api/azure/workspace/tokens/list

    % Copyright 2026 The MathWorks, Inc.

    properties
        % The information for each token.
        token_infos databricks.datastructures.token.TokenInfo {JSONMapper.JSONArray}
    end

    methods
        function obj = ListResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.token.ListResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end