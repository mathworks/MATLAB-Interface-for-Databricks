function uploadWheel(swo, options)
    % uploadWheel Upload wheel file to Databricks
    %
    % This will upload the wheel file to a default directory, related to
    % the interface directory.
    %
    %   swo.uploadWheel()
    %
    % To upload to a specific library, add an uploadDirectory argument.
    %
    %   swo.uploadWheel(uploadDirectory="/Volumes/main/default/myvolume/MyWheels")
    %

    % Copyright 2025 MathWorks, Inc.

    arguments
        swo (1,1) simwrapper.SimWrapper
        options.uploadDirectory string
    end

    if ~isDatabricksEnvironment
        warning("SPARKAP:codegen_wheel_upload", ...
            "Uploading the wheel automatically can only be done for a " + ...
            "Databricks environment.");
        return;
    end

    if isfield(options, 'uploadDirectory')
        uploadDirectory = strip(options.uploadDirectory, "right", "/");
    else
        interfaceDirectory = string(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));

        % Remove last directory
        interfaceDirectory = regexprep(interfaceDirectory, "(.+/)[^/]+", '$1');

        uploadDirectory = interfaceDirectory + "MyWheels";
    end

    F = databricks.Files();
    wheelFile = swo.getWheelFile;
    [~, plainName, plainExt] = fileparts(wheelFile);
    wheelName = plainName + plainExt;
    F.upload(wheelFile,  uploadDirectory + "/" + wheelName);

end