function results = buildBinary
    % A simple function that uses the PythonSparkBuilder to build a Spark-compatible
    % Wheel-file of MATLAB code.

    % Copyright 2026 MathWorks, Inc.

    if ispc || ismac
        error("Standalone executables for use with the MATLAB runtime running on Databricks must be compiled on Linux.");
    end

    if isfolder("_build")
    	fprintf("Deleting previous _build directory.\n");
    	rmdir("_build", "s");
    end

    fprintf("Building standalone executable.\n");
    opts = compiler.build.StandaloneApplicationOptions(...
        "inout.m", ...
        "OutputDir", "_build");

    results = compiler.build.standaloneApplication(opts);
end
