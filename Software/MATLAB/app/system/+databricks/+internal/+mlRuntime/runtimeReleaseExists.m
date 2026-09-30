function tf = runtimeReleaseExists(options)
    % RUNTIMERELEASEEXISTS Returns true if a runtime .zip for a given release is found
    % Otherwise false is returned.

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
        tf = false;
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
        tf = false;
        return;
    end

    dirListing = f.list(directory);
    if ~isprop(dirListing, "contents")
        fprintf(2, "No contents found in directory listing response.\n");
        tf = false;
        return;
    end

    % Form of name MATLAB_Runtime_R2024a_Update_5_glnxa64.zip or MATLAB_Runtime_R2024a_glnxa64.zip
    filenamePattern = "MATLAB_Runtime_" + release + "_" + wildcardPattern + ".zip";
    for n = 1:numel(dirListing.contents)
        if ~isprop(dirListing.contents(n), "name")
            fprintf(2, "Name property not found in directory listing entry of: %s\n", directory);
        else
            filename = dirListing.contents(n).name;
            if matches(filename, filenamePattern)
                tf = true;
                break
            end
        end
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