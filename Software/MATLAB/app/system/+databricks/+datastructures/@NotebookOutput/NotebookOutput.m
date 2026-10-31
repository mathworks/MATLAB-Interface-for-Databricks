classdef NotebookOutput < matlab.databricks.StructOrCellDeserializable
    % NOTEBOOKOUTPUT Databricks NotebookOutput Data Structure

    % Copyright 2022 The MathWorks, Inc.

    properties
        % The value passed to dbutils.notebook.exit(). Databricks restricts this
        % API to return the first 1 MB of the value. For a larger result, your 
        % job can store the results in a cloud storage service. This field will
        % be absent if dbutils.notebook.exit() was never called.
        result (1,1) string
        % Whether or not the result was truncated.
        truncated (1,1) logical
    end

    methods
        function obj = NotebookOutput(varargin)
            obj@matlab.databricks.StructOrCellDeserializable(varargin{:});
        end
    end
end