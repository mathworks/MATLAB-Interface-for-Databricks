function [tf, response] = waitForContextRunning(clusterId, contextId, timeout, options)
    % waitForContextRunning Wait until a context transitions from Pending to Running
    % True is returned on success otherwise false.
    % The default timeout is 30 seconds.
    % False is returned if a timeout elapses or an unexpected state is
    % returned.
    % The last received contextsStatus response is optionally returned.
    %
    % Optional named arguments
    %   authMethod     A matlab.databricks.AuthMethod
    %   profileName    A configuration file profileName value

    %  Copyright 2023-2024 MathWorks, Inc.

    arguments
        clusterId string {mustBeTextScalar, mustBeNonzeroLengthText}
        contextId string {mustBeTextScalar, mustBeNonzeroLengthText}
        timeout int32 {mustBeInteger, mustBeFinite, mustBeReal, mustBeNonnegative} = 30
        options.authMethod (1,1) matlab.databricks.AuthMethod
        options.profileName string {mustBeTextScalar, mustBeNonzeroLengthText} = databricks.internal.configurationprofile.ConfigFile.getDefaultProfileName
    end

    % Get initial status
    args = matlab.utils.addArgs(options, ["authMethod", "profileName"]);
    commandExecution = databricks.CommandExecution(args{:});
    contextsStatusResponse = commandExecution.contextsStatus(clusterId, contextId);
   
    t = 0;
    tf = false;
    while t <= timeout
        if ~isprop(contextsStatusResponse, 'status')
            warning("databricks:waitForContextRunning", "status property not found");
            break;
        end
        switch contextsStatusResponse.status
            case databricks.datastructures.commandexecution.ContextsStatus.Error
                break;

            case databricks.datastructures.commandexecution.ContextsStatus.Running
                tf = true;
                break;

            case databricks.datastructures.commandexecution.ContextsStatus.Pending
                % An initial wait of 5 seconds is required even on a running cluster
                pause(5);
                t = t + 5;

            otherwise
                warning("databricks:waitForContextRunning", "Unexpected status value: %s", contextsStatusResponse.status);
                break;
        end
        % Update the status
        contextsStatusResponse = commandExecution.contextsStatus(clusterId, contextId);
    end
    
    if nargout > 1
        response = contextsStatusResponse;
    end
end