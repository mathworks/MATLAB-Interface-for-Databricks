classdef ListConnectionsResp < JSONMapper
    % ListConnectionsResp Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.ListConnectionsResp Properties:
    %   files - List of FileInfo objects, one per file/dir

    % Copyright 2026 The MathWorks, Inc.

    properties
        % An array of connection information objects.
        connections databricks.datastructures.unitycatalog.Connection {JSONMapper.JSONArray}
        % Opaque token to retrieve the next page of results. Absent if there are no more pages.
        % page_token should be set to this value for the next request (for the next page of results).
        next_page_token string
    end

    methods
        function obj = ListConnectionsResp(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.ListConnectionsResp
            end
            obj@JSONMapper(s, inputs);
        end
    end
end