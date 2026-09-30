function [ret, status] = cli(varargin)
    % cli Interface to mlflow command line API
    %
    % Please refer to the official documentation of this:
    %  https://mlflow.org/docs/latest/cli.html
    %
    % This function will only work if mlflow is installed and available on
    % the PATH.
    %
    % The function returns two values
    %  ret - the return value of the system command.
    %  status - the output of the command
    %
    % If the status is not saved to a variable, its output will simply be
    % printed.
    %
    % Examples
    % % Check the help
    % mlflow.cli('--help')
    %
    % % List experiments
    % mlflow.cli('experiments', 'list')
    %
    % % Create an artifact for a run
    % mlflow.cli('artifacts', 'log-artifact', '-l', 'Contents.m', ...
    %    '-r', 'd48a790705394c5bb3ea43039a96ecf5', '-a', 'somewhere')
    %   2022/01/21 15:26:30 INFO mlflow.store.artifact.cli: Logged artifact from local file Contents.m to artifact_path=somewhere
    %
    % One special form, outside of the mlflow cli, exist to easier check if
    % mlflow is installed on a system. If the first argument to the
    % function is true (the logical value, not the string), the function
    % will simply return true if mlflow is installed on the system. This
    % can be useful if deciding to call this function or not.
    %
    % Example:
    % mlflow.cli(true)

    %  Copyright 2022 MathWorks, Inc.

    persistent mlflowcli_installed
    if isempty(mlflowcli_installed)
        mlflowcli_installed = check_install();
    end

    % Handling special case, where we just return whether or not mlflow is
    % available on this system.
    if ~isempty(varargin) && islogical(varargin{1}) && varargin{1}
        ret = mlflowcli_installed;
        return;
    end

    if ~mlflowcli_installed
        error('mlflow:ERROR', ...
            ['The mlflow.cli method can only be used if the mlflow ', ...
            'command line tool is installed on the system\n']);
    end

    args = string(varargin);

    cmd = sprintf('mlflow %s', sprintf('%s ', args{:}));

    [ret, status] = system(cmd);
    if nargout < 2
        fprintf('%s\n', status);
        if nargout < 1
            clear('ret', 'status');
        end
    end

end
function isInstalled = check_install()
    % check_install check if mlflow is found on the system path
    isInstalled = false;
    if ispc
        [retCode, status] = system('where mlflow'); %#ok<ASGLU> 
    else
        [retCode, status]= system('which mlflow'); %#ok<ASGLU> 
    end
    if retCode == 0
        isInstalled = true;
    end
end