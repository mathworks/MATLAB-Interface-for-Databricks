classdef ExecuteResponse < JSONMapper
    % ExecuteResponse Databricks Data Structure
    %
    % databricks.datastructures.commandexecution.ExecuteResponse Properties:
    %   id - ID for tracking the status of the command's execution.

    % Copyright 2023 The MathWorks, Inc.

    properties
        %  ID for tracking the status of the command's execution
        id string = string.empty
    end

    methods
        function obj = ExecuteResponse(s,inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.ExecuteResponse
            end
            obj@JSONMapper(s,inputs);
        end
    end
end