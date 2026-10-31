classdef testAllowlists < matlab.unittest.TestCase
    % TESTALLOWLISTS Test Databricks Allowlists

    % Copyright 2024 The MathWorks, Inc.

    properties (TestParameter)
        allowType = {'INIT_SCRIPT', 'LIBRARY_JAR', 'LIBRARY_MAVEN'}
        basePath = {...
            'abfss://mycontainer@mystorageaccount.dfs.core.windows.net/', ...
            '/Volumes/some/path/'...
            }
    end
    methods (Test)
        function testNormalInterface(testCase, allowType, basePath)
            bp = string(basePath);
            fprintf('Testing %s / %s\n', allowType, bp);
            
            % Get current status
            curArtifacts = matlab.databricks.unitycatalog.getArtifactAllowlistItems(allowType);
            testCase.assertClass(curArtifacts, 'databricks.datastructures.unitycatalog.GetArtifactAllowlistsResp');
            numArtifacts = numel(curArtifacts.artifact_matchers);

            % Add a new artifact
            if isequal(allowType, "LIBRARY_MAVEN")
                tempArtifact = "io.delta:delta-core_2.12:2.4.0";
            else
                tempArtifact = bp + matlab.lang.internal.uuid();
            end

            % Requires admin privileges
            newArtifacts = matlab.databricks.unitycatalog.addArtifactAllowlistItem(allowType, tempArtifact);
            testCase.assertClass(newArtifacts, 'databricks.datastructures.unitycatalog.SetArtifactAllowlistResp');

            % Check that it was added
            newNumArtifacts = numel(newArtifacts.artifact_matchers);
            testCase.assertEqual(numArtifacts+1, newNumArtifacts);

            % Add same artifact again, verify no-op
            newArtifactsAgain = matlab.databricks.unitycatalog.addArtifactAllowlistItem(allowType, tempArtifact);
            testCase.assertEmpty(newArtifactsAgain);

            % Remove the test artifact
            removeArtifacts = matlab.databricks.unitycatalog.removeArtifactAllowlistItem(allowType, tempArtifact);
            testCase.assertClass(removeArtifacts, 'databricks.datastructures.unitycatalog.SetArtifactAllowlistResp');
            numRemoveArtifacts = numel(removeArtifacts.artifact_matchers);

            testCase.assertEqual(numArtifacts, numRemoveArtifacts);
        end
    end
end

