classdef MATLABBatchTask < databricks.BaseTask
    % MATLABBATCHTASK Definition of a MATLAB batch mode task
    %
    % Required Argument
    % =================
    % statement:
    % A scalar string that is the MATLAB code to be executed.
    % Typically this invokes a script that encompasses the more
    % complex functionality making the statement handling less error prone. An
    % exit value of non zero returned to Databricks will be cause the job to fail.
    % 
    % Previously some manual escaping of the statement was required depending on
    % its content. This is now automatic and statements should not be
    % escaped, aside from conventional escaping of single and double quotes
    % as normal to yield a valid MATLAB string.
    %
    % The MATLAB executing the statement runs as the user given by accountName,
    % see below.
    %
    % Optional Named Arguments
    % ========================
    % notebookPath:
    % If a notebook path is not provided one is created and used for the
    % dynamically generated notebook. The Workspace path has the form:
    %    /Users/username@example.com/tmp/MATLABBatchTask-<UUID>.py
    % On completion of the task the file should be deleted. This is not done
    % automatically.
    % By default an existing notebook of the same name will be overwritten.
    % A /Volumes path may also be provided.
    %
    % If provided the path of the notebook should be an absolute path.
    %
    % baseParameters:
    % Optional base parameters can be passed as a struct. Values must be specified
    % as scalar text and can be retrieved by the MATLAB code at runtime using:
    %   valueString = getenv('structFieldName');
    %
    % preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd:
    % Optional preExecPyCmd, postExecPyCmd, preExecShCmd and postExecShCmd arguments
    % can be used to add Python code and shell commands to the notebook that are
    % invoked before and or after the MATLAB code. This may be useful "house keeping"
    % or invoking other workflows. The order of execution is:
    %   1. preExecPyCmd
    %   2. preExecShCmd
    %   3. MATLAB statement
    %   4. postExecShCmd
    %   5. postExecPyCmd
    % Shell commands are appended to a "%%sh" magic prefix.
    % These commands run as root and must adjust permissions for the accountName
    % user accordingly for file access.
    %
    % A temporary file is created and its name can be retrieved from the environment
    % variable MW_RESULT_TEMPFILE This file can be appended to in steps 1,2,4 & 5
    % along with the results from step 3.  The first 1 MB of output can be retrieved
    % from the job run when the task finishes.
    %
    % The pre and post execution commands run as root.
    % Newlines are automatically appended to each string element of Python and shell
    % string array commands when building the underlying the notebook.
    %
    % MATLABCommand:
    % The MATLABCommand argument is the command used to run MATLAB. By default
    % this is "matlab -batch". Alternatives may be:
    % 1)  "matlab -nodesktop -r" is a preferences directory required and provisioned.
    %
    % 2)  "matlab-batch" if working with batch token based licensing, Not to be
    %     confused with "matlab -batch".
    %
    % licenseManager:
    % The licenseManager argument is used to specify where MATLAB should get its
    % license. If specified the `MLM_LICENSE_FILE` environment variable is set to
    % the provided value in the notebook. If this value is already set in the docker
    % image or cluster definition it is not required at this point.
    %
    % If using batch token based licensing for CI/CD workflows the argument is still
    % used in the normal way if provided, however the value will be ignored.
    %
    % licenseToken:
    % Provide a Batch Token Licensing value. The argument should have the form:
    % "user@email.com::encodedToken". When set this values causes the MATLABCommand
    % to be set to: "matlab-batch -licensetoken user@email.com::encodedToken"
    % rather than the default "matlab -batch". If a specific MATLABCommand argument
    % is provided that value is used. License tokens must use the matlab-batch binary.
    % This must be included in the MATLAB docker file image at build time.
    % The token will be included in the notebook as plain text. The use of secrets
    % is therefore the recommended alternative.
    %
    % licenseTokenSecretKey & licenseTokenSecretScope:
    % These arguments allow a Batch Token Licensing value to be retrieved from
    % a Databricks secret at runtime.
    % If both a secret and licenseToken are specified the secret is used.
    %
    % If neither a token or secret is specified but the MLM_LICENSE_TOKEN environment
    % variable is preferred and if configured in the docker image, cluster definition
    % or preExec*Cmd options specify the MATLABCommand option as just "matlab-batch"
    % and it will be used automatically.
    %
    % accountName:
    % accountName is the name of user account that is dynamically created on the
    % cluster to run the MATLAB task. By default and where possible it will be
    % based on the account name on the system used to submit the job. This argument
    % allows this value to be specified.
    %
    % The environment variable `MW_ACCOUNTNAME` can be used to query the account
    % name at runtime. The is set in the MATLAB statement section and the pre & post
    % exec command sections.
    %
    % skipAccountNameCheck:
    % skipAccountNameCheck is a logical argument, when set to false (default) the
    % accountName is validated to check if it is a valid Linux account name. Setting
    % this value to true enables the use of accountName values such as "$MYACCOUNTNAME"
    % such that the relevant shell cells in the generated notebook use an environment
    % variable, that might be defined in a Databricks Asset Bundle, or otherwise at
    % runtime. E.g. corresponding to a service principal identity used for scheduled
    % workloads.
    % Default: false
    %
    % installDatabricksInterface:
    % Logical flag to install the MATLAB Databricks Interface package.
    % The package is installed and configured prior to the execution of the MATLAB
    % statement. If true and the interface directory or interface package
    % is not found the installation will be skipped but the task will still
    % be created with a warning.
    % Default: true.
    %
    % installDatabricksDir:
    % The directory where the Databricks interface will be installed.
    % Default: "/local_disk0/<accountName>/matlab-interface-for-databricks";
    %
    % installDatabricksOverwrite:
    % Logical flag to decide if the Databricks interface should be overwritten,
    % in the case it was already installed here.
    % Default: false
    %
    % interfaceDirectory:
    % Path to a directory containing a subdirectory "Versions" which contains
    % MATLAB Databricks Interface packages in semantically versioned directories.
    %
    % overwriteNotebook:
    % A logical flag that is true by default, meaning that if the created
    % notebook will be overwritten if it already exists.
    %
    % authMethod:
    % The authentication method to use for REST API calls.
    %
    % profileName:
    % The name of the profile to use from the .databrickscfg configuration file.
    %
    % For details on docker file registry access & authentication see:
    % Documentation/Authentication.md
    %
    % Note that only Linux startup options apply in the case of Databricks.
    % See also: https://mathworks.com/help/matlab/ref/matlablinux.html
    %
    % Example:
    %   baseParameters = struct('massLow', '1200', 'massHigh', '1400');
    %   t = databricks.MATLABBatchTask("disp('hello world'); disp(getenv('massHigh'))", baseParameters=baseParameters);
    %
    %   t = databricks.MATLABBatchTask("disp(""Hello world""); exit(0)",...
    %                                   baseParameters=struct('massLow', '1200', 'massHigh', '1400'),...
    %                                   notebookPath="/Workspace/Users/joe@example.com/MATLABBatchTask.py",...
    %                                   preExecPyCmd='print("Running preExec")',...
    %                                   postExecPyCmd='print("Running postExec")',...
    %                                   preExecShCmd='echo "Running preExec Shell"',...
    %                                   postExecShCmd='echo "Running postExec Shell"',...
    %                                   licenseManager="27000@10.0.0.4");
    %   
    %   % Specify a cluster to be created when the job runs as a databricks.Cluster object
    %   % A cluster name is assigned at runtime.
    %   % Using a policy Id simplifies the cluster configuration by adopting settings defined
    %   % centrally in the policy.
    %   c = createDatabricksCluster("", 0, policyId=<policyId, create=false);
    %
    %   % Retrieve the cluster ID from the configuration profile DEFAULT for the current cluster
    %   clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", profileName="DEFAULT");
    %   jb = databricks.Job;
    %   jb.name = "my-job-name";
    %   Assign the cluster to the job
    %   jb.setCluster(clusterId);
    %
    %   jb.setTask(t);
    %   jb.create();
    %   jobRun = jb.runNow();
    %
    %   output = jobRun.getOutput
    %   output =
    %     struct with fields:
    %            metadata: [1×1 databricks.Run]
    %     notebook_output: [1×1 databricks.datastructures.NotebookOutput]
    %   output.notebook_output
    %     ans =
    %       NotebookOutput with properties:
    %          result: "['Hello world\n']"
    %       truncated: 0

    % Copyright 2025-2026, The MathWorks, Inc.

    properties
        % The absolute path of the notebook to be run in Databricks
        % This property is required
        notebook_path string
        notebook_url matlab.net.URI
        notebook_task databricks.NotebookTask
    end

    methods
        function obj = MATLABBatchTask(statement, options)
            arguments
                statement {mustBeTextScalar, mustBeNonzeroLengthText}
                options.notebookPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.baseParameters struct

                options.preExecPyCmd string {mustBeNonzeroLengthText}
                options.postExecPyCmd string { mustBeNonzeroLengthText}
                options.preExecShCmd string {mustBeNonzeroLengthText}
                options.postExecShCmd string {mustBeNonzeroLengthText}
                options.MATLABCommand (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.licenseManager (1,1) string {mustBeNonzeroLengthText}
                options.licenseToken (1,1) string {mustBeNonzeroLengthText}
                options.licenseTokenSecretKey (1,1) string {mustBeNonzeroLengthText}
                options.licenseTokenSecretScope (1,1) string {mustBeNonzeroLengthText}
                options.accountName (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText} = matlab.utils.getAccountName
                options.skipAccountNameCheck (1,1) logical = false

                options.installDatabricksInterface (1,1) logical = true
                options.installDatabricksDir (1,1) string
                options.installDatabricksOverwrite (1,1) logical = false
                options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.overwriteNotebook (1,1) logical = true
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            escapedStatement = databricks.BaseTask.escapeSingleQuotes(statement);

            args = matlab.utils.addArgs(options,...
                ["MATLABCommand", "licenseManager", "licenseTokenSecretKey", "licenseTokenSecretScope", "batchToken", "accountName", "skipAccountNameCheck",...
                "installDatabricksInterface", ...
                "interfaceDirectory","installDatabricksDir", "installDatabricksOverwrite"...
                "preExecShCmd", "preExecPyCmd", "postExecShCmd", "postExecPyCmd",...
                "overwriteNotebook", "notebookPath", "baseParameters", "authMethod", "profileName"]);
            obj.createPyNotebook(escapedStatement, args{:});
            obj.notebook_task = databricks.NotebookTask(obj.notebook_path);
            if isfield(options, "baseParameters")
                if ~isprop(obj.notebook_task, "base_parameters")
                    obj.notebook_task.addprop("base_parameters");
                end
                obj.notebook_task.base_parameters = options.baseParameters;
            end
        end

        function entries = getTaskEntries(obj)
            taskReq.notebook_path = obj.notebook_path;
            if ~isempty(obj.notebook_task.base_parameters)
                taskReq.base_parameters = obj.notebook_task.base_parameters;
            end
            entries.notebook_task = taskReq;
        end
    end

    methods(Hidden)

        function createPyNotebook(obj, statement, options)
            % CREATEPYNOTEBOOK Create a Python notebook task to execute a MATLAB task

            arguments
                obj (1,1) databricks.MATLABBatchTask
                statement {mustBeTextScalar, mustBeNonzeroLengthText} % escaped by the caller
                options.notebookPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.baseParameters struct

                options.preExecPyCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.postExecPyCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.preExecShCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.postExecShCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.MATLABCommand (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.licenseManager (1,1) string {mustBeNonzeroLengthText}
                options.licenseToken (1,1) string {mustBeNonzeroLengthText}
                options.licenseTokenSecretKey (1,1) string {mustBeNonzeroLengthText}
                options.licenseTokenSecretScope (1,1) string {mustBeNonzeroLengthText}
                options.accountName (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText} = matlab.utils.getAccountName
                options.skipAccountNameCheck (1,1) logical = false

                options.installDatabricksInterface (1,1) logical = true
                options.installDatabricksDir (1,1) string
                options.installDatabricksOverwrite (1,1) logical = false
                options.interfaceDirectory string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.overwriteNotebook (1,1) logical = true
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            errBase = "DATABRICKS:MATLABBATCHTASK:CREATEPYNOTEBOOK";

            if options.installDatabricksInterface
                args = matlab.utils.addArgs(options, ["interfaceDirectory", "authMethod", "profileName"]);
                pkgFile = matlab.databricks.getMATLABInterfacePackage(args{:});
                if isempty(pkgFile)
                    if isfield(options, "interfaceDirectory") && strlength(options.interfaceDirectory) > 0
                        warning(errBase+":ZIPNOTFOUNDNZ",...
                            "Databricks interface package not found, check interface directory: %s\n" + ...
                            "Calls to the interface in the task will fail.", options.interfaceDirectory);
                    else
                        warning(errBase+":ZIPNOTFOUNDZ",...
                            "Databricks interface package not found, check interface directory.\n" + ...
                            "Calls to the MATLAB code in the task will fail.");
                    end
                    installDatabricksInterface = false;
                else
                    installDatabricksInterface = true;
                    interfaceDirectory = fileparts(fileparts(fileparts(pkgFile)));
                    if isfield(options, "installDatabricksDir")
                        installDatabricksDir = strip(strip(options.installDatabricksDir), "right", "/");
                    else
                        installDatabricksDir = "/local_disk0/" + options.accountName + "/matlab-interface-for-databricks";
                    end
                end
            end

            if ~options.skipAccountNameCheck
                if ~matlab.utils.isValidUnixUserName(options.accountName)
                    error(errBase+":INVALIDUSER", "Invalid user account name: %s", options.accountName);
                end
            end

            tmpfile = [tempname, '.py'];
            deleteAfter = onCleanup(@() delete(tmpfile));
            nb = matlab.sparkutils.NotebookWriter(tmpfile);
            nb.addHeader(sprintf("MATLAB Batch Task Notebook"));
            nb.comment(" This notebook runs MATLAB code in batch mode using %%%%bash");
            nb.comment(" Generated using the MATLAB Interface for Databricks v%s", matlab.databricks.databricksPackageVersion());
            if isfield(options, "baseParameters")
                baseParametersFields = fieldnames(options.baseParameters);
                if numel(baseParametersFields) > 0
                    nb.addHeader("Create base parameter widgets:");
                    nb.pf("import os\n");
                    for n = 1:numel(baseParametersFields)
                        bpf = baseParametersFields{n};
                        bpv = string(options.baseParameters.(bpf));
                        nb.pf("dbutils.widgets.text('%s', '%s', '%s')\n", bpf, bpv, bpf);
                    end

                    nb.addHeader("Populate base parameter environment variables:");
                    for n = 1:numel(baseParametersFields)
                        nb.pf("os.environ['%s'] = dbutils.widgets.get('%s')\n", baseParametersFields{n}, baseParametersFields{n});
                    end
                end
            end

            nb.addHeader("Create a temporary result file:");
            nb.pf("import os\n");
            nb.pf("from tempfile import mkstemp\n");
            nb.pf("fd, path = mkstemp()\n");
            nb.pf("os.close(fd)\n");
            nb.pf('os.environ["MW_RESULT_TEMPFILE"] = path\n');

            nb.addHeader("Configuring User account:");
            nb.magic('%%%%sh');
            nb.pf('if [ ! -d /home/%s ]; then\n', options.accountName);
            nb.pf('  adduser --shell /bin/bash --disabled-password --gecos "" %s > /dev/null \\\n', options.accountName);
            nb.pf('  && echo "%s ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/%s \\\n', options.accountName, options.accountName);
            nb.pf('  && chmod 0440 /etc/sudoers.d/%s\n', options.accountName);
            nb.pf('fi\n');
            nb.pf('sudo -u %s -EH -- mkdir -p /home/%s/Documents/MATLAB\n', options.accountName, options.accountName);

            if isfield(options, "preExecPyCmd")
                nb.addHeader("Pre-execution Python command:");
                nb.pf('import os; os.environ["MW_ACCOUNTNAME"] = "%s"\n', options.accountName);
                for n = 1:numel(options.preExecPyCmd)
                    nb.pf('%s\n', options.preExecPyCmd(n));
                end
            end

            if isfield(options, "preExecShCmd")
                nb.addHeader("Pre-execution Shell command:");
                nb.magic('%%%%sh');
                nb.pf('export MW_ACCOUNTNAME="%s"\n', options.accountName);
                for n = 1:numel(options.preExecShCmd)
                    nb.pf('%s\n', options.preExecShCmd(n));
                end
            end

            nb.addHeader("Configure environment variables:");
            nb.pf("import os\n");
            if installDatabricksInterface
                nb.pf("import base64\n");
                nb.pf("from dbruntime.databricks_repl_context import get_context\n");
                nb.pf("context = get_context()\n");
                nb.pf("dbx_username = dbutils.notebook.entry_point.getDbutils().notebook().getContext().userName().get()\n");
                nb.pf('cluster_id = spark.conf.get("spark.databricks.clusterUsageTags.clusterId", "not set")\n');
                nb.pf("os.environ['MW_ORG_ID'] = context.workspaceId\n");
                nb.pf("os.environ['MW_HOST'] = f'https://{context.workspaceUrl}'\n");
                nb.pf("os.environ['MW_API_URL'] = context.apiUrl\n");
                nb.pf("os.environ['MW_DBX_USERNAME'] = dbx_username\n");
                nb.pf("os.environ['MW_API_TOKEN_B64'] = base64.b64encode(context.apiToken.encode('utf-8')).decode('utf-8')\n");
                nb.pf("os.environ['MW_INTERFACE_DIRECTORY'] = '%s'\n", interfaceDirectory);
                nb.pf("os.environ['MW_CLUSTER_ID'] = cluster_id\n");
                nb.pf("os.environ['SPARK_CONNECT_MODE_ENABLED'] = '1'\n");
            end

            if isfield(options, "licenseManager")
                nb.pf(sprintf('os.environ["MLM_LICENSE_FILE"] = "%s"\n', options.licenseManager));
            end

            if isfield(options, "MATLABCommand")
                MATLABCommand = options.MATLABCommand;
            else
                if isfield(options, "licenseTokenSecretKey") && strlength(options.licenseTokenSecretKey) > 0 && ...
                    isfield(options, "licenseTokenSecretScope") && strlength(options.licenseTokenSecretScope) > 0
                    nb.addHeader("Retrieve license token from Databricks secret:");
                    nb.pf(compose("import os; os.environ['MLM_LICENSE_TOKEN'] = dbutils.secrets.get(scope='%s', key='%s')",...
                        options.licenseTokenSecretScope, options.licenseTokenSecretKey));
                    MATLABCommand = "matlab-batch";
                elseif isfield(options, "licenseToken")
                    MATLABCommand = "matlab-batch -licensetoken " + """" + options.licenseToken + """";
                else
                    MATLABCommand = "matlab -batch";
                end
            end

            if startsWith(MATLABCommand, "matlab-batch")
                nb.addHeader("Check for matlab-batch on the path:");
                nb.magic('%%%%bash');
                nb.pf("if ! command -v matlab-batch  >/dev/null 2>&1; then\n")
                nb.pf("  echo 'matlab-batch not found on the path, check the correct docker image is being used.'\n");
                nb.pf("  exit 1\n")
                nb.pf("fi\n")
            elseif startsWith(MATLABCommand, "matlab -batch")
                nb.addHeader("Check for matlab on the path:");
                nb.magic('%%%%bash');
                nb.pf("if ! command -v matlab >/dev/null 2>&1; then\n")
                nb.pf('  echo "matlab not found on the path, check the correct docker image is being used."\n');
                nb.pf("  exit 1\n")
                nb.pf("fi\n")
            end % If neither a custom command may being used so skip the check, not clear what to check for

            nb.addHeader("Invoke MATLAB command:");
            nb.magic('%%%%bash');
            nb.pf('export MW_ACCOUNTNAME="%s"\n', options.accountName);
            if installDatabricksInterface
                fullInstallDatabricksDir = installDatabricksDir + "/matlab-databricks";
                if options.installDatabricksOverwrite
                    % Always create the directory, overwrite if necessary
                    nb.pf('if [ -d %s ]; then\n', fullInstallDatabricksDir);
                    nb.pf('  echo "Removing MATLAB Interface for Databricks directory prior to installation"\n');
                    nb.pf("  rm -rf %s\n", fullInstallDatabricksDir);
                    nb.pf('fi\n');
                    nb.pf('  mkdir -p %s\n', fullInstallDatabricksDir);
                    nb.pf('  chown -R %s %s\n', options.accountName, fullInstallDatabricksDir);
                    nb.pf("  sudo -u %s -EH unzip -q %s -d %s\n", options.accountName, pkgFile, installDatabricksDir);
                else
                    % Only create if not already there
                    nb.pf('if [ ! -d %s ]; then\n', fullInstallDatabricksDir);
                    nb.pf('  echo "Installing MATLAB Interface for Databricks in: %s"\n', fullInstallDatabricksDir);
                    nb.pf('  mkdir -p %s\n', fullInstallDatabricksDir);
                    nb.pf('  chown -R %s %s\n', options.accountName, fullInstallDatabricksDir);
                    nb.pf("  sudo -u %s -EH unzip -q %s -d %s\n", options.accountName, pkgFile, installDatabricksDir);
                    nb.pf('fi\n');
                end
                % The " & \ in the statement will be escaped but the cd() in the setupCmd needs to escaped manually
                setupCmd = sprintf('initDir=pwd; cd("%s/Software/MATLAB/app/functions"); onDatabricksSetup(verbose=false, startupFolder=initDir);', fullInstallDatabricksDir);
                setupStatement = strjoin([setupCmd, statement], " ");
                % Use '' for statement/setupStatement to avoid having to escape \'s 
                nb.pf('sudo -u %s -EH -- env PYTHONPATH=$PYTHONPATH PATH=$PATH %s ''%s'' 2>&1 | tee $MW_RESULT_TEMPFILE && exit ${PIPESTATUS[0]}\n', options.accountName, MATLABCommand, setupStatement);
            else
                nb.pf('sudo -u %s -EH -- env PYTHONPATH=$PYTHONPATH PATH=$PATH %s ''%s'' 2>&1 | tee $MW_RESULT_TEMPFILE && exit ${PIPESTATUS[0]}\n', options.accountName, MATLABCommand, statement);
            end

            if isfield(options, "postExecShCmd")
                nb.addHeader("Post-execution Shell command:");
                nb.magic('%%%%sh');
                nb.pf('export MW_ACCOUNTNAME="%s"\n', options.accountName);
                for n = 1:numel(options.postExecShCmd)
                    nb.pf('%s\n', options.postExecShCmd(n));
                end
            end

            if isfield(options, "postExecPyCmd")
                nb.addHeader("Post-execution Python command:");
                nb.pf('import os; os.environ["MW_ACCOUNTNAME"] = "%s"\n', options.accountName);
                for n = 1:numel(options.postExecPyCmd)
                    nb.pf('%s\n', options.postExecPyCmd(n));
                end
            end

            nb.addHeader("Return results file content (First 5 MB):");
            nb.pf('import os\n');
            nb.pf('path = os.getenv("MW_RESULT_TEMPFILE")\n');
            nb.pf('if os.path.exists(path):\n');
            nb.pf("  with open(path, 'r', encoding='utf-8') as fd:\n");
            nb.pf("    result = fd.read(5*1048576)\n");
            nb.pf("  #print(result)\n");
            nb.pf("  fd.close()\n");
            nb.pf("  os.remove(path)\n");
            nb.pf("  dbutils.notebook.exit(result)\n");
            nb.pf("else:\n");
            nb.pf("  dbutils.notebook.exit('MW_RESULT_TEMPFILE not found')\n");

            % Finished writing to the local temp file for the notebook
            % Does not delete the file because it was created with a
            % filename argument
            nb.delete();

            if isfield(options, "notebookPath")
                nbPath = options.notebookPath;
            else
                [~, uuid] = fileparts(tempname);
                username = databricks.internal.settings.Settings.getSettingsField("username");
                nbPath = "/Users/" + string(username) + "/tmp/MATLABBatchTask-" + uuid + ".py";
            end

            args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
            io = databricks.internal.io.IO(args{:});

            if io.isfile(nbPath) && ~options.overwriteNotebook
                fprintf("Notebook path exists, not overwriting: %s\n", nbPath);
                obj.notebook_path = string.empty;
                return;
            end

            [nbDir,~,~] = databricks.internal.io.IO.fileparts(nbPath);
            if ~io.isfolder(nbDir)
                if ~io.mkdir(nbDir)
                    fprintf("Directory creation failed: %s\n", nbDir);
                    obj.notebook_path = string.empty;
                    return;
                end
            end

            % auto handles a notebook correctly for /workspace
            io.upload(tmpfile, nbPath, 'overwrite', options.overwriteNotebook, 'verbose', false);

            % The import of a .py drops the filename so remove it here
            if endsWith(nbPath, ".py")
                obj.notebook_path = extractBefore(nbPath, strlength(nbPath)-2);
            else
                obj.notebook_path = nbPath;
            end

            args = matlab.utils.addArgs(options, {'authMethod', 'profileName'});
            obj.notebook_url = obj.notebookPath2URI(args{:});
        end
    end
end
