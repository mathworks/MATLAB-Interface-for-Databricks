function tf = configureJDBC(varargin)
    % CONFIGUREJDBC Queries acceptance of Databricks JDBC Driver licenses
    % If the licenses are not accepted the drivers are renamed such that they are
    % not automatically configured for use.
    %
    % Returns false if the license is not accepted or if a driver file is not found.
    %
    % Example
    %   tf = matlab.databricks.setup.configureJDBC();

    % Copyright 2024-2026 The MathWorks, Inc.
    tf = matlab.internal.databricks.setup.configureJDBC(varargin{:});
end
