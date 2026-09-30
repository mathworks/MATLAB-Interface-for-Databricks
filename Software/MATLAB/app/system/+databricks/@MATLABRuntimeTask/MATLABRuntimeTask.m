classdef MATLABRuntimeTask < databricks.BaseTask
    % MATLABRUNTIMETASK Definition of a MATLAB runtime task
    %
    % Required Argument
    % =================
    % Command:
    % A scalar string specifying the compiled code to be executed.
    %
    % Optional Named Arguments
    % ========================
    % arguments:
    % Arguments passed to the compiled code as a scalar string.
    % No enclosing quotes will be added.
    % Previously some manual escaping of the Arguments was required depending on
    % its content. This is no longer necessary and statements should not be
    % escaped, aside from conventional escaping of single and double quotes
    % as normal to yield a valid MATLAB string. Note that the resulting arguments
    % are used as bash arguments and should be quotes appropriately. A leading
    % space will be added.
    %
    % notebookPath:
    % If a notebook path is not provided one is created and used for the
    % dynamically generated notebook. The Workspace path has the form:
    %    /Users/username@example.com/tmp/MATLABRuntimeTask-<UUID>.py
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
    %   3. Compiled MATLAB command
    %   4. postExecShCmd
    %   5. postExecPyCmd
    % Shell commands are appended to a "%%sh" magic prefix.
    %
    % A temporary file is created and its name can be retrieved from the environment
    % variable MW_RESULT_TEMPFILE This file can be appended to in steps 1,2,4 & 5
    % along with the results from step 3.  The first 1 MB of output can be retrieved
    % from the job run when the task finishes.
    %
    % mcrRoot:
    % The path to the root of the MATLAB runtime installation, if set this is used
    % to build up the LD_LIBRARY_PATH environment variable and set the MCRROOT
    % environment variable. By default it is expected that this is set in the
    % Cluster definition or docker file.
    %
    % ldLibraryPath:
    % Used to the set the LD_LIBRARY_PATH environment variable, if set this overrides
    % a value which may have been set based on mcrRoot. By default it is expected
    % that this is set in the Cluster definition or docker file.
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
    % Example:
    %   t = databricks.MATLABRuntimeTask("/Workspace/Users/joe@example.com/myCompiledCode",...
    %                                  arguments="3.14",...
    %                                  baseParameters=struct('massLow', '1200', 'massHigh', '1400'),...
    %                                  notebookPath="/Workspace/Users/joe@example.com/MATLABRuntimeTask.py",...
    %                                  preExecPyCmd='print("Running preExec Python")',...
    %                                  postExecPyCmd='print("Running postExec Python")',...
    %                                  preExecShCmd='echo "Running preExec Shell"',...
    %                                  postExecShCmd='echo "Running postExec Shell"');
    %
    %   c = createDatabricksCluster("runtimeTestCluster", 0, dockerAuthFile="C:\myDir\dockerAuth.json");
    %
    %   jb = databricks.Job;
    %   jb.name = "my-job-name";
    %
    %   Assign the cluster to the job
    %   jb.setCluster(c);
    %
    %   jb.setTask(t);
    %   jb.create();
    %   jobRun = jb.runNow();
    %
    %   output = jobRun.getOutput
    %     output = 
    %       struct with fields:
    %            metadata: [1×1 databricks.Run]
    %     notebook_output: [1×1 databricks.datastructures.NotebookOutput]
    %   output.notebook_output
    %     ans = 
    %       NotebookOutput with properties:
    %          result: "['Input: 3.140000\n', 'Output: 6.280000\n']"
    %       truncated: 0
    %
    % A license is not required for MATLAB runtime based tasks.
    
    % Copyright 2025-2026, The MathWorks, Inc.

    properties
        % The absolute path of the notebook to be run in Databricks
        % This property is required
        notebook_path string
        notebook_url matlab.net.URI
        notebook_task databricks.NotebookTask
    end

    methods
        function obj = MATLABRuntimeTask(command, options)
            arguments
                command string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.arguments string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.notebookPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.baseParameters struct

                options.preExecPyCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.postExecPyCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.preExecShCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.postExecShCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                
                options.mcrRoot (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.ldLibraryPath (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.overwriteNotebook (1,1) logical = true
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            args = matlab.utils.addArgs(options, ["arguments", "mcrRoot", "ldLibraryPath", "preExecShCmd", "postExecShCmd", "preExecPyCmd", "postExecPyCmd", "overwriteNotebook", "notebookPath", "baseParameters", "authMethod", "profileName"]);
            obj.createPyNotebook(command, args{:});
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

        function createPyNotebook(obj, command, options)
            arguments
                obj (1,1) databricks.MATLABRuntimeTask
                command string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.arguments string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.notebookPath string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.baseParameters struct

                options.preExecPyCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.postExecPyCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.preExecShCmd string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.postExecShCmd string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.mcrRoot (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.ldLibraryPath (1,1) string {mustBeTextScalar, mustBeNonzeroLengthText}

                options.overwriteNotebook (1,1) logical = true
                options.authMethod (1,1) matlab.databricks.AuthMethod
                options.profileName string = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
            end

            tmpfile = [tempname, '.py'];
            deleteAfter = onCleanup(@() delete(tmpfile));
            nb = matlab.sparkutils.NotebookWriter(tmpfile);
            nb.addHeader(sprintf("MATLAB Runtime Task Notebook"));
            nb.comment(" This notebook runs compiled MATLAB code with the MATLAB runtime using %%%%bash");
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
            
            if isfield(options, "preExecPyCmd")
                nb.addHeader("Pre-execution Python command:");
                for n = 1:numel(options.preExecPyCmd)
                    nb.pf('%s', options.preExecPyCmd(n));
                end
            end
            
            if isfield(options, "preExecShCmd")
                nb.addHeader("Pre-execution Shell command:");
                nb.magic('%%%%sh');
                for n = 1:numel(options.preExecShCmd)
                    nb.pf('%s\n', options.preExecShCmd(n));
                end
            end
            
            nb.addHeader("Invoke compiled MATLAB command:");
            nb.magic('%%%%bash');
            if isfield(options, "mcrRoot")
                nb.pf('export MCRROOT=%s\n', options.mcrRoot);
                nb.pf('export LD_LIBRARY_PATH=$MCRROOT/runtime/glnxa64:$MCRROOT/bin/glnxa64:$MCRROOT/sys/os/glnxa64:$MCRROOT/extern/bin/glnxa64:$MCRROOT/sys/opengl/lib/glnxa64\n');
            end
            if isfield(options, "ldLibraryPath")
                nb.pf('export LD_LIBRARY_PATH=%s\n', options.ldLibraryPath);
            end
            nb.pf("%s", command);
            if isfield(options, "arguments")
                nb.pf(" %s", options.arguments);
            end
            nb.pf(" 2>&1 | tee $MW_RESULT_TEMPFILE && exit ${PIPESTATUS[0]}\n");


            if isfield(options, "postExecShCmd")
                nb.addHeader("Post-execution Shell command:");
                nb.magic('%%%%sh');
                for n = 1:numel(options.postExecShCmd)
                    nb.pf('%s\n', options.postExecShCmd(n));
                end
            end

            if isfield(options, "postExecPyCmd")
                nb.addHeader("Post-execution Python command:");
                for n = 1:numel(options.postExecPyCmd)
                    nb.pf('%s\n', options.postExecPyCmd(n));
                end
            end

            nb.addHeader("Return results file content (First 5 MB):");
            nb.pf('import os\n');
            nb.pf('path = os.getenv("MW_RESULT_TEMPFILE")\n');
            nb.pf('if os.path.exists(path):\n');
            nb.pf("  with open(path, 'r', encoding='utf-8') as fd:\n");
            nb.pf("    lines = fd.readlines(5*1048576)\n");
            nb.pf("  #print(lines)\n");
            nb.pf("  fd.close()\n");
            nb.pf("  os.remove(path)\n");
            nb.pf("  dbutils.notebook.exit(lines)\n");
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
                nbPath = "/Users/" + string(username) + "/tmp/MATLABRuntimeTask-" + uuid + ".py";
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
