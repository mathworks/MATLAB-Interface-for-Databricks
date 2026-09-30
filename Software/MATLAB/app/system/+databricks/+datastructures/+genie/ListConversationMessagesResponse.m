classdef ListConversationMessagesResponse < JSONMapper
    % LISTCONVERSATIONMESSAGESRESPONSE Class to represent a page Genie list conversation messages responses

    % Copyright 2025 The MathWorks, Inc.

    properties
        nextPageToken string { JSONMapper.fieldName(nextPageToken, "next_page_token") }
        messages databricks.datastructures.genie.Message { JSONMapper.fieldName(messages, "messages"), JSONMapper.JSONArray }
    end

    methods
        function obj = ListConversationMessagesResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.ListConversationMessagesResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end