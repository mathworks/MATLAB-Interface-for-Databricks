function tf = configureJDBC(varargin)
    % CONFIGUREJDBC Configures the path to the Databricks JDBC driver
    % The Databricks JDBC driver is not bundled with this package and must be
    % downloaded separately. This function prompts the user to provide the
    % path to their downloaded driver and saves it to databricks-settings.json.
    %
    % Returns false if the driver path is not provided or is invalid.
    %
    % Example
    %   tf = matlab.databricks.setup.configureJDBC();

    % Copyright 2024-2026 The MathWorks, Inc.
    tf = matlab.internal.databricks.setup.configureJDBC(varargin{:});
end
