function uploadDatasets(destinationDirectory, options)
    % uploadDatasets Uploads road profiles to Databricks from the data directory

    % Copyright 2022-2025 The MathWorks, Inc.

    arguments
        destinationDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    % Remove a trailing / if present
    if endsWith(destinationDirectory, "/")
        destinationDirectory = strip(destinationDirectory, "right", "/");
    end

    srcDir = fullfile(fileparts(mfilename("fullpath")), 'data');
    if ~isfolder(srcDir)
        error("Data set source directory not found: %s\nFirst run: createDataSets\n", srcDir);
    end
    srcFiles = dir(fullfile(srcDir, '*.parquet'));

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    io = databricks.internal.io.IO(args{:});

    if ~io.isfolder(destinationDirectory)
        fprintf(2, "Destination directory not found, attempting to create it: %s\n", destinationDirectory);
        if ~io.mkdir(destinationDirectory)
            error("Failed to create destination directory: %s", destinationDirectory);
        end
    end

    for n = 1:length(srcFiles) 
        srcFile = fullfile(srcDir, srcFiles(n).name);
        dstFile = destinationDirectory + "/" + string(srcFiles(n).name);
        fprintf("Uploading to: %s\n", dstFile);
        io.upload(srcFile, dstFile);
    end
end