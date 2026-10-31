classdef ExecuteRequest < JSONMapper
    % ExecuteRequest Request to delete an execution context
    %
    % databricks.datastructures.commandexecution.ExecuteRequest Properties:
    %   clusterId - Running cluster id
    %   contextId - ID of context
    %   language - "python" "scala" "sql"
    %   command - command

    % Copyright 2023 The MathWorks, Inc.

    properties
        % Running cluster ID
        clusterId string
        % ID of context
        contextId string
        % Enumeration: "python" "scala" "sql"
        language databricks.datastructures.commandexecution.Language
        % Command to execute
        command string
    end

    methods
        function obj = ExecuteRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.ExecuteRequest
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
                fields.?databricks.datastructures.commandexecution.ExecuteRequest
            end
            obj = databricks.datastructures.commandexecution.ExecuteRequest;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end