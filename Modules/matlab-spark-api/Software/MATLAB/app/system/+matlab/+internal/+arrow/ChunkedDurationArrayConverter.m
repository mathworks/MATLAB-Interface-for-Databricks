classdef ChunkedDurationArrayConverter < matlab.internal.arrow.ChunkedPrimitiveArrayConverter
%CHUNKEDDURATIONARRAYCONVERTER Converter for converting ChunkedArrays of
% DurationArrays to MATLAB duration arrays.

% Copyright 2026 The MathWorks, Inc. 

    properties (SetAccess = private)
        Int64ToDurationFcn
    end

    properties (Constant)
        Int64Converter = matlab.internal.arrow.ChunkedIntegerArrayConverter("int64", false)
    end

    methods
        function obj = ChunkedDurationArrayConverter(unit)
            unit = validatestring(unit, ["s", "ms", "us", "ns"]);
            obj.Int64ToDurationFcn  = getInt64ToDurationFcn(unit);

        end
    end

    methods (Access = protected)
        function data = convertRawData(obj, array)
            values = obj.Int64Converter.convertRawData(array);
            data = obj.Int64ToDurationFcn(values);
        end

        function data = allocateTypedVector(~, numElements)
            data = repmat(seconds(NaN), [numElements 1]);
        end

        function data = setNullElements(~, data, nullIndices)
            data(nullIndices) = seconds(NaN);
        end
    end
end

function fcn = getInt64ToDurationFcn(unit)
    switch unit
        case "s"
            fcn = @(values) seconds(values);
        case "ms"
            fcn = @(values) milliseconds(values);
        case "us"
            fcn = @(values) milliseconds(double(values) / 1e3);
        otherwise % unit == "ns"
            fcn = @(values) milliseconds(double(values) / 1e6);
    end
end