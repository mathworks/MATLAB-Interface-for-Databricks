classdef RecipientInfoList < JSONMapper
    % RecipientInfoList Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.RecipientInfoList Properties:
    %   recipients - List of recipients

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of recipients
        recipients databricks.datastructures.unitycatalog.RecipientInfo
    end

    methods
        function obj = RecipientInfoList(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.RecipientInfoList
            end
            obj@JSONMapper(s, inputs);
        end
    end

end