function createWheel(obj)
    % createWheel Create a wheel for the Python package

    % Copyright 2022-2023 The MathWorks, Inc.

    % TODO revise to better use pyrun/pyrunfile when legacy version support permits

    old = cd(obj.OutputDir);
    goBack = onCleanup(@() cd(old));

    pyPath = getPython3Path();
    if strlength(pyPath) == 0
        error('SPARK_API:createWheel','Error building .whl file, no Python path found.');
    end

    if ~checkPyVersion(pyPath)
        error('SPARK_API:createWheel','Error building .whl file, problems with python version');
    end

    if ~checkPipInstalled(pyPath)
        error('SPARK_API:createWheel','Error building .whl file, pip not installed');
    end

    if ~checkNamedModuleInstalled(pyPath, "setuptools")
        error('SPARK_API:createWheel','Error building .whl file');
    end

    if ~checkNamedModuleInstalled(pyPath, "wheel")
        error('SPARK_API:createWheel','Error building .whl file');
    end

    if ~checkNamedModuleInstalled(pyPath, "build")
        error('SPARK_API:createWheel','Error building .whl file');
    end

    command = sprintf('%s -m build -w -n', pyPath);
    [status, cmdout] = system(command);
    if status == 0
        wheel = obj.getWheelFile();
        fprintf("Created .whl file: %s\n", wheel);
    else
        error('SPARK_API:createWheel','Error building .whl file: %s', cmdout);
    end
end


function pyPath = getPython3Path()
    % Returns the path to a Python 3 interpreter
    % If not found or otherwise invalid and empty character vector is returned

    pyPath = '';
    pe = pyenv();

    if strlength(pe.Version) == 0
        fprintf('Python environment debug - START: #####################################:\n')
        disp(pe);
        system("printenv | sort", "-echo");
        fprintf('Python environment debug - END: #####################################:\n')
        warning('SPARK_API:getPython3Path', "Python environment not found by pyenv, Python may not be installed");
    else
        if startsWith(pe.Version, '3')
            if isfile(pe.Executable)
                pyPath = char(pe.Executable);
                % pyPath may have spaces or stray ", remove 1 level if present and add " on both sides
                pyPath = ['"', strip(pyPath, 'both', '"'), '"'];
            else
                warning('SPARK_API:getPython3Path', "Python executable not found: %s", pe.Executable);
            end
        else
            warning('SPARK_API:getPython3Path', "Only Python 3 is supported, found: %s", pe.Version);
        end
    end
end



function tf = checkNamedModuleInstalled(pyPath, modName)
    % Returns true if setupTools is installed otherwise false
    tf = false;

    pipPath = getPipPath(pyPath);
    command = sprintf('%s show %s', pipPath, modName);
    [status, cmdout] = system(command);

    if status ~= 0
        warning('SPARK_API:checkSetupToolsInstalled', "System command: %s failed, returned: %d, %s", command, status, cmdout);
    else
        cmdout = strip(cmdout);
        if contains(cmdout, sprintf('Name: %s', modName))
            tf = true;
        else
            warning('SPARK_API:checkSetupToolsInstalled', ...
                "The setuptools Python package is not installed, to install: %s pip install %s", pyPath, modName);
        end
    end
end


function pipPath = getPipPath(pyPath)

    % First try normal pip
    pipPath = [char(pyPath), ' -m pip'];
    testCmd = [pipPath, ' --version'];
    [status, cmdout] = system(testCmd); %#ok<ASGLU>

    if status == 0
        return;
    end

    % Now try uv pip
    pipPath = 'uv pip';
    testCmd = [pipPath, ' list'];
    [status, cmdout] = system(testCmd); %#ok<ASGLU>

    if status == 0
        return;
    end

    pipPath = '';

end

function tf = checkPipInstalled(pyPath)
    % Returns true if pip is installed otherwise false
    tf = false;

    pipPath = getPipPath(pyPath);
    
    if isempty(pipPath)
        warning('SPARK_API:checkPipInstalled', "Failed to find a pip executable. Tried 'python -m pip' command and 'uv pip'");
    else
        tf = true;
    end
end


function tf = checkPyVersion(pyPath)
    % Check the version returned by a system call to Python is greater than a minimum
    tf = false;

    command = [char(pyPath), ' --version'];
    % Checking version sometimes fails. Give it a chance to try several
    % times
    numTries = 3;
    while numTries > 0
        [status, cmdout] = system(command);
        if status == 0
            numTries = 0; % Leave directly
        else
            fprintf("Bad try, pausing briefly and trying again.\n\t%d : %s\n", status, cmdout);
            numTries = numTries - 1;
            % Short pause
            pause(0.3);
        end
    end

    if status ~= 0
        warning('SPARK_API:checkPyVersion', "System command: %s failed, returned: %d, %s", command, status, cmdout);
    else
        % Expecting cmdout to be of the form: Python 3.8.10
        cmdout = strip(cmdout);
        fields = split(char(cmdout), ' ');
        if numel(fields) ~= 2
            warning('SPARK_API:checkPyVersion', "Expected only 2 fields of the form 'Python' & '3.8.10'");
        else
            if ~startsWith(fields{2}, '3')
                warning("SPARK_API:checkPyVersion", "Only Python 3 is supported, found: %s", fields{2});
            else
                tf = true;
            end
        end
    end
end
