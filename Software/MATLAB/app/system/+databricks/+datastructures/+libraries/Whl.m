classdef Whl < JSONMapper
    % WHL Represents a cluster Whl library
    % URI of the wheel library to install.
    % Supported URIs include Workspace paths, Unity Catalog Volumes paths, and S3 URIs.
    %
    % Examples: 
    %   "/Workspace/path/to/library.whl
    %   "/Volumes/path/to/library.whl"
    %   "s3://my-bucket/library.whl"
    %
    % If S3 is used, please make sure the cluster has read access on the library.
    % The cluster may need to be launched with an IAM role to access the S3 URI.
    %
    % See: https://docs.databricks.com/api/workspace/libraries/install

    properties
        % URI of the wheel library to install.
        whl string
    end


    methods
        function obj = Whl(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.libraries.Whl
            end
            obj@JSONMapper(s, inputs);
        end
    end
end