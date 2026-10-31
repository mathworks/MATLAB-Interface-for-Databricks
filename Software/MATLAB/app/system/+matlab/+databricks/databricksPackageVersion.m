function version = databricksPackageVersion
    % DATABRICKSPACKAGEVERSION Returns the version of the package as string
    % If the version cannot be determined an empty string is returned.
    %
    % Example
    %   v = matlab.databricks.databricksPackageVersion()

    % (c) 2024-2026 MathWorks, Inc.

  version = matlab.internal.databricks.databricksPackageVersion();
end