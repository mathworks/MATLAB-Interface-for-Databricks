function tf = dbcCreateVenv(options)
    % DBCCREATEVENV Create a Python virtual environment for a given DBC version
    %
    % Optional arguments:
    %        pe: Python environment, if not specified the python environment returned
    %            by pyenv() will be used.
    %
    %   version: Databricks Connect versions to support. A corresponding
    %            directory is expected in Software/MATLAB/Connect e.g.
    %            Software/MATLAB/Connect/15.4/
    %            By default the supported versions in Software/MATLAB/Connect
    %            are used.
    %
    %   venvDir: Directory containing the virtual environment, the default is:
    %            Software/MATLAB/Connect/<version>/venv
    %
    %   verbose: Produce additional output. Default is true.
    %
    % Python is invoked using a system call.
    % A logical true is returned on success, otherwise false.
    %
    % venv or virtualenv is required, venv is preferred.
    % pip is required.
    %
    % Example:
    %   tf = matlab.databricks.setup.internal.dbcCreateVenv(pe=mypyenv, version="15.4");

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments
        options.pe (1,1) matlab.pyclient.PythonEnvironment
        options.venvDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.version string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.cluster.getDefaultSparkVersion()
        options.verbose (1,1) logical = true
    end

    if isfield(options, "venvDir")
        venvDir = options.venvDir;
    else
        venvDir = databricksRoot("Connect", options.version, "venv");
    end

    if isfield(options, "pe")
        pe = options.pe();
    else
        pe = pyenv();
    end

    if isprop(pe, "Executable")
        if isempty(pe.Executable) || strlength(pe.Executable) == 0
            fprintf(2,"Pyenv executable value not configured.\n");
            tf = false;
            return;
        else
            pythonExecutable = pe.Executable;
        end
    else
        fprintf(2,"Pyenv executable property not found.\n");
        tf = false;
        return;
    end

    if startsWith(pythonExecutable, venvDir)
        fprintf(2, "A Python virtual environment cannot be used to create itself: %s\n", venvDir);
        tf = false;
        return;
    end

    if matlab.databricks.setup.internal.pyModuleCheck("venv", verbose=false)
        venvCmd = sprintf("""%s"" -m venv ""%s""", pythonExecutable, venvDir);
    elseif matlab.databricks.setup.internal.pyModuleCheck("virtualenv", verbose=false)
        venvCmd = sprintf("""%s"" -m virtualenv ""%s""", pythonExecutable, venvDir);
    else
        if options.verbose
            fprintf(2,"Neither the Python venv or virtualenv packages are installed, virtual environments cannot be created.\n");
        end
        tf = false;
        return;
    end
 
    if options.verbose
        fprintf("Creating a Python virtual environment: %s\n", venvDir)
    end
    [status, cmdout] = system(venvCmd);
    if status ~= 0
        if options.verbose
            fprintf(2, "Virtual environment creation: %s failed\nOutput: %s\n", venvCmd, cmdout);
        end
        tf = false;
    else
        tf = true;
    end
end
