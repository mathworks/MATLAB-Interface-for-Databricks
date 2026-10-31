classdef testAddArg < matlab.unittest.TestCase
    % testAddArg This test addArgs

    % (c) 2025 MathWorks, Inc.

    properties
    end

    methods (TestClassSetup)
        function testSetup(testCase) %#ok<MANU>
        end
    end

    methods (TestClassTeardown)
        function testTearDown(testCase) %#ok<MANU>
        end
    end

    methods (Test)
        function testInitArg1(testCase)
            ia = {"a", 1, 'b', "c"};
            s = struct;
            args = matlab.utils.addArgs(s, string.empty, ia);
            testCase.assertEqual(args, {"a", 1, "b", "c"});
        end

        function testInitArg2(testCase)
            ia = {"a", 1, "a", 2};
            s = struct;
            args = matlab.utils.addArgs(s, string.empty, ia);
            testCase.assertEqual(args, {"a", 2'});
        end

        function testInitArg3(testCase)
            ia = {"a", 1, "a", 2};
            s.a = 3;
            args = matlab.utils.addArgs(s, "a", ia);
            testCase.assertEqual(args, {"a", 3});

            args = matlab.utils.addArgs(s, 'a', ia);
            testCase.assertEqual(args, {"a", 3});
        end

        function testInitArg4(testCase)
            ia = {"a", 1, "a"};
            s = struct;
            testCase.verifyError(@() matlab.utils.addArgs(s, string.empty, ia), "ADDARGS:INITEVEN");
        end

        function testInitArg5(testCase)
            ia = {"a", 1; "a", 2};
            s = struct;
            testCase.verifyError(@() matlab.utils.addArgs(s, string.empty, ia), "ADDARGS:INITSIZE");
        end

        function testInitArg6(testCase)
            ia = {};
            s = struct;
            args = matlab.utils.addArgs(s, string.empty, ia);
            testCase.assertEqual(args, {});
        end

        function testInitArg7(testCase)
            ia = {"a", 1, pi, 2};
            s = struct;
            testCase.verifyError(@() matlab.utils.addArgs(s, string.empty, ia), "ADDARGS:INITSTRING");
        end

        function testInitArg8(testCase)
            ia = {};
            s.a = 3;
            args = matlab.utils.addArgs(s, "a", ia);
            testCase.assertEqual(args, {"a", 3});

            args = matlab.utils.addArgs(s, 'a');
            testCase.assertEqual(args, {"a", 3});

            args = matlab.utils.addArgs(s, ["a", "b"]);
            testCase.assertEqual(args, {"a", 3});

            args = matlab.utils.addArgs(s, ["b"]); %#ok<NBRAK2>
            testCase.assertEqual(args, {});
        end

        function testInitArg9(testCase)
            s.a = 3;
            s.b = 4;
            s.c = 5;
           
            args = matlab.utils.addArgs(s, "");
            testCase.assertEqual(args, {});

            args = matlab.utils.addArgs(s, "X");
            testCase.assertEqual(args, {});
        end
    end
end

