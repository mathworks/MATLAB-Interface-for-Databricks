classdef Response < handle
    % genie Response helper class
    %
    % Deals both with CreateConversationMessageResponse and StartConversationResponse

    % Copyright 2025 The MathWorks, Inc.

    properties (Hidden, SetAccess=private)
        Genie (1,1) databricks.Genie
        Response_ (1,1)
    end
    properties (SetAccess=private)
        Message matlab.databricks.genie.Message
        MessageId (1,1) string
        SpaceId (1,1) string
        StatementResponse matlab.databricks.genie.StatementResponse
    end
    properties (Dependent, SetAccess=private)
        Status  databricks.datastructures.genie.State
        ConversationId (1,1) string
    end

    methods
        function obj = Response(genie, spaceId, response)
            obj.Genie = genie;
            obj.Response_ = response;
            obj.SpaceId = spaceId;
            obj.MessageId = response.messageId;
            if isprop(response, 'message')
                obj.Message = response.message;
            end
        end


        function tf = containsMessage(obj)
            % CONTAINSMESSAGE Returns true if the response contains non empty Message property

            tf = false;
            if isprop(obj, "Message")
                if ~isempty(obj.Message)
                    tf = true;
                end
            end
        end


        function tf = containsQuery(obj)
            % CONTAINSQUERY Returns true if there is a MEssage with a non empty query attachment

            tf = false;
            if containsMessage(obj)
                if isprop(obj.Message, "Attachments") && ~isempty(obj.Message.Attachments)
                    if isprop(obj.Message.Attachments, "query") && ~isempty(obj.Message.Attachments.query)
                        tf = true;
                    end
                end
            end
        end


        function tf = containsText(obj)
            % CONTAINSTEXT Returns true if there is a MEssage with a non empty text attachment

            tf = false;
            if containsMessage(obj)
                if isprop(obj.Message, "Attachments") && ~isempty(obj.Message.Attachments)
                    if isprop(obj.Message.Attachments, "text") && ~isempty(obj.Message.Attachments.text)
                        tf = true;
                    end
                end
            end
        end


        function result = updateResponse(obj)
            % UPDATERESPONSE Update a response query if present and otherwise the text

            if obj.containsQuery
                result = obj.updateQuery();
            elseif obj.containsText
                result = obj.updateMessage();
            else
                error("Expected a response to contain a query or text.");
            end
        end


        function waitForCompletedResponse(obj, options)
            % WAITFORCOMPLETEDRESPONSE Wait for a 

            arguments
                obj (1,1) matlab.databricks.genie.Response
                options.waitTimeout (1,1) double = 30
                options.refreshTime (1,1) double = 1
            end

            if obj.containsQuery
                obj.waitForCompletedQuery(waitTimeout=options.waitTimeout, refreshTime=options.refreshTime);
            elseif obj.containsText || ~obj.containsMessage
                obj.waitForCompletedMessage(waitTimeout=options.waitTimeout, refreshTime=options.refreshTime);
            else
                % fprintf("Expected a response to contain a query or text, assuming text.");
                obj.waitForCompletedMessage(waitTimeout=options.waitTimeout, refreshTime=options.refreshTime);
            end
        end


        function message = waitForCompletedMessage(obj, options)
            % WAITFORCOMPLETEDMESSAGE Updates a message until it completes, fails or times out

            arguments
                obj (1,1) matlab.databricks.genie.Response
                options.waitTimeout (1,1) double = 30
                options.refreshTime (1,1) double = 1
            end

            startTime = tic();

            updatedMessage = obj.updateMessage();
            if updatedMessage.Status ~= "COMPLETED" && updatedMessage.Status ~= "FAILED"
                %fprintf("\n");
                while updatedMessage.Status ~= "COMPLETED" && updatedMessage.Status ~= "FAILED"
                    tElapsed = toc(startTime);
                    if tElapsed > options.waitTimeout
                        fprintf("\nGetting message timed out, status: %s\n", updatedMessage.Status);
                        message = matlab.databricks.genie.Message.empty;
                        return;
                    end
                    pause(options.refreshTime);
                    fprintf('.');
                    updatedMessage = obj.updateMessage();
                end
                fprintf("\n");
            end
            message = updatedMessage;
            obj.Message = message;
        end


        function message = updateMessage(obj)
            % UPDATEMESSAGE Get an updated conversation message

            arguments
                obj (1,1) matlab.databricks.genie.Response
            end

            [result, errorResponse] = getConversationMessage(obj.Genie, obj.SpaceId, obj.ConversationId, obj.MessageId);
            if ~isempty(errorResponse)
                disp(errorResponse);
                error("Getting a message failed.");
            end

            message = matlab.databricks.genie.Message(result);
            obj.Message = message;
        end


        function statementResponse = updateQuery(obj, options)
            % UPDATEQUERY Get an updated query message

            arguments
                obj (1,1) matlab.databricks.genie.Response
                options.attachmentIndex (1,1) int32 = 1
            end

            if ~(isprop(obj, "Message") && isprop(obj.Message, "Attachments") && ...
                    numel(obj.Message.Attachments) >= options.attachmentIndex && ...
                    isprop(obj.Message.Attachments(options.attachmentIndex), "attachmentId"))
                error("Expected attachmentId not found.");
            end
            attachmentId = obj.Message.Attachments(options.attachmentIndex).attachmentId;
            [result, errorResponse] = getMsgAttachmentSQLQueryResult(obj.Genie, obj.SpaceId, obj.ConversationId, obj.MessageId, attachmentId);
            if ~isempty(errorResponse)
                disp(errorResponse);
                error("Getting a query result failed.");
            end
            statementResponse = matlab.databricks.genie.StatementResponse(result.statementResponse);
            obj.StatementResponse = statementResponse;
        end


        function statementResponse = waitForCompletedQuery(obj, options)
            % WAITFORCOMPLETEDQUERY Updates a query message until it completes, fails or times out

            arguments
                obj (1,1) matlab.databricks.genie.Response
                options.waitTimeout (1,1) double = 30
                options.refreshTime (1,1) double = 1
                options.attachmentIndex (1,1) int32 = 1
            end

            startTime = tic();

            updatedStatementResponse = obj.updateQuery(attachmentIndex=options.attachmentIndex);
            if updatedStatementResponse.State ~= "SUCCEEDED" && updatedStatementResponse.State ~= "FAILED" && ...
                    updatedStatementResponse.State ~= "CANCELED" && updatedStatementResponse.State ~= "CLOSED"
                while updatedStatementResponse.State == "RUNNING" || updatedStatementResponse.State == "PENDING"
                    tElapsed = toc(startTime);
                    if tElapsed > options.waitTimeout
                        fprintf("\nGetting query result timed out, state: %s\n", updatedStatementResponse.State);
                        statementResponse = matlab.databricks.genie.StatementResponse.empty;
                        return;
                    end
                    pause(options.refreshTime);
                    fprintf('.');
                    updatedStatementResponse = obj.updateQuery(attachmentIndex=options.attachmentIndex);
                end
                fprintf("\n");
            end
            statementResponse = updatedStatementResponse;
            obj.StatementResponse = updatedStatementResponse;
        end


        function status = get.Status(obj)
            if isempty(obj.Message)
                status = obj.Response_.message.status;
            else
                status = obj.Message.Status;
            end
        end


        function id = get.ConversationId(obj)
            id = obj.Response_.conversationId;
        end


        function statementResponse = get.StatementResponse(obj)
            statementResponse = obj.Response_.statementResponse;
        end


        function statementResponse = executeQuery(obj, options)
            % EXECUTEQUERY Execute a query

            arguments
                obj (1,1) matlab.databricks.genie.Response
                options.attachmentIndex (1,1) int32 = 1
            end

            if ~(isprop(obj, "Message") && isprop(obj.Message, "Attachments") && ...
                    numel(obj.Message.Attachments) >= options.attachmentIndex && ...
                    isprop(obj.Message.Attachments(options.attachmentIndex), "attachmentId"))
                error("Expected attachmentId not found.");
            end

            if ~(isprop(obj, "Message") && isprop(obj.Message, "Attachments") && ...
                    numel(obj.Message.Attachments) >= options.attachmentIndex && ...
                    isprop(obj.Message.Attachments(options.attachmentIndex), "attachmentId"))
                error("Expected attachmentId not found.");
            end
            attachmentId = obj.Message.Attachments(options.attachmentIndex).attachmentId;
            [result, errorResponse] = execMsgAttachmentSQLQuery(obj.Genie, obj.SpaceId, obj.ConversationId, obj.MessageId, attachmentId);
            if ~isempty(errorResponse)
                disp(errorResponse);
                error("Execute query request failed.");
            end
            statementResponse = matlab.databricks.genie.StatementResponse(result.statementResponse);
            obj.StatementResponse = statementResponse;
        end
    end
end
