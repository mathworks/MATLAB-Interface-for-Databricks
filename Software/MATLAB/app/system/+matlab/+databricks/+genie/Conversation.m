classdef Conversation < handle
    % genie Conversation helper class

    % Copyright 2025 The MathWorks, Inc.

    properties (Hidden)
        Genie (1,1) databricks.Genie
        Conversation_ (1,1) databricks.datastructures.genie.Conversation
    end
    properties(Dependent)
        ConversationId (1,1) string
    end
    properties
        SpaceId (1,1) string
    end
    properties %(Hidden)
        Responses matlab.databricks.genie.Response
    end

    methods 
        function obj = Conversation(genie, spaceId, startConversationResponse)
            obj.Genie = genie;
            obj.SpaceId = spaceId;

            obj.Conversation_ = startConversationResponse.conversation;

            % Track all responses
            % May add support of aging out old response if needed
            obj.Responses(1) = matlab.databricks.genie.Response(obj.Genie, spaceId, startConversationResponse);
        end
        

        function response = prompt(obj, prompt)
            % PROMPT Send a prompt to a conversation
            % Note the first prompt to a given conversation is send by the create conversation call
            % at the Space level.
            arguments
                obj (1,1) matlab.databricks.genie.Conversation
                prompt string {mustBeTextScalar}
            end

            % createConversationMessage is an underlying REST API call
            % It returns a CreateConversationMessageResponse
            [createConversationMessageResponse, errorResponse] = createConversationMessage(obj.Genie, obj.SpaceId, obj.ConversationId, prompt);
            if isempty(errorResponse)
                obj.Responses(end+1) = matlab.databricks.genie.Response(obj.Genie, obj.SpaceId, createConversationMessageResponse);
            else
                error("MATLAB:DATABRICKS:GENIE", "Error creation conversation.");
            end
            response = obj.Responses(end);
        end


        function delete(obj)
            % Deletes a underlying conversation if an instance is deleted
            
            arguments
                obj (1,1) matlab.databricks.genie.Conversation
            end

            [tf, errorResponse] = deleteConversation(obj.Genie, obj.SpaceId, obj.ConversationId);
            if ~isempty(errorResponse) || ~tf
                disp(errorResponse);
                error("DATABRICKS:GENIE", "deleteConversation failed for: %s", obj.ConversationId);
            end
        end

        
        function id = get.ConversationId(obj)
            id = obj.Conversation_.conversationId;
        end
    end
end
