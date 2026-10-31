classdef CatalogInfoList < JSONMapper
    % CatalogInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.CatalogInfoList Properties:
    %   catalogs - List of catalogs

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of catalogs
        catalogs databricks.datastructures.unitycatalog.CatalogInfo
    end

    methods
        function obj = CatalogInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.CatalogInfoList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end