function PSB = buildLibrary(options)
    % BUILDLIBRARY Builds a Wheel file for runModel_spark_with_input for use on Databricks
    %
    % Optional named arguments
    %   outputDirectory - Directory where the wheel file will be created.
    %                     Should not be a Databricks /Volumes path.
    %                     Default: <tmpdir>/_build
    %   destinationDirectory - Directory where the final wheel file will be copied to
    
    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        options.outputDirectory string {mustBeTextScalar, mustBeNonzeroLengthText} = fullfile(tempname, "_build")
        options.destinationDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    
    if ispc || ismac
        fprintf(2, "\nWarning:\n");
        fprintf(2, "  While this function can run on Windows or macOS for basic testing, the resulting .whl\n");
        fprintf(2, "  file cannot be used on Databricks as it is platform specific. It must be produced\n");
        fprintf(2, "  on a Linux system, as Databricks nodes are always Linux based.\n\n");
    end

    % Preload the model, to avoid issues with GLIBC on certain platforms.
    load_system("sldemo_suspn_3dof_with_input");

    
    fprintf("Output directory: %s\n", options.outputDirectory);
    if isfield(options, "destinationDirectory")
        fprintf("Destination directory: %s\n", options.destinationDirectory);
    end
    
    here = fileparts(mfilename('fullpath'));
    if ~isfile(fullfile(here, 'runModel_spark_with_input.schema'))
        % Use a sample RoadN table and a vehicle mass of 1400kg
        Road1 = parquetread(fullfile(pwd, "data", "Road1.parquet"));
        % Generates the Schema for this function.
        % It is already in this folder, so it is skipped here.
        newSchemaFile = generateFunctionSchema("runModel_spark_with_input", {Road1, 1400}); %#ok<NASGU>
    end

    buildOpts = compiler.build.PythonPackageOptions(...
        'runModel_spark_with_input.m', ...
        'OutputDir', '_build', ...
        'PackageName', 'demo.suspn3dof_with_input');

    PSB = compiler.build.spark.pythonPackage(buildOpts);

    if isfield(options, "destinationDirectory")
        PSB.installWheelOnDatabricksCluster(options.destinationDirectory);
    end
end
