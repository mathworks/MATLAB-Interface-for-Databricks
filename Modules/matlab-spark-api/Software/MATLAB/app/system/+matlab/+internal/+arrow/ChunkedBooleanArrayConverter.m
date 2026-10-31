classdef ChunkedBooleanArrayConverter < matlab.internal.arrow.ChunkedPrimitiveArrayConverter
%CHUNKEDBOOLEANARRAYCONVERTER Converter for converting Arrow ChunkedArray's
% of BooleanArrays to MATLAB logical arrays.

% Copyright 2026 The MathWorks, Inc.

    properties
        %CASTTOBOUBLE   Whether to convert a boolean arrow array that
        % contains null values as a MATLAB double array with NaN values for
        % the null arrow array elements. Otherwise, null elements are 
        % imported as false values.
        CastToDouble(1, 1) logical
    end

    methods
    
        function obj = ChunkedBooleanArrayConverter(castToDouble)
            obj.CastToDouble = castToDouble;
        end

    end

    methods (Access = protected)
        function data = allocateTypedVector(~, numElements)
            data = false([numElements 1]);
        end

        function data = convertRawData(~, array)
            buffer = getBuffer(array, 1);
            arrayOffset = int64(array.offset);
            arrayLength = int64(py.len(array));
            data = unpackBitPackedBuffer(buffer, arrayOffset, arrayLength);
        end

        function data = setNullElements(obj, data, nullIndices)
            if obj.CastToDouble && any(nullIndices)
                data = cast(data, "double");
                data(nullIndices) = NaN;
            else
                data(nullIndices) = false;
            end
        end
    end
end
