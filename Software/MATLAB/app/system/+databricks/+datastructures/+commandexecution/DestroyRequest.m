classdef DestroyRequest < JSONMapper
    % DestroyRequest Request to delete an execution context
    %
    % databricks.datastructures.commandexecution.DestroyRequest Properties:
    %   clusterId - Running cluster ID
    %   contextId - ID of context
    %
    % Example:
    %   commandExecution = databricks.CommandExecution;
    %   destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
    %   destroyRequest.clusterId = clusterId;
    %   destroyRequest.contextId = contextId;
    %   destroyResponse = commandExecution.destroy(destroyRequest);

    % Copyright 2023 The MathWorks, Inc.

    properties
        % Running cluster id
        clusterId string
        % ID of context
        contextId string
    end

    methods
        function obj = DestroyRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.DestroyRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end

    methods (Static)
        function obj = fromInputs(fields)
            % FROMINPUTS creates an instance of the class with specific
            % properties set to specific values. For each property that is
            % to be set, provide the property name and desired value as 
            % Name-Value pairs.
            arguments
                fields.?databricks.datastructures.commandexecution.DestroyRequest
            end
            obj = databricks.datastructures.commandexecution.DestroyRequest;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end