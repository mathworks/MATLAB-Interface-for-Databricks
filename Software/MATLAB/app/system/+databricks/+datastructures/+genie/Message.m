classdef Message < JSONMapper
    % MESSAGE Class to represent a message
    % Copyright 2025 The MathWorks, Inc.

    properties
        attachments databricks.datastructures.genie.Attachment { JSONMapper.fieldName(attachments, "attachments"), JSONMapper.JSONArray }
        content string { JSONMapper.fieldName(content, "content") }
        conversationId string { JSONMapper.fieldName(conversationId, "conversation_id") }
        createdTimestamp datetime { JSONMapper.epochDatetime(createdTimestamp,'TicksPerSecond',1000), JSONMapper.fieldName(createdTimestamp, "created_timestamp") }
        error databricks.datastructures.genie.Error { JSONMapper.fieldName(error, "error"), JSONMapper.JSONArray }
        lastUpdatedTimestamp datetime { JSONMapper.epochDatetime(lastUpdatedTimestamp,'TicksPerSecond',1000), JSONMapper.fieldName(lastUpdatedTimestamp, "last_updated_timestamp") }
        messageId string { JSONMapper.fieldName(messageId, "message_id") }
        spaceId string { JSONMapper.fieldName(spaceId, "space_id") }
        status databricks.datastructures.genie.Status { JSONMapper.fieldName(status, "status") }
        userId int64 { JSONMapper.fieldName(userId, "user_id") }
    end

    methods
        function obj = Message(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Message
            end
            obj@JSONMapper(s, inputs);
        end
    end
end