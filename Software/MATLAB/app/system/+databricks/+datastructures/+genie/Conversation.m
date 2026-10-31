classdef Conversation < JSONMapper
    % CONVERSATION Class to represent a Genie Conversation

    % Copyright 2025 The MathWorks, Inc.

    properties
        conversationId string { JSONMapper.fieldName(conversationId, "conversation_id") }
        createdTimestamp datetime { JSONMapper.epochDatetime(createdTimestamp,'TicksPerSecond',1000), JSONMapper.fieldName(createdTimestamp, "created_timestamp") }
        title string { JSONMapper.fieldName(title, "title") }
    end

    methods
        function obj = Conversation(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.Conversation
            end
            obj@JSONMapper(s, inputs);
        end
    end
end