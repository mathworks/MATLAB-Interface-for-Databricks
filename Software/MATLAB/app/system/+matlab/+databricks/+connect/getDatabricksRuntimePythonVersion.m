function pyVersion = getDatabricksRuntimePythonVersion(varargin)
% GETDATABRICKSRUNTIMEPYTHONVERSION Gets the Python version used by a Databricks Runtime
%
% Example:
%   pyVersion = matlab.databricks.connect.getDatabricksRuntimePythonVersion("16.4.1")
%   pyVersion =
%      "3.12"

% Copyright 2025-2026 The MathWorks, Inc.

    % TODO: Move 18.x mapping into matlab.internal.databricks.connect.getDatabricksRuntimePythonVersion
    runtimeVersion = string(varargin{1});
    if startsWith(runtimeVersion, "18.")
        pyVersion = "3.12";
    else
        pyVersion = matlab.internal.databricks.connect.getDatabricksRuntimePythonVersion(varargin{:});
    end
end
