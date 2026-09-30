function [tf, result] = waitForCommandFinished(clusterId, contextId, commandId, timeout, options)
    % waitForCommandFinished Wait until a command status Finished is returned or a timeout elapses
    % True is returned on success otherwise false.
    % The default timeout is 30 seconds.
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        contextId string {mustBeTextScalar, mustBeNonzeroLengthText}
        commandId string {mustBeTextScalar, mustBeNonzeroLengthText}
        timeout int32 {mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 30
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    commandExecution = databricks.CommandExecution(args{:});
    commandsStatusResponse = commandExecution.commandsStatus(clusterId, contextId, commandId);
    
    t = 0;
    tf = false;
    result = string.empty;
    while t <= timeout
        if ~isprop(commandsStatusResponse, 'status')
            warning("databricks:waitForCommandFinished", "status property not found");
            break;
        end

        switch commandsStatusResponse.status
            case databricks.datastructures.commandexecution.CommandsStatusStatus.Finished
                tf = true;
                result = commandsStatusResponse.results.data;
                break;
            
            case {databricks.datastructures.commandexecution.CommandsStatusStatus.Cancelled, databricks.datastructures.commandexecution.CommandsStatusStatus.Cancelling, databricks.datastructures.commandexecution.CommandsStatusStatus.Error}
                break;

            case {databricks.datastructures.commandexecution.CommandsStatusStatus.Queued, databricks.datastructures.commandexecution.CommandsStatusStatus.Running}
                pause(5);
                t = t + 5;
                commandsStatusResponse = commandExecution.commandsStatus(clusterId, contextId, commandId);

            otherwise
                error("databricks:waitForCommandFinished", "Unexpected status value: %s", commandsStatusResponse.status);
        end
    end
end