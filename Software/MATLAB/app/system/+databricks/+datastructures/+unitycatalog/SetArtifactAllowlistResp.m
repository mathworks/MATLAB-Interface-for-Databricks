classdef SetArtifactAllowlistResp < JSONMapper
    % SetArtifactAllowlistResp Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.SetArtifactAllowlistResp Properties:
    %   artifact_matchers - A list of allowed artifact match patterns
    %   metastore_id - Unique identifier of parent metastore
    %   created_by - Username of the user who set the artifact allowlist
    %   created_at - Time at which this artifact allowlist was set

    % Copyright 2023-2024 The MathWorks, Inc.

    properties
        % A list of allowed artifact match patterns
        artifact_matchers databricks.datastructures.unitycatalog.ArtifactMatchers {JSONMapper.JSONArray}
        % Unique identifier of parent metastore
        metastore_id (1,1) string
        % Username of the user who set the artifact allowlist
        created_by (1,1) string
        % Time at which this artifact allowlist was set
        created_at datetime {JSONMapper.epochDatetime(created_at,'TicksPerSecond',1000)}
    end

    methods
        function obj = SetArtifactAllowlistResp(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.SetArtifactAllowlistResp
            end
            obj@JSONMapper(s, inputs);
        end
    end
end