classdef testCommandExecution < matlab.unittest.TestCase
    % TESTCOMMANDEXECUTION Unit tests for CommandExecution class.
    
    % Copyright 2023-2024 The MathWorks, Inc.


    methods (Test)
    
        function testConstructor(testCase)
            % Verify the overall constructor works
            if verLessThan('matlab', '9.9') %#ok<VERLESSMATLAB>
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end
            commandExecution = databricks.CommandExecution();
            testCase.verifyClass(commandExecution,?databricks.CommandExecution);
        end

        function testDataStructures(testCase)
            % Verify that datastructures which can (also) be inputs can be
            % constructed and have a fromInputs methods and derive from
            % JSONMapper
            if verLessThan('matlab', '9.9') %#ok<VERLESSMATLAB>
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end
            inputs = [ ...
                "CancelRequest", ...
                "CreateRequest", ...
                "DestroyRequest", ...
                "ExecuteRequest"];
            for class = inputs
                instance = databricks.datastructures.commandexecution.(class);
                testCase.verifyClass(instance,strcat('databricks.datastructures.commandexecution.', class));
                testCase.verifyTrue(isa(instance,'JSONMapper'));
                testCase.verifyTrue(ismethod(instance,'fromInputs'),sprintf('%s lacks fromInputs',class));
            end
            % Verify that datastructures which are only outputs can be
            % constructed and derive from JSONMapper
            general = [ ...
                "CommandsStatusResponse", ...
                "CommandsStatusResults", ...
                "ContextsStatusResponse", ...
                "CreateResponse", ...
                "ErrorResponse", ...
                "ExecuteResponse"];
    
            for class = general
                instance = databricks.datastructures.commandexecution.(class);
                testCase.verifyClass(instance,strcat('databricks.datastructures.commandexecution.', class));
                testCase.verifyTrue(isa(instance,'JSONMapper'));
            end
            % Verify that datastructures which are enums derive from
            % JSONEnum
            enums = [...
                "CommandsStatusStatus", ...
                "ResultType", ...
                "ContextsStatus", ...
                "Language"];
            
            for class = enums
                mc = meta.class.fromName(strcat('databricks.datastructures.commandexecution.', class));
                testCase.verifyTrue(contains(mc.SuperclassList.Name,'JSONEnum'));
            end

            % Verify that all datastructures have been tested
            package = meta.package.fromName('databricks.datastructures.commandexecution');
            classes = {package.ClassList.Name};
            classes = setxor(classes,strcat('databricks.datastructures.commandexecution.',enums));
            classes = setxor(classes,strcat('databricks.datastructures.commandexecution.',inputs));
            classes = setxor(classes,strcat('databricks.datastructures.commandexecution.',general));
            testCase.verifyEmpty(classes,'databricks.datastructures.commandexecution contains untested classes');
        end
        

        function testCommandExecutionMethods(testCase)
            if verLessThan('matlab', '9.9') %#ok<VERLESSMATLAB>
                fprintf("Unity Catalog requires MATLAB R2020b or later. Skipping test.\n");
                return;
            end

            if strlength(getenv('CI_PROJECT_ID')) > 0
                return;
            end
            % constructor
            language = databricks.datastructures.commandexecution.Language.python;
            commandExecution = databricks.CommandExecution;
            clusterId = databricks.internal.configurationprofile.ConfigFile.getProfileField("cluster_id");

            % Create
            createRequest = databricks.datastructures.commandexecution.CreateRequest;
            createRequest.clusterId = clusterId;
            createRequest.language = language;
            createResponse = commandExecution.create(createRequest);
            contextId = createResponse.id;
            testCase.verifyTrue(isStringScalar(contextId));
            testCase.verifyGreaterThan(strlength(contextId), 0);

            % Status
            contextsStatusResponse = commandExecution.contextsStatus(clusterId, contextId);
            testCase.verifyTrue(isStringScalar(contextsStatusResponse.id));
            testCase.verifyGreaterThan(strlength(contextsStatusResponse.id), 0);
            testCase.verifyClass(contextsStatusResponse.status, 'databricks.datastructures.commandexecution.ContextsStatus');
            timeout = int32(30);
            testCase.verifyTrue(databricks.internal.commandexecution.waitForContextRunning(clusterId, contextId, timeout));

            % Execute
            executeRequest = databricks.datastructures.commandexecution.ExecuteRequest;
            executeRequest.clusterId = clusterId;
            executeRequest.contextId = contextId;
            executeRequest.command = "print('Hello world')";
            executeRequest.language = language;
            executeResponse = commandExecution.execute(executeRequest);
            testCase.verifyTrue(isStringScalar(executeResponse.id));
            testCase.verifyGreaterThan(strlength(executeResponse.id), 0);
            commandId = executeResponse.id;

            % CommandStatus
            commandStatusResponse = commandExecution.commandsStatus(clusterId, contextId, commandId);
            testCase.verifyTrue(isStringScalar(commandStatusResponse.id));
            testCase.verifyGreaterThan(strlength(commandStatusResponse.id), 0);

            testCase.verifyClass(commandStatusResponse.status, 'databricks.datastructures.commandexecution.CommandsStatusStatus');
            testCase.verifyTrue(databricks.internal.commandexecution.waitForCommandFinished(clusterId, contextId, commandId, timeout));
            % Refresh the status after the wait
            commandStatusResponse = commandExecution.commandsStatus(clusterId, contextId, commandId);
            testCase.verifyTrue(strcmp(string(commandStatusResponse.status), string(databricks.datastructures.commandexecution.CommandsStatusStatus.Finished)));
         
            testCase.verifyTrue(isprop(commandStatusResponse, 'results'));
            testCase.verifyTrue(isa(commandStatusResponse.results, 'databricks.datastructures.commandexecution.CommandsStatusResults'));
            testCase.verifyTrue(isprop(commandStatusResponse.results, 'resultType'));
            testCase.verifyTrue(isa(commandStatusResponse.results.resultType, 'databricks.datastructures.commandexecution.ResultType'));
            testCase.verifyTrue(strcmp(string(commandStatusResponse.results.resultType), string(databricks.datastructures.commandexecution.ResultType.text)));

            testCase.verifyTrue(isprop(commandStatusResponse.results, 'data'));
            testCase.verifyClass(commandStatusResponse.results.data, "string");
            testCase.verifyEqual(commandStatusResponse.results.data, "Hello world");

            % Cancel
            cancelRequest = databricks.datastructures.commandexecution.CancelRequest;
            cancelRequest.clusterId = clusterId;
            cancelRequest.contextId = contextId;
            cancelRequest.commandId = commandId;
            cancelResponse = commandExecution.cancel(cancelRequest);
            testCase.verifyClass(cancelResponse, 'logical');
            testCase.verifyTrue(cancelResponse);

            % Destroy
            destroyRequest = databricks.datastructures.commandexecution.DestroyRequest;
            destroyRequest.clusterId = clusterId;
            destroyRequest.contextId = contextId;
            destroyResponse = commandExecution.destroy(destroyRequest);
            testCase.verifyClass(destroyResponse, 'logical');
            testCase.verifyTrue(destroyResponse);
            
        end
    end
end
