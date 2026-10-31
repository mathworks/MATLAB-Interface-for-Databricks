function finish()
    % finish - Runs at the end of a MATLAB session
    %
    % This function runs at the end of MATLAB session, and will only be
    % active when it's running on a Databricks node.
    %
    % It's controlled by the environment variables MW_STARTUP_SHUTDOWN_CONFIG,
    % which contains the JSON-file with the startup/shutdown configuration.

    % Copyright 2025-2026 The MathWorks, Inc.

    if databricks.internal.isOnDatabricks()

        startupShutdownConfig = getenv('MW_STARTUP_SHUTDOWN_CONFIG');
        if strlength(startupShutdownConfig) > 0
            pyLibDir = databricksRoot(-1, 'Python');
            if isfile(startupShutdownConfig)
                pyrun(sprintf(...
                    "import sys; sys.path.insert(0, '%s'); " + ...
                    "from mw_context.mw_prefs import shutdown; " + ...
                    "shutdown('%s')", pyLibDir, startupShutdownConfig));
            else
                fprintf(2, "File with Startup/Shutdown configuration not found: %s\n", startupShutdownConfig);
            end
        end
    end

end