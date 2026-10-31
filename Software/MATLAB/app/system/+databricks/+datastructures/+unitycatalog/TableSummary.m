classdef TableSummary < JSONMapper
    % TableSummary Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.TableSummary Properties:
    %   full_name - Fully-qualified name of Table , of the form <catalog>.<schema>.<table>
    %   table_type - Distinguishes a view vs. managed/external Table

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % Fully-qualified name of Table , of the form <catalog>.<schema>.<table>
        full_name string
        % Distinguishes a view vs. managed/external Table
        table_type string
    end

    methods
        function obj = TableSummary(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.TableSummary
            end
            obj@JSONMapper(s, inputs);
        end
    end
end