function result = provisionJavabuilderJars(options)
    % PROVISIONJAVABUILDERJARS Attempts to upload a set of javabuilder jar files
    % Requires permissions to create the javabuilder directory if it does not already exist.
    % The javabuilder path is <interfaceDirectory settings field>/runtimes/javabuilder
    % Instructions for portal use are provided.
    %
    % This function is intended to be run interactively.
    %
    % Example:
    %   matlab.databricks.setup.provisionJavabuilderJars(interfaceDirectory="/Volumes/main/default/myvolume/MathWorks")

    % Copyright 2024 The MathWorks, Inc.

    arguments
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.overwrite (1,1) logical = true
        options.verbose (1,1) logical = true
    end

    result = false; % Assume failure
    
    fprintf("\nUploading the javabuilder libraries required by the MATLAB runtimes\n");

    % Get a list of javabuilder files in /Software/MATLAB/lib/jar
    localJarDir = databricksRoot("lib", "jar");
    javabuilderPattern = "javabuilder_R" + digitsPattern(4) + characterListPattern("ab") + "U" + digitsPattern(1,2) + ".jar";
    dirList = dir(localJarDir);
    entryNames = string({dirList.name});
    matchIdx = matches(entryNames, javabuilderPattern);
    localJarList = localJarDir + filesep + entryNames(matchIdx);

    if numel(localJarList) == 0
        fprintf(2, "No local copies of javabuilder_<Release>U<n>.jar were found in: %s\n", localJarDir);
        javaBuilderInfo = hasLocalJavaBuilder();
        if ~isempty(javaBuilderInfo)
            fprintf("A local javabuilder.jar was found in your MATLAB installation:\n");
            fprintf("\t%s\n", javaBuilderInfo.LocalFullName);
            fprintf("This file can be uploaded to Databricks. This will enable running compiled MATLAB code on Databricks\n");
            fprintf("for the current MATLAB Release (%s).\n", javaBuilderInfo.MATLABRelease);
            prompt = "Upload local javabuilder.jar as " + javaBuilderInfo.ReleaseName;
            uploadLocalJar = matlab.utils.ynQuestion(prompt, "Y");
            if uploadLocalJar
                mkdir(javaBuilderInfo.LocalDir);
                deleteAfter = onCleanup(@() rmdir(javaBuilderInfo.LocalDir, 's'));
                copyfile(javaBuilderInfo.LocalFullName, javaBuilderInfo.LocalTempName)
                localJarList = javaBuilderInfo.LocalTempName;
            end
        end
    end
    if numel(localJarList) == 0
        fprintf(2, "Not uploading any javabuilder jar files to the cluster.\n");
        fprintf(2, "It will not be possible to run compiled MATLAB code on the cluster until this has been done.\n")
        fprintf(2, "Other aspects of the interface should work normally.\n")
        return;
    end

    % Get the interfaceDirectory settings value and append /runtimes/javabuilder
    if isfield(options, "interfaceDirectory")
        interfaceDirectory = options.interfaceDirectory;
    else
        interfaceDirectory = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory");
        if isempty(interfaceDirectory) || strlength(interfaceDirectory) == 0
            error("interfaceDirectory settings field not set");
        end
    end
    javabuilderDir = string(strip(interfaceDirectory, "right", "/")) + "/runtimes/javabuilder";

    % Check there isn't a file that clashes with the javabuilderDir directory name
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    io = databricks.internal.io.IO(args{:});
    if io.isfile(javabuilderDir, args{:})
        fprintf(2, "A file already exists named: %s\n", javabuilderDir);
        return;
    end
    % Check if the javabuilderDir directory already exists
    javabuilderDirExists = io.isfolder(javabuilderDir, args{:});

    % Instruct on a manual upload
    fprintf("Uploading the files requires write access to: %s\n", javabuilderDir);
    fprintf("This can be done by copying:\n");
    for n = 1:numel(localJarList)
        fprintf("  %s\n", localJarList(n));
    end
    args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
    javabuilderDirWritable = true;
    javabuilderDirPortalURL = matlab.databricks.setup.generateVolumeURL(javabuilderDir, javabuilderDirWritable, args{:});
    javabuilderDirLink = matlab.utils.URL2Link(javabuilderDirPortalURL, label=javabuilderDir);
    fprintf("to: %s\n", javabuilderDirLink);

    args = matlab.utils.addArgs(options, ["profileName", "verbose"]);
    % Set to yes to render the complete URL if the javabuilderDir exists
    volumeURL = matlab.databricks.setup.generateVolumeURL(javabuilderDir, javabuilderDirExists, args{:});
    fprintf("  via: %s\n", matlab.utils.URL2Link(volumeURL));

    reply = strip(input('Attempt to copy the files using the REST API? Y/N [Y]: ','s'));
    if strcmpi(reply,'y') || strlength(reply) == 0
        if ~startsWith(javabuilderDir, "/Volumes/")
            error("DATABRICKS:PROVISIONJAVABUILDERJARS", "Only /Volumes paths are currently supported");
        end

        % First try to create the javabuilderDir MathWorks/runtimes/javabuilder directory if possible
        if ~javabuilderDirExists
            % TODO replace create with a generic version
            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            filesObj = databricks.Files(args{:});
            if options.verbose
                fprintf("Creating: %s\n", javabuilderDir);
            end
            [createTf, createError] = filesObj.create(javabuilderDir);
            if ~createTf
                fprintf(2, "Error creating javabuilder directory: %s\n", javabuilderDir);
                disp(createError);
                fprintf(2, "\nIt is probable that admin privileges are required in your Databricks environment to create\n");
                fprintf(2, "the directory in the given catalog and schema.\n");
                return;
            end
        end

        % Upload the javabuilder files
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        filesObj = databricks.Files(args{:});
        latchingUploadTf = true;
        for n = 1:numel(localJarList)
            [~, f, e] = fileparts(localJarList(n));
            filename = f+e;
            destinationFile = javabuilderDir + "/" + string(filename);
            if options.verbose
                fprintf("Uploading: %s to: %s\n", filename, destinationFile)
            end
            [uploadTf, errorStruct] = filesObj.upload(localJarList(n), destinationFile, overwrite=options.overwrite); %#ok<ASGLU>
            if ~uploadTf
                latchingUploadTf = false;
                fprintf(2, "Unable to upload to: %s\n", destinationFile);
            end
        end
        result = latchingUploadTf;
    else
        result = false;
    end
end

function INFO = hasLocalJavaBuilder()
    localJBPath = fullfile(matlabroot, "toolbox", "javabuilder", "jar", "javabuilder.jar");
    if ~isfile(localJBPath)
        INFO = [];
        return;
    end

    mr = matlabRelease;
    relName = "javabuilder_" + mr.Release + "U" + string(mr.Update) + ".jar";
    tmp = tempname;
    INFO = struct( ...
        "LocalFullName", localJBPath, ...
        "ReleaseName", relName, ...
        "MATLABRelease", mr.Release, ...
        "LocalDir", tmp, ...
        "LocalTempName", fullfile(tmp, relName));
end