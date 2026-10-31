function tf = pipInstallFromDir(package, whlsDir, options)
    % pipInstallFromDir Install .whls from a directory of .whls
    %
    % Required argument
    %     package: Name(s) of package to install, if the name ends with
    %              "requirements.txt" then that will be used as a requirements file.
    %              This can be an array of package names.
    %
    %     whlsDir: Directory of the .whl files.
    %
    % Optional arguments
    %   pythonCmd: Path to a Python executable, the default is the venv
    %              based on the version argument.
    %
    %
    %     verbose: Produce additional output. Default is true.
    %
    % Example:
    %   tf = matlab.databricks.setup.internal.pipInstallFromDir("databricks-connect", "/myDownloads");

    % Copyright 2024 The MathWorks, Inc.

    arguments
        package string {mustBeNonzeroLengthText}
        whlsDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pythonCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    if ~isfolder(whlsDir)
        fprintf(2, "whlsDir directory not found: %s\n", whlsDir);
        tf = false;
        return;
    end

    if isfield(options, "pythonCmd")
        pythonCmd = options.pythonCmd;
    else
        pe = pyenv();
        if isempty(pe.Version) || strlength(pe.Version) == 0
            fprintf(2, "Unable to initialize a Python environment.\n");
            tf = false;
            return;
        else
            pythonCmd = pe.Executable;
        end
    end
    pipCmd = """" + pythonCmd + """" + " -m pip";
    
    if isscalar(package) && endsWith(package, "requirements.txt")
        installCmd = pipCmd + " install --requirement " + """"+package+"""" + " --retries 0" + " --no-index" + " --find-links " + """"+whlsDir+"""";
    else
        packages = join(package, " ");
        installCmd = pipCmd + " install " + packages + " --retries 0" + " --no-index" + " --find-links " + """"+whlsDir+"""";
    end

    if options.verbose
        echoArgs = {'-echo'};
    else
        echoArgs = {};
    end
    [status, cmdout] = system(installCmd, echoArgs{:});
    if status ~= 0
        fprintf(2, "pip install command: %s failed\nOutput: %s\n", installCmd, cmdout);
        tf = false;
    else
        tf = true;
    end
end