function tf = isAptPermittedOnCluster(options)
    % isAptPermittedOnCluster Returns true if a cluster can run "apt-get update"

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.timeout int32 {mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 30
        options.silent (1,1) logical = false
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end
   
    if ~options.silent
        fprintf("Checking if cluster supports Apt access\n");
    end

    args = matlab.utils.addArgs(options, ["clusterId", "timeout", "authMethod", "profileName"]);
    [returnCode, ~, ~] = databricks.internal.commandexecution.executePythonSubprocess(["apt-get", "update", "-o", "Dir::Etc::SourceParts=/tmp/nonexistantDir"], args{:});

    if strcmp(returnCode,"0")
        tf = true;
        if ~options.silent
            fprintf("Cluster supports Apt access\n");
        end
    else
        if ~options.silent
            fprintf("Cluster does not support Apt access\n");
        end
        tf = false;
    end
end

