classdef IO  < databricks.Object
    % IO Class to provide an interface to the Databricks file APIs
    %
    % Examples:
    %   io = databricks.internal.io.IO();
    %
    %   io = databricks.internal.io.IO(authMethod="PAT");
    
    % Copyright 2024-2025 The MathWorks, Inc.

    properties (Hidden)
        % Used to pass varargin arguments to resulting Files, Workspace or DBFS object
        parentVarargin
    end

    methods
        function obj = IO(varargin)
            % IO Constructor
            if verLessThan('matlab', '9.13') %#ok<VERLESSMATLAB>
                error("DATABRICKS:IO", "databricks.internal.io.IO requires MATLAB R2022b or later.");
            end

            obj.parentVarargin = varargin;
        end
    end

    
    methods (Static)
        type = getType(path, options);
        path = stripTrailingSlashes(path, options);
        [path, file, extension] = fileparts(inputPath, options);
    end
end