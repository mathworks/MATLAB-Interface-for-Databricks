classdef StorageCredentialInfoList < JSONMapper
    % CatalogInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.StorageCredentialInfoList Properties:
    %   storage_credentials - List of storage credentials

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of storage credentials
        storage_credentials databricks.datastructures.unitycatalog.StorageCredentialInfo
    end

    methods
        function obj = StorageCredentialInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.StorageCredentialInfoList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end