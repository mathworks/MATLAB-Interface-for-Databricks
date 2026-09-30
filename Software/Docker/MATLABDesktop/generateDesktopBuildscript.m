function tf = generateDesktopBuildscript(options)
    % generateDesktopBuildscript Generates a script to build images
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
    %           buildEnv : Supports docker or azure (using ACR)
    %                      Default: 'docker'
    %
    %         scriptLang : Choose bash (.sh) or PowerShell (.ps1)
    %                      Default: 'bash'
    %
    %          imageName : The name of the image to build
    %
    %           extraTag : Opaque value appended to the generated image tag
    %
    %     matlabReleases : A list of MATLAB releases to build for
    %                      The special release "all" will assume all
    %                      releases. Releases prior to R2024b and release R2025a
    %                      are not supported.
    %                      Default: ["R2024b", "R2025b", "R2026a", "R2026b"]
    %
    % databricksRuntimes : A list of Databricks runtimes to build for
    %                      The special runtime "all" will build for all
    %                      runtimes available for the corresponding matlab
    %                      release (not all databricks runtimes we support)
    %                      LTS runtimes 15.4 and later are supported.
    %                      Defaults: ["16.4", "17.3", "18.3"]
    %
    %  matlabProductList : The MATLAB products to install
    %                      Default: "MATLAB Database_Toolbox MATLAB_Compiler MATLAB_Compiler_SDK Simulink Simulink_Compiler Stateflow" 
    %
    %            verbose : Verbosity, true/false
    %                      Default: true 
    %
    %         outputName : Specific base name for script file (extension
    %                      automatic)
    %
    %       updateNumber : A string denoting an update. Specify a MATLAB
    %                      release update version (for example, U0 for the base release, or U1 for update 1).
    %                      For details, see: https://www.mathworks.com/help/install/ug/mpminstall.html#mw_37e5e202-ecc6-4e61-9fa4-22b81f9931d3
    %                      To install the latest available update, leave this argument empty.
    %                      Only use this argument for a single MATLAB
    %                      Release at the time.
    %
    % Example:
    %   generateDesktopBuildscript(registry='my_acr_registry', buildEnv='azure')
    %
    % Note: MATLAB R2024b Update 8 is not supported on Databricks, currently
    %       update 7 will be us used as the maximum by default.
    %
    % Returns a logical true upon successful completion.

    % Copyright 2025-2026 MathWorks, Inc

    arguments
        options.registry string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.noWait (1,1) logical = false
        options.buildEnv char {mustBeMember(options.buildEnv, {'docker', 'azure'})} = 'docker'
        options.scriptLang char {mustBeMember(options.scriptLang, {'bash', 'powershell'})} = 'bash'

        options.imageName (1,1) string = "matlab/databricks/desktop"
        options.extraTag (1,1) string {mustBeTextScalar} = ""
        options.matlabReleases string {mustBeNonzeroLengthText} = ["R2024b", "R2025b", "R2026a", "R2026b"]
        % Supporting building for LTS by default only ["15.4", "16.4","17.3", "18.3"]
        options.databricksRuntimes string {mustBeNonzeroLengthText} = ["16.4", "17.3", "18.3"]
        options.matlabProductList string {mustBeNonzeroLengthText} ="MATLAB Database_Toolbox MATLAB_Compiler MATLAB_Compiler_SDK Simulink Simulink_Compiler Stateflow"
        options.verbose (1,1) logical = true
        options.outputName (1,1) string
        options.updateNumber (1,1) string {mustBeNonzeroLengthText}
    end

    isDocker = strcmpi(options.buildEnv, 'docker');
    isAzure = strcmpi(options.buildEnv, 'azure');

    switch options.scriptLang
        case 'bash'
            ext = ".sh";
            lineCont = "\";
        case 'powershell'
            ext = ".ps1";
            lineCont = "`";
    end

    runtimeConfig = jsondecode(fileread(databricksRoot('config', 'runtime-info.json')));

    matlabReleases = matlab.databricks.ReleaseConfig.adaptMATLABReleases(options.matlabReleases, runtimeConfig);

    if isfield(options, 'updateNumber')
        if numel(matlabReleases) > 1
            error("DATABRICKS:DOCKERDESKTOPIMAGE:UPDATE_RELEASE_MISMATCH", ...
                "You can only use an update number if you are building for " + ...
                "a single MATLAB Release.");
        end
        if isempty(regexp(options.updateNumber, "U[0-9][0-9]*","once"))
            error("DATABRICKS:DOCKERDESKTOPIMAGE:UPDATE_RELEASE_STRING", ...
                "The updateNumber string must be a string like U7, U12, etc. " + ...
                "No check is performed to see if the release actually exists.");
        end
    end


    isBash = strcmpi(options.scriptLang, 'bash');

    srcFileGit = "https://raw.githubusercontent.com/mathworks-ref-arch/matlab-on-databricks/refs/heads/main/resources/dockerfiles/matlab/Dockerfile";
    srcFile = sprintf("%s_%s", tempname, 'Dockerfile');
    websave(srcFile, srcFileGit);

    if isfield(options, 'outputName')
        outputName = options.outputName + ext;
    else
        switch options.buildEnv
            case 'azure'
                outputName = "buildDesktopImages_azure" + ext;
            case 'docker'
                outputName = "buildDesktopImages_local" + ext;
        end
    end

    outputPath = fullfile(pwd, outputName);

    sw = matlab.sparkutils.StringWriter(outputPath);
    if isBash
        sw.pf("#!/bin/bash\n")
    end

    if isAzure
        sw.pf("# Script builds DockerFiles on Azure\n");
    end
    if isDocker
        sw.pf("# Script builds DockerFiles locally\n");
    end
    sw.pf('\n')
    if isBash
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

    switch lower(options.scriptLang)
        case 'bash'
            matlabProductList = options.matlabProductList;
        case 'powershell'
            matlabProductList = strrep(options.matlabProductList, " ", "\ ");
    end

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

            imageTag = sprintf("%s-dbx%s%s", lower(ML_Rel), lower(DBX_Rel), options.extraTag);
            dbxLTS = DBX_Rel + "-LTS";
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
            % Don't allow the latest release of 24b (U8) to be used by default
            if isfield(options, 'updateNumber')
                sw.pf("--build-arg MATLAB_UPDATE=%s %s\n", options.updateNumber, lineCont);
            else
                if strcmpi(ML_Rel, "R2024b")
                    sw.pf("--build-arg MATLAB_UPDATE=U7 %s\n", lineCont);
                end
            end
            sw.pf("--build-arg DATABRICKS_IMAGE_TAG=""%s"" %s\n", dbxLTS, lineCont);
            sw.pf("--build-arg DATABRICKS_RUNTIME_VERSION=""%s"" %s\n", DBX_Rel, lineCont);
            sw.pf("--build-arg UBUNTU_VERSION=""%s"" %s\n", ...
                matlab.databricks.ReleaseConfig.getUbuntuVersion(DBX_Rel), lineCont);
            sw.pf("--build-arg MATLAB_PRODUCT_LIST='""%s""' %s\n", matlabProductList, lineCont);
            sw.pf("-f %s .\n", srcFile);
            sw.unindent()
        end
    end

    sw.pf("\n")
    sw.pf("# End of script\n\n");

    tf = true;
end

