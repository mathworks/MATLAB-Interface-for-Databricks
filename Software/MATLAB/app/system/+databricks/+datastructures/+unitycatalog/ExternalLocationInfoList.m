classdef ExternalLocationInfoList < JSONMapper
    % CatalogInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ExternalLocationInfoList Properties:
    %   external_locations - List of external locations

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of external locations
        external_locations databricks.datastructures.unitycatalog.ExternalLocationInfo
    end

    methods
        function obj = ExternalLocationInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ExternalLocationInfoList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end