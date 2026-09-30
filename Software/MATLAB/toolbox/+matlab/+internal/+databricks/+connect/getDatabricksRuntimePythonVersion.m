function pyVersion = getDatabricksRuntimePythonVersion(runtimeVersion)
    % GETDATABRICKSRUNTIMEPYTHONVERSION Gets the Python version used by a Databricks Runtime
    %
    % Example:
    %   pyVersion = matlab.internal.databricks.connect.getDatabricksRuntimePythonVersion("16.4.1")
    %   pyVersion =
    %      "3.12"

    % Copyright 2025-2026 The MathWorks, Inc.

    arguments (Input)
        runtimeVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        pyVersion string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if startsWith(runtimeVersion, "13.") || startsWith(runtimeVersion, "14.")
        pyVersion = "3.10";
    elseif startsWith(runtimeVersion, "15.")
        pyVersion = "3.11";
    elseif startsWith(runtimeVersion, "16.") || startsWith(runtimeVersion, "17.")
        pyVersion = "3.12";
    else
        error("DATABRICKS:GETDATABRICKSRUNTIMEPYTHONVERSION", "Unsupported Databricks runtime version: %s", runtimeVersion);
    end
end
