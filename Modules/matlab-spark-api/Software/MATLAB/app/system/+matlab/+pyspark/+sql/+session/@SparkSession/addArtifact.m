function addArtifact(obj, artifact, options)
    % addArtifact  Add an artifact to a Spark session
    %
    % Only works with Spark Connect
    %
    % Please refer to corresponding pyspark documentation

    % (c) 2024-2026 MathWorks, Inc.

    arguments
        obj (1,1) matlab.pyspark.sql.session.SparkSession
        artifact (1,1) string
        options.pyfile logical
        options.archive logical
        options.file logical
    end

    if pyenv().ExecutionMode == "OutOfProcess"
        error("SPARK:ARTIFACT_MUST_RUN_PYTHON_INPROCESS", ...
            "The addArtifact feature can only be used with pyenv being run 'InProcess'. " + ...
            "This pyenv is running 'OutOfProcess'.")
    end

    if ~isfile(artifact)
        error('SPARK:ADD_ARTIFACT_FILE_MISSING', ...
            "Could not find artifact file: %s", artifact);
    end
    
    if ispc
        % Escape Windows path backslashes if necessary
        % C:\My\artifact.zip
        %   => 
        % /My/artifact.zip
        artifact = artifact.extractAfter(":").replace("\", "/");
    end
    pyCmd = sprintf("res = spark.addArtifact('%s'", artifact);
    fn = string(fieldnames(options));
    for k=1:numel(fn)
        key = fn(k);
        val = options.(key);
        pyCmd = pyCmd + sprintf(", %s=%s", key, pythonLogical(val));
    end
    pyCmd = pyCmd + ")";

    ignoreNone = pyrun(pyCmd, "res", spark=obj.sparkSession); %#ok<NASGU>
    % ignoreNone is just a Python None here.
    
end

function tf = pythonLogical(val)
    arguments
        val (1,1) logical
    end

    if val
        tf = "True";
    else
        tf = "False";
    end
end
