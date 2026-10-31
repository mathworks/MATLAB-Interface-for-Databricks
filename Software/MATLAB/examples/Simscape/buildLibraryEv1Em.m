function PSB = buildLibraryEv1Em()
    % buildLibraryEv1Em - Build the library for Databricks
    % Check that the function schema has first been generated as documented in the README.

    opts = compiler.build.PythonPackageOptions( ...
        "runEv1Em.m", ...
        "OutputDir", "_build_ev1em", ...
        "PackageName", "sldemo.virtualvehicle");

    fprintf("Output directory: %s\n", opts.OutputDir);
    
    PSB = compiler.build.spark.pythonPackage(opts);
end
