classdef AppStatus < JSONMapper
    % APPSTATUS
    %
    % App API 2.0

    % Copyright 2026 The MathWorks, Inc.

    properties
        message string { JSONMapper.fieldName(message, "message")}
        state databricks.datastructures.apps.AppState { JSONMapper.fieldName(state, "state")}
    end

    methods
        function obj = AppStatus(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.apps.AppStatus
            end
            obj@JSONMapper(s, inputs);
        end
    end
end