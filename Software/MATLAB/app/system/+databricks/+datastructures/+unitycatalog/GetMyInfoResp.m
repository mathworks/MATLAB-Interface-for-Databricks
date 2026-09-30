classdef GetMyInfoResp < JSONMapper
    % GetMyInfoResp Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.GetMyInfoResp Properties:
    %   is_metastore_admin - Flag indicating whether or not the user is a Metastore administrator

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % Flag indicating whether or not the user is a Metastore administrator
        is_metastore_admin logical
    end

    methods
        function obj = GetMyInfoResp(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.GetMyInfoResp
            end
            obj@JSONMapper(s, inputs);
        end
    end
end