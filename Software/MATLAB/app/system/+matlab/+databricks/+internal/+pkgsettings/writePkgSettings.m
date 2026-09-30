function writePkgSettings
    % WRITEPKGSETTINGS Write a JSON file with package settings
    % Build the JSON from a MATLAB struct.
    % The JSON file Software/MATLAB/config/package-settings.json
    % is the "source of truth" not this file which is just used to bootstrap the
    % JSON content during execution.
    %
    % Example
    %    matlab.databricks.internal.pkgsettings.writePkgSettings

    % Copyright 2024-2026 The MathWorks, Inc.

    settingsFile = databricksRoot("config", "package-settings.json");

    s = struct;

    s.defaultDatabricksRuntime = "17.3";
    s.supportedDatabricksRuntimes(1).version = "18.3";
    s.supportedDatabricksRuntimes(2).version = "17.3";
    s.supportedDatabricksRuntimes(3).version = "16.4";
    s.supportedDatabricksRuntimes(4).version = "15.4";
    s.supportedDatabricksRuntimes(5).version = "14.3";
    s.supportedDatabricksRuntimes(6).version = "13.3";
    
    s.supportedDatabricksRuntimes(1).pythonVersion = "3.12";
    s.supportedDatabricksRuntimes(2).pythonVersion = "3.12";
    s.supportedDatabricksRuntimes(3).pythonVersion = "3.12";
    s.supportedDatabricksRuntimes(4).pythonVersion = "3.11";
    s.supportedDatabricksRuntimes(5).pythonVersion = "3.10";
    s.supportedDatabricksRuntimes(6).pythonVersion = "3.10";
    
    s.supportedMATLABReleases(1).release = "R2026b";
    s.supportedMATLABReleases(2).release = "R2026a";
    s.supportedMATLABReleases(3).release = "R2025b";
    s.supportedMATLABReleases(4).release = "R2025a";
    s.supportedMATLABReleases(5).release = "R2024b";
    s.supportedMATLABReleases(6).release = "R2024a";
    s.supportedMATLABReleases(7).release = "R2023b";
    s.supportedMATLABReleases(8).release = "R2023a";
    s.supportedMATLABReleases(9).release = "R2022b";

    s.supportedMATLABReleases(1).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2026b/Prerelease/3/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2026b_Prerelease_Update_3_glnxa64.zip";
    s.supportedMATLABReleases(2).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2026a/Release/5/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2026a_Update_5_glnxa64.zip";
    s.supportedMATLABReleases(3).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2025b/Release/6/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2025b_Update_6_glnxa64.zip";
    s.supportedMATLABReleases(4).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2025a/Release/1/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2025a_Update_1_glnxa64.zip";
    s.supportedMATLABReleases(5).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2024b/Release/9/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2024b_Update_9_glnxa64.zip";
    s.supportedMATLABReleases(6).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2024a/Release/9/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2024a_Update_9_glnxa64.zip";
    s.supportedMATLABReleases(7).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2023b/Release/11/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2023b_Update_11_glnxa64.zip";
    s.supportedMATLABReleases(8).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2023a/Release/8/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2023a_Update_8_glnxa64.zip";
    s.supportedMATLABReleases(9).runtimeURL = "https://ssd.mathworks.com/supportfiles/downloads/R2022b/Release/10/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2022b_Update_10_glnxa64.zip";

    s.jdbcDriverInfo.downloadUrl = "https://databricks-bi-artifacts.s3.us-east-2.amazonaws.com/simbaspark-drivers/jdbc/2.8.3/DatabricksJDBC42-2.8.3.1032.zip";
    s.jdbcDriverInfo.docUrl = "https://databricks.com/spark/jdbc-drivers-download";
    s.jdbcDriverInfo.version = "2.8.3.1032";
    s.jdbcDriverInfo.artifactId = "SparkJDBC42";
    s.jdbcDriverInfo.zip42 = "DatabricksJDBC42-2.8.3.1032.zip";
  
    [fileID, errmsg]  = fopen(settingsFile, 'w');
    if fileID < 0
        error('Error opening file: %s\nMessage: %s\n', settingsFile, errmsg);
    else
        whenDone = onCleanup(@() fclose(fileID));
        fprintf(fileID, "%s", jsonencode(s, "PrettyPrint", true));
    end
end