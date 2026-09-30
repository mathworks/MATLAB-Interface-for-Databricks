function tf = uploadInitscript(options)
    % UPLOADINITSCRIPT Uploads an init script to <interfaceDirectory settings field>/runtimes
    % This should come after the provisioning of runtimes and assumes a directory
    % exists for the runtimes.
    % The optional destination argument is the directory the runtime_install.sh file
    % will be copied to not the full path of copied file.

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.initscript string {mustBeTextScalar, mustBeNonzeroLengthText} = databricksRoot("script", "runtime_install.sh")
        options.destination string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.overwrite (1,1) logical
        options.verbose (1,1) logical = true
    end

    tf = false; % Assume failure

    % Get the interfaceDirectory settings value and append /runtimes
    if isfield(options, "interfaceDirectory")
        interfaceDirectory = options.interfaceDirectory;
    else
        interfaceDirectory = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory");
        if isempty(interfaceDirectory) || strlength(interfaceDirectory) == 0
            error("interfaceDirectory settings field not set");
        end
    end
    destination = string(strip(interfaceDirectory, "right", "/")) + "/runtimes";

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    filesObj = databricks.Files(args{:});
    destinationExistsTf = filesObj.directoryExists(destination);
    if ~destinationExistsTf
        fprintf(2, "Destination path not found: %s\n", destination);
        return;
    end

    if ~isfile(options.initscript)
        fprintf(2, "Local init script not found: %s", options.initscript);
        return;
    end

    [~, f, e] = fileparts(options.initscript);
    destinationFile = destination + "/" + string(f) +string(e);

    fprintf("Uploading the init script requires write access to: %s\n", destination);
    fprintf("This can be done by copying:\n");
    destinationDirWritable = true;
    args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
    destinationURL = matlab.databricks.setup.generateVolumeURL(destination, destinationDirWritable, args{:});
    destinationLink = matlab.utils.URL2Link(destinationURL, label=destination);
    fprintf("  %s to: %s\n", options.initscript, destinationLink);

    args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
    destinationWritable = true; % Set to yes to render the complete URL
    volumeURL = matlab.databricks.setup.generateVolumeURL(destination, destinationWritable, args{:});
    fprintf("  via: %s\n", matlab.utils.URL2Link(volumeURL));

    reply = strip(input('Attempt to copy the file using the REST API? Y/N [Y]: ','s'));
    if strcmpi(reply,'y') || strlength(reply) == 0
        args = {"verbose", false};
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"], args);
        filesObj = databricks.Files(args{:});
        destinationFileExists = filesObj.fileExists(destinationFile);

        if destinationFileExists
            if isfield(options, "overwrite")
                overwrite = options.overwrite;
                if overwrite
                    fprintf("Existing %s%s file will be overwritten\n", f,e);
                end
            else
                reply = strip(input('Overwrite the existing init script, if using the latest release this is recommended? Y/N [Y]: ','s'));
                if strcmpi(reply,'y') || strlength(reply) == 0
                    overwrite = true;
                else
                    overwrite = false;
                end
            end
            if ~overwrite
                % Nothing more to do not overwriting so return
                return;
            end
        end

        % If here overwriting or first write, overwrite is the default with upload
        args = {"verbose", false};
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"], args);
        [uploadTf, errorStruct] = uploadFile(options.initscript, destinationFile, args{:}); %#ok<ASGLU>
        if uploadTf
            if options.verbose
                fprintf("Init script uploaded to: %s\n", destinationFile);
            end
            tf = true;
        else
            fprintf(2, "Unable to upload init script to: %s\n", destinationFile);
        end
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
        error("DATABRICKS:UPLOADINITSCRIPT", "Only /Volumes paths are currently supported");
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    f = databricks.Files(args{:});
    if options.verbose
        fprintf("Uploading: %s to: %s\n", localFile, destinationFile)
    end
    [tf, errorStruct] = f.upload(localFile, destinationFile);
end
