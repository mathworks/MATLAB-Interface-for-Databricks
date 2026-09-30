function pyPath = getVenvPythonPath(version, options)
    % GETVENVPYTHONPATH Get a path to for a python3.x in the corresponding venv
    % Searches the Software/MATLAB/Connect/<major>.<minor>/venv directory
    % Returns a pythonw.exe path on Windows.
    % Returns a python3 path on Linux & macOS.
    % Returns and empty string if a Python is not found.

    arguments
        version string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    pyPath = string.empty;

    fields = split(version, ".");
    major = double(string(fields{1}));

    if numel(fields) > 1
        minor = double(string(fields{2}));
    else
        minor = 0;
    end
    majorDotMinorStr = sprintf("%d.%d", major, minor);

    connectVersionDir = databricksRoot("Connect", majorDotMinorStr);
    if ~isfolder(connectVersionDir)
        if options.verbose
            fprintf(2, "Databricks Connect client directory not found: %s\n", connectVersionDir);
            fprintf(2, "Checking for alternative latest minor version match.\n");
        end
        result = findLatestMajorMatch(major);
        if ~isempty(result)
            connectVersionDir = databricksRoot("Connect", result);
            if options.verbose
                fprintf("Found: %s\n", connectVersionDir);
            end
        else
            if options.verbose
                fprintf(2, "No matching major version found.\n");
            end
            return;
        end
    end

    if ispc
        venvBinDir = fullfile(connectVersionDir, "venv", "Scripts");
        venvPython3 = fullfile(venvBinDir, "pythonw.exe");
    else
        venvBinDir = fullfile(connectVersionDir, "venv", "bin");
        venvPython3 = fullfile(venvBinDir, "python3");
    end
    if ~isfolder(venvBinDir)
        if options.verbose
            if ispc
                fprintf(2, "Databricks Connect client venv%sScripts directory not found: %s\n", filesep, venvBinDir);
            else
                fprintf(2, "Databricks Connect client venv%sbin directory not found: %s\n", filesep, venvBinDir);
            end
        end
        return;
    end

    if ~isfile(venvPython3)
        if options.verbose
            if ispc
                fprintf(2, "Databricks Connect client venv pythonw.exe file not found: %s\n", filesep, venvPython3);
            else
                fprintf(2, "Databricks Connect client venv python3 file not found: %s\n", filesep, venvPython3);
            end
        end
    else
        pyPath = venvPython3;
    end
end


function result = findLatestMajorMatch(major)
    % FINDLATESTMAJORMATCH Return highest major.minor number directory for a given major number
    % Searches the Software/MATLAB/Connect/<major>.<minor> directory.
    % Returns and empty string if no result is found.

    arguments
        major (1,1) double
    end

    result = string.empty;

    dirGlob = databricksRoot("Connect") + filesep + string(major) + ".*";
    globList = dir(dirGlob);
    dirNames = string.empty;
    for n = 1:numel(globList)
        if globList(n).isdir
            dirNames(end+1) = globList(n).name; %#ok<AGROW>
        end
    end
    if numel(dirNames) == 0
        return;
    end
    sortedDirNames = databricks.internal.databricksConnect.sortDBVersions(dirNames);
    result = sortedDirNames(end);
end
