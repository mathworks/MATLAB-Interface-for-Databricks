classdef TokenInfo < JSONMapper
    % TOKENINFO Token information
    %
    % See also: https://docs.databricks.com/api/azure/workspace/tokens/update

    % Copyright 2026 The MathWorks, Inc.

    properties
        % Comment the token was created with, if applicable.
        comment string
        % Server time (in epoch milliseconds) when the token was created.
        creation_time datetime { JSONMapper.epochDatetime(creation_time,'TicksPerSecond',1000)}
        % Server time (in epoch milliseconds) when the token will expire, or -1 if not applicable.
        expiry_time datetime { JSONMapper.epochDatetime(expiry_time,'TicksPerSecond',1000)}
        % Scope of the token was created with, if applicable.
        scopes string {JSONMapper.JSONArray}
        % The ID of this token.
        token_id string
    end

    methods
        function obj = TokenInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.token.TokenInfo
            end
            obj@JSONMapper(s, inputs);
        end
    end

    methods (Hidden)
        % For use with legacy Token objects
        function result = tokenInfo2struct(obj)
            arguments (Input)
                obj databricks.datastructures.token.TokenInfo
            end
            arguments (Output)
                result struct
            end

            props = properties(obj);
            result = struct;
            for m = 1:numel(props)
                result.(props{m}) = obj.(props{m});
            end
        end
    end
end