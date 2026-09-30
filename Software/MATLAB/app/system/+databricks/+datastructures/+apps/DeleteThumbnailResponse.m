classdef DeleteThumbnailResponse < JSONMapper
    % DeleteThumbnailResponse
    %
    % Empty response returned when deleting an app thumbnail.

    % Copyright 2026 The MathWorks, Inc.
    
    methods
        function obj = DeleteThumbnailResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.DeleteThumbnailResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
