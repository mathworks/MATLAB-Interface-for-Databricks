classdef ConnectionInfo < JSONMapper
    % ConnectionInfo Databricks Data Structure
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        % User-provided free-form text description.
        comment string
        % The type of connection.
        connection_type databricks.datastructures.unitycatalog.ConnectionType
        % Name of the connection.
        name string
        % A map of key-value properties attached to the securable.
        options JSONMapperMap
        % A map of key-value properties attached to the securable.
        connectionProperties JSONMapperMap {JSONMapper.fieldName(connectionProperties,"properties")}
        % If the connection is read only.
        read_only logical
    end

    methods
        function obj = ConnectionInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ConnectionInfo
            end
            obj@JSONMapper(s, inputs);
        end
    end
end