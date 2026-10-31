classdef testMaven < matlab.unittest.TestCase
    % TESTMAVEN Unit tests for the Semantic Version Class

    %                 (c) 2022 MathWorks, Inc.


    properties
    end

    methods (TestMethodSetup)
        function testSetup(testCase)      %#ok<*MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase)
        end
    end

    methods (Test)
        function testMvn(testCase)

            if databricks.internal.isOnDatabricks()
                % Don't test maven on Databricks
                return;
            end
            
            disp('Running testMvn');
            m = matlab.utils.Maven();
            testCase.verifyClass(m, 'matlab.utils.Maven');
            testCase.verifyClass(m.version, 'matlab.utils.SemVer');
            testCase.verifyTrue(matlab.utils.Maven.isInstalled);
            
            if ~isempty(getenv('JAVA_HOME'))
                matlab.utils.Maven.errorIfNotInstalled;
                testCase.verifyTrue(matlab.utils.Maven.checkJavaHome);
            end
            
            str = matlab.utils.Maven.getVersionString;
            testCase.verifyClass(str, "string");
            testCase.verifyTrue(strlength(str) > 1);
            testCase.verifyTrue(isStringScalar(str));

            ver = matlab.utils.Maven.getVersion;
            testCase.verifyClass(ver, 'matlab.utils.SemVer');
        end
    end
end
