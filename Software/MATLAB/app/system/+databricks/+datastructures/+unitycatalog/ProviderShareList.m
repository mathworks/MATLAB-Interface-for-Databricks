classdef ProviderShareList < JSONMapper
    % ProviderShareList Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ProviderShareList Properties:
    %   shares - List of shares

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of shares
        shares databricks.datastructures.unitycatalog.ProviderShare
    end

    methods
        function obj = ProviderShareList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ProviderShareList
            end
            obj@JSONMapper(s, inputs);
        end
    end
end