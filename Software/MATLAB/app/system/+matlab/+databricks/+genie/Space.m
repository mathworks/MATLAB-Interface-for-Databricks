classdef Space < handle
    % genie Space helper class

    % Copyright 2025 The MathWorks, Inc.

    properties (Hidden)
        Genie (1,1) databricks.Genie
        Space_ (1,1) databricks.datastructures.genie.Space
    end
    properties(Dependent)
        SpaceId (1,1) string
    end
    properties
        Conversations matlab.databricks.genie.Conversation
    end

    methods 
        function obj = Space(options)
            arguments
                options.spaceId (1,1) string
            end
            obj.Genie = databricks.Genie();

            % Currently, just use the first space if an id is not given
            if ~isfield(options, 'spaceId')
                [listSpacesResponse, errorResponse]  = obj.Genie.listSpaces();
                if ~isempty(errorResponse)
                    disp(errorResponse);
                    error("DATABRICKS:GENIE", "listSpaces() failed.\n");
                end

                if numel(listSpacesResponse.spaces) == 0
                    error('DATABRICKS:GENIE:NOSPACES', 'No spaces found. Please create a space in the Databricks Workspace and retry.');
                elseif numel(listSpacesResponse.spaces) == 1 %#ok<ISCL>
                    obj.Space_ = listSpacesResponse.spaces(1);
                else
                    if ~isprop(listSpacesResponse.spaces(1), "spaceId")
                         error('DATABRICKS:GENIE:SPACES:NOID', 'No spaces spaceId property found.');
                    end
                    fprintf("Using first returned space Id: %s\n", listSpacesResponse.spaces(1).spaceId);
                    obj.Space_ = listSpacesResponse.spaces(1);
                end
            else
                % Use a given space Id
                [space, errorResponse] = getSpace(obj.Genie, options.spaceId);
                if ~isempty(errorResponse)
                    disp(errorResponse);
                    error("DATABRICKS:GENIE", "getSpace() failed for Id: %s\n", options.spaceId);
                end
                obj.Space_ = space;
            end
        end


        function response = prompt(obj, content, options)
            arguments
                obj (1,1) matlab.databricks.genie.Space
                content string {mustBeTextScalar}
                options.conversationNumber (1,1) int32 = 1
                options.wait (1,1) logical = true
                options.waitTimeout (1,1) double = 30
                options.refreshTime (1,1) double = 1
            end

            % Get the initial response which is very likely to not be complete
            if isempty(obj.Conversations) || isempty(obj.Conversations(options.conversationNumber))
                response = obj.startConversation(content, conversationNumber=options.conversationNumber);
            else
                response = obj.Conversations(options.conversationNumber).prompt(content);
            end
            
            if options.wait 
                args = matlab.utils.addArgs(options, ["wait", "waitTimeout", "refreshTime"]);
                response.waitForCompletedResponse(args{:});
            end
        end


        function response = startConversation(obj, content, options)
            arguments
                obj (1,1) matlab.databricks.genie.Space
                content string {mustBeTextScalar}
                options.conversationNumber (1,1) int32 = 1
            end

            [startConversationResponse, errorResponse] = obj.Genie.startConversation(obj.SpaceId, content);
            if ~isempty(errorResponse)
                disp(errorResponse);
                error("DATABRICKS:GENIE", "startConversation failed.");
            end
            obj.Conversations(options.conversationNumber) = matlab.databricks.genie.Conversation(obj.Genie, obj.SpaceId, startConversationResponse);
            response = obj.Conversations(options.conversationNumber).Responses(end);
        end


        function deleteConversation(obj, options)
            arguments
                obj (1,1) matlab.databricks.genie.Space
                options.conversationNumber (1,1) int32 = 1
            end

            if ~isempty(obj.Conversations) && numel(obj.Conversations) >= options.conversationNumber
                obj.Conversations(options.conversationNumber).delete();
            end
        end


        function delete(obj)
            arguments
                obj (1,1) matlab.databricks.genie.Space
            end

            for n = 1:numel(obj.Conversations)
                if ~isempty(obj.Conversations(n))
                    obj.deleteConversation(conversationNumber=n);
                end
            end
        end


        function id = get.SpaceId(obj)
            id = obj.Space_.spaceId;
        end
    end
end
