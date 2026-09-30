classdef ConnectionUpdateRequest < JSONMapper
    % ConnectionUpdateRequest Databricks Data Structure
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        % New name of the connection.
        new_name string
        % A map of key-value properties attached to the securable.
        options JSONMapperMap
        % Username of current owner of the connection.
        owner string
    end

    methods
        function obj = ConnectionUpdateRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ConnectionUpdateRequest
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
                fields.?databricks.datastructures.unitycatalog.ConnectionUpdateRequest
            end
            obj = databricks.datastructures.unitycatalog.ConnectionUpdateRequest;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end
end