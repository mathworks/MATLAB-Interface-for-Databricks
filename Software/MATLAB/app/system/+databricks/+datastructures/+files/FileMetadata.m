classdef FileMetadata
    % FileMetadata Class to store the result of a file metadata query
    % Represents a files's metadata.

    % Copyright 2024 The MathWorks, Inc.

    properties
        contentType string
        contentLength int64
        lastModified datetime
    end

    methods
        function obj = FileMetadata()
        end
    end
end