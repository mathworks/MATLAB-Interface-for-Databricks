classdef StatementResponseStatus < JSONMapper
    % STATEMENTRESPONSESTATUS

    % Copyright 2025 The MathWorks, Inc.

    properties
        error databricks.datastructures.genie.ErrorMsgExec { JSONMapper.fieldName(error, "error") }
        state databricks.datastructures.genie.State { JSONMapper.fieldName(state, "state") }
    end

    methods
        function obj = StatementResponseStatus(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.StatementResponseStatus
            end
            obj@JSONMapper(s, inputs);
        end
    end
end