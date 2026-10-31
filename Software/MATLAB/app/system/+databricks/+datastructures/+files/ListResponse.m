classdef ListResponse < JSONMapper
    % ListResponse Class to represent a list of contents from a file list query

    % Copyright 2024 The MathWorks, Inc.

    properties
        % An array of DirectoryEntry for the contents of the directory
        contents databricks.datastructures.files.DirectoryEntry { JSONMapper.JSONArray }
    end

    methods
        function obj = ListResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.files.ListResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end
