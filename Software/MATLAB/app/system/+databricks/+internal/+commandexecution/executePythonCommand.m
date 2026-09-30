function [result, contextId, commandId] = executePythonCommand(pythonCommand, options)
    % executePythonCommand Execute a Python command via the command execution REST API
    % If a previously created contextId is provided a new one is not created
    %
    % Required argument:
    %   pythonCommand: Python code to execute is single line form
    %                  Type: scalar string
    %
    % Optional named arguments:
    %             env: containers.Map that holds environment variable key-value pairs
    %                  that will be set as a prefix to the pythonCommand code.
    %                  Keys and values should be of type scalar text.
    %
    %         timeout: The default timeout is 30 seconds. This timeout applies
    %                  to command execution only
    %                  Type: int32
    %                  Default: 30
    %
    %  startupTimeout: The default value is 8 minutes and is intended to allow for the
    %                  startup period of a cluster
    %                  Type: int32
    %                  Default: 4800 (8 minutes)
    %
    %  contextTimeout: The default contextTimeout is 30 seconds. This timeout applies
    %                  to context creation phase while the context transitions from pending
    %                  to running.
    %                  Type: int32
    %                  Default: 30
    %
    %       clusterId: ID of cluster to use, if not set the ID will be taken
    %                  from .databrickscfg configuration file
    %                  Type: scalar string
    %
    %       contextId: ID of a previously created context to be reused.
    %                  Type: scalar string
    %
    %   retainContext: Indicate if the context should be destroyed after this call or
    %                  retained and the ID returned for use in future calls
    %                  Type: scalar logical
    %                  Default: false
    %
    %      authMethod: A matlab.databricks.AuthMethod.
    %
    %     profileName: A configuration file profileName value.
    %
    %         verbose: More feedback is provided if set to true.
    %                  Default: true
    %
    %        blocking: The call will block and wait for completion of the command or not.
    %                  In the non blocking case the context is not automatically deleted
    %                  if retainContext is false. The timeout value is not applied to
    %                  execution.
    %                  Default: true
    %
    % Examples:
    %   % Simply print 'Hello world'
    %   result = databricks.internal.commandexecution.executePythonCommand("print('Hello world')")
    %     result = "Hello world"
    %
    %   % Run a sample system command that should return 0 not the value is
    %   % returned a string "0"
    %   result = databricks.internal.commandexecution.executePythonCommand("import os; result = os.system('who'); print(result)")
    %     result = "0"
    %
    %   % subprocess can provide more option and control of output and errors
    %   pyStr = sprintf('import subprocess; subprocess.run(["md5sum", "%s"], capture_output=True)', myfile);
    %   [md5sumRaw, contextId, commandId] = databricks.internal.commandexecution.executePythonCommand(pyStr, int32(5*60));

    %  Copyright 2023-2025 MathWorks, Inc.

    arguments
        pythonCommand string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.env containers.Map
        options.timeout int32 {mustBeScalarOrEmpty, mustBeNonempty, mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 30
        options.startupTimeout int32 {mustBeScalarOrEmpty, mustBeNonempty, mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 8*60
        options.contextTimeout int32 {mustBeScalarOrEmpty, mustBeNonempty, mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 30
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.contextId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.retainContext (1,1) logical = false
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
        options.blocking (1,1) logical = true
    end

    language = databricks.datastructures.commandexecution.Language.python;

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    commandExecution = databricks.CommandExecution(args{:});

    if isfield(options, 'clusterId')
        clusterId = options.clusterId;
    else
        args = matlab.utils.addArgs(options, ["verbose", "profileName"]);
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", args{:});
    end

    if ~strlength(clusterId) > 0
        error("databricks:executePythonCommand", "Cluster ID value is not defined, it must be provided either as an argument or via credentials as an environment variable or the databricks-settings.json file.");
    end

    args = {"cluster", clusterId, "timeout", options.startupTimeout};
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose"], args);
    databricks.internal.cluster.waitForClusterToStart(args{:});

    if isfield(options, 'contextId')
        % Use existing context
        contextId = options.contextId;
    else
        % Create context
        createRequest = databricks.datastructures.commandexecution.CreateRequest;
        createRequest.clusterId = clusterId;
        createRequest.language = language;
        createResponse = commandExecution.create(createRequest);
        if isa(createResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
            error("databricks:executePythonCommand", "Context creation failed:\n  %s", createResponse.error);
        else
            contextId = createResponse.id;
        end
    end

    % If the cluster/context is in a pending state wait for it to transition to running
    % Allow 8 minutes in case starting with a MATLAB runtime (default)
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    if ~databricks.internal.commandexecution.waitForContextRunning(clusterId, contextId, options.contextTimeout, args{:})
        destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
        destroyRequest.clusterId = clusterId;
        destroyRequest.contextId = contextId;
        destroyResponse = commandExecution.destroy(destroyRequest);
        if isa(destroyResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
            error("databricks:executePythonCommand", "Execution context did not transition from a pending to a running state as expected and request destruction failed:\n  %s", destroyResponse.error);
        else
            error("databricks:executePythonCommand", "Execution context did not transition from a pending to a running state as expected.");
        end
    end

    % Inject environment variables
    if isfield(options, "env") && options.env.Count > 0
        k = options.env.keys();
        envCode = "import os; ";
        for n = 1:numel(k)
            envCode = envCode + sprintf("os.environ['%s']='%s'; ", k{n}, options.env(k{n}));
        end
        pythonCommand = envCode + pythonCommand;
    end

    % Execute the command
    executeRequest = databricks.datastructures.commandexecution.ExecuteRequest;
    executeRequest.clusterId = clusterId;
    executeRequest.contextId = contextId;
    executeRequest.command = pythonCommand;
    executeRequest.language = language;
    executeResponse = commandExecution.execute(executeRequest);
    if isa(executeResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
        error("databricks:executePythonCommand", "Execute failed:\n  %s", executeResponse.error);
    else
        commandId = executeResponse.id;
    end

    % Once running wait for the command to complete
    if options.blocking 
        args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
        [cmdTf, result] = databricks.internal.commandexecution.waitForCommandFinished(clusterId, contextId, commandId, options.timeout, args{:});
        
        if ~cmdTf
            % Command didn't finish cancel the request
            fprintf("Execute did not finish: %s, cancelling request.\n", commandId);
            cancelRequest = databricks.datastructures.commandexecution.CancelRequest;
            cancelRequest.clusterId = clusterId;
            cancelRequest.contextId = contextId;
            cancelRequest.commandId = commandId;
            cancelResponse = commandExecution.cancel(cancelRequest);
            if isa(cancelResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
                error("databricks:executePythonCommand", "Cancel failed:\n  %s", cancelResponse.error);
            end
        end

        if ~options.retainContext
            destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
            destroyRequest.clusterId = clusterId;
            destroyRequest.contextId = contextId;
            destroyResponse = commandExecution.destroy(destroyRequest);
            if isa(destroyResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
                error("databricks:executePythonCommand", "Request destruction failed:\n  %s", destroyResponse.error);
            end
        end
    else
        % There is no meaningful result to return so indicate that it is a nonblocking call
        result = "returncode=NonblockingCall";
    end
end