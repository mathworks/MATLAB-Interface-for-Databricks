function tf = generateRuntimeBuildscript(options)
    % generateRuntimeBuildscript Generates a bash script to build MATLAB Runtime images
    %
    % This script generates a bash or ps1 script to build Docker images.
    % The build can be adapted with the options below:
    %
    %           registry : There registry (in case of Azure) where to store
    %                      the images
    %
    %             noWait : In case of Azure, no-wait flag
    %                      Default: false
    %
    %           buildEnv : Supports 'docker' for local builds or 'azure' for acr
    %                      builds. Default: 'docker'
    %
    %         scriptLang : Choose bash (.sh) or powershell (ps1)
    %                      Default: 'bash'
    %
    %          imageName : The name of the image to build
    %
    %     matlabReleases : A list of MATLAB releases to build for.
    %                      The special release "all" will assume all releases.
    %                      Default: ["R2024b", "R2025b", "R2026a", "R2026b"]
    %
    % databricksRuntimes : A list of databricks runtimes to build for
    %                      The special runtime "all" will build for all
    %                      runtimes available for the corresponding matlab
    %                      release (not all databricks runtimes we support)
    %                      Only LTS versions are supported.
    %                      For non LTS support manually update the Dockerfile.
    %                      Default: ["16.4", "17.3", "18.3"]
    %
    %            verbose : Verbosity, true/false
    %                      Default: true 
    %
    % Example:
    %   generateRuntimeBuildscript(registry='my_acr_registry', buildEnv='azure')
    %
    % Returns a logical true upon successful completion.

    % Copyright 2025-2026 MathWorks, Inc

    arguments
        options.registry string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.noWait (1,1) logical = false
        options.buildEnv char {mustBeMember(options.buildEnv, {'docker', 'azure'})} = 'docker'
        options.scriptLang char {mustBeMember(options.scriptLang, {'bash', 'powershell'})} = 'bash'

        options.imageName (1,1) string = "matlab/databricks/runtime"
        options.matlabReleases string {mustBeNonzeroLengthText} = ["R2024b", "R2025b", "R2026a", "R2026b"]
        % Supporting building for LTS by default only ["15.4", "16.4", "17.3", "18.3"]
        % 18.3 is the number of 18.x-LTS see: https://hub.docker.com/r/databricksruntime/standard/tags
        options.databricksRuntimes string {mustBeNonzeroLengthText} = ["16.4", "17.3", "18.3"]
        options.outputFolder string {mustBeTextScalar, mustBeNonzeroLengthText} = pwd
        options.verbose (1,1) logical = true
    end

    isDocker = strcmpi(options.buildEnv, 'docker');
    isAzure = strcmpi(options.buildEnv, 'azure');

    runtimeConfig = jsondecode(fileread(databricksRoot('config', 'runtime-info.json')));

    matlabReleases = matlab.databricks.ReleaseConfig.adaptMATLABReleases(options.matlabReleases, runtimeConfig);

    switch lower(options.scriptLang)
        case 'bash'
            ext = ".sh";
            lineCont = "\";
        case 'powershell'
            ext = ".ps1";
            lineCont = "`";
    end

    srcFileGit = "https://raw.githubusercontent.com/mathworks-ref-arch/matlab-on-databricks/refs/heads/main/resources/dockerfiles/runtime/Dockerfile";
    srcFile = sprintf("%s_%s", tempname, 'Dockerfile');
    websave(srcFile, srcFileGit);

    switch options.buildEnv
        case 'azure'
            outputName = "buildRuntimeImages_azure" + ext;
        case 'docker'
            outputName = "buildRuntimeImages_local" + ext;
    end

    if ~isfolder(options.outputFolder)
        error("DATABRICKS:DOCKER:NOFOLDER", ...
        "Output folder: '%s' does not exist.", options.outputFolder);
    else
        outputPath = fullfile(options.outputFolder, outputName);
    end

    sw = matlab.sparkutils.StringWriter(outputPath);
    if strcmpi(options.scriptLang, 'bash')
        sw.pf("#!/bin/bash\n")
    end

    if isAzure
        sw.pf("# Script builds DockerFiles on Azure\n");
    end
    if isDocker
        sw.pf("# Script builds DockerFiles locally\n");
    end
    sw.pf('\n')
    if strcmpi(options.scriptLang, 'bash')
        sw.pf("set -xeuo pipefail\n\n");
    end
    if isAzure
        if isfield(options, "registry")
            sw.pf("# The registry is set to: %s\n\n", options.registry);
        else
            sw.pf("# Use option: %sh <docker_registry_name>\n\n", outputPath);
        end

        if isfield(options, "registry")
            switch lower(options.scriptLang)
                case 'bash'
                    sw.pf('REPO="%s"\n\n', options.registry);
                case 'powershell'
                    sw.pf('$env:REPO="%s"\n\n', options.registry);
            end
        else
            switch lower(options.scriptLang)
                case 'bash'
                    sw.pf('REPO="$1"\n\n');
                case 'powershell'
                    sw.pf('$env:REPO=$args[0]\n\n');
            end
        end

        switch lower(options.scriptLang)
            case 'bash'
                sw.pf("az acr login -n $REPO\n\n");
            case 'powershell'
                sw.pf("az acr login -n $env:REPO\n\n");
        end
    end

    sw.pf("# Dockerfile was downloaded from:\n#\t%s\n\n", srcFileGit);

    for m = 1:numel(matlabReleases)
        ML_Rel = matlabReleases(m);

        databricksRuntimes = matlab.databricks.ReleaseConfig.adaptDatabricksRuntimes(options.databricksRuntimes, ML_Rel, runtimeConfig);
        for d = 1:numel(databricksRuntimes)
            DBX_Rel = databricksRuntimes(d);

            if ~matlab.databricks.ReleaseConfig.matlabDatabricksCombinationSupported(ML_Rel, DBX_Rel, runtimeConfig)
                warning("DATABRICKS:DOCKER:BAD_COMBINATION", ...
                    "The combination of MATLAB %s and Databricks %s is not supported. Skipping this image.\n", ML_Rel, DBX_Rel);
                continue;
            end

            runtimeURL = runtimeConfig.(ML_Rel).runtime;
            dbxFieldName = "dbx" + strrep(DBX_Rel, ".", "_");
            depsURL = runtimeConfig.(ML_Rel).deps.(dbxFieldName);
            imageTag = sprintf("%s-dbx%s", lower(ML_Rel), lower(DBX_Rel));
            sw.pf("\n")
            sw.pf("# Build docker image for MATLAB %s and Databricks %s\n", ML_Rel, DBX_Rel);
            if isAzure
                sw.pf("az acr build %s\n", lineCont);
            end
            if isDocker
                sw.pf("docker build %s\n", lineCont);
            end
            sw.indent()
            if isAzure
                switch lower(options.scriptLang)
                    case 'bash'
                        sw.pf("--registry $REPO %s\n", lineCont);
                    case 'powershell'
                        sw.pf("--registry $env:REPO %s\n", lineCont);
                end
                sw.pf('--image "%s:%s" %s\n', options.imageName, imageTag, lineCont);
                if options.noWait
                    sw.pf("--no-wait %s\n", lineCont);
                end
            end
            if isDocker
                sw.pf('-t "%s:%s" %s\n', options.imageName, imageTag, lineCont);
            end
            sw.pf("--build-arg MATLAB_RELEASE=%s %s\n", ML_Rel, lineCont);
            sw.pf("--build-arg DATABRICKS_RUNTIME_VERSION=""%s"" %s\n", DBX_Rel, lineCont);
            sw.pf("--build-arg MATLAB_DEPS_URL=""%s"" %s\n", depsURL, lineCont);
            sw.pf("--build-arg MATLAB_RUNTIME_URL=""%s"" %s\n", runtimeURL, lineCont);
            sw.pf("--build-arg UBUNTU_VERSION=""%s"" %s\n", ...
                matlab.databricks.ReleaseConfig.getUbuntuVersion(DBX_Rel), lineCont);
            sw.pf("-f %s .\n", srcFile);
            sw.unindent()
        end
    end
    sw.pf("\n")
    sw.pf("# End of script\n\n");
    tf = true;
end


