classdef UpdateThumbnailRequest < JSONMapper
    % UpdateThumbnailRequest
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        % The app thumbnail to set.
        appThumbnail databricks.datastructures.apps.Thumbnail { JSONMapper.fieldName(appThumbnail, "app_thumbnail")}
    end

    methods
        function obj = UpdateThumbnailRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.UpdateThumbnailRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
