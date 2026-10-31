classdef Genie < handle & matlab.mixin.Scalar
    % genie Genie helper class

    % Copyright 2025 The MathWorks, Inc.

    properties (Hidden)
        Genie_ (1,1) databricks.Genie
        Spaces matlab.databricks.genie.Space
    end

    methods
        function obj = Genie(options)
            arguments
                % obj (1,1) matlab.databricks.genie.Genie
                options.spaceId string {mustBeTextScalar, mustBeNonzeroLengthText}
                options.spaceNumber (1,1) int32 = 1
            end

            obj.Genie_ = databricks.Genie();

            if isfield(options, "spaceId")
                obj.Spaces(options.spaceNumber) = matlab.databricks.genie.Space(options.spaceId);
            else
                obj.Spaces(options.spaceNumber) = matlab.databricks.genie.Space();
            end
        end


        function chat(obj, options)
            % CHAT Initiates a chat session with the user, allowing for prompts and responses.
            arguments
                obj (1,1) matlab.databricks.genie.Genie
                options.spaceNumber (1,1) int32 = 1
            end

            fprintf("Starting chat. To stop type 'exit chat' or 'quit chat' at the prompt.\n");
            fprintf("---------------------------------------------------------------------\n");

            cleanup = onCleanup(@() cleanupConversation(obj, spaceNumber=options.spaceNumber));

            while true
                content = strip(input("Prompt: ", 's'));
                if strcmpi(content, 'exit chat')
                    fprintf("Exiting chat.\n");
                    break;
                elseif strcmpi(content, 'quit chat')
                    fprintf("Quitting chat.\n");
                    break;
                else
                    try
                        prompt(obj, content);
                    catch ME
                        fprintf("Prompt error: %s\n\n", ME.message)
                        if ~matlab.utils.ynQuestion("The prompt resulted in an error, try another prompt", "Y")
                            break;
                        end
                    end
                end
            end
        end


        function response = prompt(obj, content, options)
            % PROMPT prompt the user for prompts
            arguments
                obj (1,1) matlab.databricks.genie.Genie
                content string {mustBeTextScalar}
                options.spaceNumber (1,1) int32 = 1
                options.wait (1,1) logical = true
                options.waitTimeout (1,1) double = 30
                options.refreshTime (1,1) double = 1
                options.attachmentIndex (1,1) int32 = 1
            end

            args = matlab.utils.addArgs(options, ["wait", "waitTimeout", "refreshTime"]);

            % Send the user's prompt to the backend & get a response
            response = obj.Spaces(options.spaceNumber).prompt(content, args{:});

            if response.containsQuery && response.containsText
                fprintf("# Response unexpectedly contains both a query and text.\n");
            end

            % Display the result of the prompt which may be a text answer or a text answer + query
            response.Message.showAttachments();

            if response.containsQuery
                if matlab.utils.ynQuestion("Do you want to execute the query", "Y")
                    fprintf("Executing query.\n");
                    statementResponse = response.executeQuery(attachmentIndex=options.attachmentIndex); %#ok<NASGU>
                    statementResponse = response.waitForCompletedQuery(attachmentIndex=options.attachmentIndex);
                    T = databricks.internal.genie.statementResponse2Table(statementResponse.StatementResponse_);
                    fprintf("Query result header:\n");
                    head(T);
                    obj.saveTable(T);
                end
            end
        end
    end


    methods(Hidden)
        function cleanupConversation(obj, options)
            arguments
                obj (1,1) matlab.databricks.genie.Genie
                options.spaceNumber (1,1) int32 = 1
            end

            if isprop(obj, "Spaces") && ~isempty(obj.Spaces) && numel(obj.Spaces) >= options.spaceNumber
                obj.Spaces(options.spaceNumber).deleteConversation();
            end
        end


        function saveTable(obj, T)
            % SAVETABLE Save a table to the base workspace under a given name
            arguments
                obj (1,1) matlab.databricks.genie.Genie %#ok<INUSA>
                T table
            end

            if matlab.utils.ynQuestion("Save the table to base workspace", "Y")
                [varName,  modified] = matlab.lang.makeValidName(strip(input("Table variable name: ", 's')));
                if modified
                    fprintf("Modified given variable name to: %s\n", varName);
                end
                if evalin('base', sprintf('exist("%s", "var")', varName)) ~= 0
                    fprintf("Variable: %s, already exists in the base workspace.\n", varName);
                    if matlab.utils.ynQuestion("Overwrite the existing variable?", "N")
                        assignin('base', varName, T);
                    end
                else
                    assignin('base', varName, T);
                end
            end
        end
    end
end
