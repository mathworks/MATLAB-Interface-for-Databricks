classdef FileInfo < JSONMapper
    % FileInfo Databricks Data Structure
    %
    % databricks.datastructures.unitycatalog.FileInfo Properties:
    %   path - URI of the storage object
    %   name - of the object
    %   size - in bytes
    %   mtime - Modification time, based on unix epoch
    %   is_dir - Whether the object is a directory (or a file)

    % Copyright 2022-2024 The MathWorks, Inc.

    properties
        % Path URI of the storage object
        path string
        % Name of the object	
        name string
        % Size in bytes
        size int64
        % Modification time, based on unix epoch
        mtime datetime {JSONMapper.epochDatetime(mtime, 'TicksPerSecond', 1000)}
        % Whether the object is a directory (or a file)
        is_dir logical
    end

    methods
        function obj = FileInfo(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.unitycatalog.FileInfo
            end
            obj@JSONMapper(s, inputs);
        end
    end
end