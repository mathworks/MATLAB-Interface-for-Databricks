classdef CommandsStatusResponse < JSONMapper
    % CommandsStatusResponse Databricks Data Structure
    %
    % databricks.datastructures.commandexecution.CommandsStatusResponse Properties:
    %   id - Commmand ID
    %   status - Enumeration: "Cancelled" "Cancelling" "Error" "Finished" "Queued" "Running"
    %   results - databricks.datastructures.commandexecution.CommandsStatusResults

    % Copyright 2023 The MathWorks, Inc.

    properties
        % ID of the command
        id string = string.empty
        % Enumeration: "Cancelled" "Cancelling" "Error" "Finished" "Queued" "Running"
        status databricks.datastructures.commandexecution.CommandsStatusStatus
        % Results field
        results databricks.datastructures.commandexecution.CommandsStatusResults % {JSONMapper.JSONArray}
    end

    methods
        function obj = CommandsStatusResponse(s,inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.commandexecution.CommandsStatusResponse
            end
            obj@JSONMapper(s,inputs);
        end
    end
end