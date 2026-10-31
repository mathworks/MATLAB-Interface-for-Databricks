classdef ChunkedBinaryArrayConverter < matlab.internal.arrow.ChunkedListLikeArrayConverter
%CHUNKEDBINARYARRAYCONVERTER  Converter for converting ChunkedArrays of
% BinaryArrays and LargeBinaryArrays to MATLAB cell arrays in which each
% element is either a uint8 row vector or a scalar missing value.

% Copyright 2026 The MathWorks, Inc.

    properties (Constant)
        ValueConverter = matlab.internal.arrow.ChunkedIntegerArrayConverter("uint8", false);
    end

    methods

        function obj = ChunkedBinaryArrayConverter(offsetType)
            obj@matlab.internal.arrow.ChunkedListLikeArrayConverter(offsetType);
        end

    end

    methods (Access = protected)

        function numValues = getNumChildValues(~, chunk)
            numValues = int64(chunk.total_values_length);
        end

        function offsetArray = getOffsetArray(obj, chunk)
            pa = py.importlib.import_module("pyarrow");

            offsetType = pa.(obj.OffsetConverter.Type)();

            arrayLength = int64(py.len(chunk)) + 1;
            offsetArray = pa.Array.from_buffers(offsetType, arrayLength, ...
                {py.None, getBuffer(chunk, 1)}, pyargs("offset", int64(chunk.offset)));
        end

        function values = getValues(obj, chunkedArray)
            pa = py.importlib.import_module("pyarrow");

            getValueArrayFcn = @(chunk) obj.getValueArray(chunk);
            values = getChildValues(chunkedArray, getValueArrayFcn,...
                pa.uint8(), obj.ValueConverter);
        end
    end

    methods (Access = private)
       function valueArray = getValueArray(obj, chunk)
            pa = py.importlib.import_module("pyarrow");

            valueBuffer = getBuffer(chunk, 2);
            offsetBuffer = getBuffer(chunk, 1);
            % Use the offset of the offset array to determine the offset
            % of the data array!
            offset = chunk.offset * int64(obj.OffsetConverter.StorageSize);
            bufferSlice = offsetBuffer.slice(offset, obj.OffsetConverter.StorageSize);
            valueOffset = typecast(int8(bufferSlice), obj.OffsetConverter.Type);

            valueArray = pa.Array.from_buffers(...
                pa.uint8(), ...
                chunk.total_values_length, ...
                {py.None, valueBuffer},...
                pyargs("offset", valueOffset)...
            );
        end
    end
end