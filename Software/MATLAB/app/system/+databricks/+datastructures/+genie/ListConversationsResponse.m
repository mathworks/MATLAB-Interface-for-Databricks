classdef ListConversationsResponse < JSONMapper
    % LISTCONVERSATIONSRESPONSE Class to represent a page Genie list conversation responses

    % Copyright 2025 The MathWorks, Inc.

    properties
        nextPageToken string { JSONMapper.fieldName(nextPageToken, "next_page_token") }
        conversations databricks.datastructures.genie.Conversation { JSONMapper.fieldName(conversations, "conversations"), JSONMapper.JSONArray }
    end

    methods
        function obj = ListConversationsResponse(s, inputs)
            arguments
                s {JSONMapper.ConstructorArgument} = []
                inputs.?databricks.datastructures.genie.ListConversationsResponse
            end
            obj@JSONMapper(s, inputs);
        end
    end
end