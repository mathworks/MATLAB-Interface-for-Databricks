classdef Connection < JSONMapper
    % Connection Databricks Data Structure
    
    % Copyright 2026 The MathWorks, Inc.

    properties
        % User-provided free-form text description.
        comment string
        % Unique identifier of the Connection.
        connection_id string
        % The type of connection.
        connection_type databricks.datastructures.unitycatalog.ConnectionType
        % Date of creation
        created_at datetime {JSONMapper.epochDatetime(created_at,'TicksPerSecond',1000)}
        % Username of creator
        created_by string
        % The type of credential.
        credential_type databricks.datastructures.unitycatalog.CredentialType
        % Full name of connection.
        full_name string
        % Unique identifier of parent metastore.
        metastore_id string
        % Name of the connection.
        name string
        % A map of key-value properties attached to the securable.
        options JSONMapperMap
        % Username of current owner of the connection.
        owner string
        % A map of key-value properties attached to the securable.
        connectionProperties JSONMapperMap {JSONMapper.fieldName(connectionProperties,"properties")}
        % Status of an asynchronously provisioned resource.
        provisioning_info databricks.datastructures.unitycatalog.ProvisioningInfo 
        % If the connection is read only.
        read_only logical
        % The type of Unity Catalog securable.
        securable_type databricks.datastructures.unitycatalog.SecurableType = databricks.datastructures.unitycatalog.SecurableType.CONNECTION
        % Date of last update to Connection
        updated_at datetime {JSONMapper.epochDatetime(updated_at,'TicksPerSecond',1000)}
        % Username of user who last updated Connection
        updated_by string
        % URL of the remote data source, extracted from options.
        url string
    end

    methods
        function obj = Connection(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.Connection
            end
            obj@JSONMapper(s, inputs);
        end
    end
end