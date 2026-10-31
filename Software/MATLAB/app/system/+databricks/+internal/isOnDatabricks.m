function tf = isOnDatabricks()
    % ISONDATABRICKS Returns true if running on Databricks otherwise false
    %
    % Example:
    %   tf = databricks.internal.isOnDatabricks()

    % Copyright 2025-2026 The MathWorks, Inc.

    tf = databricks.internal.isOnDatabricksImpl();
end