function version = databricksPackageVersion
    % DATABRICKSPACKAGEVERSION Returns the version of the package as string
    % If the version cannot be determined an empty string is returned.
    %
    % Example
    %   v = matlab.internal.databricks.databricksPackageVersion()

    % Copyright 2024-2026 The MathWorks, Inc.

    root = matlab.internal.databricksRoot();
    versionFile = fullfile(root, 'VERSION');

    if ~isfile(versionFile)
        % Check if the code is using the old PSP codepath
        versionFile = matlab.internal.databricksRoot(-2, "VERSION");
    end

    if isfile(versionFile)
        version = strip(string(fileread(versionFile)));
    else
        fprintf(2, "VERSION file not found: %s\n", versionFile)
        version = string.empty;
    end
    
end
