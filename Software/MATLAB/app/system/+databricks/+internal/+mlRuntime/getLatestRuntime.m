function rtPath = getLatestRuntime(options)
    % GETLATESTRUNTIME Returns the most recent release for a given release
    % If a release is not specified the current release is used.
    % A release should be specified in the form R2024a
    % A runtimes directory may be specified otherwise
    % databricks-settings.json:interfaceDirectory/runtimes/ is used.
    % Only volumes /Volumes/ paths are supported.
    % If no match is found or the directory does not exist an empty
    % string is returned.

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.directory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.release string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if isfield(options, "directory")
        directory = options.directory;
    else
        interfaceDirectory = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory");
        if isempty(interfaceDirectory) || strlength(interfaceDirectory) == 0
            error("DATABRICKS:GETLATESTRUNTIME", "interfaceDirectory not defined in databricks-settings.json")
        else
            interfaceDirectory = string(strip(interfaceDirectory, "right", "/"));
            directory = interfaceDirectory + "/runtimes";
        end
    end

    if ~startsWith(directory, "/Volumes/")
        fprintf(2, "Only /Volumes paths are currently supported.\n");
        rtPath = string.empty;
        return;
    end

    if isfield(options, "release")
        release = options.release;
        checkRelease(release);
    else
        release = matlabRelease().Release;
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    f = databricks.Files(args{:});

    if ~f.directoryExists(directory)
        fprintf(2, "Directory not found: %s\n", directory);
        rtPath = string.empty;
        return;
    end

    dirListing = f.list(directory);
    if ~isprop(dirListing, "contents")
        fprintf(2, "No contents found in directory listing response.\n");
        rtPath = string.empty;
        return;
    end

    runtimeMatches = string.empty;
    % Form of name MATLAB_Runtime_R2024a_Update_5_glnxa64.zip or MATLAB_Runtime_R2024a_glnxa64.zip
    filenamePattern = "MATLAB_Runtime_" + release + "_" + wildcardPattern + "glnxa64.zip";
    for n = 1:numel(dirListing.contents)
        if ~isprop(dirListing.contents(n), "name")
            fprintf(2, "Name property not found in directory listing entry of: %s\n", directory);
        else
            filename = dirListing.contents(n).name;
            if matches(filename, filenamePattern)
                runtimeMatches(end+1) = filename; %#ok<AGROW>
            end
        end
    end

    if numel(runtimeMatches) == 0
        rtPath = string.empty;
    elseif numel(runtimeMatches) == 1 %#ok<ISCL>
        rtFile = runtimeMatches(1);
        rtPath = directory + "/" + rtFile;
    else
        % sort will put "update0" first if this happens and there is another entry
        % then the 2nd entry is the latest so take that
        update0 = "MATLAB_Runtime_" + release + "_glnxa64.zip";
        sorted = sort(runtimeMatches, 'descend');
        if strcmp(sorted(1), update0)
            rtFile = sorted(2);
        else
            rtFile = sorted(1);
        end
        rtPath = directory + "/" + rtFile;
    end
end


function checkRelease(release)
    arguments
        release string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    releasePat = "R" + digitsPattern(4) + characterListPattern("ab");
    if ~matches(release, releasePat)
        error("DATABRICKS:GETLATESTRUNTIME", "Expected release to match the pattern R[year][a|b] e.g.: R2024a, received: %s", release);
    end
end