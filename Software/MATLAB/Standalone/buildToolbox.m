function buildToolbox(options)
    % BUILDTOOLBOX Builds a standalone Toolbox for ODBC & JDBC connections

    % TODO
    % * java dynamic classpath
    % * docs
    % * ODBC pkg
    % * startup/setup
    % * clean build dir first
    % * README
    % Extracts to /home/<home directory>/Documents/MATLAB-Add-Ons/Toolboxes/MATLAB Database interface for Databricks
    
    %  Copyright 2024 MathWorks, Inc.

    arguments
        options.toolboxFolder string {mustBeTextScalar, mustBeNonzeroLengthText} = databricksRoot("Standalone", "build")
    end

    if isMATLABReleaseOlderThan("R2023a")
        fprintf(2, "Standalone Toolbox creation requires MATLAB R2023a or later.\n");
        return;
    end

    if strcmp(computer('arch'), 'maci64')
        fprintf("Packaging toolbox is not supported on macOS for Intel.\n");
        return;
    end

    cpStatusTFs = logical.empty;
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot(-2, "LICENSE.TXT"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot(-2, "VERSION"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot(-2, "3rdPartyLicenses", "Databricks_JDBC_ODBC_driver_license.pdf"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot(-2, "Documentation", "StandaloneODBCDatabaseInterface.md"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot(-2, "Documentation", "StandaloneJDBCDatabaseInterface.md"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot("Standalone", "source", "StandaloneJDBCConnection.m"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot("Standalone", "source", "StandaloneODBCConnection.m"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot("lib", "jar", "Shaded-Databricks-JDBC-Driver-0.0.2.jar"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot("config", "databricks_standalone_jdbc_settings.json.template"), options.toolboxFolder);
    cpStatusTFs(end+1) = copyFileToDst(databricksRoot("config", "databricks_standalone_odbc_settings.json.template"), options.toolboxFolder);
    
    if all(cpStatusTFs) == false
        fprintf(2, "There was a problem copying files to the build location.\n");
        return;
    end

    pkgTf = doPackage(options.toolboxFolder);
    if ~pkgTf
        fprintf(2, "There was a problem packaging the toolbox.\n");
        return;
    end
end


function tf = doPackage(toolboxFolder)
    arguments
        toolboxFolder string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    tf = false; %#ok<NASGU>
   
    % Fixed value
    uuid = "2241243c-5e7f-4934-a3df-50ac6529eaa8";

    opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder, uuid);
    opts.ToolboxName = "MATLAB Database interface for Databricks";
    
    % Tie version to parent package
    version = string(matlab.databricks.databricksPackageVersion());
    % Change any slashes in git branch names to _ to make safe for potential  downstream 
    % directory name creation
    version = replace(version, "/", "_");
    if contains(version, "-")
        opts.ToolboxVersion = strip(extractBefore(version, "-"), "right", "-");
    else
        opts.ToolboxVersion = version;
    end
    
    opts.Description = "This Toolbox enables standalone ODBC & JDBC interface to Databricks";
    opts.Summary = "This Toolbox provides a minimal standalone interface to " + ...
                   "simplify the creation of JDBC and ODBC connections to " + ...
                   "Databricks using Database Toolbox.";

    opts.AuthorEmail = "databricks@mathworks.com";
    opts.AuthorCompany = "MathWorks Inc";
    
    % TODO handle the ODBC driver pkg being Windows and Linux only.
    opts.SupportedPlatforms.Win64 = true;
    opts.SupportedPlatforms.Maca64 = true;
    opts.SupportedPlatforms.Glnxa64 = true;
    opts.SupportedPlatforms.MatlabOnline = true;

    opts.MinimumMatlabRelease = "R2022b";
    opts.MaximumMatlabRelease = "";

    opts.OutputFile = databricksRoot("Standalone","DatabricksDBInterface");

    % TODO 
    % opts.ToolboxGettingStartedGuide = "utilities" + filesep + "examples" + filesep + "GettingStarted.mlx";
    % add ODBC fileexchange entry.
    % RequiredAddons

    matlab.addons.toolbox.packageToolbox(opts);

    tf = true;
end


function tf = copyFileToDst(src, dst)
    arguments
        src string {mustBeTextScalar, mustBeNonzeroLengthText}
        dst string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    tf = false;

    if ~isfile(src)
        fprintf(2, "File not found: %s\n", src);
        return;
    end

    if ~isfolder(dst)
        [status, msg] = mkdir(dst);
        if status ~= 1
            fprintf(2, "Failed to create directory: %s\nMessage: %s\n", dst, msg);
            return
        end
    end

    [status, msg] = copyfile(src, dst);
    if status ~= 1
        fprintf(2, "Failed to copy file from: %s, to: %s\nMessage: %s\n", src, dst, msg);
        return
    end

    tf = true;
end