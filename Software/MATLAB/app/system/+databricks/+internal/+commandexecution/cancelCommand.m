function tf = cancelCommand(commandId, contextId, options)
    % CANCELCOMMAND Cancels a command
    % Returns a logical.
    %
    % Example:
    %   result = databricks.internal.commandexecution.cancelCommand(commandId, contextId);

    % Copyright MathWorks Inc. 2025

    arguments
        commandId string {mustBeTextScalar, mustBeNonzeroLengthText}
        contextId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
        options.verbose (1,1) logical = true
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    commandExecution = databricks.CommandExecution(args{:});
    
    if isfield(options, 'clusterId')
        clusterId = options.clusterId;
    else
        args = matlab.utils.addArgs(options, ["verbose", "profileName"]);
        clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id", args{:});
    end

    if ~strlength(clusterId) > 0
        error("databricks:getCommandStatus", "Cluster ID value is not defined, it must be provided either as an argument or via credentials as an environment variable or the databricks-settings.json file.");
    end

    cancelRequest = databricks.datastructures.commandexecution.CancelRequest;
    cancelRequest.clusterId = clusterId;
    cancelRequest.contextId = contextId;
    cancelRequest.commandId = commandId;
    
    try
        cancelResponse = commandExecution.cancel(cancelRequest);
        if cancelResponse
            tf = true;
        else
            tf = false;
        end
    catch
        tf = false;
    end
end