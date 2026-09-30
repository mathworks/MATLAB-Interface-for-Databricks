function archiveSettingsFiles(options)
    % archiveSettingsFiles Archives
    % For certain major version migration or for experimentation purposes
    % it maybe required or useful to archive settings and configuration
    % files for future reference.
    %
    % The archived files are:
    %   [home directory]/.databricks-connect
    %   [home directory]/.databrickscfg
    %   [prefdir]/.databricks-settings.json
    %
    % For details of prefdir see: doc prefdir
    %
    % Optional named arguments:
    %
    %     dryRun: If set to true then the function will report its planned actions
    %             but will not move files. No archive will be made.
    %             Default is false.
    %
    %  outputDir: Specify an alternative output directory.
    %             Default is: [home directory]/databricks-settings-archive
    %             If the directory does not exist it will be created.
    %             If the directory contains a previous archive files
    %             will be overwritten.
    %
    % Example:
    %   matlab.databricks.setup.archiveSettingsFiles(dryRun=true)

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.dryRun (1,1) logical = false
        options.outputDir string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if options.dryRun
        fprintf(2, "\nDry run enabled, files will not be moved.\n");
    end

    fprintf("\n");
    fprintf("Settings and configuration file archival\n\n");
    
    homeDir = matlab.utils.getHomeDirectory();

    if isfield(options, "outputDir")
        outputDir = options.outputDir;
    else
        outputDir = fullfile(homeDir, "databricks-settings-archive");
    end

    if isfolder(outputDir)
        fprintf("Existing output directory found: %s\n", outputDir);
    else
        fprintf("Output directory not found.\nCreating: %s\n", outputDir);
        if ~options.dryRun
            [status, msg] = mkdir(outputDir);
            if status ~= 1
                error("Output directory creation failed.\nMessage: %s", msg);
            end
        end
    end

    dbConnectPath = fullfile(homeDir, ".databricks-connect");
    fprintf("Checking for: %s\n", dbConnectPath);
    if isfile(dbConnectPath)
        archive(dbConnectPath, outputDir, options.dryRun);
    end

    databrickscfgPath = fullfile(homeDir, ".databrickscfg");
    fprintf("Checking for: %s\n", databrickscfgPath)
    if isfile(databrickscfgPath)
        archive(databrickscfgPath, outputDir, options.dryRun);
    end

    settingsPath = fullfile(prefdir, "databricks-settings.json");
    fprintf("Checking for: %s\n", settingsPath)
    if isfile(settingsPath)
        archive(settingsPath, outputDir, options.dryRun);
    end
    
    fprintf("Done.\n");
end


function archive(src, dst, dryRun)
    arguments
        src string {mustBeTextScalar, mustBeNonzeroLengthText}
        dst string {mustBeTextScalar, mustBeNonzeroLengthText}
        dryRun (1,1) logical = false
    end

    if isfolder(dst)
        if isfile(src)
            fprintf("Moving: %s, to %s\n", src, dst);
            if ~dryRun
                [status, msg] = movefile(src, dst);
                if status ~= 1
                    error("Move failed for: %s\nMessage: %s", src, msg);
                end
            end
        else
            fprintf(2, "Source file not found, not archiving: %s\n", src);
        end
    else
        fprintf(2, "Destination directory not found: %s\n", dst);
        fprintf(2, "Not archiving: %s\n", src);
    end
end
