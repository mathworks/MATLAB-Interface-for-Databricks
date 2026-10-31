classdef DockerImage < matlab.databricks.StructOrCellDeserializable
    % DockerImage Docker image connection information
    %
    % Examples:
    %    % Unauthenticated repository so do not pass empty a databricks.datastructures.DockerBasicAuth object
    %    di = databricks.datastructures.DockerImage(struct('url','http://mydockerrepourl.example.com'));
    %
    %    % Using an authenticated registry
    %    dbaStruct.username = "myusername"
    %    dbaStruct.password = "mypassword"
    %    dba = databricks.datastructures.DockerBasicAuth(dbaStruct)
    %    diStruct.url = "http://mydockerrepourl.example.com"
    %    diStruct.basic_auth = dbaStruct
    %    di = databricks.datastructures.DockerImage(diStruct)
    %
    % It is bad practice to include passwords in source code.
    % It is strongly recommended to read the value from MATLAB vault, a file or
    % other external source.

    % Copyright 2022-2025 The MathWorks, Inc.

    properties
        % URL for the Docker image
        url string
        % Basic authentication information for container registry
        basic_auth databricks.datastructures.DockerBasicAuth
    end

    methods
        function obj = DockerImage(varargin)
            obj@matlab.databricks.StructOrCellDeserializable(varargin{:});
        end
    end
end