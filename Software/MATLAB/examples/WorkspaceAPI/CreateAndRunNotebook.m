% Example of using the Databricks Workspace REST API
% Creates and executes a Python notebook in Databricks from MATLAB.
%
% Can be executed remotely or from within MATLAB running on Databricks.
% For more information see: Documentation/html/WorkspacesAPI.html
%
% It is recommended to step through this example using the debugger and
% using the methods() command and documentation to explore the additional
% functionality offered by the various databricks.* classes used.
%
% It is assumed the support package has already been configured.

% Copyright 2026 The MathWorks Inc.

% Provide a Python command that is used to populate the notebook
defaultPyCmd = 'print("Hello World")';
pyStr = strip(input(['Enter a Python command (default: ',defaultPyCmd,'): '],'s'));
disp(newline);

if isempty(pyStr)
    pyStr = defaultPyCmd;
end
% Escape \'s for inclusion in the Python command
pyStr = replace(pyStr, "\", "\\");
% Add a return value to this minimal notebook
pyStr = [pyStr, newline, 'dbutils.notebook.exit("myReturnValue")'];

% Create a Workspace path
ws = databricks.Workspace;
% Get user name string for path arguments, include a datetime string in the name
timeExt = char(datetime("now", "Format", "uuuuMMdd_HHmmss_SSS"));
notebookPath = ['/Users/', ws.username, '/workspace-example-notebook-', timeExt];
% Check the path does not exist
if ws.fileExists(notebookPath)
    error('File already exists: %s', notebookPath);
end

% Import the string into the workspace as a Python format file 
ws.import('path', notebookPath, 'format', 'SOURCE', 'language', 'PYTHON',...
    'content', pyStr, 'overwrite', true);

% The code above builds the Python command as a character vector.
% To load the code from a file use the import command as follows:
%
%  ws.import('path', pathArg, 'format', 'SOURCE', 'language', 'PYTHON', ...
%            'file', '/myPath/myFile.py', 'overwrite', true);

% Create a cluster to run the notebook job
[~, clusterName] = fileparts(notebookPath);
clusterName = ['cluster-', clusterName];
cl = createDatabricksCluster(clusterName, 0, useMATLAB=false) %#ok<NOPTS>

% Wait for cluster to enter running state
disp("Waiting for cluster to start this may take 5 minutes approximately.");
databricks.internal.cluster.waitForClusterToStart(cluster=cl.cluster_id);

% Configure the job to run on the cluster
jb = databricks.Job;
[~, jobName] = fileparts(notebookPath);
jobName = ['job-', jobName];
jb.name = jobName;
jb.setCluster(cl.cluster_id);

% Configure notifications
jb.setJobEmailNotifications();

% Add the notebook as a task to the job
task = databricks.NotebookTask;
task.notebook_path = notebookPath;
jb.setTask(task);
jb.max_retries = 0;

% Run the job now
jb.create();
run = jb.runNow();

% Retrieve the Notebook content
disp(newline);
disp('Notebook content:');
result = ws.export(notebookPath, 'SOURCE', false);
disp([result.content, newline]);

disp('Waiting for job to run:');
databricks.internal.job.waitForJob(run.job_id);

disp(newline);
disp('Notebook return value:');
returnVal = run.getOutput();
if isprop(returnVal.notebook_output, 'result')
    disp(returnVal.notebook_output.result);
else
    disp('(No return value, append dbutils.notebook.exit("myReturnValue"))');
end

% Display the result
web(run.run_page_url);

% Delete the notebook
disp(newline);
delYN = strip(input('Delete the temporary notebook (Y/N): ', 's'));
if strcmpi(delYN, 'y')
    fprintf('Deleting notebook: %s\n', notebookPath);
    recurse = true;
    ws.delete(notebookPath, recurse);
end

% Delete the cluster
disp(newline);
delYN = strip(input('Delete the cluster (Y/N): ', 's'));
if strcmpi(delYN, 'y')
   cl.permanentDelete();
end

disp('Done.');