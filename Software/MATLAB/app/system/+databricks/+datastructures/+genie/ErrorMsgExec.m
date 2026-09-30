classdef ErrorMsgExec < JSONMapper
    % ERRORMSGEXEC Class to represent Error message if Genie failed to respond to the message

    % Copyright 2025 The MathWorks, Inc.

    properties
        message string { JSONMapper.fieldName(message, "message") }
        errorCode databricks.datastructures.genie.ErrorCode { JSONMapper.fieldName(errorCode, "error_code") }
    end

    methods
        function obj = ErrorMsgExec(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.ErrorMsgExec
            end
            obj@JSONMapper(s, inputs);
        end
    end
end