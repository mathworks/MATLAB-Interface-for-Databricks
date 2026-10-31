classdef Jar < JSONMapper
    % JAR Represents a cluster Jar library
    % URI of the JAR library to install. Supported URIs include Workspace paths, Unity Catalog
    % Volumes paths, and S3 URIs.
    %
    % Examples: 
    %   "/Workspace/path/to/library.jar"
    %   "/Volumes/path/to/library.jar"
    %   "s3://my-bucket/library.jar"
    %
    % If S3 is used, please make sure the cluster has read access on the library.
    % The cluster may need to be launched with an IAM role to access the S3 URI.
    %
    % See: https://docs.databricks.com/api/workspace/libraries/install

    properties
        % URI of the JAR library to install.
        jar string
    end


    methods
        function obj = Jar(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.libraries.Jar
            end
            obj@JSONMapper(s, inputs);
        end
    end
end