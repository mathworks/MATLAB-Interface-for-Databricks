function rmUnusedWhls()
    % RMUNUSEDWHLS Remove .whl files & directory for other architectures
    % Confirmation is not requested.
    %
    % This function should no longer be needed and will removed without further
    % notice in a future release.
    %
    % Example:
    %   matlab.databricks.setup.rmUnusedWhls();

    %  Copyright 2024-2025 MathWorks, Inc.

    fprintf(2, "This function will be removed without further notice in a future release.\n");

    connectDir = databricksRoot("Connect");
    connectDirList = dir(connectDir);

    pat = digitsPattern(2) + characterListPattern(".") + digitsPattern(1);
    versionDirs = string.empty;
    for n = 1:numel(connectDirList)
        if connectDirList(n).isdir && matches(connectDirList(n).name, pat)
            versionDirs(end+1) = connectDirList(n).name; %#ok<AGROW>
        end
    end

    rmList = string.empty;
    for n = 1:numel(versionDirs)
        if ispc
            rmList(end+1) = fullfile(connectDir, versionDirs(n), "whls", "maca64"); %#ok<AGROW>
            rmList(end+1) = fullfile(connectDir, versionDirs(n), "whls", "glnxa64"); %#ok<AGROW>
        elseif ismac
            rmList(end+1) = fullfile(connectDir, versionDirs(n), "whls", "win64"); %#ok<AGROW>
            rmList(end+1) = fullfile(connectDir, versionDirs(n), "whls", "glnxa64"); %#ok<AGROW>
        else
            rmList(end+1) = fullfile(connectDir, versionDirs(n), "whls", "win64"); %#ok<AGROW>
            rmList(end+1) = fullfile(connectDir, versionDirs(n), "whls", "maca64"); %#ok<AGROW>
        end
    end

    for n = 1:numel(rmList)
        if isfolder(rmList(n))
            fprintf("Removing: %s\n", rmList(n));
            [status,msg] = rmdir(rmList(n));
            if status ~= 1
                fprintf(2, "Error removing: %s\nMessage: %s\n", rmList(n), msg);
            end
        else
            fprintf(2, "Directory not found: %s\n", rmList(n));
        end
    end
end