classdef ListVolumesResp < JSONMapper
    % ListVolumesResp Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ListVolumesResp Properties:
    %   volumes - List of FileInfo objects, one per file/dir
    %   next_page_token - Opaque token to retrieve the next page of results.
    %                     Absent if there are no more pages. page_token should
    %                     be set to this value for the next request to retrieve
    %                     the next page of results.

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % List of FileInfo objects, one per file/dir
        volumes databricks.datastructures.unitycatalog.VolumeInfo {JSONMapper.JSONArray}
        next_page_token string
    end

    methods
        function obj = ListVolumesResp(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ListVolumesResp
            end
            obj@JSONMapper(s, inputs);
        end
    end
end