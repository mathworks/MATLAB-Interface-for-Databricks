classdef ChunkedFloatingArrayConverter < matlab.internal.arrow.ChunkedNumericArrayConverter
%CHUNKEDFLOATINGARRAYCONVERTER Converter for converting Arrow 
% ChunkedArray's of floating-point arrow arrays to floating-point MATLAB 
% arrays.

% Copyright 2026 The MathWorks, Inc.

    methods
        function obj = ChunkedFloatingArrayConverter(type)
            import matlab.internal.arrow.ChunkedNumericArrayConverter
            % Accept "float32" for convenience, but map it to "single".
            type = validatestring(type, ["double" "float32" "single"]);
            type = replace(type, "float32", "single");
            obj@matlab.internal.arrow.ChunkedNumericArrayConverter(type)
        end
    end

    methods (Access = protected)
        function data = setNullElements(obj, data, nullIndices)
            data(nullIndices) = cast(NaN, obj.Type);
        end
    end
end
