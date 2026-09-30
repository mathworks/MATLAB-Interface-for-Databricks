function tf = isOnDatabricksImpl()
    % ISONDATABRICKSIMPL Returns true if running on Databricks otherwise false
    %
    % Example:
    %   tf = databricks.internal.isOnDatabricksImpl()

    % Copyright 2025-2026 The MathWorks, Inc.

    str = string(getenv("PYSPARK_PYTHON"));
    tf = str.startsWith("/databricks/python");
end