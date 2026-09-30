classdef UploadCompleteRequest < JSONMapper
    % UploadCompleteRequest

    % Copyright 2026 The MathWorks, Inc.

    properties
        parts databricks.datastructures.files.UploadCompleteRequestEntry {JSONMapper.JSONArray}
    end

    methods
        function obj = UploadCompleteRequest(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.files.UploadCompleteRequest
            end
            obj@JSONMapper(s, inputs);
        end
    end
end