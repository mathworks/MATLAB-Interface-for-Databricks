function PSB = buildLibrary
    % A simple function that uses the PythonSparkBuilder to build a Spark-compatible
    % Wheel-file of MATLAB code.

    % Copyright 2022-2025 MathWorks, Inc.

    % Generate the schema(s)
    generateSchemas();

    % First define the options needed for the build
    files = "deeply.m";

    opts = compiler.build.PythonPackageOptions(...
        files, ...
        "OutputDir", "_build", ...
        "PackageName", "mlstructs");

    % Now run the PythonSparkBuilder with these options
    PSB = compiler.build.spark.pythonPackage(opts);

end