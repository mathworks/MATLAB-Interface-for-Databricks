classdef CancelRequest < JSONMapper
    % CancelRequest Databricks Data Structure
    %
    % databricks.datastructures.commandexecution.CancelRequest Properties:
    %   clusterId - Running cluster id
    %   contextId - ID of context
    %   commandId - ID of command to cancel

    % Copyright 2023-2024 The MathWorks, Inc.

    properties
        % Running cluster ID
        clusterId string
        % ID of context
        contextId string
        % ID of command to cancel
        commandId string
    end

    methods
        function obj = CancelRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.CancelRequest
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
                fields.?databricks.datastructures.commandexecution.CancelRequest
            end
            obj = databricks.datastructures.commandexecution.CancelRequest;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end