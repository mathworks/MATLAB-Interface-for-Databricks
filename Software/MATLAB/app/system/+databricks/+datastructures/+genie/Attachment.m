classdef Attachment < JSONMapper
    % ATTACHMENT Class to represent AI-generated response to the message

    % Copyright 2025 The MathWorks, Inc.

    properties
        % Attachment ID
        attachmentId string { JSONMapper.fieldName(attachmentId, "attachment_id") }
        % Query Attachment if Genie responds with a SQL query
        query databricks.datastructures.genie.Query { JSONMapper.fieldName(query, "query") }
        % Text Attachment if Genie responds with text
        text databricks.datastructures.genie.Text { JSONMapper.fieldName(text, "text") }
    end

    methods
        function obj = Attachment(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Attachment
            end
            obj@JSONMapper(s, inputs);
        end
    end
end