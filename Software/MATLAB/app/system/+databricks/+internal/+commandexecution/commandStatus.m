function result = commandStatus(commandId, contextId, options)
    % COMMANDSTATUS Returns the status of a command
    % Returns a databricks.datastructures.commandexecution.CommandsStatusStatus enum
    %
    % Example:
    %   result = databricks.internal.commandexecution.commandStatus(commandId, contextId);

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

    commandsStatusResponse = commandExecution.commandsStatus(clusterId, contextId, commandId);

    if isprop(commandsStatusResponse, "status")
        result = databricks.datastructures.commandexecution.CommandsStatusStatus(commandsStatusResponse.status);
    else
        error("databricks:getCommandStatus", "commandsStatusResponse status property not found.");
    end
end