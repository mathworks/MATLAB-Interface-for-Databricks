function pyVersion = getDatabricksRuntimePythonVersion(varargin)
% GETDATABRICKSRUNTIMEPYTHONVERSION Gets the Python version used by a Databricks Runtime
%
% Example:
%   pyVersion = matlab.databricks.connect.getDatabricksRuntimePythonVersion("16.4.1")
%   pyVersion =
%      "3.12"

% Copyright 2025-2026 The MathWorks, Inc.

    % Databricks Runtime 18 is the first release to use this unified format.
    % Previously, each feature version (18.0, 18.1, 18.2) had its own release notes page.
    % Features that would previously have shipped
    % as 18.3 or later now ship as dated updates to Databricks Runtime 18.
    % https://docs.databricks.com/aws/en/release-notes/runtime/18
    % If the runtime is 18 and DBClient version is 18.x, it is supported
    % TODO: Move 18.x mapping into matlab.internal.databricks.connect.getDatabricksRuntimePythonVersion
    runtimeVersion = string(varargin{1});
    % "18" (dated updates) and "18.<minor>" both map to the DBR 18 Python version
    if extractBefore(runtimeVersion + ".", ".") == "18"
        pyVersion = "3.12";
    else
        pyVersion = matlab.internal.databricks.connect.getDatabricksRuntimePythonVersion(varargin{:});
    end
end
