classdef testMPMVer < matlab.unittest.TestCase
    % TESTSEMVER Unit tests for the Semantic Version Class

    %                 (c) 2022-2025 MathWorks, Inc.


    properties (TestParameter)
        lowA = {'0.0.0', '1.1.0', '1.2.2'}
        middleA = {'1.2.3', '1.2.4', '1.6.2'}
        highA = {'1.6.3', '1.8.9', '2.0.0'}
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
        function testConstructor(testCase)
            disp('Running testConstructor');

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            v = matlab.mpm.Version;

            testCase.verifyClass(v, 'matlab.mpm.Version');
            %%% Defaults to 1 not 0
            % testCase.verifyEqual(v.Major, uint32(0));
            testCase.verifyEqual(v.Minor, uint32(0));
            testCase.verifyEqual(v.Patch, uint32(0));

            v = matlab.mpm.Version('1.2.3');
            testCase.verifyEqual(v.Major, uint32(1));
            testCase.verifyEqual(v.Minor, uint32(2));
            testCase.verifyEqual(v.Patch, uint32(3));

            v =matlab.mpm.Version("1.2.3");
            testCase.verifyEqual(v.Major, uint32(1));
            testCase.verifyEqual(v.Minor, uint32(2));
            testCase.verifyEqual(v.Patch, uint32(3));

            v = matlab.mpm.Version('1.2.3');
            %%% Can create a matlab.mpm.Version from a matlab.mpm.Version
            % v = matlab.mpm.Version(v);
            testCase.verifyEqual(v.Major, uint32(1));
            testCase.verifyEqual(v.Minor, uint32(2));
            testCase.verifyEqual(v.Patch, uint32(3));
        end


        function testInRange(testCase, lowA, middleA, highA)
            disp('Running testInRange');

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            middle = matlab.mpm.Version(middleA);
            low = matlab.mpm.Version(lowA);
            high = matlab.mpm.Version(highA);

            testCase.verifyTrue(middle.ge(middle) && middle.le(middle));
            testCase.verifyTrue(middle.ge(low) && middle.le(high));
            testCase.verifyTrue(middle.ge(low) && middle.le(middle));
            testCase.verifyTrue(middle.ge(middle) && middle.le(high));
             
            testCase.verifyFalse(middle.ge(high) && middle.le(high));
            testCase.verifyFalse(middle.ge(low) && middle.le(low));

            %%% No in range method
            % testCase.verifyTrue(middle.inRange(middle, middle));
            % testCase.verifyTrue(middle.inRange(low, high));
            % testCase.verifyTrue(middle.inRange(low, middle));
            % testCase.verifyTrue(middle.inRange(middle, high));
            % 
            % testCase.verifyFalse(middle.inRange(high, high));
            % testCase.verifyFalse(middle.inRange(low, low));
        end


        function testEqLtLeGtGe(testCase, lowA, middleA, highA)
            disp('Running testEqLtLeGtGe');

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            middle = matlab.mpm.Version(middleA);
            low = matlab.mpm.Version(lowA);
            high = matlab.mpm.Version(highA);

            testCase.verifyTrue(middle.eq(middle));
            testCase.verifyFalse(middle.eq(low));
            testCase.verifyFalse(middle.eq(high));

            testCase.verifyTrue(middle.lt(high));
            testCase.verifyFalse(middle.lt(middle));
            testCase.verifyFalse(middle.lt(low));

            testCase.verifyTrue(middle.le(high));
            testCase.verifyTrue(middle.le(middle));
            testCase.verifyFalse(middle.le(low));

            testCase.verifyFalse(middle.gt(high));
            testCase.verifyFalse(middle.gt(middle));
            testCase.verifyTrue(middle.gt(low));

            testCase.verifyFalse(middle.ge(high));
            testCase.verifyTrue(middle.ge(middle));
            testCase.verifyTrue(middle.ge(low));
        end


        function testToString(testCase)
            disp('Running testToString');

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            v = matlab.mpm.Version('1.2.3');
            testCase.verifyEqual(v.string, "1.2.3")
        end


        function testCompare(testCase, lowA, middleA, highA)
            disp('Running testCompare');

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end
            
            middle = matlab.mpm.Version(middleA);
            low = matlab.mpm.Version(lowA);
            high = matlab.mpm.Version(highA); %#ok<NASGU>

            testCase.verifyTrue(low.eq(low));
            testCase.verifyTrue(middle.gt(low));
            testCase.verifyTrue(low.lt(middle));

            %%% No way to determine the state

            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha(low, low), 'eq');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha(middle, low), 'gt');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha(low, middle), 'lt');

            % testCase.verify(matlab.utils.SemVer.compareVersions(low, low), 0);
            % testCase.verifyEqual(matlab.utils.SemVer.compareVersions(middle, low), 1);
            % testCase.verifyEqual(matlab.utils.SemVer.compareVersions(low, middle), -1);
            % 
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha(low, low), 'eq');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha(middle, low), 'gt');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha(low, middle), 'lt');
        end

        function testSort(testCase)
            disp('Running testSort');

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            rawData = ["3.4.6", "1.1.1", "5.6.7", "1.1.1", "0.0.0", "1.1.0", "1.2.2"];
            dscData = ["5.6.7", "3.4.6", "1.2.2", "1.1.1", "1.1.1", "1.1.0", "0.0.0"];
            ascData = ["0.0.0", "1.1.0", "1.1.1", "1.1.1", "1.2.2", "3.4.6", "5.6.7"];
            
            %%% No array support
            % rawSv = matlab.mpm.Version(rawData);
            % dscSv = matlab.mpm.Version(dscData);
            % ascSv = matlab.mpm.Version(ascData);

            %%% No sort

            % dscResult = matlab.utils.SemVer.sort(rawSv, 'descending');
            % for n = 1:numel(rawSv)
            %     testCase.verifyTrue(dscResult(n).eq(dscSv(n)));
            % end
            % 
            % ascResult = matlab.utils.SemVer.sort(rawSv, 'ascending');
            % for n = 1:numel(rawSv)
            %     testCase.verifyTrue(ascResult(n).eq(ascSv(n)));
            % end
            % 
            % ascResult = matlab.utils.SemVer.sort(rawSv);
            % for n = 1:numel(rawSv)
            %     testCase.verifyTrue(ascResult(n).eq(ascSv(n)));
            % end
        end

        function testSemverorgVals1(testCase)

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            %%% 1.0.0-x-y-z.--. is listed in the spec
            %%% Version 1.0.0-x-y-z.--. is not a valid semantic version.
            strs = ["1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-0.3.7", "1.0.0-x.7.z.92", "1.0.0-x-y-z.--"];
            %strs = ["1.0.0-alpha", "1.0.0-alpha.1", "1.0.0-0.3.7", "1.0.0-x.7.z.92"];
            for n = 1:numel(strs)
                v = matlab.mpm.Version(strs(n));
                testCase.verifyEqual(v.string, strs(n));
            end
        end

        function testSemverorgVals2(testCase)

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            strs = ["1.0.0-alpha+001", "1.0.0+20130313144700", "1.0.0-beta+exp.sha.5114f85", "1.0.0+21AF26D3----117B344092BD"];
            for n = 1:numel(strs)
                v = matlab.mpm.Version(strs(n));
                testCase.verifyEqual(v.string, strs(n));
            end
        end

        function testOrder1(testCase)

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            % 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0"), matlab.utils.SemVer("2.0.0")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("2.0.0"), matlab.utils.SemVer("2.1.0")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("2.1.0"), matlab.utils.SemVer("2.1.1")), -1);
            % 1.0.0-alpha < 1.0.0.
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha"), matlab.utils.SemVer("1.0.0")), -1);
            % 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0.
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha"), matlab.utils.SemVer("1.0.0-alpha.1")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha.1"), matlab.utils.SemVer("1.0.0-alpha.beta")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha.beta"), matlab.utils.SemVer("1.0.0-beta")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-beta"), matlab.utils.SemVer("1.0.0-beta.2")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-beta.2"), matlab.utils.SemVer("1.0.0-beta.11")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-beta.11"), matlab.utils.SemVer("1.0.0-rc.1")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-rc.1"), matlab.utils.SemVer("1.0.0")), -1);
            % 1.0.0-alpha < 1.0.0-alpha1 < 1.0.0-alpha10 < 1.0.0-alpha20
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha"), matlab.utils.SemVer("1.0.0-alpha1")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha"), matlab.utils.SemVer("1.0.0-alpha10")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha"), matlab.utils.SemVer("1.0.0-alpha20")), -1);
            %
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha1"), matlab.utils.SemVer("1.0.0-alpha10")), -1);
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha1"), matlab.utils.SemVer("1.0.0-alpha20")), -1);
            %
            testCase.verifyEqual(matlab.utils.SemVer.compareVersions(matlab.utils.SemVer("1.0.0-alpha10"), matlab.utils.SemVer("1.0.0-alpha20")), -1);
        end


        function testOrder2(testCase)

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end

            testCase.verifyEqual(matlab.mpm.Version("1.0.0-alpha+001").string, "1.0.0-alpha+001");
            testCase.verifyTrue(matlab.mpm.Version("1.0.0-alpha+001").lt(matlab.mpm.Version("1.0.0+20130313144700")));
            testCase.verifyTrue(matlab.mpm.Version("1.0.0+20130313144700").gt(matlab.mpm.Version("1.0.0-alpha+001")));
            testCase.verifyTrue(matlab.mpm.Version("1.0.0-alpha+001").lt(matlab.mpm.Version("1.0.0-beta+exp.sha.5114f85")));
            testCase.verifyTrue(matlab.mpm.Version("1.0.0-alpha+001").lt(matlab.mpm.Version("1.0.0+21AF26D3----117B344092BD")));
            testCase.verifyTrue(matlab.mpm.Version("1.0.0+20130313144700").eq(matlab.mpm.Version("1.0.0+21AF26D3----117B344092BD")));

            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha("1.0.0-alpha+001", "1.0.0-alpha+001"), 'eq');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha("1.0.0-alpha+001", "1.0.0+20130313144700"), 'lt');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha("1.0.0+20130313144700", "1.0.0-alpha+001"), 'gt');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha("1.0.0-alpha+001", "1.0.0-beta+exp.sha.5114f85"), 'lt');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha("1.0.0-alpha+001", "1.0.0+21AF26D3----117B344092BD"), 'lt');
            % testCase.verifyEqual(matlab.utils.SemVer.compareAlpha("1.0.0+20130313144700", "1.0.0+21AF26D3----117B344092BD"), 'eq');
        end


         function testOpOver(testCase)

            if isMATLABReleaseOlderThan("R2024b")
                fprintf("matlab.mpm.Version requires R2024b or later. Skipping test.\n");
                return;
            end
            
            x = matlab.mpm.Version("1.2.3");
            y = matlab.mpm.Version("1.2.4");
            
            testCase.verifyEqual(x > y , false);
            testCase.verifyEqual(x == y , false);
            testCase.verifyEqual(x ~= y , true);
            testCase.verifyEqual(x >= y , false);
            testCase.verifyEqual(x <= y , true);
            testCase.verifyEqual(x < y , true);
        end
    end
end
