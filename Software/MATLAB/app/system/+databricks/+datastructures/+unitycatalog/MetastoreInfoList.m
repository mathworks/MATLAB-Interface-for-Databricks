classdef MetastoreInfoList < JSONMapper
    % CatalogInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.MetastoreInfoList Properties:
    %   metastores - List of metastores

    % Copyright 2022 The MathWorks, Inc.

    properties
        % List of metastores
        metastores databricks.datastructures.unitycatalog.MetastoreInfo
    end

    methods
        function obj = MetastoreInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.MetastoreInfoList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end