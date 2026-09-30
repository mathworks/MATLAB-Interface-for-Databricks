classdef CreateResponse < JSONMapper & matlab.mixin.CustomDisplay
    % CreateResponse Token create response
    %
    % See also: https://docs.databricks.com/api/azure/workspace/tokens/create

    % Copyright 2026 The MathWorks, Inc.

    properties
        % The information for each token.
        token_info databricks.datastructures.token.TokenInfo
        token_value string
    end

    methods
        function obj = CreateResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.token.CreateResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end

    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            % GETPROPERTYGROUPS Redacts sensitive information from the object display
            if isscalar(obj)
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                if ~isempty(obj.token_value) && strlength(obj.token_value) > 0
                    groups.PropertyList.token_value =  "<REDACTED>";
                end
            else
                % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end
    end
end