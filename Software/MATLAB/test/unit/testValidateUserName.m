classdef testValidateUserName < matlab.unittest.TestCase
    % testValidateUserName Unit tests checking Unix user names
    %
    %   t = testValidateUserName;
    %   run(t);

    %  (c) 2025 MathWorks, Inc.
    properties
        FixtureDir
    end

    methods (TestClassSetup)
    end

    methods (TestMethodSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)
        function testRegularNames(testCase)
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("joeuser"));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("j"));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("a$"));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("a_b"));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("a-"));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("abcdefghijklmnopqrstuvwxyz"));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("a1234567890"));

            testCase.verifyFalse(matlab.utils.isValidUnixUserName("-"));
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("_"));
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("$"));
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("A"));
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("A.B"));
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("A@B"));
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("1"));
            testCase.verifyError(@() matlab.utils.isValidUnixUserName(""), 'MATLAB:validators:mustBeNonzeroLengthText');
            testCase.verifyError(@() matlab.utils.isValidUnixUserName(), 'MATLAB:minrhs');
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"));
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("abcd", maxLength=3));
        end

        function testSysNames(testCase)
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("joeuser", useSystemNames=true));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("A", useSystemNames=true));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName("_", useSystemNames=true));
            testCase.verifyFalse(matlab.utils.isValidUnixUserName("-", useSystemNames=true));
            testCase.verifyTrue(matlab.utils.isValidUnixUserName(upper("abcdefghijklmnopqrstuvwxyz"), useSystemNames=true));
        end
    end % methods
end % class
