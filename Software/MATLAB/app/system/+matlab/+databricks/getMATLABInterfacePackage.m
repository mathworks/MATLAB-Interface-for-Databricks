function packageFile = getMATLABInterfacePackage(options)
    % getMATLABInterfacePackage Get a specified package version or the semantically latest
    %
    % Example:
    %   pkgFile = matlab.databricks.getMATLABInterfacePackage()

    % (c) 2026 The MathWorks Inc.

    arguments (Input)
        options.pkgType char {mustBeMember(options.pkgType, {'zip', 'mltbx'})} = 'zip'
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText} = strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/")
        options.version string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        packageFile string
    end

    packageFile = string.empty;
    % Don't use fullfile to get a "/" regardless of arch.
    versionsDir = options.interfaceDirectory + "/" + "Versions";

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    io = databricks.internal.io.IO("verbose", false, args{:});
    if ~io.isfolder(versionsDir)
        fprintf(2, "<InterfaceDirectory>/Versions directory not found: %s\n", versionsDir);
        return;
    end

    if strcmpi(options.pkgType, "mltbx")
        fprintf(2, "mltbx package format not yet supported, please use zip.\n");
        return;
    end

    if isfield(options, "version")
        version = options.version;
        pkgDir = versionsDir + "/" + version;
    else
        % List the versions and
        verDirList = io.dir(versionsDir);
        semverList = string.empty;
        pat = digitsPattern + "." + digitsPattern + "." + digitsPattern;
        for n = 1:numel(verDirList)
            if verDirList(n).isDir && startsWith(verDirList(n).name, pat)
                semverList(end+1) = verDirList(n).name; %#ok<AGROW>
            end
        end
        if numel(semverList) > 0
            sortedList = matlab.utils.SemVer.sort(semverList);
            version = string(sortedList(end));
            pkgDir = versionsDir + "/" + version;
        else
            fprintf(2, "No <InterfaceDirectory>/Versions/<version> directories found.\n");
            return;
        end
    end

    if ~io.isfolder(pkgDir)
        fprintf(2, "<InterfaceDirectory>/Versions/<version> directory not found: %s\n", pkgDir);
        return;
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    [matchedTf, matchedFilename] = containsMatchingPkg(pkgDir, version, options.pkgType,"verbose", false, args{:});
    if matchedTf
        if io.isfile(matchedFilename)
            packageFile = matchedFilename;
        else
            fprintf(2, "Package file not found in: %s\n", matchedFilename);
        end
    else
        fprintf(2, "Matching package file not found in: %s\n", matchedFilename);
    end
end


function [tf, matchFilePath] = containsMatchingPkg(path, version, pkgType, options)
    arguments (Input)
        path string {mustBeTextScalar, mustBeNonzeroLengthText}
        version string {mustBeTextScalar, mustBeNonzeroLengthText}
        pkgType char {mustBeMember(pkgType, {'zip', 'mltbx'})} = 'zip'
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
        matchFilePath string
    end

    tf = false;
    matchFilePath = string.empty;

    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
    io = databricks.internal.io.IO(args{:});
    pkgFilename = "matlab-databricks-v" + version;
    pkgDirList = io.dir(path);
    for n = 1:numel(pkgDirList)
        if ~pkgDirList(n).isDir
            [~, f, e] = fileparts(pkgDirList(n).name);
            if strcmp(f, pkgFilename) && strcmpi(e, "." + string(pkgType))
                matchFilePath = pkgDirList(n).folder + "/" +pkgDirList(n).name;
                tf = true;
                break;
            end
        end
    end
end