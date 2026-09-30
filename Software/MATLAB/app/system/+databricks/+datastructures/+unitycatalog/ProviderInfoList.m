classdef ProviderInfoList < JSONMapper
    % ProviderInfoList Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ProviderInfoList Properties:
    %   providers - List of providers

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of providers
        providers databricks.datastructures.unitycatalog.ProviderInfo
    end

    methods
        function obj = ProviderInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ProviderInfoList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end