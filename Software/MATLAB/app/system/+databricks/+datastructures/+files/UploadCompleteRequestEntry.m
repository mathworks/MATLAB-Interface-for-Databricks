classdef UploadCompleteRequestEntry < JSONMapper
    % UploadCompleteRequestEntry

    % Copyright 2026 The MathWorks, Inc.

    properties
        part_number (1,1) int64
        etag string
    end

    methods
        function obj = UploadCompleteRequestEntry(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.files.UploadCompleteRequestEntry
            end
            obj@JSONMapper(s, inputs);
        end
    end
end