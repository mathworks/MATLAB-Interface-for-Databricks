classdef ChunkedDate32ArrayConverter < matlab.internal.arrow.ChunkedPrimitiveArrayConverter
%CHUNKEDDATEARRAYCONVERTER Converter for converting ChunkedArrays of
% Date32Arrays to MATLAB datetime arrays.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess = private)
        Int32Converter = matlab.internal.arrow.ChunkedIntegerArrayConverter("int32", false);
    end

    properties(Constant)
        Epoch = datetime(1970, 1, 1);
    end

    methods (Access = protected)
        function data = allocateTypedVector(~, numElements)
            data = NaT([numElements 1]);
        end

        function data = convertRawData(obj, array)
            values = obj.Int32Converter.convertRawData(array);
            data = obj.Epoch + days(values);
        end

         function data = setNullElements(~, data, nullIndices)
            data(nullIndices) = NaT;
        end
    end
end
