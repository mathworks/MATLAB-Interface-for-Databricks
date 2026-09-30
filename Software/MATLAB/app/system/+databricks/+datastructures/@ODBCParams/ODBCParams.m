classdef ODBCParams < matlab.databricks.StructOrCellDeserializable
    % ODBCPARAMS Databricks ODBCParams Data Structure
    
    % Copyright 2022 The MathWorks, Inc.
    properties
        % ODBC server hostname.
        hostname string
        % ODBC server path.
        path string
        % ODBC server protocol.
        protocol string
        % ODBC server port.
        port int32
    end
    methods
        function obj = ODBCParams(varargin)
            obj@matlab.databricks.StructOrCellDeserializable(varargin{:});
        end
    end    
end