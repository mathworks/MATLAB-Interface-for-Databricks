classdef TableInfoList < JSONMapper
    % CatalogInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.TableInfoList Properties:
    %   tables - List of tables

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of tables
        tables databricks.datastructures.unitycatalog.TableInfo
    end

    methods
        function obj = TableInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.TableInfoList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end