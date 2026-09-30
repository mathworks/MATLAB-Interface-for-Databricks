classdef CommandExecution < databricks.Object
    % COMMANDEXECUTION MATLAB Class for interacting with the Databricks Command Execution API
    % For details see: https://docs.databricks.com/api/workspace/commandexecution

    % Copyright 2023-2024 The MathWorks, Inc.

    properties (Hidden)
        HTTPOptions matlab.net.http.HTTPOptions
    end

    methods
        function obj = CommandExecution(varargin)
            % Command Execution Constructor

            if verLessThan('matlab', '9.9')
                error("DATABRICKS:COMMANDEXECUTION","Command Execution requires MATLAB R2020b or later");
            end

            obj.Version = '1.2';
            obj.HTTPOptions = databricks.internal.getHTTPOptions(convertResponse=false);
            obj.getAuth(varargin{:});
        end
    end
end