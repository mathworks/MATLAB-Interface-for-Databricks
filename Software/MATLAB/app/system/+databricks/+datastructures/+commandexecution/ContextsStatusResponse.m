classdef ContextsStatusResponse < JSONMapper
    % StatusResponse Databricks Data Structure
    %
    % databricks.datastructures.commandexecution.ContextsStatusResponse Properties:
    %   id - ID 
    %   status - Enumeration: "Running" "Pending" "Error" 

    % Copyright 2023 The MathWorks, Inc.

    properties
        % ID of the new execution context
        id string = string.empty
        status databricks.datastructures.commandexecution.ContextsStatus
    end

    methods
        function obj = ContextsStatusResponse(s,inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.ContextsStatusResponse
            end
            obj@JSONMapper(s,inputs);
        end
    end
end