classdef CommandsStatusResults < JSONMapper
    % CommandsStatusResults Databricks Data Structure
    % 
    % databricks.datastructures.commandexecution.CommandsStatusResults Properties:
    %   resultType - Enumeration: "error" "image" "images" "table" "text"
    %   summary - summary - string = string.empty
    %   cause - The cause of the error
    %   filename - The image filename
    %   filenames - Array of filename strings
    %   data - object, stored a string
    %   schema - The table schema
    %   truncated - true if partial results are returned
    %   isJsonSchema - true if a JSON schema is returned instead of a string representation of the Hive type
    %   pos - internal field used by SDK

    % Copyright 2023 The MathWorks, Inc.

    properties
        % Enumeration: "error" "image" "images" "table" "text"
        resultType databricks.datastructures.commandexecution.ResultType
        % The summary of the error
        summary string = string.empty
        % The cause of the error
        cause string = string.empty
        % The image filename
        filename string = string.empty
        % % Array of strings
        filenames string = string.empty
        % object - assume data in bytes for now
        data string = string.empty 
        % The table schema
        schema {JSONMapper.JSONArray}
        % % true if partial results are returned
        truncated logical = logical.empty
        % true if a JSON schema is returned instead of a string representation of the Hive type
        isJsonSchema logical = logical.empty
        % internal field used by SDK
        pos int32 = int32.empty
    end

    methods
        function obj = CommandsStatusResults(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.CommandsStatusResults
            end
            obj@JSONMapper(s, inputs);
        end
    end
end