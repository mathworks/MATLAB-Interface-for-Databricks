function javabuilderPath = getLatestJavabuilder(interfaceDirectory, release, options)
    % GETLATESTJAVABUILDER Returns the latest javabuilder jar for a given release
    % If no matching file is found an empty string is returned.

    % Copyright 2024 The MathWorks, Inc.
    
    arguments
        interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        release string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if ~startsWith(interfaceDirectory, "/Volumes/")
        error("Only /Volumes paths are currently supported");
    end

    jbDir = strip(interfaceDirectory, "right", "/") + "/runtimes/javabuilder";

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    fileObj = databricks.Files(args{:});
    dirListing = fileObj.list(jbDir);
    if ~isprop(dirListing, "contents")
        error("No contents found in directory listing response.");
    end

    jbMatches = string.empty;
    % Filenames have the form javabuilder_R2024aU6.jar or javabuilder_R2024aU0.jar
    filenamePattern = "javabuilder_" + release + "U" + digitsPattern(1,2) + ".jar"; 
    for n = 1:numel(dirListing.contents)
        if ~isprop(dirListing.contents(n), "name")
            fprintf(2, "Name property not found in directory listing entry of: %s\n", directory);
        else
            filename = dirListing.contents(n).name;
            if matches(filename, filenamePattern)
                jbMatches(end+1) = filename; %#ok<AGROW>
            end
        end
    end

    if numel(jbMatches) == 0
        javabuilderPath = string.empty;
    elseif numel(jbMatches) == 1 %#ok<ISCL>
        jbFile = jbMatches(1);
        javabuilderPath = jbDir + "/" + jbFile;
    else
        sorted = sort(jbMatches, 'descend');
        jbFile = sorted(1);
        javabuilderPath = jbDir + "/" + jbFile;
    end
end