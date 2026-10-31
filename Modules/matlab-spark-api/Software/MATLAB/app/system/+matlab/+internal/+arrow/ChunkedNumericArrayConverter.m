classdef (Abstract) ChunkedNumericArrayConverter < matlab.internal.arrow.ChunkedPrimitiveArrayConverter
%CHUNKEDNUMERICARRAYCONVERTER Base class for that all numeric arrow array 
% converters must implement.

% Copyright 2026 The MathWorks, Inc.

    properties (SetAccess = private)
        %TYPE   Output MATLAB type.
        Type(1, 1) string
        %STORAGESIZE    Size of a single value in bytes.
        StorageSize(1, 1) double
    end

    methods
        function obj = ChunkedNumericArrayConverter(type)
            obj.Type = type;
            obj.StorageSize = numel(typecast(zeros([1 1], obj.Type), "uint8"));
        end
    end

    methods (Access = protected)

        function data = allocateTypedVector(obj, numElements)
            data = zeros([numElements 1], obj.Type);
        end

        function data = convertRawData(obj, array)
            dataBuffer = getBuffer(array, 1);
            % Compute the data buffer offset by multiplying the array 
            % offset by the size of one array element value in bytes.
            offset = int64(array.offset) * obj.StorageSize;
            % Compute the number of bytes to to import by multiplying the
            % array length by the size of one array element value in bytes.
            sliceLength = int64(py.len(array)) * obj.StorageSize;
            bufferSlice = dataBuffer.slice(offset, sliceLength);
            % Import the bytes and then reinterpet them as the output
            % MATLAB data type.
            data = typecast(int8(bufferSlice), obj.Type);
        end
    end
end
