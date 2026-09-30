function tf = configureDBC(options)
    % CONFIGUREDBC Installs Databricks Connect libraries
    % This function downloads required libraries or uses an existing
    % configured Python.
    %
    % The system Python installation must support virtual environments,
    % Python 3 typically supports virtual environments.
    %
    % Python 3.10 is required for 13.3 & 14.3.
    % Python 3.11 is required for 15.4.
    % Python 3.12 is required for 16.4 & 17.3
    %
    % This function expects interactive input.
    %
    % Optional arguments
    %      dbcVersions: Databricks Connect versions to support. A corresponding
    %                   directory is expected in Software/MATLAB/Connect e.g.
    %                   Software/MATLAB/Connect/15.4/
    %                   By default the supported versions in Software/MATLAB/Connect
    %                   are used.
    %
    %  alternativeRepo: URL for an alternative library source e.g. Artifactory.
    %
    % pythonExecutable: Version argument for pyenv command to specify the
    %                   Python used to create the virtual environments.
    %                   Can be used if Python is not found on the system path.
    %
    %       acceptance: Accept default responses to create virtual environments
    %                   and download dependencies.
    %
    %          venvDir: Base directory for optional virtual environment creation
    %                   as an alternative to the default Software/MATLAB/Connect.
    %
    %          verbose: Produce additional output. Default is true.
    %
    % Example:
    %   % Run setup step in a standalone fashion
    %   tf = matlab.databricks.setup.configureDBC();

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments
        options.dbcVersions string {mustBeNonzeroLengthText}
        options.alternativeRepo string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.pythonExecutable string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.acceptance (1,1) logical = false
        options.venvDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    tf = false;

    if options.verbose
        fprintf("Configuring Databricks Connect\n");
    end

    if databricks.internal.isOnDatabricks()
        fprintf("Running on Databricks, skipping configuration.\n");
        fprintf("  Runtime provided Databricks Connect version: %s\n", databricks.internal.databricksConnect.getDBCClientVersion());
        fprintf("  Python version: %s\n", getClientPythonVersion);
        tf = true;
        return;
    end
    
    if options.verbose
        displayDBCLicenseLink();
    end

    % Check if DBC is supported in the architecture
    if ~checkArch()
        return;
    end

    msgCleanUp = onCleanup(@() exitMessage());

    if isfield(options, "pythonExecutable")
        [peValid, workingPE] = setPyEnvFromExeArg(options.pythonExecutable, verbose=options.verbose);
        if ~peValid
            fprintf(2, "Could not configure requested Python Environment: %s\n", options.pythonExecutable);
            return;
        end
    else
        initialPE = pyenv();
        if initialPE.Status == "Loaded"
            workingPE = initialPE;
        elseif initialPE.Status == "NotLoaded"
            workingPE = pyenv(ExecutionMode="OutOfProcess");
        elseif initialPE.Status == "Terminated"
            workingPE = pyenv(ExecutionMode="OutOfProcess");
        else
            fprintf(2, "Unexpected Python Environment Status: %s\n", initialPE.Status)
            return;
        end
    end

    % Validate workingPE
    if isempty(workingPE.Version) || strlength(workingPE.Version) == 0
        fprintf(2, "Uninitialized Python environment:\n");
        disp(workingPE);
        fprintf(2, "Cannot configure Databricks Connect.\n");
        return;
    end

    if ~pyVerSupportedByMATLAB(workingPE.Version)
        fprintf("The currently configured version of Python is: %s\n", workingPE.Version);
        fprintf(2, "Databricks Connect cannot be used with Python versions older than 3.10\n");
        fprintf(2, "or more recent than 3.12.\n");
        fprintf(2, "See: %s.\n", matlab.databricks.internal.docLink("DBConnect"));
        return;
    end

    if startsWith(workingPE.Version, "3.11") && isMATLABReleaseOlderThan("R2023b")
        fprintf(2, "MATLAB releases older than R2023b cannot be used with Python 3.11.\n");
        fprintf(2, "and so cannot support Databricks Connect with 15.x or greater clusters.\n");
        fprintf(2, "See: %s.\n", matlab.databricks.internal.docLink("SupportMatrix"));
        return;
    end

    if startsWith(workingPE.Version, "3.12") && isMATLABReleaseOlderThan("R2024b")
        fprintf(2, "MATLAB releases older than R2024b cannot be used with Python 3.12\n");
        fprintf(2, "and so cannot support Databricks Connect with 16.x or greater clusters.\n");
        fprintf(2, "See: %s.\n", matlab.databricks.internal.docLink("SupportMatrix"));
        return;
    end

    % Check for pip call py.
    if ~matlab.databricks.setup.internal.pyModuleCheck("pip")
        fprintf(2, "The required Python pip package is not installed.\n");
        fprintf(2, "Cannot configure Databricks Connect.\n");
        fprintf(2, "See: %s.\n", matlab.databricks.internal.docLink("DBConnect"));
        return;
    end

    showRequirements(workingPE.Version, workingPE.Executable);

    if isfield(options, "dbcVersions")
        dbcVersions = options.dbcVersions;
    else
        dbcVersions = getDirVersions(databricksRoot("Connect"), workingPE.Version);
    end

    if numel(dbcVersions) == 0
        fprintf("No Databricks Connect versions can be configured using: Python %s\n", workingPE.Version);
        fprintf("See: %s.\n", matlab.databricks.internal.docLink("DBConnect"));
        % No need to ask further questions
        return;
    end

    % Track any failures
    allVenvsOkay = true;
    allDownloadsOkay = true;
    allInstallsOkay = true;

    fprintf("\nPython virtual environments can be used to isolate the requirements of\n");
    fprintf("the Databricks Connect library from the existing Python environment.\n");

    if ~matlab.databricks.setup.internal.pyModuleCheck("virtualenv", verbose=false) &&...
            ~matlab.databricks.setup.internal.pyModuleCheck("venv", verbose=false)
        fprintf("\n");
        fprintf(2, "Neither the Python venv or virtualenv packages are installed.\n");
        fprintf(2, "Python virtual environments cannot be created.\n");
        fprintf(2, "See: %s.\n", matlab.databricks.internal.docLink("DBConnect"));
        mkVENVs = false;
    else
        if options.acceptance
            mkVENVs = true;
        else
            prompt = sprintf("\nCreate Python virtual environments for Databricks Connect");
            mkVENVs = matlab.utils.ynQuestion(prompt, "Y");
        end
    end

    if ~mkVENVs
        fprintf("\nWhen not creating virtual environment(s) Databricks Connect requires that\n");
        fprintf("the Python environment to be used by MATLAB for Databricks Connect be configured\n");
        fprintf("independently and has the 'databricks-connect', 'build' and 'wheel' packages installed.\n");
        fprintf("pip requirements.txt files can be found in: %s\n", databricksRoot("Connect", "<Version>"));
        fprintf("See: %s.\n", matlab.databricks.internal.docLink("DBConnect"));
        fprintf("& %s\n", matlab.utils.URL2Link("https://docs.databricks.com/aws/en/dev-tools/databricks-connect/python/install#install-the-databricks-connect-client-with-venv"));
        fprintf("\n");
        fprintf("The MATLAB Python environment is configured using pyenv().\n");
        fprintf("See: %s\n", matlab.utils.URL2Link("https://www.mathworks.com/help/matlab/ref/pyenv.html"));
        % No need to ask further questions, return false
        return;
    end

    for n = 1:numel(dbcVersions)
        if isfield(options, "venvDir")
            venvDir = fullfile(options.venvDir, dbcVersions(n), "venv");
        else
            venvDir = databricksRoot("Connect", dbcVersions(n), "venv");
        end
        if ~matlab.databricks.setup.internal.dbcCreateVenv(pe=workingPE, version=dbcVersions(n), venvDir=venvDir)
            fprintf(2, "Databricks Connect virtual environment creation failed for version: %s\n", dbcVersions(n));
            allVenvsOkay = false;
            continue;
        end
        if ispc
            pythonCmd = databricksRoot("Connect", dbcVersions(n), "venv", "Scripts", "python.exe");
        else
            pythonCmd = databricksRoot("Connect", dbcVersions(n), "venv", "bin", "python");
        end

        % Get a versioned list of packages
        requirementsFile = databricksRoot("Connect", dbcVersions(n), "requirements.txt");
        whlsDir = databricksRoot("Connect", dbcVersions(n), "downloads");
        fprintf("Downloading required packages for version: %s\n", dbcVersions(n));
        args = matlab.utils.addArgs(options, ["alternativeRepo", "verbose"]);
        if ~matlab.databricks.setup.internal.pipDownload(requirementsFile, whlsDir, "pythonCmd", pythonCmd, args{:})
            allDownloadsOkay = false;
            continue;
        end

        % Install whls in venv
        fprintf("Installing Databricks Connect package version: %s.\n", dbcVersions(n));
        if ~matlab.databricks.setup.internal.pipInstallFromDir(requirementsFile, whlsDir, "pythonCmd", pythonCmd, verbose=options.verbose)
            allInstallsOkay = false;
            continue;
        end
    end

    if ~allVenvsOkay
        fprintf(2, "A problem was encountered when creating virtual environments.\n");
        return;
    end
    if ~allDownloadsOkay
        fprintf(2, "A problem was encountered when downloading Databricks Connect packages.\n");
        return;
    end
    if ~allInstallsOkay
        fprintf(2, "A problem was encountered when installing Databricks Connect packages.\n");
        return;
    end

    tf = allVenvsOkay && allDownloadsOkay && allInstallsOkay;
end


function versions = getDirVersions(connectDir, pyVer)
    arguments
        connectDir string {mustBeTextScalar, mustBeNonzeroLengthText}
        pyVer string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if ~isfolder(connectDir)
        error("Connect directory not found: %s", connectDir);
    end

    dirStruct = dir(connectDir);
    versions = string.empty;
    verPat = digitsPattern(2) + "." + digitsPattern(1);
    for n = 1:numel(dirStruct)
        if dirStruct(n).isdir && matches(dirStruct(n).name, verPat)
            if pyVerDBCVerMatch(pyVer, dirStruct(n).name)
                fullPrompt = sprintf("Enable support for version: %s? Y/N [Y]: ", dirStruct(n).name);
                reply = strip(input(fullPrompt, 's'));
                if strlength(reply) == 0
                    reply = 'y';
                end
                if strcmpi(reply, 'y')
                    versions(end+1) = string(dirStruct(n).name); %#ok<AGROW>
                end
            else
                fprintf("Cannot enable support for Databricks Connect: %s using: Python %s\n", dirStruct(n).name, pyVer)
            end
        end
    end
end


function showRequirements(currPython, pythonExe)
    arguments
        currPython string = string.empty
        pythonExe string = string.empty
    end

    if numel(currPython) > 1
        fprintf(2, "Expected current Python version value to be empty or a scalar string.\n")
        return;
    end

    pkgSettings = matlab.databricks.internal.pkgsettings.getPkgSettings;
    runtime = string.empty;
    python = string.empty;
    for n = 1:numel(pkgSettings.supportedDatabricksRuntimes)
        runtime(end+1, 1) = pkgSettings.supportedDatabricksRuntimes(n).version; %#ok<AGROW>
        python(end+1, 1) = pkgSettings.supportedDatabricksRuntimes(n).pythonVersion; %#ok<AGROW>)
    end
    connect = runtime;

    if isempty(currPython)
        supported = false(height(python),1);
    else
        supported = strcmp(python, currPython);
    end

    T = table(runtime, connect, python, supported,...
        VariableNames={'Databricks Runtime', 'Databricks Connect', 'Required Python', 'Supported by current Python'});
    outerT = table(T,'VariableNames',{'Databricks Runtimes & Connect Python requirements'}); % Nested table

    disp(outerT)
    fprintf("\n");
    if isempty(currPython)
        fprintf("Python is not currently configured.\n");
    else
        fprintf("The currently configured version of Python is: %s\n", currPython);
    end

    if isMATLABReleaseOlderThan("R2023b")
        fprintf(2, "To use Python 3.11, MATLAB R2023b or newer is required.\n");
    end

    if isMATLABReleaseOlderThan("R2024b")
        fprintf(2, "To use Python 3.12, MATLAB R2024b or newer is required.\n");
    end

    % R2026a support is the same as 24b
    % No Databricks requirement for 3.13 yet

    fprintf("\n");
    if ~isempty(pythonExe)
        fprintf("To set/reset MATLAB to use this environment at any time use:\n");
        fprintf('  pe = pyenv(Version="%s")\n\n', pythonExe);
    end
    fprintf("To rerun this setup step with an alternative Python use:\n");
    fprintf("  matlab.databricks.setup.configureDBC()\n");
    fprintf("The named argument 'pythonExecutable' can be used to set a path\n");
    fprintf("to a specific python executable which may not be on the system path.\n");
    fprintf("\n");
end


function exitMessage()
    fprintf("\nFor more information see:\n");
    fprintf("  %s\n", matlab.databricks.internal.docLink("DBConnect"));
    fprintf("  %s\n", matlab.databricks.internal.docLink("DBConnectWorkflow"));
    fprintf("  %s\n", matlab.databricks.internal.docLink("SupportMatrix"));
    fprintf("\n");
end


function tf = pyVerDBCVerMatch(pyVer, dbcVer)
    arguments
        pyVer string {mustBeTextScalar}
        dbcVer string {mustBeTextScalar, mustBeNonzeroLengthText}
    end

    if strlength(pyVer) == 0
        tf = false;
        return;
    end

    if startsWith(pyVer, "3.10") && (startsWith(dbcVer, "13.") || startsWith(dbcVer, "14."))
        tf = true;
    elseif startsWith(pyVer, "3.11") && startsWith(dbcVer, "15.")
        tf = true;
    elseif startsWith(pyVer, "3.12") && (startsWith(dbcVer, "16.") || startsWith(dbcVer, "17.") || startsWith(dbcVer, "18."))
        tf = true;
    else
        tf = false;
    end
end


function tf = pyVerSupportedByMATLAB(pyVer)
    arguments
        pyVer string {mustBeTextScalar}
    end

    if strlength(pyVer) == 0
        tf = false;
        return;
    end
    % DBR 16 & 17 use Python 3.12, DBR 15 uses Python 3.11, DBR 13 & 14 use Python 3.10
    if startsWith(pyVer, "3.10") || startsWith(pyVer, "3.11")  || startsWith(pyVer, "3.12")
        tf = true;
    else
        tf = false;
    end
end


% Unused for now
function peReset(initialPEExe, workingPE, options) %#ok<DEFNU>
    arguments
        initialPEExe string
        workingPE  matlab.pyclient.PythonEnvironment
        options.verbose (1,1) logical = true
    end

    if ~isempty(initialPEExe) && strlength(initialPEExe) > 0
        if workingPE.ExecutionMode == "OutOfProcess" || workingPE.Status == "NotLoaded"
            terminate(workingPE);
            pyenv(Version=initialPEExe);
        else
            fprintf(2, 'Current Python Environment execution mode is not: "OutOfProcess" or "InProcess" and "NotLoaded"\n');
            fprintf(2, 'thus it cannot be terminated, restart MATLAB to change the Python Environment.\n');
        end
    else
        if options.verbose
            fprintf(2, "A Python Environment to revert to has not been provided, retaining existing environment.");
        end
    end
end


function displayDBCLicenseLink()
    licensePath = databricksRoot(-2, "3rdPartyLicenses", "databricks-connect", "DBCONNECT_LICENSE.txt");
    if isfile(licensePath)
        fprintf("Databricks Connect license: %s\n", matlab.utils.editLink(licensePath));
    else
        fprintf(2, "Databricks Connect license not found: %s\n", licensePath);
    end
end


function tf = checkArch()
    tf = true;
    arch = string(computer('arch'));
    if strcmp(arch, "maci64")
        fprintf(2, "Databricks Connect is not currently supported on the Apple Intel architecture: %s\n", arch);
        if matlab.utils.internal.isAppleSilicon()
            fprintf("This release of MATLAB is the Apple Intel release running via Rosetta.\n");
        end
        fprintf("A native Apple silicon release of MATLAB is available for R2023b and later.\n");
        tf = false;
    end

    if ~(strcmp(arch, "maca64") || strcmp(arch, "glnxa64") || strcmp(arch, "win64"))
        fprintf(2, "Databricks Connect is not supported on the current architecture: %s\n", arch);
        tf = false;
    end
end


function [tf, pe] = setPyEnvFromExeArg(pythonExecutable, options)
    arguments
        pythonExecutable string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end

    if options.verbose
        fprintf("Checking specified Python path: %s\n", pythonExecutable);
    end

    % Get the current python env
    initialPE = pyenv();

    % Using an alternative Python need to change to it
    if ~isfile(pythonExecutable)
        fprintf(2, "Specified Python executable not found: %s\n", pythonExecutable);
        tf = false;
        pe = initialPE;
        return;
    end


    % If the current Python environment does not match that requested
    % then try to configure the requested one
    if ~strcmp(pythonExecutable, initialPE.Executable)
        % Initial sanity check
        if initialPE.ExecutionMode ~= "OutOfProcess" || initialPE.ExecutionMode ~= "InProcess"
            fprintf(2, "Unexpected Python Environment ExecutionMode: %s\n", initialPE.ExecutionMode)
            tf = false;
            pe = initialPE;
            return;
        end

        switch initialPE.Status
            case "Loaded"
                % Python not yet loaded, configure the requested one
                if initialPE.ExecutionMode == "OutOfProcess"
                    if options.verbose
                        fprintf("Terminating existing Python environment: %s\n", initialPE.Executable);
                    end
                    terminate(initialPE);
                    if options.verbose
                        fprintf("Setting Python environment to: %s\n", options.pythonExecutable);
                    end
                    newPE = pyenv(Version=options.pythonExecutable);
                else
                    fprintf(2, 'The current Python Environment is loaded with execution mode: "InProcess"\n');
                    fprintf(2, 'thus it cannot be terminated, restart MATLAB to change the Python Environment\n');
                    fprintf(2, 'with: pe = pyenv(Version="%s")\n', options.pythonExecutable);
                    tf = false;
                    pe = initialPE;
                    return;
                end

            case "NotLoaded"
                if options.verbose
                    fprintf("Terminating existing Python environment: %s\n", initialPE.Executable);
                end
                terminate(initialPE);
                if options.verbose
                    fprintf("Setting Python environment to: %s\n", pythonExecutable);
                end
                newPE = pyenv(Version=pythonExecutable);

            case "Terminated"
                if initialPE.ExecutionMode == "OutOfProcess"
                    newPE = pyenv(Version=pythonExecutable);
                else
                    fprintf(2, 'The current Python Environment is loaded with execution mode: "InProcess"\n');
                    fprintf(2, 'thus it cannot be terminated, restart MATLAB to change the Python Environment\n');
                    fprintf(2, 'with: pe = pyenv(Version="%s")\n', pythonExecutable);
                    tf = false;
                    pe = initialPE;
                    return;
                end

            otherwise
                fprintf(2, "Unexpected Python Environment Status: %s\n", initialPE.Status)
                tf = false;
                pe = initialPE;
                return;
        end
        tf = false;
        pe = newPE;
    else
        tf = true;
        pe = initialPE;
    end
end