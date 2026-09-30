function [tf] = pipDownload(package, whlsDir, options)
    % PIPDOWNLOAD Uses pip to download .whls to a directory
    % The package argument specifies the PyPi package(s).
    % If package is scalar text that ends in "requirements.txt" it will be
    % treated as a requirements file.
    % The whlsDir argument specifies the download destination directory.
    % If the directory does not exist an attempt will be made to create it.
    % True is returned on success otherwise false is returned.
    %
    % The version of Python and pip is determined based on the current
    % pyenv's executable.
    %
    % Optional named arguments:
    %
    %        pythonCmd: Path to a Python executable, the default is that given
    %                   by the pyenv command.
    %
    %  alternativeRepo: URL for an alternative library source e.g. Artifactory.
    %
    %          verbose: Produce additional output. Default is true.
    %
    % Example:
    %   tf = matlab.databricks.setup.internal.pipDownload("databricks-connect", "/home/username/databricks/Software/MATLAB/Connect/15.4/whls/");

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments
        package string {mustBeNonzeroLengthText}
        whlsDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pythonCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.alternativeRepo string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.noCacheDir (1,1) logical = false
        options.verbose (1,1) logical = true
    end

    tf = false;
    if isscalar(package) && endsWith(package, "requirements.txt")
        if ~isfile(package)
            fprintf(2, "Specified requirements file not found: %s\n", package);
            return;
        end
        pkgsArg = "--requirement " + """" + package + """";
    else
        pkgsArg = join(package, " ");
    end

    if ~isfolder(whlsDir)
        [status,msg] = mkdir(whlsDir);
        if status ~= 1
            fprintf(2, "Unable to create whlsDir directory: %s\nMessage: %s\n", whlsDir, msg);
            return;
        end
    end

    if isfield(options, "pythonCmd")
        pythonCmd = options.pythonCmd;
    else
        pe = pyenv();
        if isempty(pe.Version) || strlength(pe.Version) == 0
            fprintf(2, "Unable to initialize a Python environment.\n");
            return;
        else
            pythonCmd = pe.Executable;
        end
    end
    
    pipCmd = """" + pythonCmd + """" + " -m pip";
    downloadCmd = pipCmd + " download " + pkgsArg + " -d """ + whlsDir + """ -v";

    if options.noCacheDir
        downloadCmd = downloadCmd + " --no-cache-dir";
    end

    if isfield(options, "alternativeRepo")
        repoURL = matlab.net.URI(options.alternativeRepo);
        downloadCmd = downloadCmd + " --extra-index-url " + repoURL.EncodedURI + " --trusted-host " + repoURL.EncodedAuthority;
    end

    if options.verbose
        echoArgs = {'-echo'};
    else
        echoArgs = {};
    end
    [status, cmdout] = system(downloadCmd, echoArgs{:});
    if status ~= 0
        fprintf(2, "pip download command failed: %s\nOutput: %s\n", downloadCmd, cmdout);
    else
        tf = true;
    end
end