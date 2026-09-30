classdef ShareInfoList < JSONMapper
    % ShareInfoList Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ShareInfoList Properties:
    %   shares - List of shares

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of shares
        shares databricks.datastructures.unitycatalog.ShareInfo
    end

    methods
        function obj = ShareInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ShareInfoList
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
                fields.?databricks.datastructures.unitycatalog.ShareInfoList
            end
            obj = databricks.datastructures.unitycatalog.ShareInfoList;
            for field = string(fieldnames(fields))'
                obj.(field) = fields.(field);
            end
        end
    end       
end