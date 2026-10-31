function [returnCode, response, contextId, commandId] = executePythonSubprocess(pyArgs, options)
    % executePythonSubprocess Uses a Python subprocess.run command to execute system calls
    % Required arguments are provided as a string array of arguments or a scalar string.
    %
    % Providing a sequence of arguments is preferred, so the module takes care
    % of escaping and quoting of arguments, e.g. spaces in file names.
    % If passing a single string, either options.shell should be true
    % or the string should name a command to execute without arguments.
    %
    % Optional named arguments:
    %           env: containers.Map that holds environment variable key-value pairs
    %                that will be set as the subprocess.run env argument.
    %                Keys and values should be of type scalar text.
    %                The values will be set in the environment before the code
    %                is executed. In the context of an existing environment, these
    %                entries will add to or overwrite existing values.
    %                See also inheritEnv option.
    %
    %    inheritEnv: logical value (default: true), that decides if the process
    %                should inherit from the existing environment, or build an
    %                environment from scratch. It has an effect when the env option
    %                is used, but even without env, this option set to false will
    %                create an empty environment with which the process is run.
    %
    %         shell: Enable the subprocess shell feature
    %                Type: Logical
    %                Default: false
    %
    %       timeout: This timeout applies to both context creation and command execution
    %                Type: int32
    %                Default: 30
    %
    %     clusterId: ID of cluster to use, if not set the ID will be taken
    %                from .databrickscfg configuration file
    %                Type: scalar string
    %
    %     contextId: ID of a previously created context to be reused
    %                Type: scalar string
    %
    % retainContext: Indicate if the context should be destroyed after this call or
    %                retained and the ID returned for use in future calls
    %                Type: scalar logical
    %                Default: false
    %
    %    authMethod: A matlab.databricks.AuthMethod
    %
    %   profileName: A configuration file profileName value
    %
    %       verbose: More feedback is provided if set to true.
    %                Default: true
    %
    %      blocking: The call will block and wait for completion of the command or not.
    %                In the non blocking case the context is not automatically deleted
    %                if retainContext is false. The timeout value is not applied to
    %                execution.
    %                Default: true
    %
    %        userId: Run the process with this user id
    %
    %       groupId: Run the process with this group id
    %
    % The default output is the command's return code.
    %
    % A response structure is be returned containing:
    %   The stdout if present and otherwise an empty string.
    %   The stderr if present and otherwise an empty string.
    %   The subprocess command string passed to Python.
    %
    % A contextId value is returned as a string. This corresponds to the context ID
    % used to execute the command. It the retainContext argument was set to true
    % this value should be used to manually destroy the execution context when
    % it is no longer needed:
    %   destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
    %   destroyRequest.clusterId = clusterId;
    %   destroyRequest.contextId = contextId;
    %   destroyResponse = commandExecution.destroy(destroyRequest);
    % or in the last call to this function in a sequence omit the retainContext
    % argument and it will be destroyed.
    %
    % Examples:
    %   % print Hello world
    %   [result, response] = databricks.internal.commandexecution.executePythonSubprocess(["echo", "Hello world"])
    %   result =
    %       "0"
    %   response =
    %     struct with fields:
    %        pyCmd: "import subprocess; subprocess.run(["echo", "Hello world"], capture_output=True)"
    %       stdout: "Hello world\n"
    %       stderr: ""
    %
    %   % ls /
    %   [result, response] = databricks.internal.commandexecution.executePythonSubprocess("ls /")
    %   result =
    %       "0"
    %   response =
    %     struct with fields:
    %        pyCmd: "import subprocess; subprocess.run(["ls", "/"], capture_output=True)"
    %       stdout: "BUILD\nVolumes\nWorkspace\nbin\nboot\ndatabricks\ndatabricks-datasets\ndbfs\ndev\netc\nhome\nlib\nlib32\nlib64\nlibx32\nlocal_disk0\nmedia\nmnt\nopt\nproc\nroot\nrun\nsbin\nsrv\nsys\ntmp\nusr\nvar\n"
    %       stderr: ""
    %
    %   % Use the shell option with a single string, in this case to use globbing
    %   [result, response] = databricks.internal.commandexecution.executePythonSubprocess("ls /t*", shell=true)
    %   result =
    %       "0"
    %   response =
    %     struct with fields:
    %        pyCmd: "import subprocess; subprocess.run(["ls /t*"], capture_output=True, shell=True)"
    %       stdout: "Rserv\nRtmpEfhqqD\nchauffeur-daemon-params\nchauffeur-daemon.pid\nchauffeur-env.sh\ncustom-spark.conf\ndriver-daemon-params\ndriver-daemon.pid\ndriver-env.sh\nhsperfdata_root\nmaster-params\npython_lsp_logs\nspark-root-org.apache.spark.deploy.master.Master-1.pid\nsystemd-private-441422b1e4f24ed2bcda38b84e2463be-systemd-logind.service-jX39JY\nsystemd-private-441422b1e4f24ed2bcda38b84e2463be-systemd-resolved.service-CIpqKq\ntmp.uyInzKBDSN\n"
    %       stderr: ""
    %
    %   % Create a directory with spaces in the name
    %   [result, response] = databricks.internal.commandexecution.executePythonSubprocess(["mkdir", "/tmp/my space dir"])
    %   result =
    %       "0"
    %   response =
    %     struct with fields:
    %        pyCmd: "import subprocess; subprocess.run(["mkdir", "/tmp/my space dir"], capture_output=True)"
    %       stdout: ""
    %       stderr: ""

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        pyArgs string {mustBeNonzeroLengthText}
        options.env containers.Map
        options.inheritEnv (1,1) logical = true
        options.shell (1,1) logical = false
        options.timeout (1,1) int32 {mustBeFinite, mustBeReal, mustBePositive} = 60
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.contextId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.retainContext (1,1) logical = false
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
        options.blocking (1,1) logical = true
        options.userId (1,1) string  {mustBeTextScalar, mustBeNonzeroLengthText}
        options.groupId (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    pyArgs = "'" + join(pyArgs, "', '") + "'";

    pyCmd = "import subprocess; import os; ";

    envArgCmd = "";
    if isfield(options, "env")
        if options.inheritEnv
            pyCmd = pyCmd + "env=os.environ; ";
        else
            pyCmd = pyCmd + "env={}; ";
        end
        k = options.env.keys();
        for n = 1:numel(k)
            pyCmd = pyCmd + sprintf("env['%s']='%s'; ", k{n}, strrep(options.env(k{n}), '''', '\'''));
        end
        envArgCmd = ", env=env";
    else
        if ~options.inheritEnv
            pyCmd = pyCmd + "env={}; ";
            envArgCmd = ", env=env";
        end
    end

    pyCmd = pyCmd + "subprocess.run([" + pyArgs + "], capture_output=True" + envArgCmd;

    % If the shell option is true modify the python cmd string itself
    if options.shell
        pyCmd = pyCmd + ", shell=True";
    end
    if isfield(options, 'userId')
        pyCmd = pyCmd + ", user=" + options.userId;
    end
    if isfield(options, 'groupId')
        pyCmd = pyCmd + ", group=" + options.groupId;
    end

    pyCmd = pyCmd + ")";

    % Handle the other arguments
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "verbose", "timeout", "retainContext", "clusterId", "contextId", "blocking"]);
    [result, contextId, commandId] = databricks.internal.commandexecution.executePythonCommand(pyCmd, args{:});

    if ~any(contains(result, "returncode="))
        if isempty(result)
            fprintf("Python command: %s\n", pyCmd);
            error("No result returned.");
        else
            fprintf("Python command: %s\n", pyCmd);
            error("returncode value not found in: %s", result);
        end
    else
        pat = "returncode=" + alphanumericsPattern;
        returnCode = extract(result, pat);
        returnCode = split(returnCode, "=");
        returnCode = returnCode(end);
    end

    if nargout > 1
        response = struct;
        response.pyCmd = pyCmd;

        if any(contains(result, "stdout=b"))
            response.stdout = extractBetween(result, "stdout=b'", "', stderr");
        else
            response.stdout = string.empty;
        end

        if any(contains(result, "stderr=b"))
            response.stderr = extractBetween(result, "stderr=b'", "')");
        else
            response.stderr = string.empty;
        end
    end
end