classdef Message < handle
    % genie Message helper class

    % Copyright 2025 The MathWorks, Inc.

    properties
        SpaceId (1,1) string
        ConversationId (1,1) string
    end
    properties (Hidden)
        % Genie (1,1) databricks.Genie
        Message_ (1,1) databricks.datastructures.genie.Message
    end
    properties(Dependent)
        MessageId (1,1) string
    end
    properties (SetAccess=private)
        Query matlab.databricks.genie.StatementResponse
    end
    properties (Dependent, SetAccess=private)
        Status  databricks.datastructures.genie.Status
        Attachments  databricks.datastructures.genie.Attachment
    end

    methods
        function obj = Message(msg)
            obj.Message_ = msg;
            obj.SpaceId = msg.spaceId;
            obj.ConversationId = msg.conversationId;
        end

        
        function attachments = get.Attachments(obj)
            attachments = obj.Message_.attachments;
        end

        
        function status = get.Status(obj)
            status = obj.Message_.status;
        end


        function showAttachments(obj)
            attachments = obj.Attachments;
            for attachmentIdx = 1:numel(attachments)
                attachment = attachments(attachmentIdx);

                for textIdx = 1:numel(attachment.text)
                    fprintf("Text: %s\n", attachment.text(textIdx).content);
                end

                for queryIdx = 1:numel(attachment.query)
                    query = attachment.query(queryIdx);
                    fprintf("Description: %s\n", query.description);
                    fprintf("Query: %s\n", query.query);
                end
            end
        end

       
        function displayMessage(obj)
            fprintf('Space Id: %s\nConversation Id: %s\nMessage Id: %s\n', ...
                obj.SpaceId, obj.ConversationId, obj.MessageId);
        end


       function id = get.MessageId(obj)
            id = obj.Message_.messageId;
       end
    end
end