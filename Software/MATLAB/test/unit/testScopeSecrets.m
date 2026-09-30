classdef testScopeSecrets < matlab.unittest.TestCase
% TESTSCOPESECRETS Unit tests for the Secrets API

%  (c) 2020 The MathWorks, Inc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Please add your test cases below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        scopeName = '';
    end

    methods (TestMethodSetup)
        function testSetup(testCase)
            % create a unique scope name
            import java.util.UUID;
            uuid = char(UUID.randomUUID());
            testCase.scopeName = ['UnitTestScope',uuid];
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase)
            scope = databricks.Scope;
            % Get a table of scope
            scopeTable = scope.list;
            if ~isempty(scopeTable)
                % check for any entries matching the unit test scope name
                scopeTFs = contains(scopeTable.name, testCase.scopeName);
                % Count the entries
                tfsCnt = sum(scopeTFs);
                % There should be at most 1
                testCase.verifyLessThanOrEqual(tfsCnt, 1);
                if tfsCnt == 1
                    % if there is one delete it
                    scope.delete(testCase.scopeName);
                end
                % recheck, there should now be 0
                scopeTable = scope.list;
                if ~isempty(scopeTable)
                    % check for any entries matching the unit test scope name
                    scopeTFs = contains(scopeTable.name, testCase.scopeName);
                    testCase.verifyFalse(any(scopeTFs));
                end
            end
        end
    end

    methods (Test)
        function testConstructors(testCase)
            scope = databricks.Scope;
            testCase.verifyTrue(isa(scope,'databricks.Scope'));
            secret = databricks.Secret;
            testCase.verifyTrue(isa(secret,'databricks.Secret'));
        end

        function testScope(testCase)
            % String based cluster_id
            scope = databricks.Scope;
            scope.scope = testCase.scopeName;
            scope.initial_manage_principal = 'users';
            scope.create;

            % check the scope create worked
            scopeTable = scope.list;
            scopeTFs = contains(scopeTable.name, testCase.scopeName);
            testCase.verifyTrue(any(scopeTFs));

            % delete the scope and check it is no longer listed
            scope.delete(testCase.scopeName);
            scopeTable = scope.list;
            if ~isempty(scopeTable)
                scopeTFs = contains(scopeTable.name, testCase.scopeName);
                testCase.verifyFalse(any(scopeTFs));
            end
        end

        function testSecret(testCase)
            scope = databricks.Scope;
            scope.scope = testCase.scopeName;
            scope.initial_manage_principal = 'users';
            scope.create;

            % Check the scope create worked
            scopeTable = scope.list;
            scopeTFs = contains(scopeTable.name, testCase.scopeName);
            testCase.verifyTrue(any(scopeTFs));

            % Create a secret in the above scope
            secret = databricks.Secret;
            secret.scope = testCase.scopeName;
            secret.key = 'myKey';
            secret.setValue('mySecretValue');
            % Can't read the value back but the put() should not error
            secret.put;
            % Create a local timestamp for later to align with the put
            nowIsh = datetime('now','TimeZone','UTC');

            % Check the key can be found in the scope
            secretTable = secret.list;
            secretTFs = contains(secretTable.key, "myKey");
            testCase.verifyTrue(any(secretTFs));
            
            % Check the key's timestamp
            timeStamp = secretTable.last_updated_timestamp;
            % Tolerate a small difference in time between now and the
            % recently created key's timestamp
            timeDelta = seconds(nowIsh - timeStamp);
            testCase.verifyLessThan(timeDelta,10);

            % Delete the key and check it is gone
            secret.delete(testCase.scopeName, 'myKey');
            secretTable = secret.list;
            % Should return an empty table
            testCase.verifyEmpty(secretTable);

            % Delete the scope and check it is no longer listed
            scope.delete(testCase.scopeName);
            scopeTable = scope.list;
            if ~isempty(scopeTable)
                scopeTFs = contains(scopeTable.name, testCase.scopeName);
                testCase.verifyFalse(any(scopeTFs));
            end
        end
    end
end
