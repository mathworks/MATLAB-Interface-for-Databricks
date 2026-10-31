classdef DBFS < databricks.Object
    % DBFS Databricks interface to access the DBFS
    % Interface to connect to the Databricks file system (DBFS) via the
    % databricks 2.0 REST API. Please see the documentation at:
    % https://docs.databricks.com/api/latest/index.html
    %
    % For example:
    %
    %   % Create a databricks DBFS interface
    %   db = databricks.DBFS();
    
    % Copyright 2019 The MathWorks, Inc.
    
    
    methods
        %% Constructor
        function obj = DBFS(varargin)
            
            obj.getAuth(varargin{:});
            
        end
    end
    
    methods (Hidden, Access=protected)
        [rawBytes, numBytes] = readFileSection(obj, pathStr, offset, length)
    end
    
end %class
