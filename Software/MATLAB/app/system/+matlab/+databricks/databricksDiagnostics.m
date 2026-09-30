function result = databricksDiagnostics(options)
    % DATABRICKSDIAGNOSTICS Run diagnostics for MATLAB Interface for Databricks
    % Returns false if any potential issues are detected otherwise true.
    % Output is useful for initial tech support diagnostics.
    %
    % Example:
    %   tf = matlab.databricks.databricksDiagnostics()

    %  (c) 2026 MathWorks, Inc.

    arguments
        options.verbose (1,1) logical = true
    end

    result = true;

    printBanner("Running MATLAB Interface for Databricks Diagnostics", leadingNewline=true, verbose=options.verbose);

    if options.verbose
        fprintf("MATLAB: %s, Architecture: %s, Package version: %s\n",  matlabRelease().Release, computer, matlab.databricks.databricksPackageVersion());
    end

    % Check for JVM and >= 19b
    % The default value for the JVM is true i.e. required, otherwise use the provided value
    if ~usejava('jvm')
        fprintf(2, 'MATLAB must be used with the JVM enabled.\n');
        result = false;
    end
    if verLessThan('matlab', '9.13') %#ok<VERLESSMATLAB>
        fprintf(2, 'This package requires MATLAB R2022b or later.\n');
        result = false;
    end

    printBanner("Checking for settings for duplicate paths.", verbose=options.verbose);
    if detectDuplicatePaths()
        result = false;
    end

    printBanner("Checking preferences directory.", verbose=options.verbose);
    pd = prefdir;
    if ~isfolder(pd)
        fprintf(2, "Preferences directory does not exist: %s\n", pd);
        result = false;
    end

    % Sanity check possible home directories once paths are set
    printBanner("Checking home directory.", verbose=options.verbose);
    nonJavaHomeDir = char(matlab.utils.getHomeDirectory());
    userDir = getUserHomeDirectory(verbose=options.verbose);
    if ~strcmp(userDir, nonJavaHomeDir)
        fprintf(2, "Home directory mismatch\nJava result: %s, matlab.utils.getHomeDirectory result: %s", userDir, nonJavaHomeDir);
        result = false;
    end

    printBanner("Checking for settings file: databricks-settings.json", verbose=options.verbose);
    if ~isfileValidated(databricks.internal.settings.Settings.getSettingsFileReadPath)
        fprintf(2, "No settings file found.\n");
        result = false;
    end

    printBanner("Checking for configuration file: .databrickscfg", verbose=options.verbose);
    if ~databricks.internal.configurationprofile.ConfigFile.isDatabricksCfgFile
        fprintf(2, "Required .databrickscfg file configuration file was not found\n");
        result = false;
    end

    % Check JDBC jar files
    printBanner("Checking Databricks JDBC drivers", verbose=options.verbose);
    jdbcOSSJarFile = databricksRoot("lib", "jar", "Databricks-JDBC-OSS-Driver-0.0.1.jar");
    % Until shipping the driver skip the reporting
    % if isfile(jdbcOSSJarFile)
    %     fprintf('Found Databricks JDBC OSS driver: %s\n', jdbcOSSJarFile);
    % else
    %     fprintf(2, "Databricks JDBC OSS driver not found in: %s\n", databricksRoot("lib", "jar"));
    % end
    jdbcJarFile = databricksRoot("lib", "jar", "Shaded-Databricks-JDBC-Driver-0.0.2.jar");
    if isfile(jdbcJarFile)
        if options.verbose
            fprintf('Found Databricks JDBC driver: %s\n', jdbcJarFile);
        end
    else
        fprintf(2, "Databricks JDBC driver not found in: %s\n", databricksRoot("lib", "jar"));
        result = false;
    end

    % Check for legacy Databricks Connect jars
    if matlab.databricks.setup.internal.checkDBCJCP()
        result = false;
    end

    % Report if the key toolboxes Compiler, Compiler SDK or Database are missing
    if ~checkToolboxes(verbose=options.verbose)
        result = false;
    end

    printBanner("DBFS transfers", verbose=options.verbose);
    reportBase64Mode(verbose=options.verbose);

    printBanner("Checking for updates", verbose=options.verbose);
    if databricks.internal.utils.newVersionCheck(forceCheck=true, verbose=options.verbose)
        result = false;
    end

    if ~checkDATABRICKS_ORG_IDenvVar()
        result = false;
    end

    if ~checkOnDatabricksSparkModeSetting(verbose=options.verbose)
        result = false;
    end

    % Display a summary Table
    if options.verbose
        printBanner(sprintf("Package requirements summary, version: %s:", matlab.databricks.databricksPackageVersion));
        summaryTable = createSummaryTable(jdbcJarFile, jdbcOSSJarFile);
        disp(summaryTable);
    end

    docMessage(verbose=options.verbose);

    if ~result && options.verbose
        fprintf(2, "Diagnostics detected a potential issue, see: matlab.databricks.databricksDiagnostics\n");
    end
end


function outPath = removePathPrefix(inPath)
    % removePathPrefix Strip path elements preceding the given value
    arguments
        inPath string
    end

    if isempty(inPath)
        inPath = "";
    end

    prefix = string(databricksRoot(-2));
    if startsWith(inPath, prefix)
        outPath = "." + inPath.extractAfter(prefix);
    else
        outPath = inPath;
    end
end


function result = javaPathType(str)
    % javaPathType Return which if any Java path a jar is on
    arguments
        str string
    end

    if isempty(str)
        result = "None";
        return;
    end

    if ~isStringScalar(str)
        error('DATABRICKS:STARTUP', 'Expected scalar Java path value');
    end

    if strlength(str) > 0
        dynamicP = javaclasspath('-dynamic');
        onDynamic = any(contains(dynamicP, str));

        staticP = javaclasspath('-static');
        onStatic = any(contains(staticP, str));

        if onStatic && onDynamic
            result = "Both";
        elseif onStatic
            result = "Static";
        elseif onDynamic
            result = "Dynamic";
        else
            result = "None";
        end
    else
        result = "None";
    end
end


function depTable = createSummaryTable(jdbcJarFile, jdbcOSSJarFile)
    % createSummaryTable Create a table to display a dependency summary in the startup output
    arguments
        jdbcJarFile (1,1) string = ""
        jdbcOSSJarFile (1,1) string = ""
    end

    % Initialize table and add row
    rowVals = {"Databricks JDBC Driver", isfileValidated(jdbcJarFile), javaPathType(jdbcJarFile), removePathPrefix(jdbcJarFile)};
    depTable = table(rowVals{:}, 'VariableNames', {'Name', 'Present', 'Javapath', 'Location'});

    rowVals = {"Databricks JDBC OSS Driver", isfileValidated(jdbcOSSJarFile), javaPathType(jdbcOSSJarFile), removePathPrefix(jdbcOSSJarFile)};
    depTable(end+1,:) = table(rowVals{:});

    rowVals = {"Database Toolbox", ~isempty(ver('database')), "N/A", string(matlab.utils.toolboxDir('database'))};
    depTable(end+1,:) = table(rowVals{:});

    rowVals = {"MATLAB Compiler", ~isempty(ver('compiler')), "N/A", string(matlab.utils.toolboxDir('compiler'))};
    depTable(end+1,:) = table(rowVals{:});

    rowVals = {"MATLAB Compiler SDK", ~isempty(ver('compiler_sdk')), "N/A", string(matlab.utils.toolboxDir('compiler_sdk'))};
    depTable(end+1,:) = table(rowVals{:});

    if ~isempty(ver('simulinkcompiler'))
        rowVals = {"Simulink Compiler", true, "N/A", string(matlab.utils.toolboxDir('simulinkcompiler'))};
        depTable(end+1,:) = table(rowVals{:});
    end

    rowVals = {"MATLAB Coder", ~isempty(ver('matlabcoder')), "N/A", string(matlab.utils.toolboxDir('matlabcoder'))};
    depTable(end+1,:) = table(rowVals{:});

    rowVals = {"Simulink Coder", ~isempty(ver('simulinkcoder')), "N/A", string(matlab.utils.toolboxDir('simulinkcoder'))};
    depTable(end+1,:) = table(rowVals{:});

    rowVals = {"Embedded Coder", ~isempty(ver('embeddedcoder')), "N/A", string(matlab.utils.toolboxDir('embeddedcoder'))};
    depTable(end+1,:) = table(rowVals{:});
end


function docMessage(options)
    arguments
        options.verbose (1,1) logical = true
    end

    if ~options.verbose
        return;
    end

    fprintf("\n");
    docPath = databricksRoot(-2, "Documentation", "html", "index.html");
    fprintf("For support contact: databricks@mathworks.com\n")
    if isfile(docPath)
        fprintf("For documentation in HTML format see:\n")
        fprintf("  %s\n", matlab.utils.URL2Link(docPath));
    else
        fprintf("For documentation in Markdown format see:\n");
        fprintf("  %s\n", matlab.utils.editLink(databricksRoot(-2, "Documentation", "README.md")));
    end
end


function tf = checkDATABRICKS_ORG_IDenvVar()
    arguments (Output)
        tf (1,1) logical
    end
    tf = true;

    ev = getenv("DATABRICKS_ORG_ID");
    if ~isempty(ev)
        fprintf("\n");
        fprintf("Checking DATABRICKS_ORG_ID\n");
        fprintf("--------------------------\n");
        fprintf(2, "The DATABRICKS_ORG_ID environment variable is set to: %s\n", ev);
        fprintf(2, "This is not supported under Unified Authentication and will be ignored.\n");
        fprintf(2, "The org_id field is set only in the .databrickscfg file see:\n  %s\n", matlab.databricks.internal.docLink("Authentication"));
        tf = false;
    end
end

function tf = checkOnDatabricksSparkModeSetting(options)
    arguments
        options.verbose (1,1) logical = true
    end

    tf = true;
    % This setting must be active when MATLAB is run on a Databricks cluster
    if databricks.internal.isOnDatabricks()
        if ~strcmpi(getenv('SPARK_CONNECT_MODE_ENABLED'), '1')
            tf = false;
            if options.verbose
                fprintf(2, "MATLAB is running on a Databricks cluster. " + ...
                "In this case Databricks Connect requires that the SPARK_CONNECT_MODE_ENABLED " + ...
                "environment variable be set to '1'.\n");
            end
        end
    end

end


function result = isfileValidated(filename)
    arguments
        filename string
    end
    % allow for paths being string.empty
    if isempty(filename)
        result = false;
    elseif ~isStringScalar(filename)
        result = false;
    else
        result = isfile(filename);
    end
end


function printBanner(str, options)
    arguments
        str string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.leadingNewline (1,1) logical = true
        options.verbose (1,1) logical = true
    end

    % Don't print anything if not verbose
    if ~options.verbose
        return;
    end

    if options.leadingNewline
        fprintf("\n");
    end
    disp([char(str), newline,repmat('-',1,strlength(str))]);
end


function reportBase64Mode(options)
    % reportBase64Mode Report which base64 encoder is used
    arguments
        options.verbose (1,1) logical = true
    end

    mode = matlab.net.base64('getconfig');
    if options.verbose
        if strcmp(mode, 'mex')
            disp('DBFS transfer mode: Optimized (mex)');
        elseif strcmp(mode, 'shipping')
            disp('DBFS transfer mode: Unoptimized');
        else
            disp('DBFS transfer mode: Unknown');
        end
    end
end


function userDir = getUserHomeDirectory(options)
    % getUserHomeDirectory Get the user's home directory
    arguments
        options.verbose (1,1) logical = true
    end

    userDir = char(matlab.utils.getHomeDirectory());
    if strlength(userDir) < 1
        error("DATABRICKS:STARTUP", "Could not determine user's home directory");
    else
        if ~isfolder(userDir)
            error("DATABRICKS:STARTUP", "User's home directory not found: %s", userDir);
        else
            if options.verbose
                fprintf("User home directory: %s\n",userDir);
            end
        end
    end
end


function tf = checkToolboxes(options)
    % checkToolboxes Reports on missing Toolboxes
    % Database Toolbox, MATLAB Compiler & MATLAB Compiler SDK are expected
    % Simulink Compiler is not checked
    arguments (Input)
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end

    tf = true;

    printBanner("Checking Toolboxes", verbose=options.verbose);
    % Don't error or issue 'real' warnings to retain readability
    if isempty(ver('compiler'))
        fprintf(2, "MATLAB Compiler is not installed.\n");
        fprintf(2, "MATLAB code cannot be compiled and deployed to a Databricks Cluster.\n");
        tf = false;
    end

    if isempty(ver('compiler_sdk'))
        fprintf(2, "MATLAB Compiler SDK is not installed.\n");
        fprintf(2, "MATLAB code cannot be compiled and deployed to a Databricks Cluster.\n");
        tf = false;
    end

    if isempty(ver('database'))
        fprintf(2, "Database Toolbox is not installed.\n");
        fprintf(2, "JDBC/ODBC/SQL Warehouse connections cannot be used.\n");
        tf = false;
    end

    % Don't report until feature is further developed
    % if isempty(ver('embeddedcoder'))
    %     if isempty(ver('simulinkcoder'))
    %         if options.verbose
    %             fprintf("Simulink Coder & Embedded Coder are not installed.\n");
    %             fprintf("Code generation from Simulink models cannot be used.\n");
    %         end
    %     end
    % end
end


function tf = detectDuplicatePaths()
    % detectDuplicatePaths Check for duplicate Databricks installations on path
    % Returns true if duplicates found, false otherwise.
    arguments (Output)
        tf (1,1) logical
    end

    tf = false;

    here = fileparts(mfilename("fullpath"));
    dbxRootHere = fullfile(fileparts(fileparts(fileparts(here))), 'functions', 'databricksRoot.m');
    otherDbxRoots = which("-all", "databricksRoot");
    if isempty(otherDbxRoots)
        % No databricksRoot on the path, proceed.
        return;
    end

    otherDbxRootsFiltered = setdiff(otherDbxRoots, dbxRootHere);
    if isempty(otherDbxRootsFiltered)
        % The only databricksRoot in the list was from this folder. Proceed.
        return;
    end

    tf = true;

    fp3 = @(x) fileparts(fileparts(fileparts(x)));
    fprintf(2, "Entries were found on the MATLAB path that indicate that the Databricks Package\n");
    fprintf(2, "is already installed in a different location. This will cause problems and must\n")
    fprintf(2, "be remedied. Only one version/location of the package should be installed at a\n")
    fprintf(2, "time. Other versions can remain on the file system, but there should only be one\n");
    fprintf(2, "at a time on the MATLAB Path\n");
    fprintf(2, "If the MATLAB Path has been saved (using savepath), the other version should be removed,\n");
    fprintf(2, "e.g. using pathtool, and the updated path should be saved. Following this, this startup\n");
    fprintf(2, "file can simply be run again.\n\n");
    fprintf(2, "If the MATLAB paths were not saved (i.e. they do not persist between MATLAB sessions)\n");
    fprintf(2, "an alternative is to just restart MATLAB and not run startup for the other location.\n\n");
    fprintf(2, "Please note that all paths below the paths listed here must be removed recursively.\n");
    fprintf(2, "The following paths are duplicates\n");
    dups = cellfun(fp3, otherDbxRootsFiltered, 'UniformOutput', false);
    fprintf(2, "\t- %s\n", dups{:});
    fprintf(2, "\n");
end


function agentNotice() %#ok<DEFNU>
    % AGENTNOTICE Check the spark.databricks.isv.product Spark property
    if databricks.internal.isOnDatabricks()
        try
            % Use as system call to avoid altering pyenv state at startup
            cmd = 'python -c "from databricks.connect import DatabricksSession as dbs; sess=dbs; s=sess.builder.getOrCreate(); print(s.conf.get(\"spark.databricks.isv.product\"))"';
            [status, cmdOut] = system(cmd);
            if status ~= 0
                WarningText = sprintf("Unable to check Spark property: spark.databricks.isv.product, %s\n", cmdOut);
                fprintf(2, "%s", WarningText);
                assignin("base", "WarningText", WarningText);
            else
                if strlength(cmdOut) > 0
                    if ~contains(cmdOut, "MATLAB/" + digitsPattern(1))
                        ua = databricks.Object.getUserAgent();
                        WarningText = sprintf("Spark Property spark.databricks.isv.product is not set.\n");
                        WarningText = WarningText + sprintf("When creating the cluster set spark.databricks.isv.product to: %s\n", ua);
                        fprintf(2, "%s", WarningText);
                        assignin("base", "WarningText", WarningText);
                    end
                else
                    WarningText = sprintf("Unable to check Spark property spark.databricks.isv.product.\n");
                    fprintf(2, "%s", WarningText);
                    assignin("base", "WarningText", WarningText);
                end
            end
        catch ME
            WarningText = sprintf("Unable to check Spark property spark.databricks.isv.product.\nMessage: %s\n", ME.message);
            fprintf(2, "%s", WarningText);
            assignin("base", "WarningText", WarningText);
        end
    end
end