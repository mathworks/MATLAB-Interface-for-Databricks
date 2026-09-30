function tf = pyModuleCheck(module, options)
    % PYMODULECHECK Returns true if a Python module/package is found, otherwise returns false
    % Uses: importlib.util.find_spec(module)
    % A functional Python environment is required.
    %
    % Example:
    %   tf = matlab.databricks.setup.internal.pyModuleCheck("pip")

    % Copyright 2025 The MathWorks, Inc.

    arguments
        module string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    try
        pyResult = py.importlib.util.find_spec(module);
        if isa(pyResult, 'py.NoneType')
            if options.verbose
                fprintf(2, "Python module not found: %s\n", module);
            end
            tf = false;
        else
            tf = true;
        end
    catch ME
        if options.verbose
            fprintf(2, "Call to: py.importlib.util.find_spec() failed for: %s.\n", module);
            fprintf(2, "Message: %s\n", ME.message);
        end
        tf = false;
    end
end