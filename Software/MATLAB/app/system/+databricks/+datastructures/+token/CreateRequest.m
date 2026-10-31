classdef CreateRequest < JSONMapper
    % CREATEREQUEST Request to create a token
    %
    % See also: https://docs.databricks.com/api/azure/workspace/tokens/create

    % Copyright 2026 The MathWorks, Inc.

    properties
        % Optional description to attach to the token.
        comment string
        % The lifetime of the token, in seconds.
        % If the lifetime is not specified, this token remains valid for 2 years.
        lifetime_seconds int64
        % Optional scopes of the token, an array of strings
        scopes string {JSONMapper.JSONArray}
    end

    methods
        function obj = CreateRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.token.CreateRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end