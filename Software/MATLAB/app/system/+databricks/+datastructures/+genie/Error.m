classdef Error < JSONMapper
    % ERROR Class to represent Error message if Genie failed to respond to the message

    % Copyright 2025 The MathWorks, Inc.

    properties
        error string { JSONMapper.fieldName(error, "error") }
        type databricks.datastructures.genie.ErrorType { JSONMapper.fieldName(type, "type") }
    end

    methods
        function obj = Error(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Error
            end
            obj@JSONMapper(s, inputs);
        end
    end
end