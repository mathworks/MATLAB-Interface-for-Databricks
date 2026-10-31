classdef ChunkedIntegerArrayConverter < matlab.internal.arrow.ChunkedNumericArrayConverter
%CHUNKEDINTEGERARRAYCONVERTER Converter for converting ChunkedArrays of
% integer arrow arrays to MATLAB integer arrays.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess = private)
        %CASTTOBOUBLE   Whether to convert an integer arrow array that
        % contains null values as a MATLAB double array with NaN values for
        % the null arrow array elements. If false, null elements are 
        % imported as 0.
        CastToDouble(1, 1) logical
    end

    methods
        function obj = ChunkedIntegerArrayConverter(type, castToDouble)
            signedTypes = compose("int%d", 2.^(3:6));
            unsignedTypes = compose("uint%d", 2.^(3:6));
            type = validatestring(type, [signedTypes unsignedTypes]);
            obj@matlab.internal.arrow.ChunkedNumericArrayConverter(type);
            obj.CastToDouble = castToDouble;
        end
    end

    methods (Access = protected)

        function data = setNullElements(obj, data, nullIndices)
            if obj.CastToDouble && any(nullIndices)
                data = cast(data, "double");
            end
            data(nullIndices) = NaN;
        end
    end
end
