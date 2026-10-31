function createClusterPolicies(options)
    % CREATECLUSTERPOLICIES Writes a file containing cluster policy details
    %
    %
    % Example policy init script based definition for Databricks runtimes < 17:
    % {
    %   "init_scripts.0.volumes.destination":{"type":"fixed", "value":"/Volumes/main/default/myvolume/MathWorks/runtimes/runtime_install.sh"},
    %   "spark_env_vars.LD_LIBRARY_PATH": {
    %     "type": "fixed",
    %     "value":"/MATLAB_Runtime/runtime/glnxa64:/MATLAB_Runtime/bin/glnxa64:/MATLAB_Runtime/sys/os/glnxa64:/MATLAB_Runtime/sys/opengl/lib/glnxa64:/MATLAB_Runtime/extern/bin/glnxa64"},
    %   "spark_env_vars.MW_RUNTIME_ZIP": {
    %     "type": "fixed",
    %     "value": "/Volumes/main/default/myvolume/MathWorks/runtimes/MATLAB_Runtime_R2025b_glnxa64.zip"
    %   },
    %   "spark_env_vars.MW_RUNTIME_RELEASE": {
    %     "type": "fixed",
    %     "value": "R2025b"
    %   },
    %   "spark_conf.spark.databricks.isv.product": {
    %     "type": "fixed",
    %     "value": "MathWorks_MATLAB/25.2.0"
    %   },
    %   "spark_version":{"type":"allowlist", "values":[
    %     "16.4.x-scala2.13",
    %     "16.4.x-scala2.12",
    %     "15.4.x-scala2.12",
    %     "14.3.x-scala2.12",
    %     "13.3.x-scala2.12"]
    %   }
    % }
    %
    %
    % Example:
    %   matlab.databricks.setup.createClusterPolicies()

    %  (c) 2024-2025 MathWorks, Inc.

    arguments
        options.releases string {mustBeNonzeroLengthText}
        options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.initscript string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.logPath string {mustBeTextScalar, mustBeNonzeroLengthText}

        options.baseVersions string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.filterNonLTS (1,1) logical = true
        options.filterPhoton (1,1) logical = false
        options.filterML (1,1) logical = false
        options.filterGPU (1,1) logical = false
        options.filterNonUC (1,1) logical = false

        options.policySetupGuide string {mustBeTextScalar, mustBeNonzeroLengthText} = fullfile(pwd, "MATLAB_Runtime_Policies.md")

        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    if isfield(options, "interfaceDirectory")
        interfaceDirectory = options.interfaceDirectory;
        runtimesDirectory = string(strip(interfaceDirectory, "right", "/")) + "/runtimes";
    else
        interfaceDirectory = databricks.internal.settings.Settings.getSettingsField("interfaceDirectory");
        if isempty(interfaceDirectory) || strlength(interfaceDirectory) == 0
            error(2, "Invalid interfaceDirectory settings value: %s\n", interfaceDirectory);
        else
            runtimesDirectory = string(strip(interfaceDirectory, "right", "/")) + "/runtimes";
        end
    end

    if isfield(options, "baseVersions")
        baseVersions = options.baseVersions;
    else
        pkgSettings = matlab.databricks.internal.pkgsettings.getPkgSettings();
        baseVersions = [pkgSettings.supportedDatabricksRuntimes.version];
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    sparkVersionsTable = databricks.internal.getFilteredSparkVersions("baseVersions", baseVersions, "photon", options.filterPhoton, "lts", options.filterNonLTS, "gpu", options.filterGPU, "ml", options.filterML, args{:});
    sparkVersions = sort(sparkVersionsTable.key(:), 'descend');

    args = matlab.utils.addArgs(options, ["releases", "authMethod", "profileName"]);
    [zips, releases] = getRuntimeZips(runtimesDirectory, args{:});

    args = matlab.utils.addArgs(options, ["logPath", "verbose"]);
    defs = buildInitscriptDefinitions(zips, releases, sparkVersions, runtimesDirectory, args{:});

    descriptions = buildDescriptions(releases);

    % Disable creating a libraries list from v6 onward thus disabling Java builder
    %args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
    %libraries = buildLibraries(interfaceDirectory, releases, args{:});
    libraries = databricks.datastructures.libraries.Library.empty;

    names = buildNames(releases);

    if writePoliciesFile(defs, releases, descriptions, libraries, names, options.policySetupGuide)
        fprintf("\nA file containing policy creation details has been written to: %s\n", options.policySetupGuide);
        fprintf("This file contains policy information that can be used to create polices\n");
        fprintf("in Databricks to allow in-workspace creation of MATLAB enabled clusters.\n");
        fprintf("Cluster created using these polices must use notebook scoped libraries,\n");
        fprintf("See: %s\n", matlab.databricks.internal.docLink("LibraryAPI"));
        if strlength(fileparts(options.policySetupGuide)) == 0
            fprintf("See: %s\n", matlab.utils.editLink(fullfile(pwd, options.policySetupGuide)));
        else
            fprintf("See: %s\n", matlab.utils.editLink(options.policySetupGuide));
        end
    end

    % Disable attempting to update Polices from v6.0.0
    % fprintf("\nUpdating policies typically requires administrative privileges.\n");
    % reply = strip(input('Attempt to update polices? Y/N [N]: ','s'));
    % if strlength(reply) == 0
    %     reply = "n";
    % end
    % if strcmpi(reply,'y')
    %     args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);
    %     updatePolicies(releases, names, descriptions, defs, libraries, args{:});
    % end
end


function updatePolicies(releases, names, descriptions, defs, libs, options) %#ok<DEFNU>
    % UPDATEPOLICIES If polices don't exist create them otherwise off to update, this retains the policy IF
    arguments
        releases string
        names string
        descriptions string
        defs string
        libs databricks.datastructures.libraries.Library
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    clusterPolicy = databricks.ClusterPolicy(args{:});
    existingPolices = clusterPolicy.list;
    existingPolicyNames = [existingPolices.policies.name];

    for n = 1:numel(releases)
        cr = databricks.datastructures.clusterpolicy.CreateRequest;
        cr.name = names(n);
        cr.definition = defs(n);
        cr.description = descriptions(n);
        for m = 1:numel(libs(n))
            cr.libraries(end+1) = libs(n,m);
        end
        idx = find(contains(existingPolicyNames, names(n)), 1);
        if isempty(idx)
            createResult = clusterPolicy.create(cr);
            if isStringScalar(createResult) && strlength(createResult) > 0
                fprintf("Created policy: %s\n", names(n));
            elseif isa(createResult, "databricks.datastructures.clusterpolicy.ErrorResponse")
                fprintf("Failed to create policy.")
            else
                error("Unexpected return type from ClusterPolicy.create: %s", class(createResult))
            end
        else
            existingId = existingPolices.policies(idx).policyId;
            existingDescription =  existingPolices.policies(idx).description;
            fprintf("Update policy: %s\n", names(n))
            fprintf("Existing description:\n%s\n", existingDescription);
            fprintf("New description:\n%s\n", descriptions(n));
            reply = strip(input('Update policy? Y/N [Y]: ','s'));
            if strcmpi(reply,'y') || strlength(reply) == 0
                pur = databricks.datastructures.clusterpolicy.PolicyUpdateRequest();
                pur.policyId = existingId;
                pur.name = cr.name;
                pur.definition = cr.definition;
                pur.description = cr.description;
                pur.libraries =  cr.libraries;
                result = clusterPolicy.edit(pur);
                if ~isempty(result)
                    fprintf(2, "Error updating policy: %s", existingId);
                    disp(result);
                end
            end
        end
    end
end


function tf = writePoliciesFile(defs, releases, descriptions, libs, names, policySetupGuide, options)
    arguments
        defs string
        releases string
        descriptions string
        libs databricks.datastructures.libraries.Library
        names string
        policySetupGuide string
        options.verbose (1,1) logical = true
    end

    tf = false;
    if options.verbose
        fprintf("Writing: %s\n", policySetupGuide);
    end

    [fid, errmsg] = fopen(policySetupGuide, "w");
    if fid == -1
        fprintf("Unable to open file: %s, Message: %s\n", policySetupGuide, errmsg);
        return;
    end
    closeAfter = onCleanup(@() fclose(fid));

    fprintf(fid, "# Databricks Policies for MATLAB Runtime Clusters\n\n");
    fprintf(fid, "The following policy information can be used to create polices in Databricks\n");
    fprintf(fid, "to allow Workspace based creation of MATLAB runtime enabled clusters.\n\n");
    
    fprintf(fid, "> For Databricks runtimes 17 and greater the use of init script to create such\n");
    fprintf(fid, "> clusters is not supported, Container Services (Docker) must be used instead\n");
    fprintf(fid, "> See: Documentation/html/ContainerServices.html & Software/Docker/MATLABRuntime.\n\n");
    
    fprintf(fid, "If a cluster is created using such a policy which defines a *cluster scoped*\n");
    fprintf(fid, "MATLAB runtime library then further cluster scoped libraries\n");
    fprintf(fid, "cannot be installed and libraries should be installed using the *notebook scoped*\n");
    fprintf(fid, "`%%pip install /path/to/mylibrary.whl` approach.\n\n");

    for n = 1:numel(releases)
        fprintf(fid, "## MATLAB Runtime %s Policy Details\n\n", releases(n));
        fprintf(fid, "### %s Name\n\n", releases(n));
        fprintf(fid, "%s\n\n", names(n));
        fprintf(fid, "### %s Description\n\n", releases(n));
        fprintf(fid, "%s\n\n", descriptions(n));
        fprintf(fid, "### %s Definition\n\n", releases(n));
        fprintf(fid, "```json\n%s\n```\n\n", defs(n));
        
        if numel(libs) > 0
            fprintf(fid, "### %s Library\n\n", releases(n));
            fprintf(fid, "```json\n");
            for m = 1:numel(libs(n))
                fprintf(fid, "%s\n", libs(n,m).getPayload("", ""));
            end
            fprintf(fid, "```\n");
        end
        if n ~= numel(releases)
            fprintf(fid, "---\n\n");
        else
            fprintf(fid, "\n");
        end
    end
    tf = true;
end


function names = buildNames(releases)
    arguments
        releases string
    end

    names = string.empty;
    for n = 1: numel(releases)
        names(end+1) = sprintf("MATLAB Runtime %s", releases(n)); %#ok<AGROW>
    end
end


function libraries = buildLibraries(interfaceDirectory, releases, options)
    arguments
        interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        releases string
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    numReleases = numel(releases);
    numLibraries = 1; % just javabuilder.jar for now
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"]);

    if isMATLABReleaseOlderThan("R2024a")
       libraries(numReleases, numLibraries) = databricks.datastructures.libraries.Library;
    else
       libraries = createArray(numReleases, numLibraries, "databricks.datastructures.libraries.Library");
    end
    for n = 1:numReleases
        j = databricks.datastructures.libraries.Jar;
        j.jar = databricks.internal.mlRuntime.getLatestJavabuilder(interfaceDirectory, releases(n), args{:});
        libraries(n,1).setLibrary(j);
    end
end


function descriptions = buildDescriptions(releases)
    arguments
        releases string
    end

    version = matlab.databricks.databricksPackageVersion;
    if isempty(version) || strlength(version) == 0
        version = "(Version not set)";
    end
    % Descriptions must be less than 1000 characters
    descriptions = string.empty;
    for n = 1:numel(releases)
        content = sprintf("Cluster policy to use the MATLAB %s Runtime - Created using: v%s\n", releases(n), version);
        % content = content + sprintf("A cluster scoped library, javabuilder, is set. Further cluster scoped libraries cannot be installed on the cluster once created.\n");
        content = content + sprintf("Use %%pip install /path/to/mylibrary.whl for notebook scoped libraries.\n");
        content = content + sprintf("See: Documentation/html/LibraryAPI.html.\n");
        descriptions(end+1) = content; %#ok<AGROW>
    end
end


function defs = buildDockerDefinitions(zips, releases, sparkVersions, options)
    arguments
        zips string
        releases string
        sparkVersions string {mustBeNonzeroLengthText}
        options.logPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    sparkVersionsArray = '';
    for n = 1:numel(sparkVersions)
        sparkVersionsArray = [sparkVersionsArray, '    "', char(sparkVersions(n)), '"']; %#ok<AGROW>
        if n < numel(sparkVersions)
            sparkVersionsArray = [sparkVersionsArray, ',', newline]; %#ok<AGROW>
        end
    end
    sparkVersionsArray = string(sparkVersionsArray);

    defs = string.empty;
    for n = 1:numel(zips)
        % Start
        defs(n) = sprintf("{\n");
        % Docker
        defs(n) = defs(n) + string('  "docker_image.basic_auth.password": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) + string('    "value":"ey[REDACTED]MxfQ=="');
        defs(n) = defs(n) + "}," + newline;
        defs(n) = defs(n) + string('  "docker_image.basic_auth.username": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) + string('    "value":"AWS"');
        defs(n) = defs(n) + "}," + newline;
        defs(n) = defs(n) + string('  "docker_image.url": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) +sprintf('    "value":"123456789.dkr.ecr.us-west-2.amazonaws.com/mathworks/webdesktop%s:latest"', releases(n));
        defs(n) = defs(n) + "}," + newline;
        % LD_LIBRARY_PATH
        defs(n) = defs(n) + string('  "spark_env_vars.LD_LIBRARY_PATH": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) + string('    "value":"/MATLAB_Runtime/runtime/glnxa64:/MATLAB_Runtime/bin/glnxa64:/MATLAB_Runtime/sys/os/glnxa64:/MATLAB_Runtime/sys/opengl/lib/glnxa64:/MATLAB_Runtime/extern/bin/glnxa64"');
        defs(n) = defs(n) + "}," + newline;
        % MW_RUNTIME_ZIP
        defs(n) = defs(n) + string('  "spark_env_vars.MW_RUNTIME_ZIP": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) +sprintf('    "value": "%s"\n', zips(n));
        defs(n) = defs(n) + "  }," + newline;
        % MW_RUNTIME_RELEASE
        defs(n) = defs(n) + string('  "spark_env_vars.MW_RUNTIME_RELEASE": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) +sprintf('    "value": "%s"\n', releases(n));
        defs(n) = defs(n) + "  }," + newline;
        % ISV PRODUCT
        defs(n) = defs(n) + string('  "spark_conf.spark.databricks.isv.product": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) +sprintf('    "value": "%s"\n', databricks.Object.getUserAgent(release=releases(n)));
        defs(n) = defs(n) + "  }," + newline;
        % Cluster log
        if ~isempty(options.logPath) && strlength(options.logPath) == 0
            defs(n) = defs(n) + string('  "cluster_log_conf.type": {"type":"unlimited", "defaultValue":"DBFS", "isOptional":true},') + newline;
            defs(n) = defs(n) +sprintf('  "cluster_log_conf.path": {"type": "unlimited", "defaultValue": "%s"},\n', options.logPath);
        end
        % Spark version
        defs(n) = defs(n) + string('  "spark_version":{"type":"allowlist", "values":[') + newline + sparkVersionsArray + "]" + newline + "  }" + newline;
        % End
        defs(n) = defs(n) + "}";
    end
end


function defs = buildInitscriptDefinitions(zips, releases, sparkVersions, runtimesDirectory, options)
    arguments
        zips string
        releases string
        sparkVersions string {mustBeNonzeroLengthText}
        runtimesDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.logPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.initscript string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    if isfield(options, "initscript")
        initscript = options.initscript;
    else
        initscript = strip(runtimesDirectory, "right", "/") + "/runtime_install.sh";
    end

    sparkVersionsArray = '';
    for n = 1:numel(sparkVersions)
        sparkVersionsArray = [sparkVersionsArray, '    "', char(sparkVersions(n)), '"']; %#ok<AGROW>
        if n < numel(sparkVersions)
            sparkVersionsArray = [sparkVersionsArray, ',', newline]; %#ok<AGROW>
        end
    end
    sparkVersionsArray = string(sparkVersionsArray);

    defs = string.empty;
    for n = 1:numel(zips)
        % Start
        defs(n) = sprintf("{\n");
        % initscipt
        defs(n) = defs(n) + string('  "init_scripts.0.volumes.destination":{') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) +sprintf('    "value": "%s"\n', initscript);
        defs(n) = defs(n) + "  }," + newline;
        % LD_LIBRARY_PATH
        defs(n) = defs(n) + string('  "spark_env_vars.LD_LIBRARY_PATH": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) + string('    "value": "/MATLAB_Runtime/runtime/glnxa64:/MATLAB_Runtime/bin/glnxa64:/MATLAB_Runtime/sys/os/glnxa64:/MATLAB_Runtime/sys/opengl/lib/glnxa64:/MATLAB_Runtime/extern/bin/glnxa64"');
        defs(n) = defs(n) + "}," + newline;
        % MW_RUNTIME_ZIP
        defs(n) = defs(n) + string('  "spark_env_vars.MW_RUNTIME_ZIP": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) +sprintf('    "value": "%s"\n', zips(n));
        defs(n) = defs(n) + "  }," + newline;
        % MW_RUNTIME_RELEASE
        defs(n) = defs(n) + string('  "spark_env_vars.MW_RUNTIME_RELEASE": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) +sprintf('    "value": "%s"\n', releases(n));
        defs(n) = defs(n) + "  }," + newline;
        %
        defs(n) = defs(n) + string('  "spark_conf.spark.databricks.isv.product": {') + newline;
        defs(n) = defs(n) + string('    "type": "fixed",') + newline;
        defs(n) = defs(n) +sprintf('    "value": "%s"\n', databricks.Object.getUserAgent());
        defs(n) = defs(n) + "  }," + newline;
        % Cluster log
        if isfield(options, "logPath") && ~isempty(options.logPath) && strlength(options.logPath) == 0
            defs(n) = defs(n) + string('  "cluster_log_conf.type": {"type":"unlimited", "defaultValue":"DBFS", "isOptional":true},') + newline;
            defs(n) = defs(n) +sprintf('  "cluster_log_conf.path": {"type": "unlimited", "defaultValue": "%s"},\n', options.logPath);
        end
        % Spark version
        defs(n) = defs(n) + string('  "spark_version":{"type":"allowlist", "values":[') + newline + sparkVersionsArray + "]" + newline + "  }" + newline;
        % End
        defs(n) = defs(n) + "}";
    end
end


function [zips, matchedReleases] = getRuntimeZips(runtimesDirectory, options)
    arguments
        runtimesDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.releases string {mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    zips = string.empty;
    matchedReleases = string.empty;

    args = matlab.utils.addArgs(options, ["releases"]); %#ok<NBRAK2>
    releases = getReleases(args{:});

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    for n = 1:numel(releases)
        zip = databricks.internal.mlRuntime.getLatestRuntime("directory", runtimesDirectory, "release", releases(n), args{:});
        if ~isempty(zip) && strlength(zip) > 0
            zips(end+1) = zip; %#ok<AGROW>
            matchedReleases(end+1) = releases(n); %#ok<AGROW>
        else
            fprintf(2, "No corresponding MATLAB runtime found for release: %s in: %s\n", releases(n), runtimesDirectory);
        end
    end
end


function releases = getReleases(options)
    arguments
        options.releases string {mustBeNonzeroLengthText}
    end

    if isfield(options, "releases")
        releases = options.releases;
    else
        pkgSettings = matlab.databricks.internal.pkgsettings.getPkgSettings;
        releases = [pkgSettings.supportedMATLABReleases.release];
    end
end
