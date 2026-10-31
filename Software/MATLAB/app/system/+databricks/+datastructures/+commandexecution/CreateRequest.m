classdef CreateRequest < JSONMapper
    % CreateRequest Databricks Data Structure
    %
    % databricks.datastructures.commandexecution.CreateRequest Properties:
    %   clusterId - Running cluster id
    %   language -  Enumeration: "python" "scala" "sql"
    %
    % Example:
    %   commandExecution = databricks.CommandExecution();
    %   createRequest = databricks.datastructures.commandexecution.CreateRequest;
    %   createRequest.clusterId = "1117-171925-4ipnoi3i";
    %   createRequest.language = databricks.datastructures.commandexecution.Language.python;
    %   createResponse = commandExecution.create(createRequest);
    %   if isa(createResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
    %       error("Context creation failed:\n  %s", createResponse.error);
    %   else
    %        contextId = createResponse.id;
    %   end

    % Copyright 2023-2025 The MathWorks, Inc.

    properties
        % Running cluster id
        clusterId string
        % Enumeration: "python" "scala" "sql"
        language databricks.datastructures.commandexecution.Language
    end

    methods
        function obj = CreateRequest(s,inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.CreateRequest
            end
            obj@JSONMapper(s,inputs);
        end
    end

    methods (Static)
        function obj = fromInputs(fields)
            % FROMINPUTS creates an instance of the class with specific
            % properties set to specific values. For each property that is
            % to be set, provide the property name and desired value as 
            % Name-Value pairs.
            arguments
                fields.?databricks.datastructures.commandexecution.CreateRequest
            end
            obj = databricks.datastructures.commandexecution.CreateRequest;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end