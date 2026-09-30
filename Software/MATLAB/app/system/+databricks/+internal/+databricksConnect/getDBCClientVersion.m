function connectClientVersion = getDBCClientVersion()
    % GETDBCCLIENTVERSION Returns the version string of the Databricks Connect Python package
    %
    % Returns a string e.g. 16.4.10 or 16.4
    %
    % If the package is not installed, an error is raised.
    %
    % Example:
    %   ver = databricks.internal.databricksConnect.getDBCClientVersion();

    % Copyright 2025-2026 MathWorks Inc.

    if databricks.internal.isOnDatabricks()
        try
            connectClientVersion = string(pyrun("from pyspark.dbconnect_version import __dbconnect_version__ ; x = __dbconnect_version__", "x"));
            if strcmpi(connectClientVersion, "DBCONNECT_VERSION")
                % See: /databricks/spark/python/pyspark/dbconnect_version.py
                connectClientVersion = string(getenv("DATABRICKS_RUNTIME_VERSION"));
                if isempty(connectClientVersion) || strlength(connectClientVersion) == 0
                    error("DATABRICKS:DATABRICKSCONNECT:GETDBCCLIENTVERSION",...
                        "Could not determine Databricks Connect version from pyspark.dbconnect_version or $DATABRICKS_RUNTIME_VERSION.\n");
                end
            end
        catch ME
            fprintf(2, "Could not determine Databricks Connect version.\n");
            rethrow(ME);
        end
    else
        pkgName = "databricks.connect";
        try
            connectClientVersion = string(py.importlib.metadata.version(string(pkgName)));
        catch ME
            if isprop(ME, "message") && strcmpi(ME.message, sprintf("Python Error: PackageNotFoundError: No package metadata was found for %s", pkgName))
                error("DATABRICKS:DATABRICKSCONNECT:GETDBCCLIENTVERSION",...
                    "The %s package is not installed in the current Python environment.\n" + ...
                    "See: %s", pkgName, matlab.utils.editLink(databricksRoot(-2, "Documentation", "DBConnect.md")));
            else
                rethrow(ME);
            end
        end
    end
end
