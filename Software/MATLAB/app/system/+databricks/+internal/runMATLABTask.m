function jobRun = runMATLABTask(options)
    % RUNMATLABTASK Runs a MATLAB batch or runtime task automatically
    % Returns a databricks.Run job run. An empty run indicates an error.
    % If auto and "... -batch <statement>" the they be these final arguments in an auto value.
    %
    % Examples:
    %   jr = databricks.internal.runMATLABTask(command="myCompiledBinary", arguments="3.14");
    %
    %   jr = databricks.internal.runMATLABTask(cluster="1031-081221-u31ejni1",...
    %                                          statement="disp('Hello World'); exit(0)",...
    %                                          licenseManager="27000@10.0.0.4");
    %
    %   jr = databricks.internal.runMATLABTask(auto="myCompiledBinary 3.14");
    %
    %   jr = databricks.internal.runMATLABTask(cluster="1031-081221-u31ejni1", auto="disp('Hello World'); exit(0)", licenseManager="27000@10.0.0.4");
    %
    %   jr = databricks.internal.runMATLABTask(cluster="1031-081221-u31ejni1", auto='matlab -c 27000@10.0.0.4 -batch "disp('Hello World'); exit(0)"');
    %
    %
    % Common named arguments:
    % =======================
    %               auto: The function tries to determine if a batch or runtime task is to be called
    %            cluster: Databricks cluster Id or databricks.Cluster object
    %     dockerAuthFile: Docker authentication details file see createDatabricksCluster
    %       preExecPyCmd: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
    %      postExecPyCmd: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
    %       preExecShCmd: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
    %      postExecShCmd: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
    %     baseParameters: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
    %  overwriteNotebook: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
    %         authMethod: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
    %        profileName: See databricks.MATLABRuntimeTask & databricks.MATLABBatchTask
    %
    % Runtime task specific named arguments:
    % ======================================
    %           command: See databricks.MATLABRuntimeTask
    %         arguments: See databricks.MATLABRuntimeTask
    %           mcrRoot: See databricks.MATLABRuntimeTask
    %     ldLibraryPath: See databricks.MATLABRuntimeTask
    %
    % Batch task specific named arguments:
    % ====================================
    %        statement: See databricks.MATLABBatchTask
    %   licenseManager: See databricks.MATLABBatchTask
    %     licenseToken: See databricks.MATLABBatchTask
    %      accountName: See databricks.MATLABBatchTask
    %    MATLABCommand: See databricks.MATLABBatchTask
    %   licenseTokenSecretKey: See databricks.MATLABBatchTask
    % licenseTokenSecretScope: See databricks.MATLABBatchTask

    % Copyright 2025-2026, The MathWorks, Inc.

    arguments
        options.cluster {databricks.internal.cluster.mustBeScalarClusterOrId}
        options.auto string {mustBeTextScalar, mustBeNonzeroLengthText}

        % Runtime options
        options.command string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.arguments string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.mcrRoot (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.ldLibraryPath (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}

        % Batch options
        options.statement string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.licenseManager (1,1) string
        options.licenseToken (1,1) string {mustBeNonzeroLengthText}
        options.licenseTokenSecretKey (1,1) string {mustBeNonzeroLengthText}
        options.licenseTokenSecretScope (1,1) string {mustBeNonzeroLengthText}
        options.accountName (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.MATLABCommand (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}

        options.preExecPyCmd string {mustBeNonzeroLengthText}
        options.postExecPyCmd string { mustBeNonzeroLengthText}
        options.preExecShCmd string {mustBeNonzeroLengthText}
        options.postExecShCmd string {mustBeNonzeroLengthText}
        options.baseParameters struct

        % Common options
        options.overwriteNotebook (1,1) logical = true

        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName

        options.dockerAuthFile string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    jobRun = databricks.Run;
    errBase = "DATABRICKS:RUNMATLABTASK"; %#ok<NASGU>

    if isfield(options, "auto")
        autoValues = parseAuto(options.auto);
        assert(isfield(autoValues, "mode"), "Mode not determined from auto argument.");
        if autoValues.mode == "batch"
            assert(isfield(autoValues, "statement"), "Batch statement not found in parsed arguments.");
            assert(isfield(autoValues, "MATLABCommand"), "Batch MATLABCommand not found in parsed arguments.");
        else
            assert(isfield(autoValues, "command"), "Runtime command not found in parsed arguments.");
            assert(isfield(autoValues, "arguments"), "Runtime Arguments not found in parsed arguments.");
        end
        mode = autoValues.mode;

        if mode == "batch"
            if isfield(autoValues, "MATLABCommand")
                if ~isempty(autoValues.MATLABCommand)
                    % No MATLABCommand is acceptable a default of
                    % "matlab -batch" will be used
                    options.MATLABCommand = autoValues.MATLABCommand;
                end
            end
            if isfield(autoValues, "statement")
                if isempty(autoValues.statement)
                    fprintf(2, "Statement not found.\n");
                    return;
                else
                    options.statement = autoValues.statement;
                end
            end
        elseif mode == "runtime"
            if isfield(autoValues, "command") && ~isempty(autoValues.command)
                options.command = autoValues.command;
            end
            if isfield(autoValues, "arguments") && ~isempty(autoValues.arguments)
                options.arguments = autoValues.arguments;
            end
        else
            fprintf(2, "Unexpected mode, expected batch or runtime, found: %s\n", mode);
            return;
        end
    end

    assert(~(isfield(options, "command") && isfield(options, "statement")),...
        "Only one of the command or statement arguments may be used at one time.");
    assert(~(~isfield(options, "command") && ~isfield(options, "statement")),...
        "One of the command or statement arguments must be set.");

    if isfield(options, "command")
        mode = "runtime";
    else
        mode = "batch";
    end

    %clusterArg = [];
    if isfield(options, "cluster")
        if isfield(options, "dockerAuthFile")
            fprintf("The dockerAuthFile argument is not used when a cluster argument is provided.\n");
        end
        clusterArg = options.cluster;
    else
        if isfield(options, "dockerAuthFile")
            if mode == "batch"
                clusterName = "MATLAB Batch Cluster " + string(datetime('now', 'Format', 'uuuuMMdd_HHmmss'));
            else
                clusterName = "MATLAB Runtime Cluster " + string(datetime('now', 'Format', 'uuuuMMdd_HHmmss'));
            end
            fprintf("Creating cluster: %s\n", clusterName);
            clusterArg = createDatabricksCluster(clusterName, 0, dockerAuthFile=options.dockerAuthFile, create=false);
        else
            args = matlab.utils.addArgs(options, "profileName");
            clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", args{:});
            if isempty(clusterId) || strlength(clusterId) == 0
                fprintf(2, "A dockerAuthFile/cluster/clusterId argument must be provided or a cluster_id configuration file field must be set e.g. using updateClusterId('<clusterId string>').\n");
                return;
            else
                clusterArg = clusterId;
            end
        end
    end
    if isempty(clusterArg)
        fprintf(2, "Could not find a cluster to run the task.\n");
        return;
    end

    if mode ~= "batch"
        if isfield(options, "licenseManager")
            fprintf("The licenseManager argument is not used with MATLAB runtime based tasks.\n");
        end
        if isfield(options, "accountName")
            fprintf("The accountName argument is not used with MATLAB runtime based tasks.\n");
        end
    end

    if mode ~= "runtime"
        if isfield(options, "mcrRoot")
            fprintf("The mcrRoot argument is not used with MATLAB batch tasks.\n");
        end
        if isfield(options, "ldLibraryPath")
            fprintf("The ldLibraryPath argument is not used with MATLAB batch tasks.\n");
        end
        if isfield(options, "arguments")
            fprintf("The arguments argument is not used with MATLAB batch tasks.\n");
        end
    end

    if mode == "batch" && ~isfield(options, "MATLABCommand")
        options.MATLABCommand = "matlab -batch";
    end
    if mode == "batch" && ~isfield(options, "accountName")
        options.accountName = matlab.utils.getAccountName;
    end

    if mode == "batch"
        args = matlab.utils.addArgs(options, ["licenseManager", "accountName", "MATLABCommand", "preExecShCmd", "preExecPyCmd", "postExecShCmd", "postExecPyCmd", "overwriteNotebook", "notebookPath", "baseParameters", "authMethod", "profileName"]);
        t = databricks.MATLABBatchTask(options.statement, args{:});
    else
        args = matlab.utils.addArgs(options, ["arguments", "mcrRoot", "ldLibraryPath", "preExecShCmd", "preExecPyCmd", "postExecShCmd", "postExecPyCmd", "overwriteNotebook", "notebookPath", "baseParameters", "authMethod", "profileName"]);
        t = databricks.MATLABRuntimeTask(options.command, args{:});
    end

    jb = databricks.Job;
    if mode == "batch"
        jb.name = "MATLAB batch job " + string(datetime('now', 'Format', 'uuuuMMdd_HHmmss'));
    else
        jb.name = "MATLAB runtime job " + string(datetime('now', 'Format', 'uuuuMMdd_HHmmss'));
    end

    % Assign the cluster to the job
    jb.setCluster(clusterArg);

    jb.setTask(t);
    jb.create();
    jobRun = jb.runNow();
end


function out = parseAuto(in)
    % PARSEAUTO Attempt to parse out batch and runtime arguments
    % Returns a struct with a mode field set to "batch" or "runtime".
    % If set to batch a MATLABCommand and statement field are added.
    % If set to runtime a command and arguments field are added.
    arguments (Input)
        in string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        out struct
    end

    errBase = "BASETASK:PARSEAUTO";

    out = struct;
    out.mode = getMode(in);
    if out.mode == "batch"
        [out.MATLABCommand, out.statement] = parseAutoForBatchMode(in);
    elseif out.mode == "runtime"
        [out.command, out.arguments] = parseAutoForRuntimeMode(in);
    else
        error(errBase+":UNEXPECTED", "Unexpected mode: %s", out.mode);
    end
end


function [command, args] = parseAutoForRuntimeMode(in)
    % parseAutoForRuntimeMode Attempt to parse a command & arguments from input argument
    % Returns a command string and an args string, either or both may be empty.
    arguments (Input)
        in string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        command string
        args string
    end

    command = string.empty;
    args = string.empty;

    errBase = "BASETASK:PARSERUNTIMEMODE";
    inFields = split(strtrim(in), " ");

    indicesToKeep = strlength(inFields) > 0;
    inFields = inFields(indicesToKeep);

    if numel(inFields) == 0
        error(errBase+"NOFIELDS", "No runtime mode fields found in: %s", in);
    elseif numel(inFields) == 1 %#ok<ISCL>
        command = inFields(1);
    elseif numel(inFields) > 1
        command = inFields(1);
        args = join(inFields(2:end), " ");
    end
end


function mode = getMode(in)
    % GETMODE Best guess if a command string is a batch or runtime task
    % Returns "batch" or "runtime" 
    arguments (Input)
        in string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        mode string 
    end

    if in.contains("matlab" + whitespacePattern + "-batch")
        mode = "batch";
        return;
    end

    if in.startsWith("matlab" + whitespacePattern)
        mode = "batch";
        return;
    end

    if in.contains("matlab-batch" + whitespacePattern)
        mode = "batch";
        return;
    end

    if in.contains(whitespacePattern + "-nodesktop" + whitespacePattern)
        error("runMATLABTask:NoNoDesktop",...)
            "-nodesktop is not supported on Linux, use matlab -batch or omit the command for default behavior.");
    end

    if in.contains(whitespacePattern + "-r" + whitespacePattern)
        error("runMATLABTask:NoNoDesktop",...)
            "-r is not supported for non interactive use cases, use matlab -batch or omit the command for default behavior.");
    end

    if in.contains(whitespacePattern + "-batch" + whitespacePattern)
        mode = "batch";
        return;
    end

    if in.contains(whitespacePattern + "-c" + whitespacePattern)
        mode = "batch";
        return;
    end

    if startsWith(strtrim(in), "/opt/matlab/")
        mode = "batch";
        return;
    end

    if startsWith(strtrim(in), "/Volumes")
        mode = "runtime";
        return;
    end

    if startsWith(strtrim(in), "/Workspace")
        mode = "runtime";
        return;
    end

    if startsWith(strtrim(in), "/")
        mode = "runtime";
        return;
    end

    fprintf(2, "In this case the choice of batch or runtime mode is ambiguous, consider using the statement or command arguments in place of auto.\n");

    inFields = split(strtrim(in), " ");
    if inFields(1).contains('"') || inFields(1).contains("'") || inFields(1).contains('=')...
            || inFields(1).contains('{') || inFields(1).contains('(') || inFields(1).contains('[')...
            || inFields(1).contains('*') || inFields(1).contains('^') || inFields(1).contains('>')...
            || inFields(1).contains('~') || inFields(1).contains(',') || inFields(1).contains('<')...
            || inFields(1).contains(';') || inFields(1).contains(':')
        mode = "batch";
        return;
    end

    if inFields(1).endsWith('.exe')
        mode = "runtime";
        return;
    end

    if in.contains("exit(0)") || in.contains("disp") || in.contains("printf") || in.contains("eval")
        mode = "batch";
        return;
    end

    mode = "runtime";
end


function [MATLABCommand, statement] = parseAutoForBatchMode(in)
    % parseAutoForBatchMode Extract the MATLABCommand and statement from the auto argument
    arguments (Input)
        in string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        MATLABCommand string
        statement string
    end

    % Remove stray whitespace
    in = strtrim(in);
    % Look to the end to see if the string is terminated with a quite
    if endsWith(in, "'") || endsWith(in, '"')
        quotedStatement = true;
    else
        quotedStatement = false;
    end

    % If terminated with a quote find the opening quote assuming that the
    % MATLAB Command section has no quotes
    if quotedStatement
        % Check if the detected opening and closing quote is the same
        % character i.e there is only one quote
        if endsWith(in, "'")
            startQuoteIdex = regexp(in, "'", 'once');
            if startQuoteIdex == strlength(in)
                error("Cannot parse auto argument, unmatched single quote at end of argument.");
            end
        else
            startQuoteIdex = regexp(in, '"', 'once');
            if startQuoteIdex == strlength(in)
                error("Cannot parse auto argument, unmatched single quote at end of argument.");
            end
        end
        %statement = stripRepeatedPairedQuotes(extractBetween(in, startQuoteIdex, strlength(in)));
        
        % If quoted the MATLAB Command is the part before the open quote
        % and the statement follows, strip white space from both and the
        % quotes from the statement
        MATLABCommand = strtrim(extractBefore(in, startQuoteIdex));
        % If there is effectively no command signal this with the empty so
        % a default command is used as in the non quoted case
        if strlength(MATLABCommand) == 0 
            MATLABCommand = string.empty;
        end
        statement = strtrim(stripPairedQuotes(extractBetween(in, startQuoteIdex, strlength(in))));
    else
        % If not quoted there is no MATLAB command and it is just the
        % statement, strip white space.
        MATLABCommand = string.empty;
        statement = strtrim(in);
    end
end


function out = stripPairedQuotes(in)
    arguments (Input)
        in string {mustBeTextScalar, mustBeNonzeroLengthText}
    end
    arguments (Output)
        out string
    end

    if startsWith(in, "'") && endsWith(in, "'")
        out = string(strip(in, "both", "'"));
    elseif startsWith(in, '"') && endsWith(in, '"')
        out = string(strip(in, "both", '"'));
    else
        out = in;
    end
end