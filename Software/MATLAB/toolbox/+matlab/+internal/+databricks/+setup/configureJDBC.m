function tf = configureJDBC(options)
    % CONFIGUREJDBC Configures the path to the Databricks JDBC driver
    % The Databricks JDBC driver is not bundled with this package and must be
    % downloaded separately. This function prompts the user to provide the
    % path to their downloaded driver.
    %
    % The jarFilePath is persisted to the databricks-settings.json file.
    %
    % Returns false if the driver path is not provided or is invalid.
    %
    % Example
    %   tf = matlab.internal.databricks.setup.configureJDBC();
    %
    %   % Non-interactive:
    %   tf = matlab.internal.databricks.setup.configureJDBC(jarFilePath="C:\drivers\DatabricksJDBC.jar");

    % Copyright 2024-2026 The MathWorks, Inc.

    arguments (Input)
        options.jarFilePath string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.verbose (1,1) logical = true
    end
    arguments (Output)
        tf (1,1) logical
    end

    % Resolve the JDBC driver jar file path
    if isfield(options, "jarFilePath")
        jarPath = validateAndSaveJarPath(strip(options.jarFilePath), options.verbose);
    else
        jarPath = promptForJarFilePath(options.verbose);
    end

    tf = ~isempty(jarPath) && strlength(jarPath) > 0;
end


function jarPath = validateAndSaveJarPath(jarPath, verbose)
    % Validates that the jar file exists and persists the path to settings.
    % Returns the path if valid, or empty string if not.
    if ~isfile(jarPath)
        fprintf(2, "File not found: %s\n", jarPath);
        jarPath = "";
        return;
    end

    % We want to prompt the user to resolve the compatibility issue for
    % Simba drivers with Java >=11. This requires a change to java.opts and
    % a MATLAB restart. We'll prompt the user to do this if the driver +
    % Java versions require it.

    javaInfo = jenv;
    fullVersion = javaInfo.Version;
    java8Regexp = "(?<!(\d|\.))1\.8"; %This matches 1.8 not proceeded by other digits or decimals
    
    %Version number format changes between 8 and later. For version 8, the number should contain (1.8) 
    %If it doesn't we can asume we're in a Java version greater than 8
    if isempty(regexp(fullVersion,java8Regexp,'once'))
        %Check the major version to know if it's Simba (2.X)
        try
            javaaddpath(jarPath);
            driver = javaObject("com.databricks.client.jdbc.Driver");
            majorVersion = driver.getMajorVersion();

            if majorVersion <= 2
                fprintf("\nSimba Databricks JDBC driver with a Java version greater than 8 detected.\n");
                fprintf("For compatibility reasons, the following configuration argument must be passed to Java:\n")
                fprintf("--add-opens java.base/java.nio=ALL-UNNAMED\n");
                fprintf("To configure Java startup options using java.opts, see:\n");
                fprintf("  %s\n", matlab.internal.utils.URL2Link("https://www.mathworks.com/help/matlab/matlab_env/java-opts-file.html"));
                fprintf("Restart MATLAB after making these changes for them to take effect.\n\n");
            end
        catch
            %If the java error out, assume no java 
        end
        
    end

    databricks.internal.settings.Settings.writeDatabricksSettingsFields(jarFilePath=jarPath, verbose=false);
    if verbose
        fprintf("JDBC driver path saved to settings: %s\n", jarPath);
    end
end


function jarPath = promptForJarFilePath(verbose)
    % Check if a valid jarFilePath is already configured in settings
    existingPath = databricks.internal.settings.Settings.getSettingsField("jarFilePath");
    if ~isempty(existingPath) && strlength(existingPath) > 0 && isfile(existingPath)
        if verbose
            fprintf("JDBC driver already configured: %s\n", existingPath);
        end
        reply = strip(input('Replace the currently configured JDBC driver? Y/N [N]: ','s'));
        if strcmpi(reply,"n") || strlength(reply) == 0
            jarPath = existingPath;
            return;
        end
    end

    % Prompt the user to download and provide the driver path
    fprintf("\nThe Databricks JDBC driver is not bundled with this package.\n");
    fprintf("Please download it from:\n");

    %Decide which driver to provide a link to based on the Java version
    javaInfo = jenv;
    fullVersion = javaInfo.Version;
    java8Regexp = "(?<!(\d|\.))1\.8"; %This matches 1.8 not proceeded by other digits or decimals
    if isempty(regexp(fullVersion,java8Regexp,'once'))
        downloadurl = "https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/jdbc/3.4.3/DatabricksJDBC-3.4.3.zip";
    else
        downloadurl = "https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/jdbc/2.8.4/DatabricksJDBC42-2.8.4.1033.zip";
    end
    fprintf("  %s\n\n", matlab.internal.utils.URL2Link(downloadurl));


    userInput = strip(input('Enter the full path to the downloaded JDBC driver .jar file: ', 's'));

    if isempty(userInput) || strlength(userInput) == 0
        fprintf(2, "No path provided.\n");
        jarPath = "";
        return;
    end

    jarPath = validateAndSaveJarPath(userInput, verbose);
end