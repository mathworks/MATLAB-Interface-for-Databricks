classdef DesktopClusterConfigurator < handle & matlab.mixin.CustomDisplay
    % DESKTOPCLUSTERCONFIGURATOR Configures an existing Databricks Cluster Desktop MATLAB
    %
    % Typically called from: Software\Docker\MATLABDesktop\createMATLABDesktopCluster.m
    % Demonstrates the post creation steps necessary to configure a Databricks Cluster
    % for MATLAB Desktop usage.

    % Copyright 2025-2026 MathWorks, Inc

    properties
        Cluster databricks.Cluster
        State (1,1) string = "<UNSET>"
        URL (1,1) string
        DatabricksPackageVersion string
    end
    
    properties (Hidden, SetAccess=private)
        Timer
        LastUpdate
        PreExecScript  string
        PostExecScript string
        MWIStartupScript string
        AuthMethod matlab.databricks.AuthMethod
        ProfileName string
        AccountName string
        ProxyTimeout (1,1) int32
        CopyPreferences logical
        PreferenceDir string
        UseStartupShutdown (1,1) logical
        StartupShutdownConfig (1,1) string
        ExecContext string
        err
    end

    methods
        function obj = DesktopClusterConfigurator(cluster, url, options)
            arguments
                cluster (1,1) databricks.Cluster
                url (1,1) string

                % If not set don't install the interface package
                options.dbxPkgVersion (1,1) string

                % Hooks for end user actions before or after installation of the
                % MATLAB Interface for Databricks if enabled
                options.preExecScript string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.postExecScript string {mustBeTextScalar, mustBeNonzeroLengthText}

                % If not installing MATLAB Interface for Databricks the following
                % can be invoked, note it is not a script but a statement
                options.mwiStartupScript string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.proxyTimeout (1,1) int32 = 60
                options.accountName (1,1) string

                options.copyPreferences (1,1) logical = false
                options.preferenceDir (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName

                options.useStartupShutdown (1,1) logical = false
                options.startupShutdownConfig (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}

            end

            % Configure properties with creation arguments
            obj.Cluster = cluster;
            obj.URL = url;
            obj.ProxyTimeout = options.proxyTimeout;

            if isfield(options, "dbxPkgVersion")
                obj.DatabricksPackageVersion = options.dbxPkgVersion;
            end
            if isfield(options, "mwiStartupScript")
                obj.MWIStartupScript = options.mwiStartupScript;
            end
            if isfield(options, "preExecScript")
                obj.PreExecScript = options.preExecScript;
            end
            if isfield(options, "postExecScript")
                obj.PostExecScript = options.postExecScript;
            end
            if isfield(options, 'accountName')
                obj.AccountName = options.accountName;
            end

            obj.CopyPreferences = options.copyPreferences;
            if isfield(options, 'preferenceDir')
                obj.PreferenceDir = options.preferenceDir;
            end

            obj.UseStartupShutdown = options.useStartupShutdown;
            if isfield(options, 'startupShutdownConfig')
                obj.StartupShutdownConfig = options.startupShutdownConfig;
            end

            if isfield(options, 'authMethod')
                obj.AuthMethod = options.authMethod;
            end
            if isfield(options, 'profileName')
                obj.ProfileName = options.profileName;
            end

            obj.Timer = timer('ExecutionMode', 'fixedRate', 'Period', 10, ...
                'TimerFcn', @obj.refresh, 'StopFcn', @obj.stopTimerCallBack); %, ...
                %'ErrorFcn', @timerErrCallBack);
            obj.Timer.start();
        end

        function refresh(obj,  timerObj, event) %#ok<INUSD>
            obj.Cluster.refresh;
            obj.State = obj.Cluster.state;
            obj.LastUpdate = datetime('now', 'TimeZone','UTC');
            % PENDING | RUNNING | RESTARTING | RESIZING | TERMINATING | TERMINATED | ERROR | UNKNOWN
            switch obj.State
                case "RUNNING"
                    fprintf("Cluster running, stopping timer and configuring cluster.\n");
                    obj.Timer.stop;

                case {"TERMINATING", "TERMINATED", "ERROR", "UNKNOWN"}
                    % terminal states kill the timer
                    fprintf("Cluster in a terminal state, stopping cluster configuration process: %s", obj.State);
                    delete(obj.Timer);

                case {"PENDING", "RESTARTING", "RESIZING"}
                    % do nothing
                    % fprintf("Checking cluster state.\n");

                otherwise
                    fprintf("Unexpected state: %s\n", obj.State);
            end
        end

        function delete(obj)
            if ~isempty(obj.Timer) || isa(obj.Timer, "double")
                if isvalid(obj.Timer)
                    obj.Timer.StopFcn = [];
                    delete(obj.Timer);
                end
            end
        end

        function stopTimerCallBack(obj, timerObj, event) %#ok<INUSD>            
            fprintf("Executing: stopTimerCallBack.\n");
            try
                configureCluster(obj);
            catch ME
                fprintf(2, "Caught an error in databricks.cluster.DesktopClusterConfigurator.configureCluster:\n");
                disp(ME);
                delete(obj.Timer);
                rethrow(ME);
            end
            delete(obj.Timer);
        end

        function configureCluster(obj, options)
            arguments
                obj (1,1) matlab.databricks.cluster.DesktopClusterConfigurator
                options.pspInstallDir string {mustBeTextScalar, mustBeNonzeroLengthText} = "/local_disk0/matlab-databricks"
            end

            fprintf("Configuring cluster for Desktop MATLAB\n");
            fprintf("--------------------------------------\n");

            errBase = "DATABRICKS:CONFIGURECLUSTER";

            options.pspInstallDir = strip(options.pspInstallDir, "right", "/");

            if ~isempty(obj.DatabricksPackageVersion) && strlength(obj.DatabricksPackageVersion) > 0
                installPSP = true;
            else
                installPSP = false;
            end

            % Get the authMethod and profileName from the object as there is no options
            authArgs = {};
            if isprop(obj, "AuthMethod") && ~isempty(obj.AuthMethod)
                authArgs{end+1} = 'authMethod';
                authArgs{end+1} = obj.AuthMethod;
            end
            if isprop(obj, "ProfileName") && ~isempty(obj.ProfileName) && strlength(obj.ProfileName) > 0
                authArgs{end+1} = 'profileName';
                authArgs{end+1} = obj.ProfileName;
            end

            % Create an execution context to use for configuration
            commandExecution = databricks.CommandExecution(authArgs{:});
            createRequest = databricks.datastructures.commandexecution.CreateRequest;
            createRequest.clusterId = obj.Cluster.cluster_id;
            createRequest.language = databricks.datastructures.commandexecution.Language.python;
            createResponse = commandExecution.create(createRequest);
            if isa(createResponse, 'databricks.datastructures.commandexecution.ErrorResponse')
                error(errBase, "Execution context creation failed:\n  %s", createResponse.error);
            else
                obj.ExecContext = createResponse.id;
            end

            % Determine a username for the local account on the cluster used to run MATLAB
            % It should not be root. By default take the account used on the machine submitting
            % the request so the same user's license is used
            % Databricks username typically but not always the user's email address
            dbUserName = string(databricks.internal.settings.Settings.getSettingsField("username"));
            % Expectation is that an AccountName is not provided i.e. set in the constructor
            if isempty(obj.AccountName) || strlength(obj.AccountName) == 0
                % Use the account name from the local OS submitting the creation request
                acName = matlab.utils.getAccountName();
                if isempty(acName) || strlength(acName) == 0
                    % If an AccountName is not found, unlikely, minimally normalize the
                    % Databricks username and use that as a fallback
                    if contains(dbUserName, "@")
                        dbUserName = extractBefore(dbUserName, "@");
                    end
                    if contains(dbUserName, ".")
                        obj.AccountName = extractBefore(dbUserName, ".");
                    else
                        obj.AccountName = dbUserName;
                    end
                else
                    obj.AccountName = acName;
                end
            end
            if ~matlab.utils.isValidUnixUserName(obj.AccountName)
                error(errBase+":INVALIDUSER", "Invalid user account name: %s", obj.AccountName);
            end

            % Get the databricks context and set the MW* env vars in the ctx context
            fprintf("Configuring credentials based on user's context.\n");
            cmdSetVars = ...
                "from dbruntime.databricks_repl_context import get_context; " + ...
                "import base64; import os; " + ...
                "context = get_context(); " + ...
                "os.environ['MWI_SHUTDOWN_ON_IDLE_TIMEOUT']='" + string(obj.ProxyTimeout) + "'; " + ...
                "os.environ['MW_ORG_ID']=context.workspaceId; " + ...
                "os.environ['MW_HOST']=f'https://{context.workspaceUrl}'; " + ...
                "os.environ['MW_ACCOUNTNAME']='" + string(obj.AccountName) + "'; " + ...
                "os.environ['MW_API_URL']=context.apiUrl; " + ...
                "os.environ['MW_API_TOKEN_B64']=base64.b64encode(context.apiToken.encode('utf-8')).decode('utf-8'); ";
            result = execPySubcmd(obj, cmdSetVars);
            if result ~= ""
                error(errBase + ":CTX", "Unexpected result from: %s", cmdSetVars);
            end

            % Check if the user account already exists by looking for the UID
            fprintf("Checking for existing user account.\n");
            cmdUserExists = "id $MW_ACCOUNTNAME";
            [result, uidResponse] = execPySubproc(obj, cmdUserExists);
            if result ~= "0"
                % No existing account is an expected state
                if ~contains(uidResponse.stderr, "no such user")
                    error(errBase + ":ID1", "id command (1) failed: %s, Result: %s", cmdUserExists, result);
                end
            end

            % If the UID does not exist create the account
            if strlength(uidResponse.stdout) == 0
                fprintf("Creating user account.\n");
                cmdAddUser = ['adduser --shell /bin/bash --disabled-password --gecos "" $MW_ACCOUNTNAME > /dev/null ', ...
                    '&& echo "$MW_ACCOUNTNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$MW_ACCOUNTNAME ', ...
                    '&& chmod 0440 /etc/sudoers.d/$MW_ACCOUNTNAME ', ...
                    '&& mkdir -p /home/$MW_ACCOUNTNAME/Documents/MATLAB ', ...
                    '&& ln -s /home/$MW_ACCOUNTNAME/.gitconfig /home/$MW_ACCOUNTNAME/Documents/MATLAB/.gitconfig ', ...
                    '&& chown -R $MW_ACCOUNTNAME:$MW_ACCOUNTNAME /home/$MW_ACCOUNTNAME/Documents'];
                execPySubproc(obj, cmdAddUser, errMsg="adduser failed");

                % Get the UID for the just created account
                fprintf("Checking user account creation.\n");
                [~, uidResponse] = execPySubproc(obj, cmdUserExists, errMsg="id command (2) failed");
            end
            userId = regexp(uidResponse.stdout, "uid=([0-9]+)", "tokens", "once");
            groupId = regexp(uidResponse.stdout, "gid=([0-9]+)", "tokens", "once");
            if isempty(userId) || strlength(userId) == 0
                error(errBase + ":USERID", "Failed to retrieve user ID for the newly created account.");
            end
            if isempty(groupId) || strlength(groupId) == 0
                error(errBase + ":GROUPID", "Failed to retrieve group ID for the newly created account.");
            end

            if obj.CopyPreferences
                % Create MATLAB prefdir
                if isempty(obj.PreferenceDir)
                    args = [authArgs(:)', {'accountName'}, {obj.AccountName}];
                else
                    args = [authArgs(:)', {'accountName'}, {obj.AccountName}, {'databricksLocation'}, {obj.PreferenceDir}];
                end
                pd = matlab.databricks.environment.Manager.getPrefDir(args{:});

                io = databricks.internal.io.IO(authArgs{:});
                if io.isfile(pd.OutputName)
                    tarFileName = pd.OutputName;
                    if io.getType(pd.OutputName) == "WORKSPACE"
                        tarFileName = "/Workspace" + tarFileName;
                    end
                    mlPrefDir = sprintf("/home/%s/.matlab", obj.AccountName);
                    prefDirCmd = sprintf("mkdir -p %s && cd %s && tar xf %s && chown -R %s:%s .", ...
                        mlPrefDir, mlPrefDir, tarFileName, obj.AccountName, obj.AccountName);
                    execPySubproc(obj, prefDirCmd, errMsg="Prefdir population failed");
                else
                    fprintf(2, "No preferences tar.gz file found at %s.\nNo preferences copied.\n", pd.OutputName)
                end
            end

            % Create a /local_disk0 directory for the user to use and set permissions
            % This is NOT the user's home directory. The home directory is /home/<obj.AccountName> as created by adduser.
            fprintf("Creating a /local_disk0 directory for the user.\n");
            localDir = sprintf("/local_disk0/%s", obj.AccountName);
            cmdLocalDir = sprintf("mkdir -p %s && chown -R %s:%s %s", localDir, obj.AccountName, obj.AccountName, localDir);
            execPySubproc(obj, cmdLocalDir, errMsg="local_disk0 mkdir failed");

            % If installing Extract the package ahead of starting the proxy
            if installPSP
                fprintf("Extracting MATLAB Interface for Databricks package.\n");
                interfaceDirectory = string(strip(databricks.internal.settings.Settings.getSettingsField("interfaceDirectory"), "right", "/"));
                if isempty(interfaceDirectory) || strlength(interfaceDirectory) == 0
                    error(errBase + ":IFDIR", "Interface directory settings is not configured, cannot find interface packages.");
                end

                % List the existing versions available in the interface directory
                F = databricks.Files(authArgs{:});
                dbxPkgDir = sprintf("%s/Versions/%s", interfaceDirectory, obj.DatabricksPackageVersion);
                contents = F.list(dbxPkgDir);
                fileNames = [contents.contents.path];

                % This is needed, as the filename sometimes contains 'nobinaries'
                idx = find(fileNames.contains("matlab-databricks-v") & fileNames.endsWith(".zip"));
                dbxPkg = fileNames(idx); %#ok<FNDSB>

                if ~F.fileExists(dbxPkg)
                    error(errBase + ":IFEXISTS", "Could not install MATLAB Interface for Databricks, expected package file not found: %s", dbxPkg);
                end

                % Unzip the databricks package to /local_disk0 for performance
                cmdStr = sprintf("if [ ! -d %s ]; then unzip -qo %s -d /local_disk0 && chown -R %s:%s %s ; fi", ...
                    options.pspInstallDir, dbxPkg, obj.AccountName, obj.AccountName, options.pspInstallDir);
                execPySubproc(obj, cmdStr, errMsg="Interface unzip failed");
            end

            % USER and HOME overwrite native env vars of root && /root respectively
            proxyEnvVarCell = {...
                'MW_CLUSTER_ID', obj.Cluster.cluster_id; ...
                'MW_DBX_USERNAME', dbUserName; ...
                'MWI_SESSION_NAME', sprintf('%s - MATLAB Desktop', obj.Cluster.cluster_name);...
                'USER', obj.AccountName ; ...
                'HOME', sprintf('/home/%s', obj.AccountName); ...
                };
            mwProxyEnv = containers.Map(proxyEnvVarCell(:,1), proxyEnvVarCell(:,2));

            % Run startup stuff
            if obj.UseStartupShutdown
                if ~isempty(obj.StartupShutdownConfig) && strlength(obj.StartupShutdownConfig) > 0
                    startupShutdownConfigFile = obj.StartupShutdownConfig;
                else
                    matlabRelCmd = "import os; print(os.environ['MATLAB_RELEASE'])";
                    relName = execPySubcmd(obj, matlabRelCmd);
                    if isempty(relName) || strlength(relName) == 0
                        relName = matlabRelease().Release;
                    end
                    startupShutdownConfigFile = sprintf("/Workspace/Users/%s/MathWorks/Context/%s/mw_prefs.json", dbUserName, relName);
                end
                mwProxyEnv('MW_STARTUP_SHUTDOWN_CONFIG') = startupShutdownConfigFile;
                mwProxyEnv('MW_DATABRICKS_PACKAGE_DIRECTORY') = dbxPkgDir;
                cmdStartup = "import sys; sys.path.insert(0, '" + dbxPkgDir + "'); from mw_context.mw_prefs import startup; startup('" + startupShutdownConfigFile + "')";

                result = execPySubcmd(obj, cmdStartup);
                fprintf("Startup sequence running:\n%s\n", result);
            end

            if installPSP
                mwProxyEnv('MW_INTERFACE_DIRECTORY') = interfaceDirectory;
                % Add pre/post arguments
                prePostArgs = sprintf("startupFolder='%s'", localDir);
                if ~isempty(obj.PreExecScript) && strlength(obj.PreExecScript) > 0
                    prePostArgs(end+1) = sprintf("preExecScript='%s'", obj.PreExecScript);
                end
                if ~isempty(obj.PostExecScript) && strlength(obj.PostExecScript) > 0
                    prePostArgs(end+1) = sprintf("postExecScript='%s'", obj.PostExecScript);
                end
                mwiStartupScript = sprintf(...
                    "cd %s/Software/MATLAB/app/functions;" + ...
                    " onDatabricksSetup(%s)", options.pspInstallDir, join(prePostArgs, ", "));
                mwProxyEnv('MWI_MATLAB_STARTUP_SCRIPT') = mwiStartupScript;

                if obj.CopyPreferences
                    mwProxyEnv('MW_SAVE_PREFERENCES') = 'true';

                    if ~isempty(obj.PreferenceDir)
                        mwProxyEnv('MW_PREFERENCES_ARCHIVE_DIR') = obj.PreferenceDir;
                    end
                end
            else
                if ~isempty(obj.MWIStartupScript) && strlength(obj.MWIStartupScript) > 0
                    mwProxyEnv('MWI_MATLAB_STARTUP_SCRIPT') = obj.MWIStartupScript;
                end
            end

            fprintf("Checking for the MATLAB proxy.\n");
            proxyPath = "/databricks/python3/bin/matlab-proxy-app";
            result = execPySubcmd(obj, sprintf("import os.path; os.path.isfile('%s')", proxyPath));
            if result ~= "True"
                error(errBase + ":PROXYEXISTS", "MATLAB Proxy not found: %", proxyPath);
            end

            % Start the proxy app, note this uses the newly created user's uid and gid
            fprintf("Starting the MATLAB proxy.\n");
            % TODO should retain context be false here?
            result = databricks.internal.commandexecution.executePythonSubprocess(...
                proxyPath, ...
                env=mwProxyEnv, ...
                userId=userId, ...
                groupId=groupId, ...
                clusterId=obj.Cluster.cluster_id, ...
                retainContext=true, ...
                contextId=obj.ExecContext, ...
                shell=true, ...
                blocking=false, ... % Don't use execPySubproc as this is nonblocking
                verbose=false);
            if result ~= "NonblockingCall"
                fprintf(2, "Unexpected Proxy start response: %s, Expected: NonblockingCall, Result: %s", proxyPath, result);
            end

            fprintf('Access MATLAB Desktop cluster:\n   <a href="%s">%s</a>\n   Copy URL to <a href="matlab: clipboard(''copy'', ''%s'')">clipboard</a>.\n', obj.URL, obj.URL, obj.URL);
        end
    end

    methods(Hidden)
        function [result, response] = execPySubproc(obj, cmdStr, options)
            % EXECPYSUBPROC Calls executePythonSubprocess for a largely default set of arguments
            % The aim is to provide a more concise function call.
            % Hardwired executePythonSubprocess arguments:
            %        blocking: true
            %       clusterId: obj.Cluster.cluster_id
            %       contextId: obj.ExecContext
            %   retainContext: true
            %         verbose: false
            %           shell: true
            %
            % The command Id is not returned.
            % A command can be provided.

            arguments
                obj (1,1) matlab.databricks.cluster.DesktopClusterConfigurator
                cmdStr string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.errMsg string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.env containers.Map
                options.blocking (1,1) logical = true
                options.verbose (1,1) logical = false
                options.shell (1,1) logical = true
            end

            errBase = "DATABRICKS:CONFIGURECLUSTER:EXECPYSUBPROC";

            if isempty(obj.ExecContext) || strlength(obj.ExecContext) == 0
                error(errBase+"CTX", "Execution context not set for command: %s", cmdStr);
            end

            if isempty(obj.Cluster)
                error(errBase+"CLUSTER", "Cluster not set for command: %s", cmdStr);
            else
                if ~isprop(obj.Cluster, "cluster_id") || strlength(obj.Cluster.cluster_id) == 0
                    error(errBase+"CLUSTERID", "Cluster Id not set for command: %s", cmdStr);
                end
            end

            if isfield(options, "env") && optons.env.Count > 0
                [result, response, ctx, commandId] = databricks.internal.commandexecution.executePythonSubprocess(...
                    cmdStr, env = options.env, clusterId=obj.Cluster.cluster_id, ...
                    retainContext=true, contextId=obj.ExecContext, ...
                    shell=options.shell, blocking=options.blocking, verbose=options.verbose); %#ok<ASGLU>
            else
                [result, response, ctx, commandId] = databricks.internal.commandexecution.executePythonSubprocess(...
                    cmdStr, clusterId=obj.Cluster.cluster_id, ...
                    retainContext=true, contextId=obj.ExecContext, ...
                    shell=options.shell, blocking=options.blocking, verbose=options.verbose); %#ok<ASGLU>
            end
            if isfield(options, "errMsg")
                if result ~= "0"
                    error(errBase + ":NONZERO", "%s, Command: %s, Result: %s", options.errMsg, cmdStr, result);
                end
            end
        end

        function result = execPySubcmd(obj, cmdStr)
            % EXECPYSUBCMD Calls executePythonCommand for a largely default set of arguments
            % The aim is to provide a more concise function call.
            % Hardwired executePythonSubprocess arguments:
            %        blocking: true
            %       clusterId: obj.Cluster.cluster_id
            %       contextId: obj.ExecContext
            %   retainContext: true
            %         verbose: false
            %           shell: true
            %
            % The command Id is not returned.
            % A command can be provided.

            arguments
                obj (1,1) matlab.databricks.cluster.DesktopClusterConfigurator
                cmdStr string {mustBeTextScalar, mustBeNonzeroLengthText}
            end

            errBase = "DATABRICKS:CONFIGURECLUSTER:EXECPYSUBCMD";

            if isempty(obj.ExecContext) || strlength(obj.ExecContext) == 0
                error(errBase+"CTX", "Execution context not set for command: %s", cmdStr);
            end

            if isempty(obj.Cluster)
                error(errBase+"CLUSTER", "Cluster not set for command: %s", cmdStr);
            else
                if ~isprop(obj.Cluster, "cluster_id") || strlength(obj.Cluster.cluster_id) == 0
                    error(errBase+"CLUSTERID", "Cluster Id not set for command: %s", cmdStr);
                end
            end

            [result, ctx, commandId] = databricks.internal.commandexecution.executePythonCommand(...
                cmdStr, ...
                clusterId=obj.Cluster.cluster_id, ...
                retainContext=true, ...
                contextId=obj.ExecContext, ...
                blocking=true, ...
                verbose=false); %#ok<ASGLU>
        end
    end

    methods(Access = protected)
        function groups = getPropertyGroups(obj)
            if isscalar(obj)
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
                isRunning = groups.PropertyList.State == "RUNNING";
                if isRunning
                    groups.PropertyList.URL = matlab.utils.URL2Link(groups.PropertyList.URL, label=sprintf("Open %s: %s", obj.Cluster.cluster_name, groups.PropertyList.URL));
                else
                    groups.PropertyList.URL = sprintf("Cluster (Not Ready): %s", groups.PropertyList.URL);
                end
                if isprop(obj.Cluster, "start_time")
                    startTime = obj.Cluster.start_time;
                    startTime.TimeZone = "UTC";
                    groups.PropertyList.StartTime = startTime;
                    if isRunning
                        if isempty(obj.LastUpdate)
                            groups.PropertyList.StartupDuration = seconds(0);
                        else
                            groups.PropertyList.StartupDuration = obj.LastUpdate - startTime;
                        end
                    else
                        if isempty(obj.LastUpdate)
                            groups.PropertyList.ElapsedTime = seconds(0);
                        else
                            groups.PropertyList.ElapsedTime = obj.LastUpdate - startTime;
                        end
                    end
                end
                groups.PropertyList.ClusterName = string(obj.Cluster.cluster_name);
            else
                % Nonscalar case: call superclass method
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end %function
    end %methods
end
