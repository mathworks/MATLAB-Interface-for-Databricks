classdef Thumbnail < JSONMapper
    % Thumbnail
    %
    % The thumbnail for an app.

    % Copyright 2026 The MathWorks, Inc.

    properties
        % The thumbnail image bytes.
        thumbnail string { JSONMapper.fieldName(thumbnail, "thumbnail")}
    end

    methods
        function obj = Thumbnail(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.Thumbnail
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
