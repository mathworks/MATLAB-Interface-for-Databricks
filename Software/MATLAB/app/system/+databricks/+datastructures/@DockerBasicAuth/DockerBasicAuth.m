classdef DockerBasicAuth < matlab.databricks.StructOrCellDeserializable
    % DockerBasicAuth Container registry basic authentication information
    %
    % Example:
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
        % User name for the container registry.
        username string
        % Password for the container registry.
        password string
    end

    methods
        function obj = DockerBasicAuth(varargin)
            obj@matlab.databricks.StructOrCellDeserializable(varargin{:});
        end
    end
end