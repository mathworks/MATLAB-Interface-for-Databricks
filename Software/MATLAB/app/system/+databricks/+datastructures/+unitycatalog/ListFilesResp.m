classdef ListFilesResp < JSONMapper
    % ListFilesResp Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ListFilesResp Properties:
    %   files - List of FileInfo objects, one per file/dir

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of FileInfo objects, one per file/dir
        files databricks.datastructures.unitycatalog.FileInfo {JSONMapper.JSONArray}
    end

    methods
        function obj = ListFilesResp(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ListFilesResp
            end
            obj@JSONMapper(s, inputs);
        end
    end
end