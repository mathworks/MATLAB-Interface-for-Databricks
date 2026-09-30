function PSB = pythonPackage(buildOpts, options)
    % compiler.build.spark.pythonPackage Spark builder for Python
    %
    %  Please refer to the documentation delivered in this package for
    %  PythonSparkBuilder for usage examples.
    %
    % Arguments:
    %  buildOpts - A required argument of type compiler.build.PythonPackageOptions
    %
    %  partialTables - An option that makes it possible to use a table as input,
    %      that lacks certain columns. The functions compiled must be
    %      written to handle missing columns.
    %      Default: false
    %
    % tryCatch (experimental) - This option encloses the calling of the
    %      compiled function in a try/catch statement, and ensures that a
    %      job will not fail because one section fails in the MATLAB
    %      function. If the MATLAB function fails, an empty table will be
    %      returned, and some messages will be written to stderr, which can
    %      be found in the cluster-logs if turned on. Please note that this
    %      is a sort of "silent error" and should be used with caution.
    %      Default: false
    %
    % tryCatchErrorColumn (experimental) - This option is only active
    %      together with the tryCatch option. It can be used to return the
    %      error message when the compiled MATLAB function fails in a
    %      certain column. The column must exist in the output table and
    %      be of type string.
    %
    % wheelDestination - A string for the directory where the wheel file
    %      should be uploaded. This feature is currently only supported on
    %      Databricks. It will create a %pip install line in the example
    %      python files/notebooks that are generated, and can be used with
    %      the uploadWheel method.
    %
    % notebookDestination - A string for the directory where
    %      notebook example files should be uploaded. This feature
    %      is currently only supported on Databricks. The
    %      uploadExampleNotebooks methods will automatically upload
    %      the notebooks to this directory if no argument is
    %      specified.
    %
    % buildTag - This option enables adding a build tag. It must start with a
    %     numerical digit.
    %
    % versionTag - A version string explicitly set. Default is the current
    %      MATLAB release used for compilation, e.g. for R2026a it is 26.1.0

    % debug - Internal development option. Undocumented.
    %
    % platformsTag - Internal development option. Undocumented. Currently
    %      not processed correctly by setup process.
    
    % Copyright 2022-2026 MathWorks, Inc.
    
    arguments
        buildOpts (1,1) compiler.build.PythonPackageOptions
        
        options.versionTag string = string.empty
        options.buildTag string = string.empty
        options.platformsTag string = string.empty

        options.partialTables (1,1) logical = false
        options.debug (1,1) logical = false
        options.tryCatch (1,1) logical = false
        options.tryCatchErrorColumn (1,1) string = ""
        options.wheelDestination string = string.empty
        options.notebookDestination  string = string.empty
    end

    PSB = compiler.build.spark.PythonSparkBuilder( ...
        buildOpts, ...
        versionTag = options.versionTag, ...
        buildTag = options.buildTag, ...
        platformsTag = options.platformsTag, ...
        partialTables=options.partialTables, ...
        tryCatch=options.tryCatch, ...
        tryCatchErrorColumn=options.tryCatchErrorColumn, ...
        wheelDestination=options.wheelDestination, ...
        notebookDestination=options.notebookDestination, ...
        debug=options.debug);
    
    PSB.build()
end
