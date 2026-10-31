classdef tConverters < matlab.unittest.TestCase
%TCONVERTERS Contains miscellaneous unit tests for different subclasses of
% matlab.internal.arrow.ChunkedArrayConverter.

% Copyright 2026 The MathWorks, Inc.

    methods (Test)
        function testAcceptFloat32(testCase)
            % Verify matlab.internal.arrow.ChunkedFloatingArrayConverter's
            % constructor accepts "float32" as the type input argument.
            converter = matlab.internal.arrow.ChunkedFloatingArrayConverter("float32");
            testCase.verifyEqual(converter.Type, "single");
            testCase.verifyEqual(converter.StorageSize, 4); 
        end
    end

end