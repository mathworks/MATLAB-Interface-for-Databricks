function provisionMATLABRuntimes(options)
    % PROVISIONMATLABRUNTIMES Provision MATLAB runtimes in the Databricks environment
    % Requires permissions to create the destination directory if it does not already exist.
    % The default destination is the <interfaceDirectory settings field>/runtimes
    % Instructions for portal and notebook based use are provided.
    % 
    % This function is intended to be run interactively.

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments
        options.releases string {mustBeNonzeroLengthText}
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.verbose (1,1) logical = true
    end

    fprintf("\nConfiguring MATLAB runtimes in Databricks.\n\n");

    % Read the release sub struct from Software/MATLAB/config/package-settings.json
    [runtimeURLs, urlsTF] = getRuntimeURLs();
    if ~urlsTF
        fprintf(2, "Error getting runtime URLs.\n");
        return;
    end

    % Get the interfaceDirectory settings value and append /runtimes
    if isfield(options, "interfaceDirectory")
        interfaceDirectory = options.interfaceDirectory;
    else
        interfaceDirectory = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory");
        if isempty(interfaceDirectory) || strlength(interfaceDirectory) == 0
            error("interfaceDirectory settings field not set.");
        end
    end
    runtimesDir = string(strip(interfaceDirectory, "right", "/")) + "/runtimes";

    % Determine the runtimes to be used
    releases = getReleaseSelection(options, runtimeURLs);
    if options.verbose
        if numel(releases) == 0
            fprintf(2, "No runtime releases specified.\n");
        elseif numel(releases) == 1 %#ok<ISCL>
            fprintf("Configuring release: %s\n", releases);
        else
            releasesStr = join(releases, ", ");
            fprintf("Configuring releases: %s\n", releasesStr);
        end
    end
    
    % Check if the runtimes runtimesDir directory exists (/Volumes only)
    fprintf("Checking for <interface directory>/runtimes directory.\n");
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    io = databricks.internal.io.IO(args{:});
    runtimesDirExistsTf = io.isfolder(runtimesDir, "verbose", false, args{:});
    if runtimesDirExistsTf
        fprintf("Found: %s\n", runtimesDir);
    else
        fprintf(2, "Directory not found: %s\n", runtimesDir);
    end
    
    runtimesDirWritable = false;
    if runtimesDirExistsTf
        % Check we can write to the runtimesDir as the current user
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        if ~checkDestinationWritable(runtimesDir, "verbose", false, args{:})
            fprintf(2, "Could not write to the  <interface directory>/runtimes directory.\n");
        else
            runtimesDirWritable = true;
        end
    else
        [createTf, createError] = createDestination(runtimesDir, args{:});
        if createTf
            % Check we can write to the newly created directory
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            if ~checkDestinationWritable(runtimesDir, "verbose", false, args{:})
                fprintf(2, "Could not write to the  <interface directory>/runtimes directory.\n");
            else
                runtimesDirWritable = true;
            end
        else
            fprintf(2, "Error creating  <interface directory>/runtimes path: %s\n", runtimesDir);
            disp(createError);
            fprintf(2, "\nIt is probably that admin privileges are required in your Databricks environment to create\n");
            fprintf(2, "either the catalog, schema or directory. Instructions will be provided on how to proceed once\n");
            fprintf(2, "the  <interface directory>/runtimes path has been created or sufficient privileges allocated.\n");
        end
    end

    fprintf("\n");
    if ~runtimesDirWritable
        fprintf("Once the  <interface directory>/runtimes path has been created, with the required privileges.\n");
    end
    fprintf("MATLAB runtimes can be downloaded most quickly using a Databricks notebook.\n");
    fprintf("This requires the Databricks Workspace to have internet access to the respective URLs.\n");
    fprintf("The runtime .zip files should not be decompressed.\n");
    fprintf("Each runtime is approximately 4.5GB in size.\n");
    if numel(releases) > 0
        if numel(releases) == 1 %#ok<ISCL>
            fprintf("\nCreate a Databricks notebook with the following content for the specified release:\n\n");
        else
            fprintf("\nCreate a Databricks notebook with the following content for the specified releases:\n\n");
        end
        args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
        nbStr = generateNotebookContent(runtimesDir, releases, runtimeURLs, args{:});
        fprintf("\n\n%s\n\n\n", nbStr);
    else
        fprintf(2, "No runtime releases have been specified for download.\n");
    end

    if isscalar(releases)
        fprintf("Alternatively, download the runtime & libraries locally and then upload it to Databricks here:\n");
    else
        fprintf("Alternatively, download the runtimes & libraries locally and then upload them to Databricks here:\n");
    end
    args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
    fprintf("  %s\n\n", matlab.utils.URL2Link(matlab.databricks.setup.generateVolumeURL(runtimesDir, runtimesDirWritable, args{:})));
    
    fprintf("MATLAB runtimes are freely available from:\n  %s\n", matlab.utils.URL2Link("https://www.mathworks.com/products/compiler/matlab-runtime.html"));
    if numel(releases) > 0
        if isscalar(releases)
            fprintf("The specified runtime .zip file is:\n");
        else
            fprintf("The specified runtime .zip files are:\n");
        end
        args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
        io = databricks.internal.io.IO(args{:});
        for n = 1:numel(releases)
            url = matlab.net.URI(runtimeURLs.(releases(n)));
            filename = string(url.Path(end));
            fileExistsTf = io.isfile(runtimesDir + "/" + filename, verbose=false);
            if fileExistsTf
                fprintf("File already exists:  %s\n",  runtimesDir + "/" + filename);
            else
                fprintf("  %s\n",  matlab.utils.URL2Link(string(runtimeURLs.(releases(n)))));
            end
        end
    else
        fprintf(2, "No runtime releases have been specified for download.\n");
    end
    fprintf("\n");
end


function nbStr = generateNotebookContent(runtimesDir, releases, runtimeURLs, options)
    arguments
        runtimesDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        releases string
        runtimeURLs struct
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.verbose (1,1) logical = true;
    end

    % There are no releases to download
    if numel(releases) == 0
        nbStr = string.empty;
        return;
    end

    if endsWith(runtimesDir, "/")
        runtimesDirSlash = runtimesDir;
    else
        runtimesDirSlash = runtimesDir + "/";
    end

    nbStr = "############ COPY FROM HERE ############" + newline;
    nbStr = nbStr + sprintf("\n%%%%sh\n");
    nbStr = nbStr + "#" + newline;
    nbStr = nbStr + sprintf("# Notebook to Download MATLAB runtime(s) to: %s\n", runtimesDir);
    
    nbStr = nbStr + '# Include the preceding "%%sh"' + newline;
    nbStr = nbStr + "#" + newline;
    % List Required libraries
    nbStr = nbStr + "# Commands make offline (/Volumes/...) copies of required libraries which will be" + newline;
    nbStr = nbStr + "# installed if the cluster cannot connect to the internet using apt-get to do so." + newline;
    nbStr = nbStr + "apt-get update" + newline;
    nbStr = nbStr + "#" + newline;

    nbStr = nbStr + 'URL=$(apt-get download --print-uris libnss3 | cut -d " " -f 1 | tr -d "''")' + newline;
    nbStr = nbStr + "DECODEDURL=$(echo $URL | sed 's@+@ @g;s@%@\\x@g' | xargs -0 printf '%b')" + newline;
    nbStr = nbStr + 'FILENAME=$(basename "${DECODEDURL}")' + newline;
    nbStr = nbStr + sprintf('wget -timeout=30 --backups=0 -nv -O "%sdeps/${FILENAME}" ${URL}', runtimesDirSlash) + newline;
    
    nbStr = nbStr + "#" + newline;
    nbStr = nbStr + 'URL=$(apt-get download --print-uris libgbm1 | cut -d " " -f 1 | tr -d "''")' + newline;
    nbStr = nbStr + "DECODEDURL=$(echo $URL | sed 's@+@ @g;s@%@\\x@g' | xargs -0 printf '%b')" + newline;
    nbStr = nbStr + 'FILENAME=$(basename "${DECODEDURL}")' + newline;
    nbStr = nbStr + sprintf('wget -timeout=30 --backups=0 -nv -O "%sdeps/${FILENAME}" ${URL}', runtimesDirSlash) + newline;
    nbStr = nbStr + "#" + newline;

    % List MATLAB Runtime Jars
    nbStr = nbStr + sprintf("# Commands to download MATLAB runtime .zip files\n");
    if numel(releases) > 0
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        io = databricks.internal.io.IO(args{:});
        for n = 1:numel(releases)
            url = matlab.net.URI(runtimeURLs.(releases(n)));
            filename = string(url.Path(end));
            fileExistsTf = io.isfile(runtimesDirSlash+filename, "verbose", false, args{:});
            if fileExistsTf
                nbStr = nbStr + "# File already exists - commenting out following download" + newline;
                nbStr = nbStr + sprintf("# wget -timeout=30 -nv -O %s %s\n", runtimesDirSlash+filename, runtimeURLs.(releases(n)));
            else
                nbStr = nbStr + sprintf("wget -timeout=30 -nv -O %s %s\n", runtimesDirSlash+filename, runtimeURLs.(releases(n)));
            end 
        end
    else
        nbStr = nbStr + "# No MATLAB releases selected so no MATLAB runtimes listed for download" + newline;
    end

    nbStr = nbStr + sprintf("\n################ TO HERE ###############\n");
end


function [tf, writeError] = checkDestinationWritable(runtimesDir, options)
    % checkDestinationWritable Writes and removes a temporary file to the runtimesDir path to check it is writable
    arguments
        runtimesDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.verbose (1,1) logical = true;
    end

    if options.verbose
        fprintf("Checking  <interface directory>/runtimes is writable.\n");
    end

    tmpFilePath = [tempname, '.deleteme'];
    [fid, errmsg] = fopen(tmpFilePath, "w");
    if fid == -1
        error("DATABRICKS:PROVISIONMATLABRUNTIMES", "Unable to open temporary local file: %s\nMessage: %s", tmpFilePath, errmsg);
    end
    fprintf(fid, "Temporary test file to check if this location is writable - this file should be deleted.\n");
    fclose(fid);
    cleanup = onCleanup(@()deleteLocalFile(tmpFilePath));

    [~, f, e] = fileparts(tmpFilePath);
    runtimesDirFile = runtimesDir + "/" + string(f) +string(e);
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
    [uploadTf, errorStruct] = uploadFile(tmpFilePath, runtimesDirFile, args{:});
    if uploadTf
        % If the upload worked it is expected the rm will work too
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        f = databricks.Files(args{:});
        [rmTf, errorStruct] = f.rm(runtimesDirFile);
        if ~rmTf
            fprintf(2, "Error deleting: %s\n", runtimesDirFile);
        end
        writeError = errorStruct;
        tf = rmTf;
    else
        writeError = errorStruct;
        tf = uploadTf;
    end
end


function [tf, errorStruct] = uploadFile(localFile, destinationFile, options)
    arguments
        localFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        destinationFile string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true;
    end

    if ~startsWith(destinationFile, "/Volumes/")
        error("DATABRICKS:PROVISIONMATLABRUNTIMES", "Only /Volumes paths are currently supported.");
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    f = databricks.Files(args{:});
    if options.verbose
        fprintf("Uploading: %s to: %s\n", localFile, destinationFile)
    end
    [tf, errorStruct] = f.upload(localFile, destinationFile);
end


function deleteLocalFile(filePath)
    arguments
        filePath string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if isfile(filePath)
        delete(filePath)
    end
end


function localFile = getLocalCopy(url, options) %#ok<DEFNU>
    arguments
        url (1,1) matlab.net.URI;
        options.verbose (1,1) logical = true;
    end

    filePath = fullfile(tempdir, url.Path(end));
    if options.verbose
        fprintf("Downloading: %s\n", url.EncodedURI);
    end
    localFile = websave(filePath, url);
end


function [tf, errorResponse] = createDestination(destination, options)
    % createDestination Attempts to create a directory oin /Volumes
    arguments
        destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true;
    end

    if ~startsWith(destination, "/Volumes/")
        error("DATABRICKS:PROVISIONMATLABRUNTIMES", "Only /Volumes paths are currently supported.");
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    f = databricks.Files(args{:});
    if options.verbose
        fprintf("Creating: %s\n", destination);
    end
    [tf, errorResponse] = f.create(destination);
end


function releases = getReleaseSelection(options, runtimeURLs)
    % getReleaseSelection Determine the runtimes to be used
    % May be the current release only, the specified releases or the releases
    % listed in the package-settings.json file.
    arguments
        options struct
        runtimeURLs struct
    end

    releases = string.empty;

    if isfield(options, "releases")
        releases = options.releases;
    else
        fields = fieldnames(runtimeURLs);
        for n = 1:numel(fields)
            releases(end+1) = string(fields{n}); %#ok<AGROW>
        end
    end
end


function [runtimeURLs, tf] = getRuntimeURLs()
    % Read the release sub struct from Software/MATLAB/config/package-settings.json
    % Default to returning an empty struct, an error state
    
    pkgSettings = matlab.databricks.internal.pkgsettings.getPkgSettings;
    runtimeURLs = struct;
    for n = 1:numel(pkgSettings.supportedMATLABReleases)
        fieldName = matlab.lang.makeValidName(pkgSettings.supportedMATLABReleases(n).release);
        runtimeURLs.(fieldName) = pkgSettings.supportedMATLABReleases(n).runtimeURL;
    end
    tf = true;
end
