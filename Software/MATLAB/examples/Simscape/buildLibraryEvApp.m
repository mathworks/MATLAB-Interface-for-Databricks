function PSB = buildLibraryEvApp()
    % buildLibraryEvApp - Build the library for Databricks
    % Check that the function schema has first been generated as documented in the README.

    opts = compiler.build.PythonPackageOptions( ...
        "runEvRefApp.m", ...
        "OutputDir", "_build_ev_app", ...
        "PackageName", "sldemo.virtualvehicleref");

    fprintf("Output directory: %s\n", opts.OutputDir);
    
    PSB = compiler.build.spark.pythonPackage(opts);
end
