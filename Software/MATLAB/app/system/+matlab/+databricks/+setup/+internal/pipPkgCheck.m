function tf = pipPkgCheck(pkg, options)
    % PIPPKGCHECK Returns true if a package is found, returns false otherwise
    % Uses a system command to call the python with -m pip show <package>: arguments.
    % Requires that the pip package is installed.
    % Can be used without an python environment using an absolute path.
    %
    % Returns false if the Python environment, if used, executable property is not
    % correctly configured.
    % If a matlab.pyclient.PythonEnvironment or PythonPath is not provided just
    % "python" or "python.exe" will be called. This is not recommended due to a
    % high chance of failure.
    %
    % The function cannot be used to check for the presence of pip itself.
    % 
    % Example:
    %   % Check if pip is databricks-connect
    %   tf = matlab.databricks.setup.internal.pipPkgCheck("databricks-connect", pyenv=mypyenv)

    % Copyright 2024-2025 The MathWorks, Inc.

    arguments
        pkg string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pyenv matlab.pyclient.PythonEnvironment
        options.pythonPath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    if strcmp(pkg, "pip")
        fprintf(2, "The check uses the pip package an thus cannot be used to check for pip.\n")
        tf = false;
        return;
    end

    if isfield(options, "pyenv")
        if strlength(options.pyenv.Executable) > 0 && isfile(options.pyenv.Executable)
            exePath = pyenv.Executable;
        else
            if options.verbose
                fprintf(2, "Python environment is not configured, cannot check for package: %s\n", pkg);
            end
            tf = false;
            return;
        end
    elseif isfield(options, "pythonPath")
        if isfile(options.pythonPath)
            exePath = options.pythonPath;
        else
            if options.verbose
                fprintf(2, "Specified Python executable not found: \n  %s\nCannot check for package: %s\n", options.pythonPath, pkg);
            end
            tf = false;
            return;
        end
    else
        if options.verbose
            fprintf(2,"Neither a Python environment or Python path has been specified.\n")
            if ispc
                fprintf(2, "The command: python.exe will be used, this may not be on the path and may fail.\n");
            else
                fprintf(2, "The command: python will be used, this may not be on the path and may fail.\n");
            end
        end
        if ispc
            exePath = "python.exe"; % Consider if pythonw.exe is a better option?
        else
            exePath = "python";
        end
    end

    chkCmd = """" + exePath + """" + " -m pip show " + pkg;
    [status, cmdout] = system(chkCmd);
    if status == 0
        tf = true;
    else
        tf = false;
        if options.verbose
            fprintf(2, "Output: %s\n", cmdout);
        end
    end
end