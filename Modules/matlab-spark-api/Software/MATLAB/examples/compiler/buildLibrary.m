function PSB = buildLibrary()
    % buildLibrary
    %
    % This is used as an example in
    %   Modules/matlab-spark-api/Documentation/PythonSparkBuilder.md

    % Copyright 2024-2025 The MathWorks, Inc.

    opts = compiler.build.PythonPackageOptions(...
        ["plusPi.m", "doMath.m", "addStringCol.m"], ...
        "OutputDir", "_build", ...
        "PackageName", "some.pkg");

    PSB = compiler.build.spark.pythonPackage(opts);

end