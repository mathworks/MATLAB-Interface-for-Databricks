function build(obj, options)
    % build Start the build of a PythonSparkBuilder object to produce a .whl file
    %
    % This method takes a number of optional arguments. In almost all cases
    % the default values should be used.
    %
    % Optional arguments:
    %        clean: Remove previous build (default: true)
    %
    %   genHelpers: Generate the partition helpers (default: true)
    %
    %  genWrappers: Generate the wrapper file (default: true)
    %
    %  createWheel: Create the wheel file (default: true)
    %
    %   wheelCheck: Verify the wheel doesn't contain any non-Linux files
    %               (default: true if working with Databricks, false: otherwise)

    % Copyright 2022-2026 The MathWorks, Inc.

    arguments
        obj (1,1) compiler.build.spark.PythonSparkBuilder
        options.clean (1,1) logical = true
        options.genHelpers (1,1) logical = true
        options.genWrappers (1,1) logical = true
        options.createWheel (1,1) logical = true
        options.generateExamples (1,1) logical = true
        options.wheelCheck (1,1) logical
    end

    if obj.Debug
        fprintf("### Building with Debug turned on\n");
    end

    if ~isfield(options, 'wheelCheck')
        options.wheelCheck = isDatabricksEnvironment;
    end

    if isVolumesOutputDir(obj)
        error("COMPILER:BUILD:SPARK:VOLUMESOUTPUTDIRECTORY", ...
            "Build output directory cannot be a /Volumes path.\n" + ...
            "Specify a different output directory when creating the build options.");
    end

    if options.clean
        obj.clean();
    end

    obj.determineMethodTypes();
    
    if options.genHelpers
        obj.genPartitionHelpers();
    end

    buildOpts = addHelperFilesToBuild(obj);

    addpath(obj.GenMatlabDir);
    removePathAfter = onCleanup(@() rmpath(obj.GenMatlabDir));

    % Reconsider warning state if g3316366 resolved.
    warnState = warning('off', 'Compiler:compiler:COM_WARN_USING_PERSONAL_JAVA_SETTING');
    resetWarnings = onCleanup(@() warning(warnState));
    obj.BuildResults = compiler.build.pythonPackage(buildOpts);
    
    % Overwrite the original setup.py file, to comply with things like bdist_wheel
    obj.genPythonSetup();

    if options.genWrappers
        % Generate a wrapper file, that creates Spark friendly interfaces
        obj.generateWrapper();
    end

    obj.generateMATLABUDFHelpers();
    
    if isDatabricksEnvironment
        obj.createZipArtifact();
    end

    % Now package all the functions in a wheel
    if options.createWheel
        obj.createWheel();
        if options.wheelCheck
            fprintf("Scanning for incompatible binaries.\n");
            whlScanResult = matlab.utils.internal.wheelscan.wheelScan(obj.getWheelFile(), execArch="GLNXA64", verbose=obj.Debug);
            if ~whlScanResult
                warning("MATLABSPARKAPI:wheelscan_output", ...
                    "The wheel scan indicated there are files in this archive that are not suitable for running on Linux.\n" + ...
                    "Running this archive may fail at runtime. See output above for details.");
            end
        end
    end

    % Generate example files
    if options.generateExamples
        obj.generateExamples();
    end

    if obj.Debug
        fprintf("%s\n", join(repmat("# Build finished #", 1, 8)));
    end
end


function tf = isVolumesOutputDir(obj)
    % isVolumesOutputDir Check if output directory is a Databricks Volumes path
    % If not running on Databricks false is returned, it should be not be /Volumes
    % in the Databricks sense.
    % Otherwise, if the output directory begins with /Volumes/ or /volumes/ returns
    % true. If the path is relative i.e. begins with a "." then the working
    % directory is check to see if it is under /Volumes/ or /volumes/. If so true
    % is returned otherwise false

    arguments (Input)
        obj (1,1) compiler.build.spark.PythonSparkBuilder
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = false;

    if isDatabricksEnvironment && databricks.internal.isOnDatabricks()
        % If the output directory is set use it otherwise assume the pwd
        if isprop(obj, 'OutputDir') && strlength(obj.OutputDir) > 0
            outputDir = string(obj.OutputDir);
        else
            outputDir = string(pwd);
        end

        % Check both cases as Databricks mounts variants
        if startsWith(outputDir, "/Volumes/") || startsWith(outputDir, "/volumes/")
            tf = true;
        else
            % If a relative path is set check the pwd it will normalized with
            if startsWith(outputDir, ".")
                if startsWith(string(pwd), "/Volumes/") || startsWith(string(pwd), "/volumes/")
                    tf = true;
                end
            end
        end
    end
end