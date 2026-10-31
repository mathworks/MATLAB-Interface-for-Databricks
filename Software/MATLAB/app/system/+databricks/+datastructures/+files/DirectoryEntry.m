classdef DirectoryEntry < JSONMapper
    % DirectoryEntry

    % Copyright 2024 The MathWorks, Inc.

    properties
        % The absolute path of the file or directory
        path string %{mustBeTextScalar}
        % True if the path is a directory
        isDirectory logical { JSONMapper.fieldName(isDirectory,"is_directory") }
        % The length of the file in bytes. This field is omitted for directories
        fileSize int64 { JSONMapper.fieldName(fileSize,"file_size") } = int64.empty
        % Last modification time of given file in milliseconds since unix epoch
        lastModified datetime { JSONMapper.epochDatetime(lastModified,'TicksPerSecond',1000), JSONMapper.fieldName(lastModified,"last_modified") } = datetime.empty
        % The name of the file or directory. This is the last component of the path
        name string %{mustBeTextScalar}
    end

    methods
        function obj = DirectoryEntry(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.files.DirectoryEntry
            end
            obj@JSONMapper(s, inputs);
        end
    end
end