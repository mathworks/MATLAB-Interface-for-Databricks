classdef Text < JSONMapper
    % TEXT Class to represent Text Attachment if Genie responds with text

    % Copyright 2025 The MathWorks, Inc.

    properties
        % AI generated message
        content string { JSONMapper.fieldName(content, "content") }
        % ID
        id string { JSONMapper.fieldName(id, "id") }
    end

    methods
        function obj = Text(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Text
            end
            obj@JSONMapper(s, inputs);
        end
    end
end