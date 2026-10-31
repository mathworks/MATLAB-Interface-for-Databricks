classdef CreateResponse < JSONMapper
    % CreateResponse Databricks Data Structure
    %
    % databricks.datastructures.commandexecution.CreateResponse Properties:
    %   id - ID of the new execution context

    % Copyright 2023 The MathWorks, Inc.

    properties
        % ID of the new execution context
        id string = string.empty
    end

    methods
        function obj = CreateResponse(s,inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.CreateResponse
            end
            obj@JSONMapper(s,inputs);
        end
    end
end