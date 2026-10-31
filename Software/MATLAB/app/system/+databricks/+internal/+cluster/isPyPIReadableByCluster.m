function tf = isPyPIReadableByCluster(options)
    % isPyPIReadableByCluster returns true if accessing the https://pypi.org returns 200
    % 

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        options.pypiURL string {mustBeTextScalar, mustBeNonzeroLengthText} = "https://pypi.org/pypi/databricks-connect/json"
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.timeout int32 {mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 30
        options.silent (1,1) logical = false
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName

    end

    if ~options.silent
        fprintf("Checking if cluster supports PyPI access\n");
    end
    pyStr = sprintf('import urllib; print(urllib.request.urlopen("%s").getcode())', options.pypiURL);
    
    % Generally not needed
    % if ~options.silent
    %     fprintf("Executing: %s\n", pyStr);
    % end

    args = {'verbose', false};
    args = matlab.utils.addArgs(options, ["authMethod", "profileName", "clusterId", "timeout"], args);
    httpCode = databricks.internal.commandexecution.executePythonCommand(pyStr, args{:});

    % 200 is the return value from getcode in: 'import urllib; print(urllib.request.urlopen("%s").getcode())'
    tf = strcmp(strip(httpCode), "200");

    if ~options.silent
        if tf
            fprintf("Cluster supports PyPI access\n");
        else
            fprintf("Cluster does not support PyPI access\n");
        end
    end
end

