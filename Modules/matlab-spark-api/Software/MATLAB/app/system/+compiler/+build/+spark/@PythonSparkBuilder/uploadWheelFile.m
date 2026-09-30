function [tf, wheelDestFile] = uploadWheelFile(PSB, options)
    % uploadWheelFile Upload the wheel file
    %
    % This method is currently only supported on Databricks. If the option
    % wheelDestination was used during build, it doesn't need an argument
    % for the destination. The destination should either be a Volume directory or
    % a Workspace directory. This function will return true if the upload
    % was successful, false otherwise.
    %
    % Call it like this:
    %   PSB.uploadWheelFile(destination="/Volumes/main/default/myvolume/MyWheels");
    %
    % or if wheelDestination was specified during build:
    %   PSB.uploadWheelFile();
    %
    %      destination : A directory to upload to
    %
    %       authMethod : A matlab.databricks.AuthMethod.
    %
    %      profileName : A configuration file profileName value.
    
    % Copyright 2026 The MathWorks, Inc.

    arguments (Input)
        PSB (1,1) compiler.build.spark.PythonSparkBuilder
        options.destination (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end
    arguments (Output)
        tf (1,1) logical
        wheelDestFile (1,1) string
    end

    if ~isDatabricksEnvironment()
        error("SPARKAPI:UPLOADWHEEL:PLATFORMS", ...
            "The uploadWheel method currently only works on " + ...
            "the Databricks platform. In this environment, it will have no effect.");
    end

    [fullWheelSrc, plainWheelName] = PSB.getWheelFile();

    if isfield(options, 'destination')
        dest = options.destination;
    elseif ~isempty(PSB.WheelDestination)
        dest = PSB.WheelDestination;
    else
        error("SPARKAPI:WHEELUPLOAD:DESTMISSING", ...
            "When uploading a wheel file, a destination must be provided, " + ...
            "either through an optional argument or by setting WheelDestination " + ...
            "during build.");
    end

    % Clean destination
    dest = strip(dest, "right", "/");

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);

    io = databricks.internal.io.IO(args{:});
    if ~io.isfolder(dest)
        if ~io.mkdir(dest)
            error("SPARKAPI:WHEELUPLOAD:MKDIRFAILED", ...
                "Failed to create destination directory: " + dest);
        end
    end

    wheelDestFile = dest + "/" + string(plainWheelName);
    io.upload(fullWheelSrc, wheelDestFile);

    tf = io.isfile(wheelDestFile);
end
