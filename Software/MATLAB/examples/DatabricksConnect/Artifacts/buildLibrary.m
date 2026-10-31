function PSB = buildLibrary()
    % buildLibrary Build a compiled MATLAB library (.whl) package

    % Generate the required schema files
    generateSchemas();

    opts = compiler.build.PythonPackageOptions(...
        ["plusPi.m", "doMath.m", "addStringCol.m", "tblPlus.m", "myArr.m"], ...
        "OutputDir", fullfile(tempdir, "Artifacts", "_build"), ...
        "PackageName", "artifacts.example");

    fprintf("Output directory: %s\n", opts.OutputDir);

    PSB = compiler.build.spark.pythonPackage(opts);
end