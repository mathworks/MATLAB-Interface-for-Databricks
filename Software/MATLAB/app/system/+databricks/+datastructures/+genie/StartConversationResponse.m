classdef StartConversationResponse < JSONMapper
    % STARTCONVERSATIONRESPONSE Class to represent a response to startConversation

    % Copyright 2025 The MathWorks, Inc.

    properties
        conversation databricks.datastructures.genie.Conversation { JSONMapper.fieldName(conversation, "conversation") }
        conversationId string { JSONMapper.fieldName(conversationId, "conversation_id") }
        message databricks.datastructures.genie.Message { JSONMapper.fieldName(message, "message") }
        messageId string { JSONMapper.fieldName(messageId, "message_id") }
    end

    methods
        function obj = StartConversationResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.StartConversationResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end