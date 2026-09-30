classdef Mltbx
    %MLTBX Class to help working with and packaging .mltbx files
    %
    % Examples:
    %   [result, mltbxFile] = matlab.databricks.internal.Mltbx.build("C:\local\databricks\matlab-databricks-v6.0.3.zip")
    %
    %   [result, mltbxFile] = matlab.databricks.internal.Mltbx.build("C:\git\databricks")
    %
    %   result = matlab.databricks.internal.Mltbx.install("/home/someuser/git/databricks/matlab-databricks-v6.0.5.mltbx")
    %
    %   matlab.databricks.internal.Mltbx.uninstallAll(...)
    %
    %   matlab.databricks.internal.Mltbx.uninstall(version="6.0.3")
    %
    %   T = matlab.databricks.internal.Mltbx.listInstalledVersions()
    %
    %   T = matlab.databricks.internal.Mltbx.listEnabledVersions()
    %
    %   tf = matlab.databricks.internal.Mltbx.isInstalled(...)
    %
    %   tf = matlab.databricks.internal.Mltbx.isEnabled(...)
    %
    %   tf = matlab.databricks.internal.Mltbx.isMoreThanOneEnabled()
    %
    %   matlab.databricks.internal.Mltbx.enableVersion("6.0.3")
    %
    %   matlab.databricks.internal.Mltbx.disableVersion("6.0.3")
    %
    %   matlab.databricks.internal.Mltbx.disableAll(...)
    %
    %   matlab.databricks.internal.Mltbx.disableOtherVersions("6.0.3")

    % (c) 2026 MathWorks Inc.

    properties
        UUID = "60cf67da-a82c-4902-b329-6b87a4068a23"
        PkgName = "MATLAB Interface for Databricks"
    end

    methods
        % Constructor
        function obj = Mltbx()
            if ~obj.versionLimits()
                error("MATLAB:DATABRICKS:INTERNAL:MLTBX:R2026a", "R2026a is not currently supported by matlab.databricks.internal.Mltbx.")
            end
        end
    end

    methods(Static)
        function [result, mltbxFile] = build(varargin, options)
            % BUILD Builds a .mltbx package for the MATLAB Interface for Databricks
            % A .zip path can be provided or a path to a previously extracted .zip
            % file or a currently in use (on the path) Databricks Interface.
            % Sources are evaluated in that order.
            %
            % Optional arguments:
            %     outputDirectory: Output location for .mltbx file.
            %                      Default: Current directory.
            %
            % retainTempDirectory: Delete a temporary working directory if created.
            %                      Default: false.
            %
            % Example:
            %   matlab.databricks.internal.Mltbx.build("C:\local\databricks\matlab-databricks-v6.0.3.zip")

            arguments (Input, Repeating)
                varargin
            end
            arguments (Input)
                options.outputDirectory string {mustBeFolder} = pwd
                options.retainTempDirectory (1,1) logical = false
            end
            arguments (Output)
                result (1,1) logical
                mltbxFile string
            end

            obj = matlab.databricks.internal.Mltbx();
            
            % Default failure return values
            result = false;
            mltbxFile = string.empty;

            fprintf("Creating %s package (.mltbx)\n", obj.PkgName);

            if numel(varargin) == 0
                if isDatabricksEnvironment
                    srcDir = databricksRoot(-2);
                    workDir = tempname;
                    if ~options.retainTempDirectory
                        rmWorkDirVar = onCleanup(@() deleteTempDir(workDir));
                    end
                else
                    fprintf(2, "A source .zip file or directory must be specified if the package is not on the MATLAB path.\n");
                    return;
                end
            end

            if numel(varargin) >= 1
                if ~isfile(varargin{1}) && ~isfolder(varargin{1})
                    fprintf(2, "Specified source file or directory not found: %s\n", varargin{1});
                    return;
                end
            end

            if numel(varargin) >= 1 && isfile(varargin{1})
                if ~endsWith(varargin{1}, ".zip", "IgnoreCase", true)
                    fprintf(2, "Expected a .zip file, found: %s\n", varargin{1});
                    return;
                else
                    tmpDir = tempname;
                    if ~options.retainTempDirectory
                        rmWorkDirVar = onCleanup(@() deleteTempDir(tmpDir));
                    end
                    unzip(strip(varargin{1}), tmpDir);
                    srcDir = fullfile(tmpDir, "matlab-databricks");
                    % Put the work dir in the temp dir along with the unzipped contents
                    workDir = fullfile(tmpDir, "tempPkgDir");
                end
            end

            if numel(varargin) >= 1 && isfolder(varargin{1})
                srcDir = varargin{1};
                workDir = tempname;
                if ~options.retainTempDirectory
                    rmWorkDirVar = onCleanup(@() deleteTempDir(workDir));
                end
            end

            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % At this point srcDir should exist and contain the files to be packaged
            % workDir is named and will be cleaned up but may not exist yet
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % See databricks\Internal\scripts\export_repo.sh for .zip packaging script
            if ~isfile(fullfile(srcDir, "Documentation", "html", "index.html"))
                fprintf(2, "Packaging expects the html docs to have been generated.\n");
                return;
            end

            % Remove previous builds
            if ~deleteTempDir(workDir)
                fprintf(2, "Removing previous package directory failed.\n");
                return;
            end

            if ~createPackageDirectory(workDir)
                fprintf(2, "Creating package directory failed.\n");
                return;
            end

            fprintf("Getting target version: ");
            version = getTargetVersion(fullfile(srcDir, "VERSION"));
            fprintf("%s\n", version);

            fprintf("Copying files...\n");
            if ~stageDatabricksFiles(srcDir, workDir)
                fprintf(2, "There was a problem copying Databricks files to the build location.\n");
                return;
            end
            if ~stageJSONMapperFiles(fullfile(srcDir, "Modules", "matlab-jsonmapper"), fullfile(workDir, "Modules", "matlab-jsonmapper"))
                fprintf(2, "There was a problem copying JSONMapper files to the build location.\n");
                return;
            end
            if ~stageMLFlowFiles(fullfile(srcDir, "Modules", "matlab-mlflow"), fullfile(workDir, "Modules", "matlab-mlflow"))
                fprintf(2, "There was a problem copying MLFlow files to the build location.\n");
                return;
            end
            if ~stageSparkAPIFiles(fullfile(srcDir, "Modules", "matlab-spark-api"), fullfile(workDir, "Modules", "matlab-spark-api"))
                fprintf(2, "There was a problem copying Spark API files to the build location.\n");
                return;
            end

            fprintf("Cleanup...\n");
            if ~copyCleanup(workDir)
                fprintf(2, "There was a problem in the cleanup step.\n");
                return;
            end

            fprintf("Packaging, this will take 30s approximately...\n");
            [status, mltbxFile] = obj.doPackage(workDir, options.outputDirectory, version);
            if ~status
                fprintf(2, "There was a problem creating the package.\n");
                return;
            end

            fprintf("Package creation complete.\n");
            if options.retainTempDirectory
                fprintf("  See: %s\n", workDir);
                fprintf("       %s\n", mltbxFile);
            else
                fprintf("  See: %s\n", mltbxFile);
            end
            result = true;
        end


        function result = install(mltbxFile)
            % INSTALL Alternative installation method to the Addon Manager UI
            % Returns true if the package installation completes. Otherwise false,
            % including if the package is already installed.
            %
            % The path to the .mltbx file is provided as an argument.

            arguments (Input)
                mltbxFile string {mustBeFile}
            end
            arguments (Output)
                result (1,1) logical
            end

            obj = matlab.databricks.internal.Mltbx();

            result = false;
            fprintf("Installing %s package (.mltbx)\n", obj.PkgName);

            if ~endsWith(mltbxFile, ".mltbx", IgnoreCase=true)
                fprintf(2, "The package file must have a .mltbx extension.\n");
                return;
            end
        
            if obj.isInstalled
                fprintf("Previous installation found:\n");
                disp(obj.listInstalledVersions);
            else
                fprintf("No previous installation found.\n");
            end

            fprintf("Installing...\n");
            installedPkg = matlab.addons.toolbox.installToolbox(mltbxFile);
            if isempty(installedPkg)
                fprintf(2, "Package not installed.\n");
            else
                fprintf("Package installed:\n");
                disp(installedPkg);
                result = true;
            end
        end


        function uninstallAll(options)
            arguments (Input)
                options.verbose (1,1) logical = false
            end
        
            obj = matlab.databricks.internal.Mltbx();

            if options.verbose
                fprintf("Uninstalling all versions of the %s.\n", obj.PkgName);
            end

            installVersionsT = obj.listInstalledVersions;
            for n = 1:height(installVersionsT)
                s = struct;
                s.Name = obj.PkgName;
                s.Guid = obj.UUID;
                s.Version = installVersionsT.Version(n);
                if options.verbose
                    fprintf("Uninstalling version: %s\n", s.Version);
                end
                matlab.addons.toolbox.uninstallToolbox(s);
            end
        end


        function uninstall(options)
            % UNINSTALL Alternative uninstall method to the Addon Manager UI
            % Returns true if the package is uninstalled or is not already
            % installed, otherwise false.

            arguments (Input)
                options.version string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = false
            end
            
            obj = matlab.databricks.internal.Mltbx();

            if options.verbose
                if isfield(options, "version")
                    fprintf("Uninstalling %s package, version: %s\n", obj.PkgName, options.version);
                else
                    fprintf("Uninstalling %s package\n", obj.PkgName);
                end
            end

            if isfield(options, "version")
                installed = obj.isInstalled(version=options.version);
            else
                installed = obj.isInstalled();
            end
            
            if installed
                installVersionsT = obj.listInstalledVersions;
                if options.verbose
                    fprintf("Previous installation found:\n");
                    disp(installVersionsT);
                end
                s = struct;
                s.Name = obj.PkgName;
                s.Guid = obj.UUID;
                if isfield(options, "version")
                    s.Version = options.Version;
                    matlab.addons.toolbox.uninstallToolbox(s);
                else
                    if height(installVersionsT) == 1
                        s.Version = installVersionsT.Version(1);
                        matlab.addons.toolbox.uninstallToolbox(s);
                    elseif height(enabledT) > 1
                        if options.verbose
                            fprintf("More than one installed version found, uninstalling version: %s\n", installVersionsT.Version(1));
                        end
                        s.Version = installVersionsT.Version(1);
                        matlab.addons.toolbox.uninstallToolbox(s);
                    else
                        fprintf("Error: Unexpected state.\n");
                    end
                end
            else
                if options.verbose
                    fprintf("No previous installation found.\n");
                end
            end
        end


        function T = listInstalledVersions()
            arguments (Output)
                T table
            end
            obj = matlab.databricks.internal.Mltbx();

            addOnsT = matlab.addons.installedAddons;
            rf = rowfilter(addOnsT);
            T = addOnsT(rf.Identifier == obj.UUID, :);
        end


        function T = listEnabledVersions()
            arguments (Output)
                T table
            end
            obj = matlab.databricks.internal.Mltbx();

            addOnsT = matlab.addons.installedAddons;
            rf = rowfilter(addOnsT);
            T = addOnsT(rf.Identifier == obj.UUID & rf.Enabled==true, :);
        end


        function tf = isInstalled(options)
            arguments (Input)
                options.version string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                tf (1,1) logical
            end

            obj = matlab.databricks.internal.Mltbx();
            addOnsT = matlab.addons.installedAddons;
            rf = rowfilter(addOnsT);
            if isfield(options, "version")
                T = addOnsT(rf.Identifier == obj.UUID & rf.Version==options.version, :);
            else
                T = addOnsT(rf.Identifier == obj.UUID, :);
            end
            if height(T) > 0
                tf = true;
            else
                tf = false;
            end
        end


        function tf = isEnabled(options)
            arguments (Input)
                options.version string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                tf (1,1) logical
            end

            obj = matlab.databricks.internal.Mltbx();
            addOnsT = matlab.addons.installedAddons;
            rf = rowfilter(addOnsT);
            if isfield(options, "version")
                T = addOnsT(rf.Identifier == obj.UUID & rf.Enabled==true & rf.Version==options.version, :);
            else
                T = addOnsT(rf.Identifier == obj.UUID & rf.Enabled==true, :);
            end
            if height(T) > 0
                tf = true;
            else
                tf = false;
            end
        end


        function tf = isMoreThanOneEnabled(options)
            arguments (Input)
                options.verbose (1,1) logical = true
            end
            arguments (Output)
                tf (1,1) logical
            end
            T = matlab.databricks.internal.Mltbx.isEnabled;
            if height(T) > 1
                tf = true;
                if options.verbose
                    fprintf("More than on version is installed and enabled.\n");
                    fprintf("This is an unexpected state and may produce undesired results.\n");
                    fprintf("See also: disableOtherVersions()\n");
                end
            else
                tf = false;
            end
        end


        function enableVersion(version, options)
            arguments (Input)
                version string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end
            obj = matlab.databricks.internal.Mltbx();
            if obj.isInstalled(version=version)
                if obj.isEnabled(version=version)
                    fprintf("Version: %s is already enabled.\n", version);
                else
                    matlab.addons.enableAddon(obj.UUID, version);
                end
            else
                if options.verbose
                    fprintf(2, "Version: %s of the package is not installed.\n", version);
                end
            end
        end


        function disableVersion(version, options)
            arguments (Input)
                version string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end
            obj = matlab.databricks.internal.Mltbx();
            if obj.isInstalled(version=version)
                if ~obj.isEnabled(version=version)
                    if options.verbose
                        fprintf("Version: %s is already disabled.\n", version);
                    end
                else
                    matlab.addons.disableAddon(obj.UUID, version);
                end
            else
                if options.verbose
                    fprintf(2, "Version: %s of the package is not installed.\n", version);
                end
            end
        end


        function disableAll(options)
            arguments (Input)
                options.verbose (1,1) logical = true
            end
            obj = matlab.databricks.internal.Mltbx();
            T = obj.listEnabledVersions();
            enabledVersions = T.Version;
            for n = 1:numel(enabledVersions)
                if options.verbose
                    fprintf("Disabling version: %s\n", enabledVersions(n));
                end
                obj.disableVersion(enabledVersions(n), verbose=false);
            end
        end


        function disableOtherVersions(version, options)
            arguments (Input)
                version string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.verbose (1,1) logical = true
            end
            obj = matlab.databricks.internal.Mltbx();

            if ~matlab.databricks.internal.Mltbx.isEnabled(version=version)
                fprintf(2, "Version: %s of the package is not enabled.\n", version)
            end

            T = obj.listEnabledVersions();
            enabledVersions = T.Version;
            for n = 1:numel(enabledVersions)
                if ~strcmp(enabledVersions(n), version)
                    if options.verbose
                        fprintf("Disabling version: %s\n", enabledVersions(n));
                    end
                    obj.disableVersion(enabledVersions(n), verbose=false);
                end
            end
        end
    end


    methods (Hidden)
        function tf = versionLimits(obj)
            arguments (Input)
                obj matlab.databricks.internal.Mltbx
            end
            arguments (Output)
                tf (1,1) logical
            end
            tf = false;

            % The mltbx is common across versions so can be built once on >=23a for >=22b
            if isMATLABReleaseOlderThan("R2023a")
                fprintf(2, "%s support requires MATLAB R2023a or later.\n", metaclass(obj).Name);
                return;
            end

            % Addon manger bug under investigation, see: g3996334
            if strcmp(matlabRelease().Release, "R2026a")
                fprintf(2, "%s is not currently supported on MATLAB R2026a or later.\n", metaclass(obj).Name);
                return;
            end

            % This may well be possible but is not tested at this point
            if strcmp(computer('arch'), 'maci64')
                fprintf(2, "%s is not supported on macOS for Intel.\n", metaclass(obj).Name);
                return;
            end

            tf = true;
        end


        function [tf, mltbxFile] = doPackage(obj, workDir, outputDir, version)
            arguments (Input)
                obj matlab.databricks.internal.Mltbx
                workDir string {mustBeTextScalar, mustBeNonzeroLengthText}
                outputDir string {mustBeTextScalar, mustBeNonzeroLengthText}
                version string {mustBeTextScalar, mustBeNonzeroLengthText}
            end
            arguments (Output)
                tf (1,1) logical
                mltbxFile string
            end

            tf = false; %#ok<NASGU>
            mltbxFile = string.empty; %#ok<NASGU>

            opts = matlab.addons.toolbox.ToolboxOptions(workDir, obj.UUID, ToolboxMatlabPath = getPaths(workDir));
            opts.ToolboxName = obj.PkgName;
            opts.ToolboxVersion = version;
            if ~isMATLABReleaseOlderThan('R2026b')
                opts.PackageName = opts.ToolboxName;
            end

            opts.Description = "This package enables MATLAB to work with Databricks";
            opts.Summary = "This package provides support Databricks when working in MATLAB and " + ...
                "also allows MATLAB to run on Databricks.";

            opts.AuthorEmail = "databricks@mathworks.com";
            opts.AuthorCompany = "MathWorks Inc";
            opts.AuthorName = "MathWorks";

            opts.SupportedPlatforms.Win64 = true;
            opts.SupportedPlatforms.Glnxa64 = true;
            opts.SupportedPlatforms.MatlabOnline = true;

            % NAP'd perhaps incorrectly should be reviewed vs. intended behavior
            % https://komodo.mathworks.com/main/gecko/view?Record=3724770
            % opts.SupportedPlatforms.Maca64 = true;
            opts.SupportedPlatforms.Maci64 = true;

            opts.MinimumMatlabRelease = "R2022b";
            opts.MaximumMatlabRelease = "";

            opts.OutputFile = fullfile(outputDir, sprintf("matlab-databricks-v%s", version));

            % If the icon cannot be found skip it
            iconPath = getIconPath();
            if ~isempty(iconPath)
                opts.ToolboxImageFile = iconPath;
            end

            % TODOs
            % * Exploit the hook for a getting started mlx that might drop in
            %   setup/startup or examples
            %   opts.ToolboxGettingStartedGuide = "GettingStarted.mlx";
            % * Consider opts. AppGalleryFiles
            %
            % No need to add opts.ToolboxJavaPath as databricks.xDBC classes do that on demand

            matlab.addons.toolbox.packageToolbox(opts);
            mltbxFile = opts.OutputFile;
            tf = true;
        end
    end
end


function tf = copyDirToDst(src, dst)
    arguments (Input)
        src string {mustBeTextScalar, mustBeNonzeroLengthText}
        dst string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = false;
    src = strip(src);
    dst = strip(dst);

    if ~isfolder(src)
        if isfile(src)
            fprintf(2, "Found a file, expected a directory: %s\n", src);
        else
            fprintf(2, "Directory not found: %s\n", src);
        end
        return;
    end

    [~, f, e] = fileparts(src);
    dstFull = fullfile(dst, f+e);
    if ~isfolder(dstFull)
        [status, msg] = mkdir(dstFull);
        if status ~= 1
            fprintf(2, "Failed to create directory: %s\nMessage: %s\n", dstFull, msg);
            return;
        end
    end

    [status, msg] = copyfile(src, dstFull);
    if status ~= 1
        fprintf(2, "Failed to directory file from: %s, to: %s\nMessage: %s\n", src, dstFull, msg);
        return;
    end

    tf = true;
end


function version = getTargetVersion(versionFile)
    arguments (Input)
        versionFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        version string
    end

    if isfile(versionFile)
        version = strip(string(fileread(versionFile)));
    else
        fprintf(2, "VERSION file not found: %s\n", versionFile)
        version = string.empty;
    end
end


function tf = copyFileToDst(src, dst)
    arguments (Input)
        src string {mustBeTextScalar, mustBeNonzeroLengthText}
        dst string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = false;
    src = strip(src);
    dst = strip(dst);

    [p,f,~] = fileparts(src);
    if ~startsWith(f, "*")
        if ~isfile(src)
            if isfolder(src)
                fprintf(2, "Found a directory, expected a file: %s\n", src);
            else
                fprintf(2, "File not found: %s\n", src);
            end
            return;
        end
        if ~isfolder(dst)
            [status, msg] = mkdir(dst);
            if status ~= 1
                fprintf(2, "Failed to create directory: %s\nMessage: %s\n", dst, msg);
                return;
            end
        end
        [status, msg] = copyfile(src, dst);
        if status ~= 1
            fprintf(2, "Failed to copy file from: %s, to: %s\nMessage: %s\n", src, dst, msg);
            return;
        end
        tf = true;
    else
        if ~isfolder(p)
            fprintf(2, "Source directory not found: %s\n", p);
            return;
        end
        [status, files] = getStarDotList(src);
        if ~status
            fprintf(2, "Error expanding *. file list: %s\n", src);
            return;
        else
            for n = 1:numel(files)
                expSrc = fullfile(p, files(n));
                if ~copyFileToDst(expSrc, dst)
                    fprintf(2, "Failed to copy file from: %s, to: %s\n", expSrc, dst);
                    return;
                end
            end
        end
        tf = true;
    end
end


function iconPath = getIconPath()
    arguments (Output)
        iconPath string
    end

    % Use the location of the build script as an anchor for the .png
    % Don't use databricksRoot as may want to use this without the package
    % being on the path
    iconPath = fullfile(fileparts(fileparts(fileparts(fileparts(fileparts(fileparts(fileparts(fileparts(mfilename('fullpath'))))))))), "Documentation", "images", "mltbxIcon.png");
    if ~isfile(iconPath)
        fprintf(2, "Package icon not found: %s\n", iconPath);
        iconPath = string.empty;
    end
end


function tf = isDatabricksEnvironment()
    % isDatabricksEnvironment Check if this is run in Databricks context
    try
        ignoreMe = databricksRoot(); %#ok<NASGU>
        tf = true;
    catch ME
        tf = false;
    end
end


function tf = deleteTempDir(workDir)
    arguments (Input)
        workDir string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end

    if isfile(workDir)
        fprintf(2, "Expected a directory found a file, not deleting: %s", workDir);
        tf = false;
        return;
    end

    if ~isfolder(workDir)
        tf = true;
    else
        fprintf("Deleting directory: %s\n", workDir);
        [status, msg] = rmdir(workDir, "s");
        if status ~= 1
            fprintf(2, "Failed to delete directory: %s\nMessage: %s\n", workDir, msg);
            tf = false;
        else
            tf = true;
        end
    end
end


function tf = stageSparkAPIFiles(srcDir, workDir)
    arguments (Input)
        srcDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        workDir string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end
    cpTFs = logical.empty;

    % Top level files
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "*.md"), workDir);
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "VERSION"), workDir);

    % Documentation
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Documentation"), workDir);

    % Software
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Software", "MATLAB"), fullfile(workDir, "Software"));

    tf = all(cpTFs);
end


function tf = copyCleanup(workDir)
    arguments (Input)
        workDir string {mustBeTextScalar, mustBeNonzeroLengthText} %#ok<INUSA>
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = true;
end


function tf = createPackageDirectory(dst)
    arguments (Input)
        dst string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end

    dst = strip(dst);

    if ~isfolder(dst)
        [status, msg] = mkdir(dst);
        if status ~= 1
            fprintf(2, "Failed to create package directory: %s\nMessage: %s\n", dst, msg);
            tf = false;
        else
            tf = true;
        end
    end
end


function tf = stageDatabricksFiles(srcDir, workDir)
    arguments (Input)
        srcDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        workDir string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end
    cpTFs = logical.empty;

    if ~isfolder(srcDir)
        fprintf(2, "Source directory not found: %s\n", srcDir);
        return;
    end

    % Top level files
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "LICENSE.md"), workDir);
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "VERSION"), workDir);
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "*.md"), workDir);
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "3rdPartyLicenses"), workDir);

    % Documentation excl. .md files
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Documentation", "html"), fullfile(workDir, "Documentation"));

    % Software/Python
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "Python", "*.py"), fullfile(workDir, "Software", "Python"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "Python", "mw_context", "mw_prefs.py"), fullfile(workDir, "Software", "Python", "mw_context"));

    % Software/Java
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "Java", "JDBCDriver", "pom.xml"), fullfile(workDir, "Software", "Java", "JDBCDriver"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "Java", "JDBCDriver", "pomOSS.xml"), fullfile(workDir, "Software", "Java", "JDBCDriver"));

    % Software/Docker
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "Docker", "MATLABDesktop", "*.m"), fullfile(workDir, "Software", "Docker", "MATLABDesktop"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "Docker", "MATLABDesktop", "*.md"), fullfile(workDir, "Software", "Docker", "MATLABDesktop"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "Docker", "MATLABRuntime", "*.m"), fullfile(workDir, "Software", "Docker", "MATLABRuntime"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "Docker", "MATLABRuntime", "*.md"), fullfile(workDir, "Software", "Docker", "MATLABRuntime"));

    % Software/MATLAB
    cpTFs(end+1) = copyFileToFile(fullfile(srcDir, "Software", "MATLAB", "startup.m"), fullfile(workDir, "Software", "MATLAB", "dbxStartup.m"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "setup.m"), fullfile(workDir, "Software", "MATLAB"));
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Software", "MATLAB", "app"), fullfile(workDir, "Software", "MATLAB"));
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Software", "MATLAB", "toolbox"), fullfile(workDir, "Software", "MATLAB"));
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Software", "MATLAB", "examples"), fullfile(workDir, "Software", "MATLAB"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "lib", "jar", "Shaded-Databricks-JDBC-Driver-0.0.2.jar"), fullfile(workDir, "Software", "MATLAB", "lib", "jar"));
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Software", "MATLAB", "script"), fullfile(workDir, "Software", "MATLAB"));
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Software", "MATLAB", "Standalone"), fullfile(workDir, "Software", "MATLAB"));
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Software", "MATLAB", "test"), fullfile(workDir, "Software", "MATLAB"));

    % Software/MATLAB/Connect
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "Connect", "13.3", "requirements.txt"), fullfile(workDir, "Software", "MATLAB", "Connect", "13.3"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "Connect", "14.3", "requirements.txt"), fullfile(workDir, "Software", "MATLAB", "Connect", "14.3"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "Connect", "15.4", "requirements.txt"), fullfile(workDir, "Software", "MATLAB", "Connect", "15.4"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "Connect", "16.4", "requirements.txt"), fullfile(workDir, "Software", "MATLAB", "Connect", "16.4"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "Connect", "17.3", "requirements.txt"), fullfile(workDir, "Software", "MATLAB", "Connect", "17.3"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "Connect", "18.3", "requirements.txt"), fullfile(workDir, "Software", "MATLAB", "Connect", "18.3"));

    % Software/MATLAB/config
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "config", "databricks_standalone_jdbc_settings.json.template"), fullfile(workDir, "Software", "MATLAB", "config"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "config", "databricks_standalone_odbc_settings.json.template"), fullfile(workDir, "Software", "MATLAB", "config"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "config", "databricks-http.json.template"), fullfile(workDir, "Software", "MATLAB", "config"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "config", "databricks-http.json"), fullfile(workDir, "Software", "MATLAB", "config"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "config", "databrickscfg.template"), fullfile(workDir, "Software", "MATLAB", "config"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "config", "dockerAuth.json.template"), fullfile(workDir, "Software", "MATLAB", "config"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "config", "package-settings.json"), fullfile(workDir, "Software", "MATLAB", "config"));
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "Software", "MATLAB", "config", "runtime-info.json"), fullfile(workDir, "Software", "MATLAB", "config"));

    tf = all(cpTFs);
end


function tf = stageJSONMapperFiles(srcDir, workDir)
    arguments (Input)
        srcDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        workDir string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end
    cpTFs = logical.empty;

    % Top level files
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "internal"), workDir);

    tf = all(cpTFs);
end


function tf = stageMLFlowFiles(srcDir, workDir)
    arguments (Input)
        srcDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        workDir string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end
    cpTFs = logical.empty;

    % Top level files
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "*.md"), workDir);
    cpTFs(end+1) = copyFileToDst(fullfile(srcDir, "VERSION"), workDir);

    % Documentation
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Documentation"), workDir);

    % Software
    cpTFs(end+1) = copyDirToDst(fullfile(srcDir, "Software", "MATLAB"), fullfile(workDir, "Software"));

    tf = all(cpTFs);
end


function tf = copyFileToFile(src, dst)
    arguments (Input)
        src string {mustBeFile}
        dst string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = false;
    src = strip(src);
    dst = strip(dst);

    [~,f,~] = fileparts(src);
    if ~startsWith(f, "*")
        if ~isfolder(dst)
            [status, msg] = mkdir(dst);
            if status ~= 1
                fprintf(2, "Failed to create directory: %s\nMessage: %s\n", dst, msg);
                return;
            end
        end
        [status, msg] = copyfile(src, dst);
        if status ~= 1
            fprintf(2, "Failed to copy file from: %s, to: %s\nMessage: %s\n", src, dst, msg);
            return;
        end
        tf = true;
    else
        fprintf("copyFileToFile does not support * filters: %s\n", src);
    end
end


function [status, files] = getStarDotList(src)
    % getStarDotList Returns an array of files specified by a *.ext filter
    % TODO consider case sensitivity.
    arguments (Input)
        src string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        status (1,1) logical
        files string
    end

    status = false;
    files = string.empty;

    [p, f, e] = fileparts(src);

    if strlength(e) == 0
        % Should not need this capability for now
        fprintf(2, "File extensions of zero length are not supported.\n");
        return;
    end

    if strcmp(e, ".") || strcmp(e, "..")
        % Should not need this capability for now
        % avoid complication of handling . & ..
        fprintf(2, "File extensions of . or .. are not supported.\n");
        return;
    end

    if ~isfolder(p)
        fprintf(2, "Directory not found: %s\n", p);
        return;
    end

    if ~startsWith(f, "*")
        fprintf(2, "Expected filter to start with '*', found: %s\n", src);
        return;
    end

    pList = dir(p);
    for n = 1:numel(pList)
        if pList(n).isdir
            continue;
        end
        if endsWith(pList(n).name, e)
            files(end+1) = pList(n).name; %#ok<AGROW>
        end
    end

    status = true;
end


function paths = getPaths(workDir)
    arguments (Input)
        workDir string
    end
    arguments (Output)
        paths string
    end
    paths = string.empty;

    % Databricks
    paths(end+1) = fullfile(workDir, "Software", "MATLAB", "app", "functions");
    paths(end+1) = fullfile(workDir, "Software", "MATLAB", "app", "mex");
    paths(end+1) = fullfile(workDir, "Software", "MATLAB", "app", "system");
    paths(end+1) = fullfile(workDir, "Software", "MATLAB", "test", "unit");
    paths(end+1) = fullfile(workDir, "Software", "MATLAB", "test", "functional");
    paths(end+1) = fullfile(workDir, "Software", "MATLAB", "toolbox");

    % JSONMapper
    paths(end+1) = fullfile(workDir, "Modules", "matlab-jsonmapper", "internal");

    

    % MLFlow
    paths(end+1) = fullfile(workDir, "Modules", "matlab-mlflow", "Software", "MATLAB", "app", "functions");
    paths(end+1) = fullfile(workDir, "Modules", "matlab-mlflow", "Software", "MATLAB", "app", "system");
    paths(end+1) = fullfile(workDir, "Modules", "matlab-mlflow", "Software", "MATLAB", "test", "unit");

    % Spark API
    paths(end+1) = fullfile(workDir, "Modules", "matlab-spark-api", "Software", "MATLAB", "app", "functions");
    paths(end+1) = fullfile(workDir, "Modules", "matlab-spark-api", "Software", "MATLAB", "app", "system");
    paths(end+1) = fullfile(workDir, "Modules", "matlab-spark-api", "Software", "MATLAB", "app", "mex");
    paths(end+1) = fullfile(workDir, "Modules", "matlab-spark-api", "Software", "MATLAB", "app", "target", "sim_pandas", "sim_pandas");
end