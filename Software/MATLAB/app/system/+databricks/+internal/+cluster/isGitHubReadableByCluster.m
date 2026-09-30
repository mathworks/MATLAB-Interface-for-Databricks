function tf = isGitHubReadableByCluster(options)
    % isGitHubReadableByCluster returns true if accessing the GitHub returns 200

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        options.githubURL string {mustBeTextScalar, mustBeNonzeroLengthText} = "https://github.com/cdarlint/winutils/raw/master/hadoop-2.7.3/bin/hadoop.dll"
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.timeout int32 {mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 30
        options.silent (1,1) logical = false
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    pyStr = sprintf('import urllib; print(urllib.request.urlopen("%s").getcode())', githubURL);
    
    if ~options.silent
        fprintf("Checking fif GitHub is readable from the cluster\n");
    end

    % fprintf("Executing: %s\n", pyStr);
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "clusterId", "timeout"]);
    httpCode = databricks.internal.commandexecution.executePythonCommand(pyStr, args{:});

    % 200 is the return value from getcode in: 'import urllib; print(urllib.request.urlopen("%s").getcode())'
    if strcmp(strip(httpCode), "200")
        tf = true;
    else
        tf = false;
    end

    if ~options.silent
        if tf
            fprintf("GitHub.com is readable from the cluster\n");
        else
            fprintf("GitHub.com is not readable from the cluster\n");
        end
    end
end

